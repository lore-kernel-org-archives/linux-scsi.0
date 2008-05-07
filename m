From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] mptsas: add mptsas_shutdown to call pci_disable_msi
Date: Wed, 7 May 2008 16:40:22 -0700
Message-ID: <86802c440805071640m46ceb05ex14f25d4b6bc58d7f@mail.gmail.com>
References: <200804221947.33524.yhlu.kernel@gmail.com>
	 <86802c440804222012w1536b0a7y14a5c2f9dc333624@mail.gmail.com>
	 <20080507163155.1217515f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:35228 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbYEGXkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2008 19:40:25 -0400
Received: by rv-out-0506.google.com with SMTP id l9so623323rvb.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2008 16:40:23 -0700 (PDT)
In-Reply-To: <20080507163155.1217515f.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, sathya.prakash@lsi.com, Eric.Moore@lsi.com, ebiederm@xmission.com

On Wed, May 7, 2008 at 4:31 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 22 Apr 2008 20:12:08 -0700
>  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Tue, Apr 22, 2008 at 7:47 PM, Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>  > >
>  > >
>  > >  this change
>  > >
>  > >  | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
>  > >  | Author: Prakash, Sathya <sathya.prakash@lsi.com>
>  > >  | Date:   Fri Mar 7 15:53:21 2008 +0530
>  > >  |
>  > >  |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
>  > >  |
>  > >  |     This patch modifies the driver to enable MSI by default for all SAS chips.
>  > >  |
>  > >  cause kexec RHEL 5.1 kernel fail.
>  > >
>  > >  root casue: the rhel 5.1 kernel still use INTx emulation.
>  > >  and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on kexec path
>  > >
>  > >  so try to call mptsas_remove in mptsas_shutdown.
>  > >  then pci_disable_msi will be called via mptsas_remove==>mptscih_remove==>
>  > >  mpt_detach.
>  > >
>  > >  Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  > >  CC: Prakash, Sathya <sathya.prakash@lsi.com>
>  > >  CC: "Moore, Eric" <Eric.Moore@lsi.com>
>  > >
>  > >  Index: linux-2.6/drivers/message/fusion/mptsas.c
>  > >  ===================================================================
>  > >  --- linux-2.6.orig/drivers/message/fusion/mptsas.c
>  > >  +++ linux-2.6/drivers/message/fusion/mptsas.c
>  > >  @@ -3327,6 +3327,11 @@ static void __devexit mptsas_remove(stru
>  > >         mptscsih_remove(pdev);
>  > >   }
>  > >
>  > >  +static void mptsas_shutdown(struct pci_dev *pdev)
>  > >  +{
>  > >  +       mptsas_remove(pdev);
>  > >  +}
>  > >  +
>  > >   static struct pci_device_id mptsas_pci_table[] = {
>  > >         { PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1064,
>  > >                 PCI_ANY_ID, PCI_ANY_ID },
>  > >  @@ -3348,7 +3353,7 @@ static struct pci_driver mptsas_driver =
>  > >         .id_table       = mptsas_pci_table,
>  > >         .probe          = mptsas_probe,
>  > >         .remove         = __devexit_p(mptsas_remove),
>  > >  -       .shutdown       = mptscsih_shutdown,
>  > >  +       .shutdown       = mptsas_shutdown,
>  > >   #ifdef CONFIG_PM
>  > >         .suspend        = mptscsih_suspend,
>  > >         .resume         = mptscsih_resume,
>  > >  --
>  >
>  > fail on one system with big sas expander...
>  >
>  > LBSuse:~ # mkdir /xx
>  > LBSuse:~ # mount /dev/sdl1 /xx
>  > LBSuse:~ # cd /xx
>  > LBSuse:/xx # sh kk_rh_5.1
>  > LBSuse:/xx # ./kexec -e
>  > BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
>  > IP: [<ffffffff80337af4>] sysfs_find_dirent+0x1f/0x5f
>  > PGD 41f137067 PUD 424482067 PMD 0
>  > Oops: 0000 [1] SMP
>  > CPU 7
>  > Modules linked in:
>  > Pid: 7534, comm: kexec Not tainted
>
>  I don't understand your email.
>
>  Are you saying that this oops is the thing which your patch fixes?
>
>  Or are you saying that this oops occurs even after your patch is applied?
>  That we have a second regression?
>
>
>
>  > 2.6.25-sched-devel.git-x86-latest.git-03823-g1508ed0-dirty #135
>  > RIP: 0010:[<ffffffff80337af4>]  [<ffffffff80337af4>] sysfs_find_dirent+0x1f/0x5f
>  > RSP: 0018:ffff8104238f7708  EFLAGS: 00010246
>  > RAX: 0000000000000000 RBX: ffffffff80cd36a5 RCX: 000000008c0f362e
>  > RDX: ffffffff80e20ab0 RSI: ffffffff80cd36a5 RDI: 0000000000000000
>  > RBP: ffff8104238f7728 R08: 0000000000000000 R09: 000000008c0f362e
>  > R10: ffff8104238f77f8 R11: 000000008c0f362e R12: 0000000000000000
>  > R13: ffff810223190358 R14: 0000000000000000 R15: 0000000000000000
>  > FS:  00007fde8859d6f0(0000) GS:ffff810427039f00(0000) knlGS:0000000000000000
>  > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  > CR2: 0000000000000028 CR3: 00000004238b8000 CR4: 00000000000006e0
>  > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  > Process kexec (pid: 7534, threadinfo ffff8104238f6000, task ffff8104238e0000)
>  > Stack:  0000000000000000 000000008c0f362e ffffffff80cd36a5 0000000000000000
>  >  ffff8104238f7758 ffffffff80337b70 000000008c0f362e 000000008c0f362e
>  >  ffff810223190268 ffffffff80e1fb20 ffff8104238f7798 ffffffff8033966e
>  > Call Trace:
>  >  [<ffffffff80337b70>] sysfs_get_dirent+0x3c/0x72
>  >  [<ffffffff8033966e>] sysfs_remove_group+0x38/0xb4
>  >  [<ffffffff80633007>] dpm_sysfs_remove+0x2f/0x45
>  >  [<ffffffff806336d3>] device_pm_remove+0x34/0x85
>  >  [<ffffffff8062b283>] device_del+0x30/0x1b0
>  >  [<ffffffff8062b428>] device_unregister+0x25/0x48
>  >  [<ffffffff80639e73>] enclosure_unregister+0x85/0xcb
>  >  [<ffffffff807dad42>] ses_intf_remove+0x8b/0xa8
>  >  [<ffffffff8062b2fb>] device_del+0xa8/0x1b0
>  >  [<ffffffff8062b428>] device_unregister+0x25/0x48
>  >  [<ffffffff80700bb4>] __scsi_remove_device+0x4c/0xaf
>  >  [<ffffffff80700c50>] scsi_remove_device+0x39/0x5c
>  >  [<ffffffff80700d15>] __scsi_remove_target+0xa2/0xf6
>  >  [<ffffffff80700de0>] ? __remove_child+0x0/0x4f
>  >  [<ffffffff80700e12>] __remove_child+0x32/0x4f
>  >  [<ffffffff8062ab27>] ? next_device+0x21/0x45
>  >  [<ffffffff8062ac23>] device_for_each_child+0x40/0x84
>  >  [<ffffffff80713d8e>] ? do_sas_phy_delete+0x0/0x66
>  >  [<ffffffff80700dbc>] scsi_remove_target+0x53/0x77
>  >  [<ffffffff807134b0>] sas_rphy_remove+0x42/0x81
>  >  [<ffffffff80713514>] sas_rphy_delete+0x25/0x48
>  >  [<ffffffff80713570>] sas_port_delete+0x39/0x147
>  >  [<ffffffff802259e0>] ? mcount_call+0x5/0x35
>  >  [<ffffffff80713d8e>] ? do_sas_phy_delete+0x0/0x66
>  >  [<ffffffff80713dc2>] do_sas_phy_delete+0x34/0x66
>  >  [<ffffffff8062ac23>] device_for_each_child+0x40/0x84
>  >  [<ffffffff80713d8e>] ? do_sas_phy_delete+0x0/0x66
>  >  [<ffffffff8071343f>] sas_remove_children+0x2e/0x5d
>  >  [<ffffffff807134b7>] sas_rphy_remove+0x49/0x81
>  >  [<ffffffff80713514>] sas_rphy_delete+0x25/0x48
>  >  [<ffffffff80713570>] sas_port_delete+0x39/0x147
>  >  [<ffffffff802259e0>] ? mcount_call+0x5/0x35
>  >  [<ffffffff80713d8e>] ? do_sas_phy_delete+0x0/0x66
>  >  [<ffffffff80713dc2>] do_sas_phy_delete+0x34/0x66
>  >  [<ffffffff8062ac23>] device_for_each_child+0x40/0x84
>  >  [<ffffffff8071343f>] sas_remove_children+0x2e/0x5d
>  >  [<ffffffff807136a6>] sas_remove_host+0x28/0x3e
>  >  [<ffffffff80ab22ab>] mptsas_remove+0x46/0x107
>  >  [<ffffffff802259e0>] ? mcount_call+0x5/0x35
>  >  [<ffffffff8080ef6d>] mptsas_shutdown+0x21/0x37
>  >  [<ffffffff805a6815>] pci_device_shutdown+0x37/0x4d
>  >  [<ffffffff8062a2ad>] device_shutdown+0x64/0xa0
>  >  [<ffffffff8027e57f>] ? blocking_notifier_call_chain+0x27/0x3d
>  >  [<ffffffff8027131e>] kernel_restart_prepare+0x3f/0x5a
>  >  [<ffffffff802716f7>] sys_reboot+0x172/0x1cb
>  >  [<ffffffff802e2ac0>] ? __fput+0x158/0x17b
>  >  [<ffffffff802efc4e>] ? vfs_ioctl+0x3e/0xa2
>  >  [<ffffffff802e2ef0>] ? fput+0x2c/0x42
>  >  [<ffffffff802df2d2>] ? filp_close+0x78/0x9a
>  >  [<ffffffff802df0b4>] ? __put_unused_fd+0x33/0x60
>  >  [<ffffffff802e0bed>] ? sys_close+0x8c/0xdf
>  >  [<ffffffff80225b9b>] system_call_after_swapgs+0x7b/0x80
>  >
>  >
>  > Code: e8 37 85 f2 ff 48 83 c4 18 5b c9 c3 55 48 89 e5 41 54 53 48 83
>  > ec 10 66 66 90 66 90 65 48 8b 04 25 28 00 00 00 48 89 45 e8 31 c0 <48>
>  > 8b 5f 28 49 89 f4 eb 14 48 8b 7b 18 4c 89 e6 e8 25 e8 25 00
>  > RIP  [<ffffffff80337af4>] sysfs_find_dirent+0x1f/0x5f
>  >  RSP <ffff8104238f7708>
>  > CR2: 0000000000000028
>  > ---[ end trace 4ca22418d73866ec ]---
>  >
>  > may need create mptsas that only call pci_disable_msi
>  >
>
>  It would be strange for an interrupt-disabling problem to cause sysfs to go
>  oops?

andrew, updated version has been merged...

YH
