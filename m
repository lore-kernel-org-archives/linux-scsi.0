From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] [SCSI] scsi_alloc_sdev() trips WARN_ON in scsi_free_queue()
Date: Tue, 8 Nov 2011 12:36:23 +1100
Message-ID: <20111108123623.1a94db09@kryten>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<CAO+b5-paS698V61BA8e4ZYstdqR4AKda2EKx4DHqv4gtR2ocPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-paS698V61BA8e4ZYstdqR4AKda2EKx4DHqv4gtR2ocPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


commit 3308511c93e6 ([SCSI] Make scsi_free_queue() kill pending SCSI
commands) requires us to reset the queuedata pointer before calling
scsi_free_queue.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Thanks for the tip Bart, does this look good?

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 72273a0..ebb1206 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -322,6 +322,7 @@ out_device_destroy:
 	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_dev);
+	sdev->request_queue->queuedata = NULL;
 	scsi_free_queue(sdev->request_queue);
 	put_device(&sdev->sdev_gendev);
 out:
