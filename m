From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] Fusion MPT SPI bringup takes 80 seconds when the kernel
 is quiet
Date: Thu, 25 Aug 2011 17:00:49 GMT
Message-ID: <201108251700.p7PH0nVF003094@demeter1.kernel.org>
References: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:48072 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1HYRAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 13:00:50 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7PH0nLR003095
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2011 17:00:50 GMT
In-Reply-To: <bug-26692-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D26692





--- Comment #4 from Ferenc W=C3=A1gner <wferi@niif.hu>  2011-08-25 17:0=
0:48 ---
If I boot with 'quiet mptbase.mpt_fwfault_debug=3D1' I always reach the=
 following
panic:

[   19.692064] Kernel panic - not syncing: ioc0: Firmware is halted due=
 to
command timeout
[   19.692066]=20
[   19.701704] Pid: 195, comm: scsi_scan_2 Not tainted 3.1.0-rc3+ #44
[   19.707953] Call Trace:
[   19.710482]  [<c12ce914>] ? panic+0x4d/0x14a
[   19.714830]  [<f82eba69>] ? mpt_halt_firmware+0x50/0x50 [mptbase]
[   19.721001]  [<f82ebab3>] ? mpt_SoftResetHandler+0x4a/0x2e3 [mptbase=
]
[   19.727519]  [<f82ed8df>] ? mpt_Soft_Hard_ResetHandler+0xb/0x1f [mpt=
base]
[   19.734385]  [<f82edef9>] ? mpt_config+0x457/0x4b5 [mptbase]
[   19.740124]  [<f82a955e>] ? mptspi_write_spi_device_pg1+0x2a4/0x2f7 =
[mptspi]
[   19.747246]  [<f82a960d>] ? mptspi_write_width+0x5c/0x61 [mptspi]
[   19.753414]  [<f82a9d9f>] ? mptspi_target_alloc+0x38/0x1a6 [mptspi]
[   19.759761]  [<f82a9eed>] ? mptspi_target_alloc+0x186/0x1a6 [mptspi]
[   19.766194]  [<f8215cc4>] ? scsi_alloc_target+0x194/0x1ed [scsi_mod]
[   19.772624]  [<f8216bd4>] ? __scsi_scan_target+0x40/0x536 [scsi_mod]
[   19.779054]  [<c100b93d>] ? __switch_to+0xe3/0x155
[   19.783920]  [<c12cf192>] ? schedule+0x5f7/0x622
[   19.788622]  [<f8217111>] ? scsi_scan_channel+0x47/0x76 [scsi_mod]
[   19.794881]  [<f8217200>] ? scsi_scan_host_selected+0xc0/0xff [scsi_=
mod]
[   19.801657]  [<f8217290>] ? do_scsi_scan_host+0x51/0x56 [scsi_mod]
[   19.807914]  [<f82172a9>] ? do_scan_async+0x14/0x107 [scsi_mod]
[   19.813910]  [<f8217295>] ? do_scsi_scan_host+0x56/0x56 [scsi_mod]
[   19.820170]  [<c1052417>] ? kthread+0x65/0x6a
[   19.824602]  [<c10523b2>] ? kthread_worker_fn+0x119/0x119
[   19.830080]  [<c12d553e>] ? kernel_thread_helper+0x6/0x10
[   19.835566] Rebooting in 10 seconds..

I hope it more or less answers where the time is being spent. Sometime =
instead
of rebooting the console output continues as:

[   19.839551] ------------[ cut here ]------------
[   19.839551] WARNING: at arch/x86/kernel/smp.c:118 resched_task+0x59/=
0x5b()
[   19.839551] Hardware name: eserver xSeries 345 -[867091X]-
[   19.839551] Modules linked in: sg sr_mod cdrom mptspi(+) mptscsih
ata_generic mptbase scsi_transport_spi pata_serverworks libata ohci_hcd
ehci_hcd scsi_mod e1000 usbcore floppy
[   19.839551] Pid: 6, comm: migration/0 Not tainted 3.1.0-rc3+ #44
[   19.839551] Call Trace:
[   19.839551]  [<c102c396>] ? resched_task+0x59/0x5b
[   19.839551]  [<c103bd97>] ? warn_slowpath_common+0x68/0x7a
[   19.839551]  [<c103bdb5>] ? warn_slowpath_null+0xc/0xf
[   19.839551]  [<c102c396>] ? resched_task+0x59/0x5b
[   19.839551]  [<c102cd44>] ? check_preempt_curr+0x35/0x5f
[   19.839551]  [<c1036463>] ? active_load_balance_cpu_stop+0x1a0/0x1ed
[   19.839551]  [<c10362c3>] ? pull_task+0x34/0x34
[   19.839551]  [<c1075829>] ? cpu_stopper_thread+0xbd/0x150
[   19.839551]  [<c12cf192>] ? schedule+0x5f7/0x622
[   19.839551]  [<c10365f4>] ? try_to_wake_up+0x144/0x14d
[   19.839551]  [<c102d364>] ? __wake_up_common+0x34/0x59
[   19.839551]  [<c10322de>] ? complete+0x28/0x36
[   19.839551]  [<c107576c>] ? res_counter_charge+0xcd/0xcd
[   19.839551]  [<c1052417>] ? kthread+0x65/0x6a
[   19.839551]  [<c10523b2>] ? kthread_worker_fn+0x119/0x119
[   19.839551]  [<c12d553e>] ? kernel_thread_helper+0x6/0x10
[   19.839551] ---[ end trace af3cae9d17823201 ]---

but it's probably unrelated. I also recompiled with CONFIG_FUSION_LOGGI=
NG=3Dy so
setting 'mptbase.mpt_debug_level=3D-1' actually has an effect. But this=
 of course
can't be seen when coupled with 'quiet', so the above console output do=
esn't
show this. I'm trying to find a better mpt_debug_level value.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
