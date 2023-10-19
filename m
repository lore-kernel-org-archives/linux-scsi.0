Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D486CDB465
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 15:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346339AbjJSPiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 11:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346333AbjJSPiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 11:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA037126
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 08:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697729832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=52KErJhns9Z66A7jrZAJrnpbZYC1gr+sfVc9qg0RYTU=;
        b=NtnRd8jc7sI8h4OeuKuiJWUpqbDseBF0LgY+XP5QU4VjmToVHh0ffbw1hhJwi6Z/voe8G7
        b6WdaMXEx/p7tNfAJuZr3bvPVUO165fB2nY5PoO54fxNIB5Jfk8RPDMvaAKyX/Pv5Lp8RR
        EjW/YV1m7CZFIDUVdjk5CZyUtEXY9DM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-9bHrLPCMPcuDa7Bt2S-2EA-1; Thu, 19 Oct 2023 11:37:08 -0400
X-MC-Unique: 9bHrLPCMPcuDa7Bt2S-2EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D7418C78C0;
        Thu, 19 Oct 2023 15:37:08 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.45.224.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 981AA503B;
        Thu, 19 Oct 2023 15:37:07 +0000 (UTC)
From:   Tomas Henzl <thenzl@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     sreekanth.reddy@broadcom.com, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com
Subject: [PATCH v2] mpt3sas: suppress a warning in debug kernel
Date:   Thu, 19 Oct 2023 17:37:06 +0200
Message-ID: <20231019153706.7967-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mpt3sas_ctl_exit should be called after communication
with the controller stops but in currently  it may cause
false warnings about not released memory.
Fix it by leaving mpt3sas_ctl_exit handle misc driver release
per driver and release DMA in mpt3sas_ctl_release per ioc.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
V2: separate handling of DMA release and misc driver deregistration


 drivers/scsi/mpt3sas/mpt3sas_base.h  |  1 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 42 ++++++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  1 +
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 1be0850ca17a..48ad17bd811d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1983,6 +1983,7 @@ extern const struct attribute_group *mpt3sas_host_groups[];
 extern const struct attribute_group *mpt3sas_dev_groups[];
 void mpt3sas_ctl_init(ushort hbas_to_enumerate);
 void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
+void mpt3sas_ctl_release(struct MPT3SAS_ADAPTER *ioc);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index efdb8178db32..147cb7088d55 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4157,31 +4157,37 @@ mpt3sas_ctl_init(ushort hbas_to_enumerate)
 }
 
 /**
- * mpt3sas_ctl_exit - exit point for ctl
- * @hbas_to_enumerate: ?
+ * mpt3sas_ctl_release - release dma for ctl
+ * @ioc: per adapter object
  */
 void
-mpt3sas_ctl_exit(ushort hbas_to_enumerate)
+mpt3sas_ctl_release(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct MPT3SAS_ADAPTER *ioc;
 	int i;
 
-	list_for_each_entry(ioc, &mpt3sas_ioc_list, list) {
+	/* free memory associated to diag buffers */
+	for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
+		if (!ioc->diag_buffer[i])
+			continue;
+		dma_free_coherent(&ioc->pdev->dev,
+				  ioc->diag_buffer_sz[i],
+				  ioc->diag_buffer[i],
+				  ioc->diag_buffer_dma[i]);
+		ioc->diag_buffer[i] = NULL;
+		ioc->diag_buffer_status[i] = 0;
+	}
 
-		/* free memory associated to diag buffers */
-		for (i = 0; i < MPI2_DIAG_BUF_TYPE_COUNT; i++) {
-			if (!ioc->diag_buffer[i])
-				continue;
-			dma_free_coherent(&ioc->pdev->dev,
-					  ioc->diag_buffer_sz[i],
-					  ioc->diag_buffer[i],
-					  ioc->diag_buffer_dma[i]);
-			ioc->diag_buffer[i] = NULL;
-			ioc->diag_buffer_status[i] = 0;
-		}
+	kfree(ioc->event_log);
+}
+
+/**
+ * mpt3sas_ctl_exit - exit point for ctl
+ * @hbas_to_enumerate: ?
+ */
+void
+mpt3sas_ctl_exit(ushort hbas_to_enumerate)
+{
 
-		kfree(ioc->event_log);
-	}
 	if (hbas_to_enumerate != 1)
 		misc_deregister(&ctl_dev);
 	if (hbas_to_enumerate != 2)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 605013d3ee83..96dd2af5cd7d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11350,6 +11350,7 @@ static void scsih_remove(struct pci_dev *pdev)
 	}
 
 	mpt3sas_base_detach(ioc);
+	mpt3sas_ctl_release(ioc);
 	spin_lock(&gioc_lock);
 	list_del(&ioc->list);
 	spin_unlock(&gioc_lock);
-- 
2.41.0

