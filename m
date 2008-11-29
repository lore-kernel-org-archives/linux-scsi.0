From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 11:32:41 -0800 (PST)
Message-ID: <20081129193241.9EC3B10800F@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbYK2TdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 14:33:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATJWffM019859
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 11:32:42 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #4 from anonymous@kernel-bugs.osdl.org  2008-11-29 11:32 -------
Reply-To: stefanr@s5r6.in-berlin.de

For comparison, here is a log from the very same disk, also spun down
when firewire-sbp2 logs in, from 2.6.27.4:

  # modprobe firewire-sbp2

Nov 29 20:17:01 mini scsi5 : SBP-2 IEEE-1394
Nov 29 20:17:01 mini Error handler scsi_eh_5 sleeping
Nov 29 20:17:01 mini firewire_sbp2: fw1.0: logged in to LUN 0000 (0 retries)
Nov 29 20:17:01 mini scsi 5:0:0:0: scsi scan: INQUIRY pass 1 length 36
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 5500,
(ffffffff80375047)
Nov 29 20:17:01 mini scsi 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini scsi 5:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 36, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini scsi 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini scsi 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini scsi 5:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
Nov 29 20:17:01 mini scsi 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini scsi 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 36 bytes done.
Nov 29 20:17:01 mini scsi scan: INQUIRY successful with code 0x0
Nov 29 20:17:01 mini scsi 5:0:0:0: Direct-Access-RBC ST340083 2A              
3.03 PQ: 0 ANSI: 4
Nov 29 20:17:01 mini sd 5:0:0:0: sd_attach
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] sd_revalidate_disk
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 20:17:01 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 0 bytes done.
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 8, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 8 bytes done.
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] 781422768 512-byte hardware sectors
(400088 MB)
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 4, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 4 bytes done.
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Write Protect is off
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Mode Sense: 11 00 00 00
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 4, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 4 bytes done.
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 22, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 22 bytes done.
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] sd_open
Nov 29 20:17:01 mini scsi_block_when_processing_errors: rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] sd_revalidate_disk
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 20:17:01 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 0 bytes done.
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 8, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 8 bytes done.
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] 781422768 512-byte hardware sectors
(400088 MB)
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 4, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 4 bytes done.
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Write Protect is off
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Mode Sense: 11 00 00 00
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 4, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 4 bytes done.
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 30000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 22, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:01 mini sd 5:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 20:17:01 mini sd 5:0:0:0: scsi host busy 1 failed 0
Nov 29 20:17:01 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:01 mini 0 sectors total, 22 bytes done.
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

  # coming up: the first READ(10)

Nov 29 20:17:01 mini sdb:<6>sd 5:0:0:0: [sdb] sd_init_command: block=0, count=8
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] block=0
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] reading 8/8 512 byte blocks.
Nov 29 20:17:01 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 60000,
(ffffffff80375047)
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00
08 00
Nov 29 20:17:01 mini buffer = 0xffff88007df61eb0, bufflen = 4096, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:01 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:01 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Done: 0xffff88007d6cbed0 FAILED
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00
08 00
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Sense Key : Not Ready [current] 
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Add. Sense: Logical unit not ready,
initializing command required
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] scsi host busy 1 failed 0
Nov 29 20:17:01 mini Waking error handler thread
Nov 29 20:17:01 mini Error handler scsi_eh_5 waking up
Nov 29 20:17:01 mini sd 5:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1,
cancel: 0
Nov 29 20:17:01 mini Total of 1 commands on 1 devices require eh work
Nov 29 20:17:01 mini scsi_eh_5: Sending START_UNIT to sdev: 0xffff8800737fe000
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] Send: 0xffff88007d6cbed0 
Nov 29 20:17:01 mini sd 5:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 20:17:01 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:08 mini scsi_eh_done scmd: ffff88007d6cbed0 result: 0
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] scsi host busy 1 failed 1
Nov 29 20:17:08 mini scsi_send_eh_cmnd: scmd: ffff88007d6cbed0, timeleft: 52572
Nov 29 20:17:08 mini scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Send: 0xffff88007d6cbed0 
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 20:17:08 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:08 mini scsi_eh_done scmd: ffff88007d6cbed0 result: 0
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] scsi host busy 1 failed 1
Nov 29 20:17:08 mini scsi_send_eh_cmnd: scmd: ffff88007d6cbed0, timeleft: 10000
Nov 29 20:17:08 mini scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Nov 29 20:17:08 mini scsi_eh_tur: scmd ffff88007d6cbed0 rtn 2002
Nov 29 20:17:08 mini scsi_eh_5: flush retry cmd: ffff88007d6cbed0
Nov 29 20:17:08 mini Inserting command ffff88007d6cbed0 into mlqueue
Nov 29 20:17:08 mini scsi_restart_operations: waking up host to restart
Nov 29 20:17:08 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 60000,
(ffffffff80375047)
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Send: 0xffff88007d6cbed0 
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00
08 00
Nov 29 20:17:08 mini buffer = 0xffff88007df61eb0, bufflen = 4096, queuecommand
0xffffffffa00d2a8a

  # cutting out some traffic to [sda], the root filesystem disk

Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00
08 00
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] scsi host busy 1 failed 0
Nov 29 20:17:08 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:08 mini 8 sectors total, 4096 bytes done.
Nov 29 20:17:08 mini sdb1
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] sd_release
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Attached SCSI disk
Nov 29 20:17:08 mini sg_alloc: dev=1 
Nov 29 20:17:08 mini sd 5:0:0:0: Attached scsi generic sg1 type 14
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] sd_open
Nov 29 20:17:08 mini scsi_block_when_processing_errors: rtn: 1
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] sd_init_command: block=0, count=32
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] block=0
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] reading 32/32 512 byte blocks.
Nov 29 20:17:08 mini scsi_add_timer: scmd: ffff88007d6cbed0, time: 60000,
(ffffffff80375047)
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Send: 0xffff88007d6cbed0 
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00
20 00
Nov 29 20:17:08 mini buffer = 0xffff88007df61eb0, bufflen = 16384, queuecommand
0xffffffffa00d2a8a
Nov 29 20:17:08 mini leaving scsi_dispatch_cmnd()
Nov 29 20:17:08 mini scsi_delete_timer: scmd: ffff88007d6cbed0, rtn: 1
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Done: 0xffff88007d6cbed0 SUCCESS
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00
20 00
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] scsi host busy 1 failed 0
Nov 29 20:17:08 mini sd 5:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 20:17:08 mini sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 20:17:08 mini 32 sectors total, 16384 bytes done.

  # et cetera


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
