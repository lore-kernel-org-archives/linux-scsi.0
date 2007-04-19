From: Josef Bacik <jwhiter@redhat.com>
Subject: [RFC][PATCH] fix for async scsi scan sysfs problem (resend)
Date: Thu, 19 Apr 2007 09:25:00 -0400
Message-ID: <20070419132459.GB1481@korben.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161490AbXDSNYE@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

Resending this to a wider audience (thanks Andrew).  I'm having a problem on 
the newest version of linus's git tree with my qla2xxx card.  This is on a UP 
box, the problem doesn't happen on my similarly configured SMP box.  When I 
unload and then try to load the qla2xxx driver again I get this message

kobject_add failed for 3:0:0:0 with -EEXIST, don't try to register
things with the same name in the same directory.
 [<c0405ea6>] show_trace_log_lvl+0x1a/0x2f
 [<c0406456>] show_trace+0x12/0x14
 [<c04064d1>] dump_stack+0x16/0x18
 [<c04e6e86>] kobject_shadow_add+0xcd/0x1df
 [<c04e6fa2>] kobject_add+0xa/0xc
 [<c0557ae1>] device_add+0xab/0x62e
 [<d0873a0f>] scsi_sysfs_add_sdev+0x2d/0x1eb [scsi_mod]
 [<d0871db8>] scsi_probe_and_add_lun+0x974/0xaa5 [scsi_mod]
 [<d087240a>] __scsi_scan_target+0xc0/0x5f1 [scsi_mod]
 [<d0872ec5>] scsi_scan_target+0x97/0xa6 [scsi_mod]
 [<d08b1c34>] fc_scsi_scan_rport+0x5a/0x76 [scsi_transport_fc]
 [<c0435f33>] run_workqueue+0x89/0x14e
 [<c0436949>] worker_thread+0xf8/0x124
 [<c043911b>] kthread+0xb3/0xdc
 [<c0405b4f>] kernel_thread_helper+0x7/0x10
 =======================

I traced this down to the async scanning doing a kobject_add for that object,
the backtrace below shows the path we took to add it.

 [<c0405ea6>] show_trace_log_lvl+0x1a/0x2f
 [<c0406456>] show_trace+0x12/0x14
 [<c04064d1>] dump_stack+0x16/0x18
 [<c04e6e86>] kobject_shadow_add+0xcd/0x1df
 [<c04e6fa2>] kobject_add+0xa/0xc
 [<c055a45c>] class_device_add+0x9e/0x3ad
 [<d0873a3c>] scsi_sysfs_add_sdev+0x5a/0x1eb [scsi_mod]
 [<d0872cd4>] do_scan_async+0x62/0xf8 [scsi_mod]
 [<c043911b>] kthread+0xb3/0xdc
 [<c0405b4f>] kernel_thread_helper+0x7/0x10
 =======================

Looking through everything I came to the conclusion that we don't really need
the scsi_sysfs_add_devices in scsi_finish_async_scan, which gets run everytime
we do a do_scan_async.  In doing the scanning, if we come upon anything we will
already be registering the device with sysfs so the scsi_sysfs_add_devices step
is kind of useless.  I tested this and it worked fine on my UP box (where the
problem was happening) and my SMP box (where the problem wasn't happening).  Now
I'm not entirely sure if this is correct, but I'm attaching the patch that I
used to fix it for me, please point out if I've done something wrong or if there
is a different way this needs to be fixed.  Thank you,

Josef

PS. I'm not on linux-scsi so please CC me, thanks for your time.

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0949145..2c8527b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1661,15 +1661,6 @@ int scsi_scan_host_selected(struct Scsi_
 	return 0;
 }
 
-static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-	shost_for_each_device(sdev, shost) {
-		if (scsi_sysfs_add_sdev(sdev) != 0)
-			scsi_destroy_sdev(sdev);
-	}
-}
-
 /**
  * scsi_prep_async_scan - prepare for an async scan
  * @shost: the host which will be scanned
@@ -1741,8 +1732,6 @@ static void scsi_finish_async_scan(struc
 
 	wait_for_completion(&data->prev_finished);
 
-	scsi_sysfs_add_devices(shost);
-
 	spin_lock(&async_scan_lock);
 	shost->async_scan = 0;
 	list_del(&data->list);
