From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46031] New: kswapd0 moving to uninterruptible sleep (STAT D)
Date: Thu, 16 Aug 2012 12:40:13 +0000 (UTC)
Message-ID: <bug-46031-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44285 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab2HPMkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2012 08:40:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC5332025B
	for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 12:40:16 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0B8C420223
	for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 12:40:14 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46031

           Summary: kswapd0 moving to uninterruptible sleep (STAT D)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.5.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: Markus.Hetzmannseder@jku.at
        Regression: No


Hi,

I have a hangup problem with my litle server. The Hardware is a Dell Poweredge
SC1430 with mirrored harddrives conntected on the PERC 5/i Adapter, it uses the
megaraid/megasas scsi driver.

The problem occurs specially at heavy diskIO like update of the file name
database.

The system is running in x86_PAE mode with 8GB RAM installed. So far I have
tried out kernel 3.1.4 3.6.0-rc1 and now running 3.5.2 version.

According to kernel.log its allways the kswapd0 process which starts to hang in
STAT D mode. After that more and more processes are hitting STAT D and the
system is getting practically unusable. In that state a login over the network
is still possible. A normal reboot is not working anymore (keeps waiting to
kill some processes) only a reboot -f is doing the job.

When the error accurs the /proc/sys/kernel/tainted has state 512

In the attachment I add all the kern.log output I got so far.

In the kern.log I see something like this:

-----------------------------------------------------------------
Aug 16 11:49:57 servername kernel: [ 7361.062388] WARNING: at
fs/jbd/journal.c:469 __log_start_commit+0x6b/0x7e()
Aug 16 11:49:57 servername kernel: [ 7361.062391] Hardware name: PowerEdge
SC1430
Aug 16 11:49:57 servername kernel: [ 7361.062393] jbd: bad log_start_commit:
2168023832 2168023832 0 0
Aug 16 11:49:57 servername kernel: [ 7361.062395] Modules linked in: ppdev lp
bluetooth rfkill mperf cpufreq_conservative cpufreq_userspace cpufreq_powersave
cpufreq_stats nfsd exportfs nfs lockd fscache auth_rpcgss nfs_acl sunrpc fuse
loop psmouse lpc_ich mfd_core i5000_edac edac_core serio_raw evdev tpm_tis
pcspkr tpm shpchp hid_generic coretemp rng_core dcdbas tpm_bios i5k_amb
pci_hotplug microcode parport_pc processor button parport thermal_sys usbhid
hid uhci_hcd sg sr_mod tg3 cdrom ehci_hcd libphy usbcore usb_common sd_mod
crc_t10dif [last unloaded: scsi_wait_scan]
Aug 16 11:49:57 servername kernel: [ 7361.062454] Pid: 46, comm: kswapd0 Not
tainted 3.5.2 #1
Aug 16 11:49:57 servername kernel: [ 7361.062456] Call Trace:
Aug 16 11:49:57 servername kernel: [ 7361.062464]  [<c1023a3d>] ?
warn_slowpath_common+0x6a/0x7b
Aug 16 11:49:57 servername kernel: [ 7361.062468]  [<c11575ae>] ?
__log_start_commit+0x6b/0x7e
Aug 16 11:49:57 servername kernel: [ 7361.062472]  [<c1023ab4>] ?
warn_slowpath_fmt+0x28/0x2c
Aug 16 11:49:57 servername kernel: [ 7361.062476]  [<c11575ae>] ?
__log_start_commit+0x6b/0x7e
Aug 16 11:49:57 servername kernel: [ 7361.062480]  [<c1157625>] ?
log_start_commit+0x1b/0x22
Aug 16 11:49:57 servername kernel: [ 7361.062484]  [<c110fa0a>] ?
ext3_evict_inode+0xbe/0x1cc
Aug 16 11:49:57 servername kernel: [ 7361.062489]  [<c10d4a6a>] ?
evict+0x8a/0x126
Aug 16 11:49:57 servername kernel: [ 7361.062492]  [<c10d4e72>] ?
dispose_list+0x2e/0x37
Aug 16 11:49:57 servername kernel: [ 7361.062496]  [<c10d50fa>] ?
prune_icache_sb+0x27f/0x287
Aug 16 11:49:57 servername kernel: [ 7361.062501]  [<c10c5f21>] ?
prune_super+0xa2/0xf5
Aug 16 11:49:57 servername kernel: [ 7361.062506]  [<c109f8bb>] ?
shrink_slab+0x1b7/0x254
Aug 16 11:49:57 servername kernel: [ 7361.062509]  [<c10a16fe>] ?
kswapd+0x54f/0x805
Aug 16 11:49:57 servername kernel: [ 7361.062515]  [<c103ad7d>] ?
wake_up_bit+0x56/0x56
Aug 16 11:49:57 servername kernel: [ 7361.062519]  [<c10a11af>] ?
try_to_free_pages+0xd5/0xd5
Aug 16 11:49:57 servername kernel: [ 7361.062522]  [<c103aa1f>] ?
kthread+0x68/0x6d
Aug 16 11:49:57 servername kernel: [ 7361.062526]  [<c103a9b7>] ?
kthread_freezable_should_stop+0x45/0x45
Aug 16 11:49:57 servername kernel: [ 7361.062531]  [<c1346b7e>] ?
kernel_thread_helper+0x6/0xd
Aug 16 11:49:57 servername kernel: [ 7361.062534] ---[ end trace
7f2284fed89c7a03 ]---
Aug 16 12:33:17 servername kernel: [ 9960.684081] INFO: task acroread:3117
blocked for more than 120 seconds.
Aug 16 12:33:17 servername kernel: [ 9960.684116] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 16 12:33:17 servername kernel: [ 9960.684162] acroread        D 00000000   
 0  3117   3115 0x00000000
