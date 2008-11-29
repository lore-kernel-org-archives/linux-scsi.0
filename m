From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 11:29:55 -0800 (PST)
Message-ID: <20081129192955.3C53F10800F@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYK2Ta2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 14:30:28 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mATJTths019721
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 11:29:56 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #3 from anonymous@kernel-bugs.osdl.org  2008-11-29 11:29 -------
Reply-To: stefanr@s5r6.in-berlin.de

> It sounds like the device isn't being spun up, so commands which require
> media read are being failed with not ready.  Could we get some traces to
> show this; just enable all tracing in the boot up sequence:
> 
> echo 0xffffffff > /sys/module/scsi_mod/parameters/scsi_logging_level

OK, here is a log from a failing session in 2.6.28-rc6.
The firmware responds to everything without spinning the disk up,
until the first READ(10) is sent.

  # spin disk down artificially with
  # "modprobe -r firewire-sbp2" while manage_start_stop == 1
  #
  # then "modprobe firewire-sbp2"

Nov 29 19:57:05 stein Error handler scsi_eh_20 sleeping
Nov 29 19:57:05 stein scsi20 : SBP-2 IEEE-1394
Nov 29 19:57:06 stein firewire_sbp2: fw3.0: logged in to LUN 0000 (0 retries)
Nov 29 19:57:06 stein scsi 20:0:0:0: scsi scan: INQUIRY pass 1 length 36
Nov 29 19:57:06 stein scsi 20:0:0:0: Send: 0xf57986b0 
Nov 29 19:57:06 stein scsi 20:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
Nov 29 19:57:06 stein buffer = 0xf725f9d0, bufflen = 36, queuecommand
0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein scsi 20:0:0:0: Done: 0xf57986b0 SUCCESS
Nov 29 19:57:06 stein scsi 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein scsi 20:0:0:0: CDB: Inquiry: 12 00 00 00 24 00
Nov 29 19:57:06 stein scsi 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein scsi 20:0:0:0: Notifying upper driver of completion
(result 0)
Nov 29 19:57:06 stein 0 sectors total, 36 bytes done.
Nov 29 19:57:06 stein scsi scan: INQUIRY successful with code 0x0
Nov 29 19:57:06 stein scsi 20:0:0:0: Direct-Access-RBC ST340083 2A             
 3.03 PQ: 0 ANSI: 4
Nov 29 19:57:06 stein sd 20:0:0:0: sd_attach
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] sd_revalidate_disk
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57986b0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 19:57:06 stein buffer = 0x00000000, bufflen = 0, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57986b0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 0 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57986b0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 19:57:06 stein buffer = 0xf725f9d0, bufflen = 8, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57986b0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 8 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] 781422768 512-byte hardware sectors:
(400 GB/372 GiB)
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57986b0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 19:57:06 stein buffer = 0xf725f9d0, bufflen = 4, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57986b0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 4 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Write Protect is off
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Mode Sense: 11 00 00 00
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57986b0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 19:57:06 stein buffer = 0xf725f9d0, bufflen = 4, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57986b0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 4 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57986b0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 19:57:06 stein buffer = 0xf725f9d0, bufflen = 22, queuecommand
0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57986b0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 22 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] sd_open
Nov 29 19:57:06 stein scsi_block_when_processing_errors: rtn: 1
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] sd_revalidate_disk
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57984a0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 19:57:06 stein buffer = 0x00000000, bufflen = 0, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57984a0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Test Unit Ready: 00 00 00 00 00 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 0 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf5798550 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 19:57:06 stein buffer = 0xf725fd68, bufflen = 8, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf5798550 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Read Capacity(10): 25 00 00 00 00 00 00
00 00 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 8 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] 781422768 512-byte hardware sectors:
(400 GB/372 GiB)
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf57981e0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 19:57:06 stein buffer = 0xf725fed8, bufflen = 4, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf57981e0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 00 3f 00 04 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 4 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Write Protect is off
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Mode Sense: 11 00 00 00
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf5798600 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 19:57:06 stein buffer = 0xf725f918, bufflen = 4, queuecommand 0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf5798600 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 04 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 4 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: Send: 0xf5798ef0 
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 19:57:06 stein buffer = 0xe5961b40, bufflen = 22, queuecommand
0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: Done: 0xf5798ef0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: CDB: Mode Sense(6): 1a 08 06 00 16 00
Nov 29 19:57:06 stein sd 20:0:0:0: scsi host busy 1 failed 0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
0)
Nov 29 19:57:06 stein 0 sectors total, 22 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

  # partition scanning code gets into gears,
  # issues very first READ command,
  # now the failures start

