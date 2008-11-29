From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Bug 12120] [Block layer or SCSI] requests aborted too early
 during check_partition()
Date: Sat, 29 Nov 2008 22:30:21 +0100 (CET)
Message-ID: <tkrat.08c6487c76d999a8@s5r6.in-berlin.de>
References: <20081129193241.9EC3B10800F@picon.linux-foundation.org>
 <1227988491.4636.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54045 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYK2Vff (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Nov 2008 16:35:35 -0500
In-Reply-To: <1227988491.4636.14.camel@localhost.localdomain>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On 29 Nov, James Bottomley wrote:
> OK, so there are a few problems.  First, by responding OK to the test
> unit ready (which is illegal under spec) it avoids the spin up the sd
> driver normally does, so we're relying on the eh allow_restart flag to
> start the unit on the first failing command.  Then, in the failure case:
> 
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00
>> 08 00
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Sense Key : Not Ready [current] 
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Add. Sense: Logical unit not ready,
>> initializing command required
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] scsi host busy 1 failed 0
>> Nov 29 19:57:06 stein Waking error handler thread
>> Nov 29 19:57:06 stein Error handler scsi_eh_20 waking up
>> Nov 29 19:57:06 stein sd 20:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1,
>> cancel: 0
>> Nov 29 19:57:06 stein Total of 1 commands on 1 devices require eh work
>> Nov 29 19:57:06 stein scsi_eh_20: Sending START_UNIT to sdev: 0xe58fc7f0
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Send: 0xf5798ef0 
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Start/Stop Unit: 1b 00 00 00 01
>> 00
>> Nov 29 19:57:06 stein buffer = 0x00000000, bufflen = 0, queuecommand 0xf85fb980
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Done: 0xf5798ef0 SUCCESS
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Result: hostbyte=DID_OK
>> driverbyte=DRIVER_OK,SUGGEST_OK
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Start/Stop Unit: 1b 00 00 00 01
>> 00
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Unrecognized sense data (in hex):
>> Nov 29 19:57:06 stein 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
>> Nov 29 19:57:06 stein 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
>> Nov 29 19:57:06 stein Sense Key : No Sense [current] 
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Add. Sense: No additional sense
>> information
>> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] scsi host busy 1 failed 1
> 
> The second start unit is a failure ... I suspect because of our change
> to no sense return handling.  What the drive is probably trying to say
> is (I'm spinning up) but this gets interpreted as an error because the
> sense data for this isn't present (because we didn't ask for it).
> 
> Can you try this patch?  It should take the success return of the first
> spin up and act on it instead of blindly sending another.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 3863617..635d8b4 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -931,12 +931,15 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
>  	if (scmd->device->allow_restart) {
>  		int i, rtn = NEEDS_RETRY;
>  
> -		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
> +		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++) {
>  			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
>  						scmd->device->timeout, 0);
>  
> -		if (rtn == SUCCESS)
> -			return 0;
> +			if (rtn == SUCCESS)
> +				return 0;
> +			/* if failure, wait before retrying */
> +			ssleep(3);
> +		}
>  	}
>  
>  	return 1;
> 
> 

Still no luck.  Here is a log from a simpler test:
# sg_start --stop /dev/sdb
# echo 0xfffffff > /sys/module/scsi_mod/parameters/scsi_logging_level
# hdparm -tT /dev/sdb
This works under 2.6.27.y (i.e. disk spins up, hdparm proceeds) but
fails under 2.6.28-rc with disk put offline.

