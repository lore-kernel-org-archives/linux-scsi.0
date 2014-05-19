From: James Bottomley <jbottomley@parallels.com>
Subject: Re: scsi error handling thread and REQUEST SENSE
Date: Mon, 19 May 2014 13:41:59 +0000
Message-ID: <1400506919.24320.1.camel@dabdike>
References: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net>
	 <1400270713.3813.33.camel@localhost.localdomain> <5379C1B2.2040600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:60116 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaESNmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 09:42:04 -0400
In-Reply-To: <5379C1B2.2040600@suse.de>
Content-Language: en-US
Content-ID: <9CEDC9BD7EE6634CA689EDFAFB41566A@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "emilne@redhat.com" <emilne@redhat.com>, "Elliott@hp.com" <Elliott@hp.com>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "hch@infradead.org" <hch@infradead.org>


On Mon, 2014-05-19 at 10:32 +0200, Hannes Reinecke wrote:
> On 05/16/2014 10:05 PM, Ewan Milne wrote:
> > On Fri, 2014-05-16 at 19:02 +0000, Elliott, Robert (Server Storage)
> > wrote:
> >> There is an issue with a command timeout followed by a failed
> >> abort in the linux SCSI stack.
> >
> > This might explain some  odd crashes I've seen, where it looks like
> > a command might have completed *long* after it should have timed out.
> > I have a few questions, see below:
> >
> >>
> >> After triggering a timeout on a command like:
> >> [ 5454.196861] sd 2:0:0:1: [sds] Done: TIMEOUT
> >> [ 5454.196863] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> >> [ 5454.196866] sd 2:0:0:1: [sds] CDB: Mode Sense(10): 5a 00 03 00 00 00 00 00 04 00
> >>
> >> scsi_times_out() invokes scsi_abort_command():
> >> [ 5454.196880] sd 2:0:0:1: [sds] scmd ffff880428963a70 abort scheduled
> >>
> >> and scmd_eh_abort_handler() tries to abort the command:
> >> [ 5454.206828] sd 2:0:0:1: [sds] aborting command ffff880428963a70
> >>
> >> If the abort fails (with return value FAILED (0x2003 == 8195)):
> >> [ 5454.206832] sd 2:0:0:1: [sds] scmd ffff880428963a70 abort failed, rtn 8195
> >>
> >> then scmd_eh_abort_handler() just gives up and expects the error
> >> handler thread to deal with the problem.
> >>
> >> When that thread (scsi_error_handler()) wakes up later on, it finds
> >> this command (and others) outstanding:
> >> [ 5454.373581] scsi_eh_2: waking up 0/3/3
> >> [ 5454.375037] sd 2:0:0:1: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
> >> [ 5454.377332] sd 2:0:0:11: scsi_eh_prt_fail_stats: cmds failed: 2, cancel: 0
> >> [ 5454.379779] Total of 3 commands on 2 devices require eh work
> >>
> >> For each command, it starts with this check:
> >>
> >> #define SCSI_SENSE_VALID(scmd) \
> >>          (((scmd)->sense_buffer[0] & 0x70) == 0x70)
> >>
> >>                  if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
> >>                      SCSI_SENSE_VALID(scmd))
> >>                          continue;
> >>
> >> In this case, that if statement fails.  The eflags bit is not
> >> set, and the sense data buffer still contains zeros or garbage -
> >> the command is still outstanding, so the buffer might be written
> >> at any time.
> >>
> >> (the sense buffer shouldn't be read unless a valid bit says
> >> it's filled in, and this lacks support for descriptor format
> >> sense data (type 0x72), but those are side issues)
> >
> > Doesn't the check for:   (byte[0] & 0x70) == 0x70   cover 0x70 - 0x73?
> >
> >>
> >> Strangely, the error handler code (scsi_unjam_host()) proceeds
> >> to send a REQUEST SENSE command and sees the resulting sense
> >> key of NO SENSE:
> >>
> >> [ 5454.381659] sd 2:0:0:1: [sds] scsi_eh_2: requesting sense
> >> [ 5454.383597] scsi_eh_done scmd: ffff880428963a70 result: 0
> >> [ 5454.385457] sd 2:0:0:1: [sds] Done: UNKNOWN
> >> [ 5454.387430] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> >> [ 5454.390450] sd 2:0:0:1: [sds] CDB: Request Sense: 03 00 00 00 60 00
> >> [ 5454.393497] scsi_send_eh_cmnd: scmd: ffff880428963a70, timeleft: 9998
> >> [ 5454.395667] scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> >> [ 5454.397842] sense requested for ffff880428963a70 result 0
> >> [ 5454.399675] sd 2:0:0:1: [sds] Sense Key : No Sense [current]
> >> [ 5454.402570] sd 2:0:0:1: [sds] Add. Sense: No additional sense information
> >
> > So, a command timed out, the abort didn't succeed, but a
> > REQUEST SENSE completed normally?
> >
> > What kernel was this?  Did it have the change to issue the abort
> > in the timeout handler rather than the EH thread?  It seems like
> > it does, based on your description above.  However, I'm wondering
> > because I have seen crashes on kernels both with and without that
> > change.
> >
> >>
> >> The bogus "UNKNOWN" print is being fixed by Hannes' logging
> >> patch. It just means the REQUEST SENSE command was submitted
> >> successfully.
> >>
> >> This device uses autosense, so REQUEST SENSE is not a valid way
> >> to find out any information for the timed out command. There is
> >> no contingent allegiance condition stalling the queue until
> >> REQUEST SENSE comes along to collect the sense data - that
> >> parallel SCSI concept went obsolete in SAM-3 revision 5 in
> >> January 2003.
> >>
> >> The command is still outstanding; data transfers might still occur,
> >> and a completion using its tag could still appear at any time.
> >> However, the error handler declares that the command is done,
> >> so all the buffers are freed and the tag is reused.
> >>
> >> The SCSI error handler needs to escalate this to a reset that
> >> ensures that the command is no longer outstanding: ABORT
> >> TASK (which already didn't work), ABORT TASK SET, LOGICAL
> >> UNIT RESET, I_T NEXUS RESET, or hard reset.
> >
> > What is supposed to happen is that the EH will escalate and
> > eventually reset the HBA if all else fails.  It definitely
> > should not be returning the scmd if the LLD is still using it.
> >
> Well, problem here is that the 'REQUEST SENSE' command has two problems:
> a) Most modern HBA (ie all non-SPI HBAs) use autosense, ie the sense 
> code is returned with the command. So issuing 'REQUEST SENSE' here 
> is pointless.
> b) The sense code (when retrieved via 'REQUEST SENSE') relates to 
> the most recently processed command (from the target perspective).
> Which is a bit hard to make out, as by the time SCSI EH starts
> several other commands might have been processed already, so any
> sense we'd be retrieving most likely does not relate to the failed 
> command.
> 
> I would propose to disable the 'REQUEST_SENSE' step as soon as the 
> HBA is capable of autosensing. We requires us to add another flag
> to the scsi_host field.
> 
> What about the attached patch? That should roughly do what's 
> required here, right?

This patch shouldn't be necessary at all.  A driver with autosense
returning check condition should already have collected the sense, so we
should succeed in the first if condition

		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
		    SCSI_SENSE_VALID(scmd))
			continue;

If we drop through, the return code shouldn't be CHECK_CONDITION, so it
should get kicked out here:

		if (status_byte(scmd->result) != CHECK_CONDITION)
			/*
			 * don't request sense if there's no check condition
			 * status because the error we're processing isn't one
			 * that has a sense code (and some devices get
			 * confused by sense requests out of the blue)
			 */
			continue;

However, that last bit is a recent introduction:


commit d555a2abf3481f81303d835046a5ec2c4fb3ca8e
Author: James Bottomley <JBottomley@Parallels.com>
Date:   Fri Mar 28 10:50:17 2014 -0700

    [SCSI] Fix spurious request sense in error handling

So if the problem occurred before that patch, it may be fixed by it.

James