Nov 29 19:57:06 stein sdd:<6>sd 20:0:0:0: [sdd] sd_init_command: block=0,
count=8
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] block=0
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] reading 8/8 512 byte blocks.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Send: 0xf5798ef0 
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00
08 00
Nov 29 19:57:06 stein buffer = 0xe5961b40, bufflen = 4096, queuecommand
0xf85fb980
Nov 29 19:57:06 stein leaving scsi_dispatch_cmnd()
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Done: 0xf5798ef0 FAILED
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00
08 00
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Sense Key : Not Ready [current] 
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Add. Sense: Logical unit not ready,
initializing command required
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] scsi host busy 1 failed 0
Nov 29 19:57:06 stein Waking error handler thread
Nov 29 19:57:06 stein Error handler scsi_eh_20 waking up
Nov 29 19:57:06 stein sd 20:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1,
cancel: 0
Nov 29 19:57:06 stein Total of 1 commands on 1 devices require eh work
Nov 29 19:57:06 stein scsi_eh_20: Sending START_UNIT to sdev: 0xe58fc7f0
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Send: 0xf5798ef0 
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Start/Stop Unit: 1b 00 00 00 01
00
Nov 29 19:57:06 stein buffer = 0x00000000, bufflen = 0, queuecommand 0xf85fb980
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Done: 0xf5798ef0 SUCCESS
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Start/Stop Unit: 1b 00 00 00 01
00
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Unrecognized sense data (in hex):
Nov 29 19:57:06 stein 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 19:57:06 stein 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Nov 29 19:57:06 stein Sense Key : No Sense [current] 
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Add. Sense: No additional sense
information
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] scsi host busy 1 failed 1
Nov 29 19:57:06 stein scsi_send_eh_cmnd: scmd: f5798ef0, timeleft: 0
Nov 29 19:57:06 stein firewire_sbp2: fw3.0: sbp2_scsi_abort
Nov 29 19:57:06 stein scsi_eh_done scmd: f5798ef0 result: 20000
Nov 29 19:57:06 stein scsi_eh_20: START_UNIT failed to sdev: 0xe58fc7f0
Nov 29 19:57:06 stein scsi_eh_20: Sending BDR sdev: 0xe58fc7f0
Nov 29 19:57:06 stein scsi_eh_20: BDR failed sdev:0xe58fc7f0
Nov 29 19:57:06 stein scsi_eh_20: Sending target reset to target 0
Nov 29 19:57:06 stein scsi_eh_20: Target reset failed target: 0
Nov 29 19:57:06 stein scsi_eh_20: Sending BRST chan: 0
Nov 29 19:57:06 stein scsi_try_bus_reset: Snd Bus RST
Nov 29 19:57:06 stein scsi_eh_20: BRST failed chan: 0
Nov 29 19:57:06 stein scsi_eh_20: Sending HRST
Nov 29 19:57:06 stein scsi_try_host_reset: Snd Host RST
Nov 29 19:57:06 stein scsi_eh_20: HRST failed
Nov 29 19:57:06 stein sd 20:0:0:0: Device offlined - not ready after error
recovery
Nov 29 19:57:06 stein scsi_eh_20: flush finish cmd: f5798ef0
Nov 29 19:57:06 stein sd 20:0:0:0: Notifying upper driver of completion (result
2)
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein 8 sectors total, 0 bytes done.
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Result: hostbyte=DID_OK
driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 19:57:06 stein end_request: I/O error, dev sdd, sector 0
Nov 29 19:57:06 stein Buffer I/O error on device sdd, logical block 0
Nov 29 19:57:06 stein scsi_restart_operations: waking up host to restart
Nov 29 19:57:06 stein Error handler scsi_eh_20 sleeping
Nov 29 19:57:06 stein sd 20:0:0:0: rejecting I/O to offline device
Nov 29 19:57:06 stein Buffer I/O error on device sdd, logical block 0
Nov 29 19:57:06 stein ldm_validate_partition_table(): Disk read failed.
Nov 29 19:57:06 stein sd 20:0:0:0: rejecting I/O to offline device
Nov 29 19:57:06 stein Buffer I/O error on device sdd, logical block 0
Nov 29 19:57:06 stein sd 20:0:0:0: rejecting I/O to offline device
Nov 29 19:57:06 stein Buffer I/O error on device sdd, logical block 0
Nov 29 19:57:06 stein unable to read partition table
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] sd_release
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Attached SCSI disk
Nov 29 19:57:06 stein sg_alloc: dev=3 
Nov 29 19:57:06 stein sd 20:0:0:0: Attached scsi generic sg3 type 14
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] sd_open
Nov 29 19:57:06 stein scsi_block_when_processing_errors: rtn: 0
Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] sd_open
Nov 29 19:57:06 stein scsi_block_when_processing_errors: rtn: 0
Nov 29 19:57:08 stein firewire_sbp2: fw3.0: reconnected to LUN 0000 (0 retries)
Nov 29 19:57:14 stein firewire_sbp2: fw3.0: reconnected to LUN 0000 (0 retries)
Nov 29 19:58:09 stein xinetd[4299]: START: imap2 pid=18913 from=192.168.0.42
Nov 29 19:58:09 stein imapd[18913]: imap service init from 192.168.0.42
Nov 29 19:58:09 stein imapd[18913]: Login user=stefan host=stein [192.168.0.42]
Nov 29 19:58:15 stein imapd[18914]: imap service init from 192.168.0.42
Nov 29 19:58:15 stein xinetd[4299]: START: imap2 pid=18914 from=192.168.0.42
Nov 29 19:58:15 stein imapd[18914]: Login user=stefan host=stein [192.168.0.42]
Nov 29 19:58:19 stein imapd[18913]: Logout user=stefan host=stein
[192.168.0.42]
Nov 29 19:58:19 stein xinetd[4299]: EXIT: imap2 status=0 pid=18913
duration=10(sec)
Nov 29 19:59:07 stein imapd[18914]: Logout user=stefan host=stein
[192.168.0.42]
Nov 29 19:59:07 stein xinetd[4299]: EXIT: imap2 status=0 pid=18914
duration=52(sec)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
