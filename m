From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 13:45:59 -0800 (PST)
Message-ID: <20081129214559.E3ED810800F@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbYK2Vqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 16:46:32 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATLjxSO024986
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 13:46:00 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #7 from anonymous@kernel-bugs.osdl.org  2008-11-29 13:45 -------
Reply-To: stefanr@s5r6.in-berlin.de

I wrote:
> On 29 Nov, James Bottomley wrote:
>> Can you try this patch?  It should take the success return of the first
>> spin up and act on it instead of blindly sending another.
...
> Still no luck.  Here is a log from a simpler test:
> # sg_start --stop /dev/sdb
> # echo 0xfffffff > /sys/module/scsi_mod/parameters/scsi_logging_level
> # hdparm -tT /dev/sdb
> This works under 2.6.27.y (i.e. disk spins up, hdparm proceeds) but
> fails under 2.6.28-rc with disk put offline.
> 
> The firmware apparently doesn't like the command abortion (SBP-2 fetch
> agent reset) while it is spinning up.

Same with firewire-sbp2 instead of ieee1394/sbp2:

Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] sd_init_command: block=0, count=512
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] block=0
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] reading 512/512 512 byte blocks.
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Send: 0xffff88007169cf08 
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 02
00 00
Nov 29 22:36:31 mini buffer = 0xffff88007c8e75f0, bufflen = 262144,
queuecommand 0xffffffffa013c9df
Nov 29 22:36:31 mini leaving scsi_dispatch_cmnd()
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Done: 0xffff88007169cf08 FAILED
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 02
00 00
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Sense Key : Not Ready [current] 
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Add. Sense: Logical unit not ready,
initializing command required
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 0
Nov 29 22:36:31 mini Waking error handler thread
Nov 29 22:36:31 mini Error handler scsi_eh_2 waking up
Nov 29 22:36:31 mini sd 2:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1,
cancel: 0
Nov 29 22:36:31 mini Total of 1 commands on 1 devices require eh work
Nov 29 22:36:31 mini scsi_eh_2: Sending START_UNIT to sdev: 0xffff88006e373000
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Send: 0xffff88007169cf08 
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:36:31 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa013c9df
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Done: 0xffff88007169cf08 SUCCESS
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Unrecognized sense data (in hex):
Nov 29 22:36:31 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 22:36:31 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 22:36:31 mini Sense Key : No Sense [current] 
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] Add. Sense: No additional sense
information
Nov 29 22:36:31 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 1
Nov 29 22:36:31 mini scsi_send_eh_cmnd: scmd: ffff88007169cf08, timeleft: 0
Nov 29 22:36:31 mini firewire_sbp2: fw1.0: sbp2_scsi_abort
Nov 29 22:36:31 mini scsi_eh_done scmd: ffff88007169cf08 result: 20000
Nov 29 22:36:33 mini firewire_sbp2: fw1.0: reconnected to LUN 0000 (0 retries)
Nov 29 22:36:34 mini scsi_eh_2: START_UNIT failed to sdev: 0xffff88006e373000
Nov 29 22:36:34 mini scsi_eh_2: Sending BDR sdev: 0xffff88006e373000
Nov 29 22:36:34 mini scsi_eh_2: BDR failed sdev:0xffff88006e373000
Nov 29 22:36:34 mini scsi_eh_2: Sending target reset to target 0
Nov 29 22:36:34 mini scsi_eh_2: Target reset failed target: 0
Nov 29 22:36:34 mini scsi_eh_2: Sending BRST chan: 0
Nov 29 22:36:34 mini scsi_try_bus_reset: Snd Bus RST
Nov 29 22:36:34 mini scsi_eh_2: BRST failed chan: 0
Nov 29 22:36:34 mini scsi_eh_2: Sending HRST
Nov 29 22:36:34 mini scsi_try_host_reset: Snd Host RST
Nov 29 22:36:34 mini scsi_eh_2: HRST failed
Nov 29 22:36:34 mini sd 2:0:0:0: Device offlined - not ready after error
recovery
Nov 29 22:36:34 mini scsi_eh_2: flush finish cmd: ffff88007169cf08
Nov 29 22:36:34 mini sd 2:0:0:0: Notifying upper driver of completion (result
2)
Nov 29 22:36:34 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:36:34 mini 512 sectors total, 0 bytes done.
Nov 29 22:36:34 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 22:36:34 mini end_request: I/O error, dev sdb, sector 0
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 0
Nov 29 22:36:34 mini sd 2:0:0:0: rejecting I/O to offline device
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 0
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 1
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 2
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 3
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 4
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 5
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 6
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 7
Nov 29 22:36:34 mini Buffer I/O error on device sdb, logical block 8
Nov 29 22:36:34 mini scsi_restart_operations: waking up host to restart
Nov 29 22:36:34 mini Error handler scsi_eh_2 sleeping
Nov 29 22:36:37 mini sd 2:0:0:0: [sdb] sd_release
Nov 29 22:36:39 mini firewire_sbp2: fw1.0: reconnected to LUN 0000 (0 retries)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
