Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381A9C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A8720672
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZWxw9GLb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgG3IEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgG3IEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 04:04:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FC2C061794
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:30 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so7708912pfh.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2020 01:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H3KkPz6MdgQnnbTmO8PnKM2NIt+6lkDcy+gwm+RtcPY=;
        b=ZWxw9GLbbyuZIgcATp9xfWVsD8QzbcWwYJwr//CIyGvTZluRr3PUEv/Z36jCARt0Tv
         sHnsIfHUV2KAGyGDY5LGnzU/zFk7PEVlWIDzR+r6p0uhHy8ASk+FkK/gJMaN1MHBNnZV
         vtBTdFUcIZdztrMWhy2XSdNIaisvIp/1vL8jM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H3KkPz6MdgQnnbTmO8PnKM2NIt+6lkDcy+gwm+RtcPY=;
        b=MxlqF39CZDTJczdxAeTym7n59crVjDDjQkaHe0NJ1isE3MdMPzzKOccduUnVfiolFc
         d2+vbe261bo8zl36WDR473XnGqAS3k0x+nXm7wFFAAF3xvbnwxTDCtAwcyo6KugCGhnH
         2KxmWeZTAhl37K4An1a8aQCSrObx7LkhdZAlpnvw8Cam6hfly9Ep0s6fAuqrHAhSDRk9
         4Lk95XnYZ2lTdFAh4ZCdT/C84pJNqF+TgDKFAkRvdRQelrK0dK8gHpZa8e9sgsf3R+EO
         mOoGnHQKzA02BtT6H0ro0CBunrsKBXWXHUcHsCrX6/pxpBIBfpLHXjsaTZrlYK+2b2Cn
         /7xQ==
X-Gm-Message-State: AOAM533qj2xzzOnLs5lvORP09J1OneOfU/9TLT35CinkKCZKSR+sPPQK
        3TznTXVbdOS42pw6pLnRZzXcyQ==
X-Google-Smtp-Source: ABdhPJxw9jNHEralfGp2qCXonE+sgzSjQBKIGtYcZnzNPefOv5Y/M9/K8DDZCOVl6b6UQTt9duIQeQ==
X-Received: by 2002:a63:3005:: with SMTP id w5mr32777443pgw.441.1596096269900;
        Thu, 30 Jul 2020 01:04:29 -0700 (PDT)
Received: from localhost.localdomain ([192.19.212.250])
        by smtp.gmail.com with ESMTPSA id d13sm5051412pfq.118.2020.07.30.01.04.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 01:04:29 -0700 (PDT)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        sathya.prakash@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 4/7] mpt3sas: Rename and export interrupt mask/unmask fn's.
Date:   Thu, 30 Jul 2020 13:33:46 +0530
Message-Id: <1596096229-3341-5-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1596096229-3341-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename Function _base_unmask_interrupts() to
mpt3sas_base_unmask_interrupts() and
_base_mask_interrupts() to mpt3sas_base_mask_interrupts()
Also added function declarion to mpt3sas_base.h

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 24 +++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 ++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b9d8f08..2ffdbbb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -129,8 +129,6 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc,
 static int
 _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc);
 static void
-_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc);
-static void
 _base_clear_outstanding_commands(struct MPT3SAS_ADAPTER *ioc);
 
 /**
@@ -680,7 +678,7 @@ _base_fault_reset_work(struct work_struct *work)
 			ioc->shost_recovery = 1;
 			spin_unlock_irqrestore(
 			    &ioc->ioc_reset_in_progress_lock, flags);
-			_base_mask_interrupts(ioc);
+			mpt3sas_base_mask_interrupts(ioc);
 			_base_clear_outstanding_commands(ioc);
 		}
 
@@ -1465,13 +1463,13 @@ _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
- * _base_mask_interrupts - disable interrupts
+ * mpt3sas_base_mask_interrupts - disable interrupts
  * @ioc: per adapter object
  *
  * Disabling ResetIRQ, Reply and Doorbell Interrupts
  */
-static void
-_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
@@ -1483,13 +1481,13 @@ _base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_unmask_interrupts - enable interrupts
+ * mpt3sas_base_unmask_interrupts - enable interrupts
  * @ioc: per adapter object
  *
  * Enabling only Reply Interrupts
  */
-static void
-_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
@@ -3371,7 +3369,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 		goto out_fail;
 	}
 
-	_base_mask_interrupts(ioc);
+	mpt3sas_base_mask_interrupts(ioc);
 
 	r = _base_get_ioc_facts(ioc);
 	if (r) {
@@ -7119,7 +7117,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 
  skip_init_reply_post_host_index:
 
-	_base_unmask_interrupts(ioc);
+	mpt3sas_base_unmask_interrupts(ioc);
 
 	if (ioc->hba_mpi_version_belonged != MPI2_VERSION) {
 		r = _base_display_fwpkg_version(ioc);
@@ -7168,7 +7166,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	/* synchronizing freeing resource with pci_access_mutex lock */
 	mutex_lock(&ioc->pci_access_mutex);
 	if (ioc->chip_phys && ioc->chip) {
-		_base_mask_interrupts(ioc);
+		mpt3sas_base_mask_interrupts(ioc);
 		ioc->shost_recovery = 1;
 		_base_make_ioc_ready(ioc, SOFT_RESET);
 		ioc->shost_recovery = 0;
@@ -7734,7 +7732,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	}
 	_base_pre_reset_handler(ioc);
 	mpt3sas_wait_for_commands_to_complete(ioc);
-	_base_mask_interrupts(ioc);
+	mpt3sas_base_mask_interrupts(ioc);
 	r = _base_make_ioc_ready(ioc, type);
 	if (r)
 		goto out;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4ed704c..9da7265 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1529,6 +1529,8 @@ __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 void *mpt3sas_base_get_pcie_sgl(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 dma_addr_t mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc);
 
 void mpt3sas_base_put_smid_fast_path(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 handle);
-- 
2.26.2