Aug 16 12:33:17 servername kernel: [ 9960.684179]  f0ef69a0 00200082 00000001
00000000 c6b6ddac 00000002 39abe377 c1514dc0
Aug 16 12:33:17 servername kernel: [ 9960.684186]  c6b6ddac c2c0dd38 c1514dc0
c1514dc0 f0ef69a0 c1514dc0 0101b7ba 00000020
Aug 16 12:33:17 servername kernel: [ 9960.684192]  c10d7899 c2c0ddb0 009e8d67
00000000 da7ff09c c6b6ddac 0000000b ce221700
Aug 16 12:33:17 servername kernel: [ 9960.684199] Call Trace:
Aug 16 12:33:17 servername kernel: [ 9960.684210]  [<c10d7899>] ?
mntput_no_expire+0x15/0xf1
Aug 16 12:33:17 servername kernel: [ 9960.684215]  [<c1110214>] ?
search_dirblock+0x5f/0x93
Aug 16 12:33:17 servername kernel: [ 9960.684221]  [<c103aeef>] ?
prepare_to_wait+0x14/0x52
Aug 16 12:33:17 servername kernel: [ 9960.684225]  [<c10d4106>] ?
__wait_on_freeing_inode+0x6e/0x88
Aug 16 12:33:17 servername kernel: [ 9960.684229]  [<c103ada6>] ?
autoremove_wake_function+0x29/0x29
Aug 16 12:33:17 servername kernel: [ 9960.684232]  [<c10d4155>] ?
find_inode_fast+0x35/0x6d
Aug 16 12:33:17 servername kernel: [ 9960.684236]  [<c10d54a8>] ?
iget_locked+0x2f/0xd5
Aug 16 12:33:17 servername kernel: [ 9960.684240]  [<c110ce15>] ?
ext3_iget+0x18/0x332
Aug 16 12:33:17 servername kernel: [ 9960.684243]  [<c1111e0c>] ?
ext3_lookup+0x5d/0x9b
Aug 16 12:33:17 servername kernel: [ 9960.684248]  [<c10cb8b8>] ?
__lookup_hash+0x8f/0xa8
Aug 16 12:33:17 servername kernel: [ 9960.684251]  [<c10cb8fd>] ?
lookup_slow+0x2c/0x78
Aug 16 12:33:17 servername kernel: [ 9960.684255]  [<c10cccde>] ?
walk_component+0x48/0xe8
Aug 16 12:33:17 servername kernel: [ 9960.684259]  [<c10cdc9a>] ?
path_lookupat+0xa4/0x2a6
Aug 16 12:33:17 servername kernel: [ 9960.684264]  [<c109a79a>] ?
free_hot_cold_page_list+0x4a/0x60
Aug 16 12:33:17 servername kernel: [ 9960.684268]  [<c10cdeb7>] ?
do_path_lookup+0x1b/0x85
Aug 16 12:33:17 servername kernel: [ 9960.684271]  [<c10ce88c>] ?
user_path_at_empty+0x3d/0x65
Aug 16 12:33:17 servername kernel: [ 9960.684277]  [<c10adb55>] ?
handle_mm_fault+0x118/0x129
Aug 16 12:33:17 servername kernel: [ 9960.684281]  [<c10ce8bf>] ?
user_path_at+0xb/0xe
Aug 16 12:33:17 servername kernel: [ 9960.684284]  [<c10c75ab>] ?
vfs_fstatat+0x3d/0x63
Aug 16 12:33:17 servername kernel: [ 9960.684287]  [<c10c768d>] ?
vfs_stat+0x10/0x12
Aug 16 12:33:17 servername kernel: [ 9960.684290]  [<c10c769e>] ?
sys_stat64+0xf/0x23
Aug 16 12:33:17 servername kernel: [ 9960.684295]  [<c1343c4b>] ?
spurious_fault+0xe5/0xe5
Aug 16 12:33:17 servername kernel: [ 9960.684299]  [<c1346613>] ?
sysenter_do_call+0x12/0x22
Aug 16 12:35:17 servername kernel: [10080.684102] INFO: task acroread:3117
blocked for more than 120 seconds.
Aug 16 12:35:17 servername kernel: [10080.684138] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug 16 12:35:17 servername kernel: [10080.684183] acroread        D 00000000   
 0  3117   3115 0x00000000
