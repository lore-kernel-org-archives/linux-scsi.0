From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 13:30:30 -0800 (PST)
Message-ID: <20081129213030.11076108041@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752730AbYK2Vad convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 16:30:33 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATLUUWS024277
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 13:30:31 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #6 from anonymous@kernel-bugs.osdl.org  2008-11-29 13:30 -------
Reply-To: stefanr@s5r6.in-berlin.de

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
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 02
00 00
Nov 29 22:12:53 mini buffer = 0xffff88007b60c5f0, bufflen = 262144,
queuecommand 0xffffffffa015d445
Nov 29 22:12:53 mini leaving scsi_dispatch_cmnd()
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 FAILED
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 02
00 00
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Sense Key : Not Ready [current] 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Add. Sense: Logical unit not ready,
initializing command required
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 0
Nov 29 22:12:53 mini Waking error handler thread
Nov 29 22:12:53 mini Error handler scsi_eh_2 waking up
Nov 29 22:12:53 mini sd 2:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1,
cancel: 0
Nov 29 22:12:53 mini Total of 1 commands on 1 devices require eh work
Nov 29 22:12:53 mini scsi_eh_2: Sending START_UNIT to sdev: 0xffff8800712ef000
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Send: 0xffff88007b76af08 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:12:53 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa015d445
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 SUCCESS
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Unrecognized sense data (in hex):
Nov 29 22:12:53 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 22:12:53 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 22:12:53 mini Sense Key : No Sense [current] 
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Add. Sense: No additional sense
information
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 1
Nov 29 22:12:53 mini scsi_send_eh_cmnd: scmd: ffff88007b76af08, timeleft: 0
Nov 29 22:12:53 mini ieee1394: sbp2: aborting sbp2 command
Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:12:53 mini scsi_eh_done scmd: ffff88007b76af08 result: 50000
Nov 29 22:12:55 mini ieee1394: sbp2: Reconnected to SBP-2 device
Nov 29 22:12:55 mini ieee1394: sbp2: Node 0-01:1023: Max speed [S400] - Max
payload [2048]
Nov 29 22:12:56 mini scsi_eh_2: START_UNIT failed to sdev: 0xffff8800712ef000
Nov 29 22:12:56 mini scsi_eh_2: Sending BDR sdev: 0xffff8800712ef000
Nov 29 22:12:56 mini ieee1394: sbp2: reset requested
Nov 29 22:12:56 mini ieee1394: sbp2: generating sbp2 fetch agent reset
Nov 29 22:12:56 mini sd 2:0:0:0: [sdb] Send: 0xffff88007b76af08 
Nov 29 22:12:56 mini sd 2:0:0:0: [sdb] CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 22:12:56 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa015d445
Nov 29 22:13:02 mini ieee1394: sbp2: Reconnected to SBP-2 device
Nov 29 22:13:02 mini ieee1394: sbp2: Node 0-01:1023: Max speed [S400] - Max
payload [2048]
Nov 29 22:13:02 mini scsi_eh_done scmd: ffff88007b76af08 result: 20000
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 SUCCESS
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_BUS_BUSY
driverbyte=DRIVER_OK,SUGGEST_OK
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
Nov 29 22:13:02 mini sd 2:0:0:0: Device offlined - not ready after error
recovery
Nov 29 22:13:02 mini scsi_eh_2: flush finish cmd: ffff88007b76af08
Nov 29 22:13:02 mini sd 2:0:0:0: Notifying upper driver of completion (result
2)
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:13:02 mini 512 sectors total, 0 bytes done.
Nov 29 22:13:02 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
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
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
