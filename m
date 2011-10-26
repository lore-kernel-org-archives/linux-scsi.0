From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH] scsi_dh: check queuedata pointer before proceeding further
Date: Wed, 26 Oct 2011 14:29:38 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD91040F25B@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:15422 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932733Ab1JZS3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2011 14:29:51 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>

This patch validates sdev pointer in scsi_dh_activate before proceeding further.

Without this check we might see the panic as below. I have seen this
panic multiple times..

Call trace:

 #0 [ffff88007d647b50] machine_kexec at ffffffff81020902
 #1 [ffff88007d647ba0] crash_kexec at ffffffff810875b0
 #2 [ffff88007d647c70] oops_end at ffffffff8139c650
 #3 [ffff88007d647c90] __bad_area_nosemaphore at ffffffff8102dd15
 #4 [ffff88007d647d50] page_fault at ffffffff8139b8cf
    [exception RIP: scsi_dh_activate+0x82]
    RIP: ffffffffa0041922  RSP: ffff88007d647e00  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000000  RCX: 00000000000093c5
    RDX: 00000000000093c5  RSI: ffffffffa02e6640  RDI: ffff88007cc88988
    RBP: 000000000000000f   R8: ffff88007d646000   R9: 0000000000000000
    R10: ffff880082293790  R11: 00000000ffffffff  R12: ffff88007cc88988
    R13: 0000000000000000  R14: 0000000000000286  R15: ffff880037b845e0
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
 #5 [ffff88007d647e38] run_workqueue at ffffffff81060268
 #6 [ffff88007d647e78] worker_thread at ffffffff81060386
 #7 [ffff88007d647ee8] kthread at ffffffff81064436
 #8 [ffff88007d647f48] kernel_thread at ffffffff81003fba

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
 
--- linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh.c.orig	2011-10-26 11:36:18.000000000 -0500
+++ linux-3.1-rc4/drivers/scsi/device_handler/scsi_dh.c	2011-10-26 12:52:47.000000000 -0500
@@ -441,7 +441,15 @@ int scsi_dh_activate(struct request_queu
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
-	if (sdev && sdev->scsi_dh_data)
+	if (!sdev) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		err = SCSI_DH_NOSYS;
+		if (fn)
+			fn(data, err);
+		return err;
+	}
+
+	if (sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	dev = get_device(&sdev->sdev_gendev);
 	if (!scsi_dh || !dev ||