The firmware apparently doesn't like the command abortion (SBP-2 fetch
agent reset) while it is spinning up.


Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] sd_init_command: block=0, count=512
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] block=0
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] reading 512/512 512 byte blocks.
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Send: 0xffff88007b76af08 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 02 00 00
Nov 29 22:12:53 mini buffer = 0xffff88007b60c5f0, bufflen = 262144, queuecommand 0xffffffffa015d445
Nov 29 22:12:53 mini leaving scsi_dispatch_cmnd()
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 FAILED
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 02 00 00
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Sense Key : Not Ready [current] 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Add. Sense: Logical unit not ready, initializing command required
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 0
Nov 29 22:12:53 mini Waking error handler thread
Nov 29 22:12:53 mini Error handler scsi_eh_2 waking up
Nov 29 22:12:53 mini sd 2:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1, cancel: 0
Nov 29 22:12:53 mini Total of 1 commands on 1 devices require eh work
Nov 29 22:12:53 mini scsi_eh_2: Sending START_UNIT to sdev: 0xffff8800712ef000
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Send: 0xffff88007b76af08 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:12:53 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand 0xffffffffa015d445
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 SUCCESS
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Unrecognized sense data (in hex):
Nov 29 22:12:53 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 22:12:53 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 22:12:53 mini Sense Key : No Sense [current] 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Add. Sense: No additional sense information
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 1
Nov 29 22:12:53 mini scsi_send_eh_cmnd: scmd: ffff88007b76af08, timeleft: 0
Nov 29 22:12:53 mini ieee1394: sbp2: aborting sbp2 command
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:12:53 mini scsi_eh_done scmd: ffff88007b76af08 result: 50000
Nov 29 22:12:55 mini ieee1394: sbp2: Reconnected to SBP-2 device
Nov 29 22:12:55 mini ieee1394: sbp2: Node 0-01:1023: Max speed [S400] - Max payload [2048]
Nov 29 22:12:56 mini scsi_eh_2: START_UNIT failed to sdev: 0xffff8800712ef000
Nov 29 22:12:56 mini scsi_eh_2: Sending BDR sdev: 0xffff8800712ef000
Nov 29 22:12:56 mini ieee1394: sbp2: reset requested
Nov 29 22:12:56 mini ieee1394: sbp2: generating sbp2 fetch agent reset
Nov 29 22:12:56 mini sd 2:0:0:0: [sdb] Send: 0xffff88007b76af08 
Nov 29 22:12:56 mini sd 2:0:0:0: [sdb] CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 22:12:56 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand 0xffffffffa015d445
Nov 29 22:13:02 mini ieee1394: sbp2: Reconnected to SBP-2 device
Nov 29 22:13:02 mini ieee1394: sbp2: Node 0-01:1023: Max speed [S400] - Max payload [2048]
Nov 29 22:13:02 mini scsi_eh_done scmd: ffff88007b76af08 result: 20000
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 SUCCESS
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_BUS_BUSY driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 1
Nov 29 22:13:02 mini scsi_send_eh_cmnd: scmd: ffff88007b76af08, timeleft: 4840
Nov 29 22:13:02 mini scsi_send_eh_cmnd: scsi_eh_completed_normally 2003
Nov 29 22:13:02 mini scsi_eh_tur: scmd ffff88007b76af08 rtn 2003
Nov 29 22:13:02 mini scsi_eh_2: Sending target reset to target 0
Nov 29 22:13:02 mini scsi_eh_2: Target reset failed target: 0
Nov 29 22:13:02 mini scsi_eh_2: Sending BRST chan: 0
Nov 29 22:13:02 mini scsi_try_bus_reset: Snd Bus RST
Nov 29 22:13:02 mini scsi_eh_2: BRST failed chan: 0
Nov 29 22:13:02 mini scsi_eh_2: Sending HRST
Nov 29 22:13:02 mini scsi_try_host_reset: Snd Host RST
Nov 29 22:13:02 mini scsi_eh_2: HRST failed
Nov 29 22:13:02 mini sd 2:0:0:0: Device offlined - not ready after error recovery
Nov 29 22:13:02 mini scsi_eh_2: flush finish cmd: ffff88007b76af08
Nov 29 22:13:02 mini sd 2:0:0:0: Notifying upper driver of completion (result 2)
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:13:02 mini 512 sectors total, 0 bytes done.
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:13:02 mini end_request: I/O error, dev sdb, sector 0
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 0
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 1
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 2
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 3
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 4
Nov 29 22:13:02 mini sd 2:0:0:0: rejecting I/O to offline device
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 5
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 6
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 7
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 8
Nov 29 22:13:02 mini Buffer I/O error on device sdb, logical block 0
Nov 29 22:13:02 mini scsi_restart_operations: waking up host to restart
Nov 29 22:13:02 mini Error handler scsi_eh_2 sleeping

-- 
Stefan Richter
-=====-==--- =-== ===-=
http://arcgraph.de/sr/

