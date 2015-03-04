From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [libsas] Kernel Crash in smp_execute_task
Date: Wed, 04 Mar 2015 18:59:48 -0500
Message-ID: <54F79C74.7070001@interlog.com>
References: <154a8ccd0622409b84859abb1c3259f3@EX01.lg.local> <68a5e8f0ce4f4630bafe5f3505334f3e@EX01.lg.local>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33810 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbbCEAAS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2015 19:00:18 -0500
In-Reply-To: <68a5e8f0ce4f4630bafe5f3505334f3e@EX01.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>

On 15-03-04 06:29 PM, Praveen Murali wrote:
> On second thoughts, should we even let smp commands/requests thru for sas end devices (dev->dev_type == SAS_END_DEV) ? if so, wont the following patch more sense? (also, in my last mail the kernel logs were all messed up; sorry dint realize that when I sent the mail. Trying to fix it here)

LSI SAS-2 and SAS-3 HBAs accept several SMP requests.
For example with a LSI 9300-4i4e and lk-3.19.0:

# smp_rep_manufacturer /dev/bsg/sas_host6
Report manufacturer response:
   SAS-1.1 format: 0
   vendor identification: LSI
   product identification: Virtual SMP Port
   product revision level:

That usage is slightly peculiar since that is being issued
on the machine that has sas_host6 (on its PCIe bus). That
cannot be issued from another machine in the same SAS
domain (e.g. via connections to a common expander). Seen
from an expander (or another HBA) a HBA is a SAS_END_DEV.

It is not clear to me whether this usage (i.e. sending
SMP requests to your own machine's HBA) would be broken
by what you are proposing.

Also I cannot remember ever reading anything in the SAS
drafts that precludes sending SMP requests to a SAS target
(e.g. an enclosure).


As I side note, FreeBSD doesn't have special device nodes
for expanders. It takes advantage of the common practice
in SAS-2 and SAS-3 expanders of including a SES device.
Hence in FreeBSD you might use:
   # smp_discover /dev/ses3
to list the disposition of the phys in the expander which
includes /dev/ses3

Doug Gilbert


> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 58e6183..a44019a 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -72,6 +72,14 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
>          struct sas_internal *i =
>                  to_sas_internal(dev->port->ha->core.shost->transportt);
>
> +       /* can we send smp commands to a device? */
> +       if (dev->dev_type == SAS_END_DEV) {
> +                       printk("%s: can we send a smp request to a device?\n",
> +                                  __func__);
> +                       res = -ECOMM;
> +                       goto out;
> +       }
> +
>          mutex_lock(&dev->ex_dev.cmd_mutex);
>          for (retry = 0; retry < 3; retry++) {
>                  if (test_bit(SAS_DEV_GONE, &dev->state)) {
>
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Praveen Murali
> Sent: Wednesday, March 04, 2015 1:43 PM
> To: linux-scsi@vger.kernel.org; dan.j.williams@intel.com
> Cc: JBottomley@Parallels.com
> Subject: [libsas] Kernel Crash in smp_execute_task
>
> Hi Dan,
>    I am experiencing a crash in smp_execute_task when it calls mutex_lock with 15K SAS drives HP Model EH0146FAWJB (Seagate model ST9146852SS) connected to a Marvell 88SE9485 SAS/SATA 6Gb/s controller; kernel version is 3.4.87. The crash happens as soon as I connect this drive; crash dump is included in the mail.
>
> This mutex lock was introduced in the commit 89d3cf6ac3cdc4f15a82709f8c78ed169a98be5b. What I see is that the mutex is initialized only for devices with type EDGE_DEV or FANOUT_DEV but in my case smp_execute_task gets called and the device type is SAS_END_DEV. To troubleshoot further I added a check in smp_execute_task before calling mutex_lock and mutex_unlock to do these calls only for EDGE_DEV or FANOUT_DEV device types and the disk got detected; no crash this time. I have captured the logs from this run and included in the mail. I guess there are a couple of ways to fix this (1) add the check before using the mutex (2) move the mutex to domain device (from expander device) and initialize it for all device types. Do you think either of these is a valid approach? Or am I missing someth
 ing here.
>
> Thanks for your time!
> Praveen
>
> --------------------------Begin Change in sas_expander.c-----------------------------------
>   diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 58e6183..505ada2 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -72,7 +72,8 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
>          struct sas_internal *i =
>                  to_sas_internal(dev->port->ha->core.shost->transportt);
>
> -       mutex_lock(&dev->ex_dev.cmd_mutex);
> +       if ((dev->dev_type == EDGE_DEV) || (FANOUT_DEV == dev->dev_type))
> +               mutex_lock(&dev->ex_dev.cmd_mutex);
>          for (retry = 0; retry < 3; retry++) {
>                  if (test_bit(SAS_DEV_GONE, &dev->state)) {
>                          res = -ECOMM;
> @@ -144,7 +145,8 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
>                          task = NULL;
>                  }
>          }
> -       mutex_unlock(&dev->ex_dev.cmd_mutex);
> +       if ((dev->dev_type == EDGE_DEV) || (FANOUT_DEV == dev->dev_type))
> +               mutex_unlock(&dev->ex_dev.cmd_mutex);
>
>          BUG_ON(retry == 3 && task != NULL);
>          sas_free_task(task);
> --------------------------End Change in sas_expander.c-----------------------------------
>
> --------------------------------------Begin Kernel log after change-------------------------------
> [  132.667582] sas: phy-1:0 added to port-1:0, phy_mask:0x1 (5000c5001cb4c151) [  132.667595] drivers/scsi/mvsas/mv_sas.c 1225:set wide port phy map 1 [  132.687496] sas: DOING DISCOVERY on port 0, pid:5 [  132.687509] sas: DONE DISCOVERY on port 0, pid:5, result:0
> [  133.001934] scsi 1:0:0:0: Direct-Access     HP       EH0146FAWJB      HPDD PQ: 0 ANSI: 5
> [  133.010371] ssw_validate_device: Not a SATA device; skip
> [  133.010638] sd 1:0:0:0: [sdb] Spinning up disk...
> [  133.034290] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [  133.044469] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [  134.012041] .
> [  134.668084] sas: broadcast received: 0
> [  134.672977] sas: REVALIDATING DOMAIN on port 0, pid:5
> [  134.672984] sas_ex_revalidate_domain: calling sas_find_bcast_dev 1
> [  134.672991] sas_find_bcast_dev: calling sas_get_ex_change_count
> [  134.673129] sas: smp_execute_task: task to dev 5000c5001cb4c151 response: 0x0 status 0x2
> [  134.673258] sas: smp_execute_task: task to dev 5000c5001cb4c151 response: 0x0 status 0x2
> [  134.673385] sas: smp_execute_task: task to dev 5000c5001cb4c151 response: 0x0 status 0x2
> [  134.673394] sas_find_bcast_dev: done [  134.673400] sas_ex_revalidate_domain: done
> [  134.673407] sas: done REVALIDATING DOMAIN on port 0, pid:5, res 0xffffffba
> [  135.016018] ....ready [  138.470597] sd 1:0:0:0: [sdb] READ CAPACITY(16) failed
> [  138.476212] sd 1:0:0:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  138.488301] sd 1:0:0:0: [sdb] Sense not available.
> [  138.495033] sd 1:0:0:0: [sdb] READ CAPACITY failed
> [  138.501825] sd 1:0:0:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  138.516376] sd 1:0:0:0: [sdb] Sense not available.
> [  138.524333] sd 1:0:0:0: [sdb] Write Protect is off
> [  138.532360] sd 1:0:0:0: [sdb] Mode Sense: 00 00 00 00
> [  138.532393] sd 1:0:0:0: [sdb] Asking for cache data failed
> [  138.540642] sd 1:0:0:0: [sdb] Assuming drive cache: write through
> [  138.550085] sd 1:0:0:0: [sdb] READ CAPACITY(16) failed
> [  138.558551] sd 1:0:0:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  138.575243] sd 1:0:0:0: [sdb] Sense not available.
> [  138.583697] sd 1:0:0:0: [sdb] READ CAPACITY failed
> [  138.592104] sd 1:0:0:0: [sdb]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  138.609371] sd 1:0:0:0: [sdb] Sense not available.
> [  138.618292] sd 1:0:0:0: [sdb] Asking for cache data failed
> [  138.627172] sd 1:0:0:0: [sdb] Assuming drive cache: write through
> [  138.636053] sd 1:0:0:0: [sdb] Attached SCSI disk
>
> --------------------------------------End Kernel log after change-------------------------------
>
> --------------------------------------Begin Kernel crash dump-------------------------------
> [  366.946212] scsi 3:0:1:0: Direct-Access     HP       EH0146FAWJB      HPDD PQ: 0 ANSI: 5
> [  366.946905] ssw_validate_device: Not a SATA device; skip
> [  366.947225] sd 3:0:1:0: Attached scsi generic sg1 type 0
> [  366.947370] sd 3:0:1:0: [sdb] Spinning up disk....
> [  368.804046] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  368.804072] IP: [<ffffffff81358457>] __mutex_lock_common.isra.7+0x9c/0x15b
> [  368.804098] PGD 0
> [  368.804114] Oops: 0002 [#1] SMP
> [  368.804143] CPU 1
> [  368.804151] Modules linked in: sg netconsole s3g(PO) uinput joydev hid_multitouch usbhid hid snd_hda_codec_via cpufreq_userspace cpufreq_powersave cpufreq_stats uhci_hcd cpufreq_conservative snd_hda_intel snd_hda_codec snd_hwdep snd_pcm sdhci_pci snd_page_alloc sdhci snd_timer snd psmouse evdev serio_raw pcspkr soundcore xhci_hcd shpchp s3g_drm(O) mvsas mmc_core ahci libahci drm i2c_core acpi_cpufreq mperf video processor button thermal_sys dm_dmirror exfat_fs exfat_core dm_zcache dm_mod padlock_aes aes_generic padlock_sha iscsi_target_mod target_core_mod configfs sswipe libsas libata scsi_transport_sas picdev via_cputemp hwmon_vid fuse parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 sd_mod crc_t10dif usb_storage scsi_mod ehci_hcd usbcore usb_common
> [  368.804749]
> [  368.804764] Pid: 392, comm: kworker/u:3 Tainted: P        W  O 3.4.87-logicube-ng.22 #1 To be filled by O.E.M. To be filled by O.E.M./EPIA-M920
> [  368.804802] RIP: 0010:[<ffffffff81358457>]  [<ffffffff81358457>] __mutex_lock_common.isra.7+0x9c/0x15b
> [  368.804827] RSP: 0018:ffff880117001cc0  EFLAGS: 00010246
> [  368.804842] RAX: 0000000000000000 RBX: ffff8801185030d0 RCX: ffff88008edcb420
> [  368.804857] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff8801185030d4
> [  368.804873] RBP: ffff8801181531c0 R08: 0000000000000020 R09: 00000000fffffffe
> [  368.804885] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801185030d4
> [  368.804899] R13: 0000000000000002 R14: ffff880117001fd8 R15: ffff8801185030d8
> [  368.804916] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
> [  368.804931] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  368.804946] CR2: 0000000000000000 CR3: 000000000160b000 CR4: 00000000000006e0
> [  368.804962] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  368.804978] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  368.804995] Process kworker/u:3 (pid: 392, threadinfo ffff880117000000, task ffff8801181531c0)
> [  368.805009] Stack:
> [  368.805017]  ffff8801185030d8 0000000000000000 ffffffff8161ddf0 ffffffff81056f7c
> [  368.805062]  000000000000b503 ffff8801185030d0 ffff880118503000 0000000000000000
> [  368.805100]  ffff8801185030d0 ffff8801188b8000 ffff88008edcb420 ffffffff813583ac
> [  368.805135] Call Trace:
> [  368.805153]  [<ffffffff81056f7c>] ? up+0xb/0x33
> [  368.805168]  [<ffffffff813583ac>] ? mutex_lock+0x16/0x25
> [  368.805194]  [<ffffffffa018c414>] ? smp_execute_task+0x4e/0x222 [libsas]
> [  368.805217]  [<ffffffffa018ce1c>] ? sas_find_bcast_dev+0x3c/0x15d [libsas]
> [  368.805240]  [<ffffffffa018ce4f>] ? sas_find_bcast_dev+0x6f/0x15d [libsas]
> [  368.805264]  [<ffffffffa018e989>] ? sas_ex_revalidate_domain+0x37/0x2ec [libsas]
> [  368.805280]  [<ffffffff81355a2a>] ? printk+0x43/0x48
> [  368.805296]  [<ffffffff81359a65>] ? _raw_spin_unlock_irqrestore+0xc/0xd
> [  368.805318]  [<ffffffffa018b767>] ? sas_revalidate_domain+0x85/0xb6 [libsas]
> [  368.805336]  [<ffffffff8104e5d9>] ? process_one_work+0x151/0x27c
> [  368.805351]  [<ffffffff8104f6cd>] ? worker_thread+0xbb/0x152
> [  368.805366]  [<ffffffff8104f612>] ? manage_workers.isra.29+0x163/0x163
> [  368.805382]  [<ffffffff81052c4e>] ? kthread+0x79/0x81
> [  368.805399]  [<ffffffff8135fea4>] ? kernel_thread_helper+0x4/0x10
> [  368.805416]  [<ffffffff81052bd5>] ? kthread_flush_work_fn+0x9/0x9
> [  368.805431]  [<ffffffff8135fea0>] ? gs_change+0x13/0x13
> [  368.805442] Code: 83 7d 30 63 7e 04 f3 90 eb ab 4c 8d 63 04 4c 8d 7b 08 4c 89 e7 e8 fa 15 00 00 48 8b 43 10 4c 89 3c 24 48 89 63 10 48 89 44 24 08 <48> 89 20 83 c8 ff 48 89 6c 24 10 87 03 ff c8 74 35 4d 89 ee 41
> [  368.805851] RIP  [<ffffffff81358457>] __mutex_lock_common.isra.7+0x9c/0x15b
> [  368.805877]  RSP <ffff880117001cc0>
> [  368.805886] CR2: 0000000000000000
> [  368.805899] ---[ end trace b720682065d8f4cc ]---
> --------------------------------------End Kernel crash dump-------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

