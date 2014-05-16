From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: scsi error handling thread and REQUEST SENSE
Date: Fri, 16 May 2014 19:02:58 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:58424 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaEPTFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 May 2014 15:05:02 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 712101E44
	for <linux-scsi@vger.kernel.org>; Fri, 16 May 2014 18:45:46 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

There is an issue with a command timeout followed by a failed
abort in the linux SCSI stack.

After triggering a timeout on a command like:
[ 5454.196861] sd 2:0:0:1: [sds] Done: TIMEOUT
[ 5454.196863] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[ 5454.196866] sd 2:0:0:1: [sds] CDB: Mode Sense(10): 5a 00 03 00 00 00 00 00 04 00

scsi_times_out() invokes scsi_abort_command():
[ 5454.196880] sd 2:0:0:1: [sds] scmd ffff880428963a70 abort scheduled

and scmd_eh_abort_handler() tries to abort the command:
[ 5454.206828] sd 2:0:0:1: [sds] aborting command ffff880428963a70

If the abort fails (with return value FAILED (0x2003 == 8195)):
[ 5454.206832] sd 2:0:0:1: [sds] scmd ffff880428963a70 abort failed, rtn 8195

then scmd_eh_abort_handler() just gives up and expects the error 
handler thread to deal with the problem.

When that thread (scsi_error_handler()) wakes up later on, it finds 
this command (and others) outstanding:
[ 5454.373581] scsi_eh_2: waking up 0/3/3
[ 5454.375037] sd 2:0:0:1: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
[ 5454.377332] sd 2:0:0:11: scsi_eh_prt_fail_stats: cmds failed: 2, cancel: 0
[ 5454.379779] Total of 3 commands on 2 devices require eh work

For each command, it starts with this check:

#define SCSI_SENSE_VALID(scmd) \
        (((scmd)->sense_buffer[0] & 0x70) == 0x70)

                if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
                    SCSI_SENSE_VALID(scmd))
                        continue;

In this case, that if statement fails.  The eflags bit is not 
set, and the sense data buffer still contains zeros or garbage - 
the command is still outstanding, so the buffer might be written 
at any time.

(the sense buffer shouldn't be read unless a valid bit says
it's filled in, and this lacks support for descriptor format 
sense data (type 0x72), but those are side issues)

Strangely, the error handler code (scsi_unjam_host()) proceeds 
to send a REQUEST SENSE command and sees the resulting sense 
key of NO SENSE:

[ 5454.381659] sd 2:0:0:1: [sds] scsi_eh_2: requesting sense
[ 5454.383597] scsi_eh_done scmd: ffff880428963a70 result: 0
[ 5454.385457] sd 2:0:0:1: [sds] Done: UNKNOWN
[ 5454.387430] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK 
[ 5454.390450] sd 2:0:0:1: [sds] CDB: Request Sense: 03 00 00 00 60 00
[ 5454.393497] scsi_send_eh_cmnd: scmd: ffff880428963a70, timeleft: 9998
[ 5454.395667] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[ 5454.397842] sense requested for ffff880428963a70 result 0
[ 5454.399675] sd 2:0:0:1: [sds] Sense Key : No Sense [current]
[ 5454.402570] sd 2:0:0:1: [sds] Add. Sense: No additional sense information

The bogus "UNKNOWN" print is being fixed by Hannes' logging 
patch. It just means the REQUEST SENSE command was submitted 
successfully.

This device uses autosense, so REQUEST SENSE is not a valid way 
to find out any information for the timed out command. There is
no contingent allegiance condition stalling the queue until 
REQUEST SENSE comes along to collect the sense data - that
parallel SCSI concept went obsolete in SAM-3 revision 5 in 
January 2003.

The command is still outstanding; data transfers might still occur, 
and a completion using its tag could still appear at any time. 
However, the error handler declares that the command is done, 
so all the buffers are freed and the tag is reused.

The SCSI error handler needs to escalate this to a reset that 
ensures that the command is no longer outstanding: ABORT
TASK (which already didn't work), ABORT TASK SET, LOGICAL 
UNIT RESET, I_T NEXUS RESET, or hard reset.

If those fail, then it needs to escalate to resetting or disabling
the controller - disable the Bus Master Enable bit in its PCIe 
interface so the controller cannot write into host memory and
report the device as gone.  It's not safe to proceed while
hardware is still able to write to host memory for those old
commands.

The error handler thread does let a transport layer replace 
scsi_unjam_host(), but not all drivers have a transport
layer assisting them:
                if (shost->transportt->eh_strategy_handler)
                        shost->transportt->eh_strategy_handler(shost);
                else
                        scsi_unjam_host(shost);

libsas, for example, provides sas_scsi_recover_host() as that
function.  It does try more things, but appears to give up 
if they don't work and eventually calls scsi_eh_get_sense() 
just like scsi_unjam_host(), so may suffer from the same 
problem.

Any suggestions for how to fix this?

---
Rob Elliott    HP Server Storage


