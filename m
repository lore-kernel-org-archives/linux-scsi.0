Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DC2C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E24CE64E44
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 09:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBGJYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 04:24:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229760AbhBGJX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 04:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612689748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5cbAKZsab5lSbZHsOVXdud8NTo655iceg85Z09+ozzg=;
        b=gu9+km5CKbj+DoOSS8pbYsllBEj1dyI8f3F2dICqXrxLEtY0lqkL8rPSg823Wy/Ycm2xDz
        7f0fp5QWN9tO8DLBoY9g+VkDasngW7q8GQ1j46wxZqDv75wJxGehkL2PdHows6AQOqoIe1
        bK3seXrCJ/L1PV4dlqbNWusous103NU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-nNp_7GC_PDyAmXhdemacoQ-1; Sun, 07 Feb 2021 04:22:23 -0500
X-MC-Unique: nNp_7GC_PDyAmXhdemacoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C370801962;
        Sun,  7 Feb 2021 09:22:22 +0000 (UTC)
Received: from localhost (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 098551412A;
        Sun,  7 Feb 2021 09:22:15 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Omar Sandoval <osandov@fb.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 10/13] megaraid_sas: v2 replace sdev_busy with local counter
Date:   Sun,  7 Feb 2021 17:20:26 +0800
Message-Id: <20210207092029.1558550-11-ming.lei@redhat.com>
In-Reply-To: <20210207092029.1558550-1-ming.lei@redhat.com>
References: <20210207092029.1558550-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kashyap Desai <kashyap.desai@broadcom.com>

use local tracking of per sdev outstanding command since sdev_busy in
SML is improved for performance reason using sbitmap (earlier it was
atomic variable).

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Fix checkpatch ERROR and WARNING.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 47 +++++++++++++++++----
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 0f808d63580e..0c6a56b24c6e 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2019,10 +2019,12 @@ union megasas_frame {
  * struct MR_PRIV_DEVICE - sdev private hostdata
  * @is_tm_capable: firmware managed tm_capable flag
  * @tm_busy: TM request is in progress
+ * @sdev_priv_busy: pending command per sdev
  */
 struct MR_PRIV_DEVICE {
 	bool is_tm_capable;
 	bool tm_busy;
+	atomic_t sdev_priv_busy;
 	atomic_t r1_ldio_hint;
 	u8 interface_type;
 	u8 task_abort_tmo;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fd607287608e..e9ec9b7b1c36 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -220,6 +220,40 @@ megasas_clear_intr_fusion(struct megasas_instance *instance)
 	return 1;
 }
 
+static inline void
+megasas_sdev_busy_inc(struct megasas_instance *instance,
+		      struct scsi_cmnd *scmd)
+{
+	if (instance->perf_mode == MR_BALANCED_PERF_MODE) {
+		struct MR_PRIV_DEVICE *mr_device_priv_data =
+			scmd->device->hostdata;
+		atomic_inc(&mr_device_priv_data->sdev_priv_busy);
+	}
+}
+
+static inline void
+megasas_sdev_busy_dec(struct megasas_instance *instance,
+		      struct scsi_cmnd *scmd)
+{
+	if (instance->perf_mode == MR_BALANCED_PERF_MODE) {
+		struct MR_PRIV_DEVICE *mr_device_priv_data =
+			scmd->device->hostdata;
+		atomic_dec(&mr_device_priv_data->sdev_priv_busy);
+	}
+}
+
+static inline int
+megasas_sdev_busy_read(struct megasas_instance *instance,
+		       struct scsi_cmnd *scmd)
+{
+	if (instance->perf_mode == MR_BALANCED_PERF_MODE) {
+		struct MR_PRIV_DEVICE *mr_device_priv_data =
+			scmd->device->hostdata;
+		return atomic_read(&mr_device_priv_data->sdev_priv_busy);
+	}
+	return 0;
+}
+
 /**
  * megasas_get_cmd_fusion -	Get a command from the free pool
  * @instance:		Adapter soft state
@@ -357,15 +391,9 @@ megasas_get_msix_index(struct megasas_instance *instance,
 		       struct megasas_cmd_fusion *cmd,
 		       u8 data_arms)
 {
-	int sdev_busy;
-
-	/* TBD - if sml remove device_busy in future, driver
-	 * should track counter in internal structure.
-	 */
-	sdev_busy = atomic_read(&scmd->device->device_busy);
-
 	if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
-	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)) {
+	    (megasas_sdev_busy_read(instance, scmd) >
+	    (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))) {
 		cmd->request_desc->SCSIIO.MSIxIndex =
 			mega_mod64((atomic64_add_return(1, &instance->high_iops_outstanding) /
 					MR_HIGH_IOPS_BATCH_COUNT), instance->low_latency_index_start);
@@ -3390,6 +3418,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 * Issue the command to the FW
 	 */
 
+	megasas_sdev_busy_inc(instance, scmd);
 	megasas_fire_cmd_fusion(instance, req_desc);
 
 	if (r1_cmd)
@@ -3450,6 +3479,7 @@ megasas_complete_r1_command(struct megasas_instance *instance,
 		scmd_local->SCp.ptr = NULL;
 		megasas_return_cmd_fusion(instance, cmd);
 		scsi_dma_unmap(scmd_local);
+		megasas_sdev_busy_dec(instance, scmd_local);
 		scmd_local->scsi_done(scmd_local);
 	}
 }
@@ -3550,6 +3580,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 				scmd_local->SCp.ptr = NULL;
 				megasas_return_cmd_fusion(instance, cmd_fusion);
 				scsi_dma_unmap(scmd_local);
+				megasas_sdev_busy_dec(instance, scmd_local);
 				scmd_local->scsi_done(scmd_local);
 			} else	/* Optimal VD - R1 FP command completion. */
 				megasas_complete_r1_command(instance, cmd_fusion);
-- 
2.29.2

