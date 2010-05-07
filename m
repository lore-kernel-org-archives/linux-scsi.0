From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Fri, 7 May 2010 08:01:35 GMT
Message-ID: <201005070801.o4781ZnZ029071@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44476 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0EGIBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2010 04:01:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4781ZFF029073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 7 May 2010 08:01:35 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #20 from kdesai <kashyap.desai@lsi.com>  2010-05-07 08:01:25 ---
(In reply to comment #19)
> So... patch seems to fix ATA command pass-through problems.  I let it go a
> day spamming hddtemp in a loop on all the drives, while at same time reading
> 600MB/sec or so.  No problem.  Again, without patch, it would never manage
> more than 10 seconds spamming all the drives at once.
> 
> IMO it seems like the ATA-Passthrough bug is fixed by this patch.  I cannot
> cause a failure using ATA-Passthrough.
> 
> All is not good news however....
> 
> With this bug fixed I was going to start expanding a md array one disk at a
> time.  Unfortunately sooner or later the controller seems to crap out.  I
> don't know what is at fault, but the mptsas drive's method of just blowing
> up and blocking processes forever sucks.
> 
> I've tried this 4 times now and each time I see some read errors, then task
> resets fail and eventually it gets to point it just keeps spamming 'sometask
> has been blocked for 120s'.  I WISH this was a bad drive, but even if it was
> a bad drive it shouldn't take down the system like this, but just to be sure
> I've been swapping a few drives and it doesn't really make a difference.
> Each time a different drive starts the fail sequence.  I'm guessing its
> unlikely I have a pile of bad drives.
> 
> I do have 16 drives all attached via a HP SAS Expander, perhaps the expander
> is at fault.  I also have a backup Chenbro Expander I could try...  but I'm
> too lazy to at the moment.  I could also try ditching the Expanders to see
> if that is the cause of these problems, but again too lazy at the moment.
> Monday a mpt2sas expander is being delivered, I think my best bet is to
> ditch this mptsas driver all together.  If that doesn't fix problems I'll
> then go back and try swapping Expanders and whatnot.
> 
> Anyways, TL;DR:  ATA-PassThrough bug is fixed, mptsas still blows.

Patch for setting dma boundary is mere avoiding condition which is causing this
issue. LSI Gen-1 controller does not have 512byte dma boundary limitation. I
have started internal chat with our Firmware engineer. I will update you
findings as and when some imp stuffs are found. 
> 
> Here log from current failures, fairly sure this is unrelated to the entire
> ATA-Passthrough problem:
> May  6 17:52:09 nine kernel: [18838.207805] md: recovery of RAID array md127
> May  6 17:52:09 nine kernel: [18838.207815] md: minimum _guaranteed_  speed:
> 1000 KB/sec/disk.
> May  6 17:52:09 nine kernel: [18838.207818] md: using maximum available idle
> IO bandwidth (but not more than 200000 KB/sec) for recovery.
> May  6 17:52:09 nine kernel: [18838.207831] md: using 128k window, over a
> total of 1953510784 blocks.
> May  6 17:52:09 nine kernel: [18838.207833] md: resuming recovery of md127
> from checkpoint.
> May  6 20:51:21 nine kernel: [29589.980035] mptscsih: ioc0: attempting task
> abort! (sc=ffff8803318f4900)
> May  6 20:51:21 nine kernel: [29589.980041] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8e f6 00 00 01 00 00
> May  6 20:51:28 nine kernel: [29596.503483] mptbase: ioc0:
> LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> May  6 20:51:28 nine kernel: [29596.503747] mptscsih: ioc0: task abort:
> SUCCESS (sc=ffff8803318f4900)
> May  6 20:51:28 nine kernel: [29597.253319] mptbase: ioc0:
> LogInfo(0x31170000): Originator={PL}, Code={IO Device Missing Delay Retry},
> SubCode(0x0000)
> May  6 20:51:28 nine kernel: [29597.253329] mptscsih: ioc0: attempting task
> abort! (sc=ffff8803318f4e00)
> May  6 20:51:28 nine kernel: [29597.253332] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8e fc 00 00 01 00 00
> May  6 20:51:28 nine kernel: [29597.253341] mptscsih: ioc0: task abort:
> SUCCESS (sc=ffff8803318f4e00)
> May  6 20:51:29 nine kernel: [29597.753599] mptbase: ioc0:
> LogInfo(0x31130000): Originator={PL}, Code={IO Not Yet Executed},
> SubCode(0x0000)
> May  6 20:51:29 nine kernel: [29597.753608] mptscsih: ioc0: attempting task
> abort! (sc=ffff8803318f4c00)
> May  6 20:51:29 nine kernel: [29597.753610] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 02 00 00 01 00 00
> May  6 20:51:29 nine kernel: [29597.753619] mptscsih: ioc0: task abort:
> SUCCESS (sc=ffff8803318f4c00)
> May  6 20:51:29 nine kernel: [29597.753622] mptscsih: ioc0: attempting task
> abort! (sc=ffff8803318f5b00)
> May  6 20:51:29 nine kernel: [29597.753624] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 0e 00 00 01 00 00
> May  6 20:51:29 nine kernel: [29597.753633] mptscsih: ioc0: task abort:
> SUCCESS (sc=ffff8803318f5b00)
> May  6 20:51:29 nine kernel: [29597.753636] mptscsih: ioc0: attempting task
> abort! (sc=ffff880331e3d900)
> May  6 20:51:29 nine kernel: [29597.753638] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 14 00 00 00 08 00
> May  6 20:51:29 nine kernel: [29597.753646] mptscsih: ioc0: task abort:
> SUCCESS (sc=ffff880331e3d900)
> May  6 20:51:29 nine kernel: [29597.753649] mptscsih: ioc0: attempting task
> abort! (sc=ffff880331e3d400)
> May  6 20:51:29 nine kernel: [29597.753651] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 14 08 00 00 68 00
> May  6 20:51:29 nine kernel: [29597.753659] mptscsih: ioc0: task abort:
> SUCCESS (sc=ffff880331e3d400)
> May  6 20:51:29 nine kernel: [29597.753671] mptscsih: ioc0: attempting
> target reset! (sc=ffff8803318f4900)
> May  6 20:51:29 nine kernel: [29597.753673] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8e f6 00 00 01 00 00
> May  6 20:51:29 nine kernel: [29597.753685] mptscsih: ioc0: target reset:
> FAILED (sc=ffff8803318f4900)
> May  6 20:51:29 nine kernel: [29597.753693] mptscsih: ioc0: attempting bus
> reset! (sc=ffff8803318f4900)
> May  6 20:51:29 nine kernel: [29597.753695] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8e f6 00 00 01 00 00
> May  6 20:51:29 nine kernel: [29597.753712] mptscsih: ioc0: bus reset:
> FAILED (sc=ffff8803318f4900)
> May  6 20:51:29 nine kernel: [29597.753715] mptscsih: ioc0: attempting host
> reset! (sc=ffff8803318f4900)
> May  6 20:52:04 nine kernel: [29632.830020] mptscsih: ioc0: host reset:
> SUCCESS (sc=ffff8803318f4900)
> May  6 20:52:14 nine kernel: [29642.840021] sd 6:0:5:0: Device offlined -
> not ready after error recovery
> May  6 20:52:14 nine kernel: [29642.840024] sd 6:0:5:0: Device offlined -
> not ready after error recovery
> May  6 20:52:14 nine kernel: [29642.840026] sd 6:0:5:0: Device offlined -
> not ready after error recovery
> May  6 20:52:14 nine kernel: [29642.840028] sd 6:0:5:0: Device offlined -
> not ready after error recovery
> May  6 20:52:14 nine kernel: [29642.840030] sd 6:0:5:0: Device offlined -
> not ready after error recovery
> May  6 20:52:14 nine kernel: [29642.840032] sd 6:0:5:0: Device offlined -
> not ready after error recovery
> May  6 20:52:14 nine kernel: [29642.840076] sd 6:0:5:0: [sdh] Unhandled
> error code
> May  6 20:52:14 nine kernel: [29642.840082] sd 6:0:5:0: [sdh] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> May  6 20:52:14 nine kernel: [29642.840087] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8e f6 00 00 01 00 00
> May  6 20:52:14 nine kernel: [29642.840112] raid5:md127: read error not
> correctable (sector 1284435456 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840129] raid5:md127: read error not
> correctable (sector 1284435464 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840133] raid5:md127: read error not
> correctable (sector 1284435472 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840136] raid5:md127: read error not
> correctable (sector 1284435480 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840139] raid5:md127: read error not
> correctable (sector 1284435488 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840143] raid5:md127: read error not
> correctable (sector 1284435496 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840149] raid5:md127: read error not
> correctable (sector 1284435504 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840196] raid5:md127: read error not
> correctable (sector 1284435512 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840199] raid5:md127: read error not
> correctable (sector 1284435520 on sdh2).
> May  6 20:52:14 nine kernel: [29642.840202] raid5:md127: read error not
> correctable (sector 1284435528 on sdh2).
> May  6 20:52:14 nine kernel: [29642.847676] sd 6:0:5:0: [sdh] Unhandled
> error code
> May  6 20:52:14 nine kernel: [29642.847678] sd 6:0:5:0: [sdh] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> May  6 20:52:14 nine kernel: [29642.847681] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8e fc 00 00 01 00 00
> May  6 20:52:14 nine kernel: [29642.847745] sd 6:0:5:0: [sdh] Unhandled
> error code
> May  6 20:52:14 nine kernel: [29642.847746] sd 6:0:5:0: [sdh] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> May  6 20:52:14 nine kernel: [29642.847749] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 02 00 00 01 00 00
> May  6 20:52:14 nine kernel: [29642.847812] sd 6:0:5:0: [sdh] Unhandled
> error code
> May  6 20:52:14 nine kernel: [29642.847813] sd 6:0:5:0: [sdh] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> May  6 20:52:14 nine kernel: [29642.847816] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 0e 00 00 01 00 00
> May  6 20:52:14 nine kernel: [29642.847871] sd 6:0:5:0: [sdh] Unhandled
> error code
> May  6 20:52:14 nine kernel: [29642.847873] sd 6:0:5:0: [sdh] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> May  6 20:52:14 nine kernel: [29642.847875] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 14 00 00 00 08 00
> May  6 20:52:14 nine kernel: [29642.847907] sd 6:0:5:0: [sdh] Unhandled
> error code
> May  6 20:52:14 nine kernel: [29642.847908] sd 6:0:5:0: [sdh] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> May  6 20:52:14 nine kernel: [29642.847911] sd 6:0:5:0: [sdh] CDB: Read(10):
> 28 00 4c 8f 14 08 00 00 68 00
> May  6 20:52:19 nine kernel: [29647.840019] mptbase: ioc0: WARNING - Issuing
> Reset from mpt_config!!
> May  6 20:52:50 nine kernel: [29678.961260] ------------[ cut here
> ]------------
> May  6 20:52:50 nine kernel: [29678.961268] WARNING: at
> /home/kernel-ppa/mainline/build/kernel/workqueue.c:485
> flush_cpu_workqueue+0x8c/0x90()
> May  6 20:52:50 nine kernel: [29678.961271] Hardware name: empty
> May  6 20:52:50 nine kernel: [29678.961273] Modules linked in: btrfs
> zlib_deflate crc32c libcrc32c xfs exportfs mptctl binfmt_misc ppdev
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge
> stp kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
> psmouse serio_raw ioatdma snd i5100_edac nvidia(P) dca soundcore
> snd_page_alloc edac_core lp parport raid10 raid456 async_raid6_recov
> async_pq raid6_pq async_xor ses enclosure xor async_memcpy async_tx raid1
> raid0 multipath linear ahci e1000e mptsas mptscsih mptbase
> scsi_transport_sas
> May  6 20:52:50 nine kernel: [29678.961333] Pid: 321, comm: mpt/0 Tainted:
> P           2.6.34-020634rc6-generic #020634rc6
> May  6 20:52:50 nine kernel: [29678.961336] Call Trace:
> May  6 20:52:50 nine kernel: [29678.961341]  [<ffffffff8107a9ac>] ?
> flush_cpu_workqueue+0x8c/0x90
> May  6 20:52:50 nine kernel: [29678.961346]  [<ffffffff8105f1ec>]
> warn_slowpath_common+0x8c/0xc0
> May  6 20:52:50 nine kernel: [29678.961350]  [<ffffffff8105f234>]
> warn_slowpath_null+0x14/0x20
> May  6 20:52:50 nine kernel: [29678.961353]  [<ffffffff8107a9ac>]
> flush_cpu_workqueue+0x8c/0x90
> May  6 20:52:50 nine kernel: [29678.961357]  [<ffffffff8106f981>] ?
> try_to_del_timer_sync+0x51/0xe0
> May  6 20:52:50 nine kernel: [29678.961360]  [<ffffffff8107aa74>]
> flush_workqueue+0x44/0x70
> May  6 20:52:50 nine kernel: [29678.961373]  [<ffffffffa004531c>]
> mptsas_cleanup_fw_event_q+0x12c/0x160 [mptsas]
> May  6 20:52:50 nine kernel: [29678.961378]  [<ffffffffa0048434>]
> mptsas_ioc_reset+0x94/0x130 [mptsas]
> May  6 20:52:50 nine kernel: [29678.961383]  [<ffffffff81033d39>] ?
> default_spin_lock_flags+0x9/0x10
> May  6 20:52:50 nine kernel: [29678.961389]  [<ffffffffa001222d>]
> mpt_signal_reset+0x4d/0x60 [mptbase]
> May  6 20:52:50 nine kernel: [29678.961394]  [<ffffffffa0018eb6>]
> mpt_SoftResetHandler+0x1b6/0x3c0 [mptbase]
> May  6 20:52:50 nine kernel: [29678.961399]  [<ffffffffa001bee7>]
> mpt_config+0x307/0x640 [mptbase]
> May  6 20:52:50 nine kernel: [29678.961404]  [<ffffffffa004c6f0>] ?
> mptsas_firmware_event_work+0x0/0xe80 [mptsas]
> May  6 20:52:50 nine kernel: [29678.961409]  [<ffffffffa001d0b1>]
> mpt_findImVolumes+0xb1/0x600 [mptbase]
> May  6 20:52:50 nine kernel: [29678.961415]  [<ffffffffa004c6f0>] ?
> mptsas_firmware_event_work+0x0/0xe80 [mptsas]
> May  6 20:52:50 nine kernel: [29678.961419]  [<ffffffffa004cd88>]
> mptsas_firmware_event_work+0x698/0xe80 [mptsas]
> May  6 20:52:50 nine kernel: [29678.961424]  [<ffffffff8100985b>] ?
> __switch_to+0xbb/0x2e0
> May  6 20:52:50 nine kernel: [29678.961428]  [<ffffffff8105118e>] ?
> put_prev_entity+0x2e/0x80
> May  6 20:52:50 nine kernel: [29678.961430]  [<ffffffff81051af6>] ?
> finish_task_switch+0x66/0xd0
> May  6 20:52:50 nine kernel: [29678.961435]  [<ffffffffa004c6f0>] ?
> mptsas_firmware_event_work+0x0/0xe80 [mptsas]
> May  6 20:52:50 nine kernel: [29678.961438]  [<ffffffff8107a10c>]
> run_workqueue+0xbc/0x190
> May  6 20:52:50 nine kernel: [29678.961441]  [<ffffffff8107a65b>]
> worker_thread+0x9b/0x100
> May  6 20:52:50 nine kernel: [29678.961444]  [<ffffffff8107edc0>] ?
> autoremove_wake_function+0x0/0x40
> May  6 20:52:50 nine kernel: [29678.961447]  [<ffffffff8107a5c0>] ?
> worker_thread+0x0/0x100
> May  6 20:52:50 nine kernel: [29678.961450]  [<ffffffff8107e9e6>]
> kthread+0x96/0xa0
> May  6 20:52:50 nine kernel: [29678.961453]  [<ffffffff8100be64>]
> kernel_thread_helper+0x4/0x10
> May  6 20:52:50 nine kernel: [29678.961456]  [<ffffffff8107e950>] ?
> kthread+0x0/0xa0
> May  6 20:52:50 nine kernel: [29678.961458]  [<ffffffff8100be60>] ?
> kernel_thread_helper+0x0/0x10
> May  6 20:52:50 nine kernel: [29678.961460] ---[ end trace 5b0b1793526edc2a
> ]---
> May  6 20:53:20 nine kernel: [29709.040090] mptscsih: ioc0: attempting task
> abort! (sc=ffff880331812400)
> May  6 20:53:20 nine kernel: [29709.040093] sd 6:0:15:0: [sdr] CDB:
> Write(10): 2a 00 00 00 00 47 00 00 02 00
> May  6 20:53:50 nine kernel: [29739.040011] mptscsih: ioc0: WARNING -
> Issuing Reset from mptscsih_IssueTaskMgmt!!
> May  6 20:54:13 nine kernel: [29761.700122] md127_resync  D
> ffff880001f55740     0  6733      2 0x00000000
> May  6 20:54:13 nine kernel: [29761.700130]  ffff8803318f3b90
> 0000000000000046 ffff8803318f3b50 ffff8803318f3fd8
> May  6 20:54:13 nine kernel: [29761.700134]  ffff8803318eae20
> 0000000000015740 0000000000015740 ffff8803318f3fd8
> May  6 20:54:13 nine kernel: [29761.700137]  0000000000015740
> ffff8803318f3fd8 0000000000015740 ffff8803318eae20
> May  6 20:54:13 nine kernel: [29761.700141] Call Trace:
> May  6 20:54:13 nine kernel: [29761.700160]  [<ffffffffa00f20e2>]
> get_active_stripe+0x232/0x340 [raid456]
> May  6 20:54:13 nine kernel: [29761.700167]  [<ffffffff810507e0>] ?
> default_wake_function+0x0/0x20
> May  6 20:54:13 nine kernel: [29761.700172]  [<ffffffffa00f49ad>]
> sync_request+0x26d/0x2d0 [raid456]
> May  6 20:54:13 nine kernel: [29761.700176]  [<ffffffffa00f1e8e>] ?
> raid5_unplug_device+0x7e/0xa0 [raid456]
> 
> 

As of now you can continue with patched for dma boundary alignment issue.
For this new issue you can provide me complete var log messages with debug
turned on.

use 0x8188 > /sys/modules/mptbase/parameters/mpt_debug_level

Thanks,
Kashyap
> On Wed, May 5, 2010 at 3:35 AM, <bugzilla-daemon@bugzilla.kernel.org> wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=14831
> >
> >
> > Andrew Dunn <andrew.g.dunn.dod@gmail.com> changed:
> >
> >           What    |Removed                     |Added
> >
> > ----------------------------------------------------------------------------
> >                 CC|                            |
> > andrew.g.dunn.dod@gmail.com
> >
> >
> >
> >
> > --- Comment #18 from Andrew Dunn <andrew.g.dunn.dod@gmail.com>  2010-05-05
> > 10:35:17 ---
> > I anxiously await confirmation of this patch. This issue has been plaguing
> > me
> > for quite a while. Just for verification the mpt2sas controllers don't have
> > problems with this? I was thinking of trying to get an AOC-USAS2-L8i
> > (
> > http://www.supermicro.com/products/accessories/addon/AOC-USAS2-L8i.cfm?TYP=I
> > )
> >
> > --
> > Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> > ------- You are receiving this mail because: -------
> > You are on the CC list for the bug.
> >

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