Aug 16 12:35:17 servername kernel: [10080.684200]  f0ef69a0 00200082 00000001
00000000 c6b6ddac 00000002 39abe377 c1514dc0
Aug 16 12:35:17 servername kernel: [10080.684207]  c6b6ddac c2c0dd38 c1514dc0
c1514dc0 f0ef69a0 c1514dc0 0101b7ba 00000020
Aug 16 12:35:17 servername kernel: [10080.684214]  c10d7899 c2c0ddb0 009e8d67
00000000 da7ff09c c6b6ddac 0000000b ce221700
Aug 16 12:35:17 servername kernel: [10080.684220] Call Trace:
Aug 16 12:35:17 servername kernel: [10080.684231]  [<c10d7899>] ?
mntput_no_expire+0x15/0xf1
Aug 16 12:35:17 servername kernel: [10080.684237]  [<c1110214>] ?
search_dirblock+0x5f/0x93
Aug 16 12:35:17 servername kernel: [10080.684243]  [<c103aeef>] ?
prepare_to_wait+0x14/0x52
Aug 16 12:35:17 servername kernel: [10080.684247]  [<c10d4106>] ?
__wait_on_freeing_inode+0x6e/0x88
Aug 16 12:35:17 servername kernel: [10080.684251]  [<c103ada6>] ?
autoremove_wake_function+0x29/0x29
Aug 16 12:35:17 servername kernel: [10080.684254]  [<c10d4155>] ?
find_inode_fast+0x35/0x6d
Aug 16 12:35:17 servername kernel: [10080.684258]  [<c10d54a8>] ?
iget_locked+0x2f/0xd5
Aug 16 12:35:17 servername kernel: [10080.684261]  [<c110ce15>] ?
ext3_iget+0x18/0x332
Aug 16 12:35:17 servername kernel: [10080.684265]  [<c1111e0c>] ?
ext3_lookup+0x5d/0x9b
Aug 16 12:35:17 servername kernel: [10080.684269]  [<c10cb8b8>] ?
__lookup_hash+0x8f/0xa8
Aug 16 12:35:17 servername kernel: [10080.684273]  [<c10cb8fd>] ?
lookup_slow+0x2c/0x78
Aug 16 12:35:17 servername kernel: [10080.684276]  [<c10cccde>] ?
walk_component+0x48/0xe8
Aug 16 12:35:17 servername kernel: [10080.684280]  [<c10cdc9a>] ?
path_lookupat+0xa4/0x2a6
Aug 16 12:35:17 servername kernel: [10080.684285]  [<c109a79a>] ?
free_hot_cold_page_list+0x4a/0x60
Aug 16 12:35:17 servername kernel: [10080.684289]  [<c10cdeb7>] ?
do_path_lookup+0x1b/0x85
Aug 16 12:35:17 servername kernel: [10080.684292]  [<c10ce88c>] ?
user_path_at_empty+0x3d/0x65
Aug 16 12:35:17 servername kernel: [10080.684298]  [<c10adb55>] ?
handle_mm_fault+0x118/0x129
Aug 16 12:35:17 servername kernel: [10080.684302]  [<c10ce8bf>] ?
user_path_at+0xb/0xe
Aug 16 12:35:17 servername kernel: [10080.684305]  [<c10c75ab>] ?
vfs_fstatat+0x3d/0x63
Aug 16 12:35:17 servername kernel: [10080.684308]  [<c10c768d>] ?
vfs_stat+0x10/0x12
Aug 16 12:35:17 servername kernel: [10080.684311]  [<c10c769e>] ?
sys_stat64+0xf/0x23
Aug 16 12:35:17 servername kernel: [10080.684316]  [<c1343c4b>] ?
spurious_fault+0xe5/0xe5
Aug 16 12:35:17 servername kernel: [10080.684320]  [<c1346613>] ?
sysenter_do_call+0x12/0x22
--------------------------------------------------------------

Any hints how to get the system back in a stable mode?

Markus

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
