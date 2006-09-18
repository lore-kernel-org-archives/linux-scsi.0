From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] mptspi : Bug fix to prevent infinite nested domain validation
Date: Mon, 18 Sep 2006 17:44:53 -0600
Message-ID: <20060918234453.GA7576@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19916 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030264AbWIRXrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 19:47:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This event occurs when dv sends an inquiry to a device,
and the device never returns, thus timing out.
This results in a task_abort, followed by host_reset.
>From host_reset, domain validation is invoked again, and this
loop repeats itself forever.

Invoking domain validation from host_reset is required, as
device go to slowest speed, asyn narrow.

The fix I propose is to keep a bitwise flag `hd->spi_pending`
that keeps track of the devices that are in progress of domain
validation.  Then when host_reset occurs, we see if the
flag is non-zero, then take a different path which
program devices to old nego parameters, instead of calling dv
again.  We do nothing for the device that currently in
the middle of dv. When `hd->spi_pending` is zero, then
dv is performed on all devices.

Please note, we tried using the starget_data->dv_pending flag
from host_reset, by calling dv for devices not pending,
and this doesn't work.  The reason is if there is a faulty device
with a high id, such as 10, by the time we loop back to that id,
the dv_pending flag was always was zero, thus dv looped again.
Using the `hd->spi_pending` prevents nested dv, and at
the same time programs the devices back to previous nego.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-09-18 15:32:42.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-09-18 16:07:46.000000000 -0600
@@ -981,6 +981,7 @@ typedef struct _MPT_SCSI_HOST {
 	int			  scandv_wait_done;
 	long			  last_queue_full;
 	u16			  tm_iocstatus;
+	u16			  spi_pending;
 } MPT_SCSI_HOST;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-09-18 15:32:42.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2006-09-18 16:07:09.000000000 -0600
@@ -302,7 +302,9 @@ static void mptspi_dv_device(struct _MPT
 		return;
 	}
 
+	hd->spi_pending |= (1 << sdev->id);
 	spi_dv_device(sdev);
+	hd->spi_pending &= ~(1 << sdev->id);
 
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 0, vtarget->target_id) < 0)
@@ -789,11 +791,27 @@ mptspi_dv_renegotiate_work(void *data)
 	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
 	struct _MPT_SCSI_HOST *hd = wqw->hd;
 	struct scsi_device *sdev;
+	struct scsi_target *starget;
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
 
 	kfree(wqw);
 
-	shost_for_each_device(sdev, hd->ioc->sh)
-		mptspi_dv_device(hd, sdev);
+	if (hd->spi_pending) {
+		shost_for_each_device(sdev, hd->ioc->sh) {
+			if  (hd->spi_pending & (1 << sdev->id))
+				continue;
+			starget = scsi_target(sdev);
+			nego = mptspi_getRP(starget);
+			pg1.RequestedParameters = cpu_to_le32(nego);
+			pg1.Reserved = 0;
+			pg1.Configuration = 0;
+			mptspi_write_spi_device_pg1(starget, &pg1);
+		}
+	} else {
+		shost_for_each_device(sdev, hd->ioc->sh)
+			mptspi_dv_device(hd, sdev);
+	}
 }
 
 static void
@@ -1054,6 +1072,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
+	hd->spi_pending = 0;
 
 	/* Some versions of the firmware don't support page 0; without
 	 * that we can't get the parameters */
