From: Amit Patel <patelamitv@yahoo.com>
Subject: Re: State Model for scsi device badness PATCH
Date: Thu, 20 Nov 2003 11:01:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120190105.7456.qmail@web13007.mail.yahoo.com>
References: <20031120015655.30453.qmail@web13006.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web13007.mail.yahoo.com ([216.136.174.17]:57360 "HELO
	web13007.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263057AbTKTTBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 14:01:10 -0500
In-Reply-To: <20031120015655.30453.qmail@web13006.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Amit Patel <patelamitv@yahoo.com>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

James,

I just walked through some of the code and I could
work around the badness problem by not doing
get_device if the scsi device is not in running state
yet. I have attached the patch for scsi_lib.c where I
do not call get_device if the state is not
SDEV_RUNNING and similarly do not do put_device if you
have not done get_device because of the device state.

I am not sure whether this will introduce some other
problem but something which I tried and worked. Let me
know if I am missing something.

Thanks
Amit
 diff -u 
/cdrive/mm1/linux-2.6.0-test9/drivers/scsi/scsi_lib.c
scsi_lib.c
---
/cdrive/mm1/linux-2.6.0-test9/drivers/scsi/scsi_lib.c 
     2003-10-25 11:43:38.000000000 -0700
+++ scsi_lib.c  2003-11-20 09:20:42.507430872 -0800
@@ -917,6 +917,22 @@
 {
        struct scsi_device *sdev = q->queuedata;
        struct scsi_cmnd *cmd;
+       int specials_only = 0;
+
+       if(unlikely(sdev->sdev_state != SDEV_RUNNING))
{
+               /* OK, we're not in a running state
don't prep
+                * user commands */
+               if(sdev->sdev_state == SDEV_DEL) {
+                       /* Device is fully deleted, no
commands
+                        * at all allowed down */
+                       printk(KERN_ERR "scsi%d
(%d:%d): rejecting I/O to dead device\n",
+                              sdev->host->host_no,
sdev->id, sdev->lun);
+                       return BLKPREP_KILL;
+               }
+               /* OK, we only allow special commands
(i.e. not
+                * user initiated ones */
+               specials_only = 1;
+       }

        /*
         * Find the actual device driver associated
with this command.
@@ -939,6 +955,14 @@
                } else
                        cmd = req->special;
        } else if (req->flags & (REQ_CMD |
REQ_BLOCK_PC)) {
+
+               if(unlikely(specials_only)) {
+                       printk(KERN_ERR "scsi%d
(%d:%d): rejecting I/O to device being removed\n",
+                              sdev->host->host_no,
sdev->id, sdev->lun);
+                       return BLKPREP_KILL;
+               }
+
+
                /*
                 * Just check to see if the device is
online.  If
                 * it isn't, we refuse to process
ordinary commands
@@ -1120,6 +1144,11 @@
        struct Scsi_Host *shost = sdev->host;
        struct scsi_cmnd *cmd;
        struct request *req;
+
+       if(sdev->sdev_state == SDEV_RUNNING)
+               if(!get_device(&sdev->sdev_gendev))
+               /* We must be tearing the block queue
down already */
+                       return;

        /*
         * To start with, we keep looping until the
queue is empty, or until
@@ -1192,9 +1221,11 @@
                        break;
                }
        }
-
+       if(sdev->sdev_state == SDEV_RUNNING)
+               goto out;
        return;

+
  not_ready:
        spin_unlock_irq(shost->host_lock);

@@ -1211,6 +1242,12 @@
        sdev->device_busy--;
        if(sdev->device_busy == 0)
                blk_plug_device(q);
+ out:
+       /* must be careful here...if we trigger the
->remove() function
+        * we cannot be holding the q lock */
+       spin_unlock_irq(q->queue_lock);
+       put_device(&sdev->sdev_gendev);
+       spin_lock_irq(q->queue_lock);
 }

 u64 scsi_calculate_bounce_limit(struct Scsi_Host
*shost)

--- Amit Patel <patelamitv@yahoo.com> wrote:
> Hi James,
> 
> I was trying updated state model for scsi device
> patch. I have 2.6.0-test9-mm3 and QLogic 2300
> adapter.
> While loading the qlogic driver I see lot of Kobject
> badness messages. 
> 
> I am not really familiar with kobject/scsi code but
> is
> it because while doing the scan of the scsi devices
> we
> have really not setup kobject for the device but we
> are sending INQUIRY command to see if there are any
> devices attached to the target. This code path will
> go
> through scsi_request_fn and as part of the patch
> first
> thing in scsi_request_fn is get_device. This is
> where
> the badness message is coming from. 
> 
> I don't see this messages once initial scan is done.
> I
> am not sure what other information will be helpful
> but
> if you need any more information please let me know.
> 
> Thanks
> Amit
> 
> Badness in kobject_get at lib/kobject.c:440
> Call Trace:
>  [<c023cd8c>] kobject_get+0x4c/0x50
>  [<c0299818>] get_device+0x18/0x30
>  [<f88a5b36>] scsi_request_fn+0x26/0x980 [scsi_mod]
>  [<f889d64e>] scsi_put_command+0x1ee/0x350
> [scsi_mod]
>  [<c029fb72>] blk_run_queue+0xa2/0x1a0
>  [<f88a41ca>] scsi_wait_req+0xea/0x100 [scsi_mod]
>  [<f88a3ef0>] scsi_wait_done+0x0/0x1f0 [scsi_mod]
>  [<c015faeb>] check_poison_obj+0x2b/0x1a0
>  [<f88a7089>] scsi_probe_lun+0x99/0x2e0 [scsi_mod]
>  [<f889d028>] scsi_allocate_request+0x28/0x70
> [scsi_mod]
>  [<f88a7a22>] scsi_probe_and_add_lun+0x112/0x200
> [scsi_mod]
>  [<f88a7a3b>] scsi_probe_and_add_lun+0x12b/0x200
> [scsi_mod]
>  [<f88a8274>] scsi_scan_target+0x94/0x110 [scsi_mod]
>  [<f88a834b>] scsi_scan_channel+0x5b/0xa0 [scsi_mod]
>  [<f88a8482>] scsi_scan_host_selected+0xf2/0x140
> [scsi_mod]
>  [<f88a8501>] scsi_scan_host+0x31/0x40 [scsi_mod]
>  [<f890a3ee>] qla2x00_probe_device+0xb0e/0xe50
> [qla2300]
>  [<c01ad923>] d_instantiate+0x123/0x1c0
>  [<c01aa9e0>] dput+0x30/0x780
>  [<c01e4400>] sysfs_new_inode+0x30/0xb0
>  [<c02495cd>] pci_device_probe_static+0x4d/0x60
>  [<c024961c>] __pci_device_probe+0x3c/0x50
>  [<c024965c>] pci_device_probe+0x2c/0x50
>  [<c029a7dd>] bus_match+0x3d/0x70
>  [<c029a91c>] driver_attach+0x5c/0x90
>  [<c029ac14>] bus_add_driver+0xa4/0xc0
>  [<c029b0d6>] driver_register+0x96/0xa0
>  [<c0249879>] pci_register_driver+0x99/0xc0
>  [<f887305e>] qla2x00_module_init+0x5e/0x8a
> [qla2300]
>  [<f8904000>] qla2x00_set_info+0x0/0x10 [qla2300]
>  [<c0150306>] sys_init_module+0x1f6/0x3d0
>  [<c039d942>] sysenter_past_esp+0x43/0x65
> 
> 
> __________________________________
> Do you Yahoo!?
> Free Pop-Up Blocker - Get it now
> http://companion.yahoo.com/


__________________________________
Do you Yahoo!?
Free Pop-Up Blocker - Get it now
http://companion.yahoo.com/
