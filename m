From: Borislav Petkov <bp@amd64.org>
Subject: "[SCSI] sd: limit the scope of the async probe domain" breaks
 booting here
Date: Wed, 30 May 2012 18:51:09 +0200
Message-ID: <20120530165109.GF4771@aftab.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <JBottomley@Parallels.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dudes,

so I've been testing latest linus
(731a7378b81c2f5fa88ca1ae20b83d548d5613dc) here and my box fails booting
because it can't find the root partition, see message below.

I did a bisect run (also below) and pointed me to the first bad commit
(see below too).

Reverting the commit in question fixes booting.

Let me know what other info you'd need.

Thanks.


* bisect
========

git bisect start
# bad: [731a7378b81c2f5fa88ca1ae20b83d548d5613dc] Merge branch 'x86-trampoline-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 731a7378b81c2f5fa88ca1ae20b83d548d5613dc
# good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
git bisect good 76e10d158efb6d4516018846f60c2ab5501900bc
# bad: [fb09bafda67041b74a668dc9d77735e36bd33d3b] Merge tag 'staging-3.5-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect bad fb09bafda67041b74a668dc9d77735e36bd33d3b
# bad: [da4f58ffa08a7b7012fab9c205fa0f6ba40fec42] Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect bad da4f58ffa08a7b7012fab9c205fa0f6ba40fec42
# good: [9a00be04e66cc025ab4558d34620615d5c4de5b6] iwlwifi: add BT reduced tx power flag
git bisect good 9a00be04e66cc025ab4558d34620615d5c4de5b6
# good: [ff8ce5f67ddca709fe59e6173f89260f0fdc2b22] Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm
git bisect good ff8ce5f67ddca709fe59e6173f89260f0fdc2b22
# good: [ac1806572df55b6125ad9d117906820dacfa3145] Merge tag 'regulator-3.5' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect good ac1806572df55b6125ad9d117906820dacfa3145
# bad: [76b311fdbdd2e16e5d39cd496a67aa1a1b948914] [SCSI] lpfc 8.3.31: Update lpfc to version 8.3.31
git bisect bad 76b311fdbdd2e16e5d39cd496a67aa1a1b948914
# good: [949e71f17d9a5c59fa7b02cce3b548384bff1c92] [SCSI] fcoe: Don't hold rtnl_mutex in fcoe_update_src_mac
git bisect good 949e71f17d9a5c59fa7b02cce3b548384bff1c92
# bad: [794c10fa0fa4d1781c5651c31e3d4d0b71629128] [SCSI] sg: remove while (1) non-loop
git bisect bad 794c10fa0fa4d1781c5651c31e3d4d0b71629128
# good: [852af20aa64ef34ab07de978c676e1e8860dca2e] [SCSI] hpsa: retry driver initiated commands on busy status
git bisect good 852af20aa64ef34ab07de978c676e1e8860dca2e
# good: [e16a33adc0e59aa96a483fd2923d77e674f013c1] [SCSI] hpsa: refine interrupt handler locking for greater concurrency
git bisect good e16a33adc0e59aa96a483fd2923d77e674f013c1
# good: [21334ea9086c31db38e76152a1e31001a0ed288a] [SCSI] hpsa: removed unused member maxQsinceinit
git bisect good 21334ea9086c31db38e76152a1e31001a0ed288a
# bad: [a7a20d103994fd760766e6c9d494daa569cbfe06] [SCSI] sd: limit the scope of the async probe domain
git bisect bad a7a20d103994fd760766e6c9d494daa569cbfe06
# good: [e85c59746957fd6e3595d02cf614370056b5816e] [SCSI] hpsa: dial down lockup detection during firmware flash
git bisect good e85c59746957fd6e3595d02cf614370056b5816e



* first bad commit
==================

