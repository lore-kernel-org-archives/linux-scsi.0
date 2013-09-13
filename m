From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 20/22] be2iscsi: Invalidate WRB in Abort/Reset Path
Date: Thu, 12 Sep 2013 22:10:10 -0700
Message-ID: <1379049014-32716-20-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57344 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3IMFgx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:53 -0400
Received: by mail-pd0-f171.google.com with SMTP id g10so776556pdj.30
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:51 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 When iSCSI stack invokes Abort or Reset handlers, the aborted tasks
 Invalid Bit in WRB needs to be set. Else FW will not be aware of
 the command invalidated which leads to BAD_WRB error posted by FW.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 9e9d9c4..ff1d82b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -246,6 +246,11 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 		return SUCCESS;
 	}
 	spin_unlock_bh(&session->lock);
+	/* Invalidate WRB Posted for this Task */
+	AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+		      aborted_io_task->pwrb_handle->pwrb,
+		      1);
+
 	conn = aborted_task->conn;
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
@@ -323,6 +328,11 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
 			continue;
 
+		/* Invalidate WRB Posted for this Task */
+		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+			      abrt_io_task->pwrb_handle->pwrb,
+			      1);
+
 		inv_tbl->cid = cid;
 		inv_tbl->icd = abrt_io_task->psgl_handle->sgl_index;
 		num_invalidate++;
-- 
1.7.10.4