commit a7a20d103994fd760766e6c9d494daa569cbfe06
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 22 17:05:11 2012 -0700

    [SCSI] sd: limit the scope of the async probe domain
    
    sd injects and synchronizes probe work on the global kernel-wide domain.
    This runs into conflict with PM that wants to perform resume actions in
    async context:
    
    [  494.237079] INFO: task kworker/u:3:554 blocked for more than 120 seconds.
    [  494.294396] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [  494.360809] kworker/u:3     D 0000000000000000     0   554      2 0x00000000
    [  494.420739]  ffff88012e4d3af0 0000000000000046 ffff88013200c160 ffff88012e4d3fd8
    [  494.484392]  ffff88012e4d3fd8 0000000000012500 ffff8801394ea0b0 ffff88013200c160
    [  494.548038]  ffff88012e4d3ae0 00000000000001e3 ffffffff81a249e0 ffff8801321c5398
    [  494.611685] Call Trace:
    [  494.632649]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
    [  494.674687]  [<ffffffff8104b968>] async_synchronize_cookie_domain+0xb6/0x112
    [  494.734177]  [<ffffffff810461ff>] ? __init_waitqueue_head+0x50/0x50
    [  494.787134]  [<ffffffff8131a224>] ? scsi_remove_target+0x48/0x48
    [  494.837900]  [<ffffffff8104b9d9>] async_synchronize_cookie+0x15/0x17
    [  494.891567]  [<ffffffff8104ba49>] async_synchronize_full+0x54/0x70  <-- here we wait for async contexts to complete
    [  494.943783]  [<ffffffff8104b9f5>] ? async_synchronize_full_domain+0x1a/0x1a
    [  495.002547]  [<ffffffffa00114b1>] sd_remove+0x2c/0xa2 [sd_mod]
    [  495.051861]  [<ffffffff812fe94f>] __device_release_driver+0x86/0xcf
    [  495.104807]  [<ffffffff812fe9bd>] device_release_driver+0x25/0x32  <-- here we take device_lock()
    
    [  853.511341] INFO: task kworker/u:4:549 blocked for more than 120 seconds.
    [  853.568693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    [  853.635119] kworker/u:4     D ffff88013097b5d0     0   549      2 0x00000000
    [  853.695129]  ffff880132773c40 0000000000000046 ffff880130790000 ffff880132773fd8
    [  853.758990]  ffff880132773fd8 0000000000012500 ffff88013288a0b0 ffff880130790000
    [  853.822796]  0000000000000246 0000000000000040 ffff88013097b5c8 ffff880130790000
    [  853.886633] Call Trace:
    [  853.907631]  [<ffffffff8149dd25>] schedule+0x5a/0x5c
    [  853.949670]  [<ffffffff8149cc44>] __mutex_lock_common+0x220/0x351
    [  854.001225]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
    [  854.049082]  [<ffffffff81304bd7>] ? device_resume+0x58/0x1c4
    [  854.097011]  [<ffffffff8149ce48>] mutex_lock_nested+0x2f/0x36   <-- here we wait for device_lock()
    [  854.145591]  [<ffffffff81304bd7>] device_resume+0x58/0x1c4
    [  854.192066]  [<ffffffff81304d61>] async_resume+0x1e/0x45
    [  854.237019]  [<ffffffff8104bc93>] async_run_entry_fn+0xc6/0x173  <-- ...while running in async context
    
    Provide a 'scsi_sd_probe_domain' so that async probe actions actions can
    be flushed without regard for the state of PM, and allow for the resume
    path to handle devices that have transitioned from SDEV_QUIESCE to
    SDEV_DEL prior to resume.
    
    Acked-by: Alan Stern <stern@rowland.harvard.edu>
    [alan: uplevel scsi_sd_probe_domain, clarify scsi_device_resume]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    [jejb: remove unneeded config guards in include file]
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>

* Error msg:
============

[    4.582698] ata4.00: configured for UDMA/133
[    4.587609] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5001AALS-0 01.0 PQ: 0 ANSI: 5
[    4.597471] sd 3:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    4.597750] sd 3:0:0:0: Attached scsi generic sg0 type 0
[    4.599666] scsi 4:0:1:0: CD-ROM            Optiarc  DVD RW AD-7240S  1.01 PQ: 0 ANSI: 5
[    4.602711] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.602714] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.603366] sr 4:0:1:0: Attached scsi CD-ROM sr0
[    4.603922] sr 4:0:1:0: Attached scsi generic sg1 type 5
[    4.604481] VFS: Cannot open root device "sda2" or unknown-block(0,0): error -6
[    4.604484] Please append a correct "root=" boot option; here are the available partitions:
[    4.604501] 0b00         1048575 sr0  driver: sr
[    4.604506] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
[    4.604511] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.0+ #2
[    4.604512] Call Trace:
[    4.604526]  [<ffffffff814223e4>] panic+0xbd/0x1c4
[    4.604533]  [<ffffffff81422538>] ? printk+0x4d/0x4f
[    4.604540]  [<ffffffff81ac5f72>] mount_block_root+0x251/0x26f
[    4.604545]  [<ffffffff81ac60f5>] mount_root+0x56/0x5a
[    4.604550]  [<ffffffff81ac6259>] prepare_namespace+0x160/0x18d
[    4.604554]  [<ffffffff81ac5c50>] kernel_init+0x1eb/0x1fd
[    4.604560]  [<ffffffff81ac5495>] ? loglevel+0x31/0x31
[    4.604567]  [<ffffffff8142ced4>] kernel_thread_helper+0x4/0x10
[    4.604573]  [<ffffffff81425386>] ? retint_restore_args+0xe/0xe
[    4.604577]  [<ffffffff81ac5a65>] ? start_kernel+0x2ee/0x2ee
[    4.604582]  [<ffffffff8142ced0>] ? gs_change+0xb/0xb
[    4.605421] ------------[ cut here ]------------
[    4.605428] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x2a/0x56()
[    4.605430] Hardware name: Dinar
[    4.605432] Modules linked in:
[    4.605436] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.0+ #2
[    4.605437] Call Trace:
[    4.605446]  <IRQ>  [<ffffffff8102f1fc>] warn_slowpath_common+0x85/0x9d
[    4.605451]  [<ffffffff8102f22e>] warn_slowpath_null+0x1a/0x1c
[    4.605456]  [<ffffffff81019cad>] native_smp_send_reschedule+0x2a/0x56
[    4.605463]  [<ffffffff8105e531>] trigger_load_balance+0x1ed/0x21a
[    4.605467]  [<ffffffff810581b8>] scheduler_tick+0xe9/0xf2
[    4.605472]  [<ffffffff8103cbe9>] update_process_times+0x67/0x77
[    4.605477]  [<ffffffff8107122f>] tick_sched_timer+0x72/0x91
[    4.605481]  [<ffffffff8104e4c1>] __run_hrtimer+0xc3/0x17f
[    4.605486]  [<ffffffff810711bd>] ? tick_nohz_handler+0xd1/0xd1
[    4.605490]  [<ffffffff8104edbd>] hrtimer_interrupt+0xd4/0x197
[    4.605497]  [<ffffffff8142d5ea>] smp_apic_timer_interrupt+0x86/0x99
[    4.605501]  [<ffffffff8142c5dc>] apic_timer_interrupt+0x6c/0x80
[    4.605510]  <EOI>  [<ffffffff811d523a>] ? delay_tsc+0x23/0x50
[    4.605515]  [<ffffffff811d5199>] __delay+0xf/0x11
[    4.605520]  [<ffffffff811d51c4>] __const_udelay+0x29/0x2b
[    4.605525]  [<ffffffff81019d7a>] native_stop_other_cpus+0x78/0x13d
[    4.605530]  [<ffffffff814223f3>] panic+0xcc/0x1c4
[    4.605535]  [<ffffffff81422538>] ? printk+0x4d/0x4f
[    4.605540]  [<ffffffff81ac5f72>] mount_block_root+0x251/0x26f
[    4.605544]  [<ffffffff81ac60f5>] mount_root+0x56/0x5a
[    4.605548]  [<ffffffff81ac6259>] prepare_namespace+0x160/0x18d
[    4.605552]  [<ffffffff81ac5c50>] kernel_init+0x1eb/0x1fd
[    4.605557]  [<ffffffff81ac5495>] ? loglevel+0x31/0x31
[    4.605562]  [<ffffffff8142ced4>] kernel_thread_helper+0x4/0x10
[    4.605566]  [<ffffffff81425386>] ? retint_restore_args+0xe/0xe
[    4.605570]  [<ffffffff81ac5a65>] ? start_kernel+0x2ee/0x2ee
[    4.605574]  [<ffffffff8142ced0>] ? gs_change+0xb/0xb
[    4.605577] ---[ end trace 4eaa2a86a8e2da24 ]---


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
