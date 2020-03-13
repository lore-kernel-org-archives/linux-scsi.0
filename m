Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F8DC2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 23:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F3512074C
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 23:23:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="s05+YjZ0";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="D2+sQCR+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCMXXJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 19:23:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38868 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgCMXXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 19:23:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id F3ADB8EE111;
        Fri, 13 Mar 2020 16:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1584141789;
        bh=VCoX1EwwLnSr6L3tIQYfVCXuLN2kvd+PaSNMLAJpXN4=;
        h=Subject:From:To:Cc:Date:From;
        b=s05+YjZ07WMjm9g6zuapE8sI5f/QJLCkc1O7Lo0s//eI/m9auMmJP7IqaOhdk5km1
         EiHzMF2FG12S6GLYyLfeIOK2KnsaKYsctVupZjkV0yVctheeFv2GwA9AH/mlMlA6Qt
         JmAyV7YxlxQ9zN5yowJRFxTxf6PC09NwhOMYGif0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5djAmLk8IPCm; Fri, 13 Mar 2020 16:23:08 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8CB518EE10C;
        Fri, 13 Mar 2020 16:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1584141788;
        bh=VCoX1EwwLnSr6L3tIQYfVCXuLN2kvd+PaSNMLAJpXN4=;
        h=Subject:From:To:Cc:Date:From;
        b=D2+sQCR+1nc/EN+g5sb3qgEV1AS8yq4QAOp8RbBOUeDRn3NnLzIEhkzkMbiID9vdB
         ERfAZtLv/U82n8aSqm2a9wZdoo5BloRR+63asx5iIObv8KjXvNbd6CAxasGMA4KnVL
         wTUFpQXNBSiNnpJlye9z3ArDyQ00PRai/JCrYmp0=
Message-ID: <1584141787.20167.3.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.6-rc5
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 13 Mar 2020 16:23:07 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Two small fixes, both in drivers: ipr and ufs.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Can Guo (1):
      scsi: ufs: Fix possible unclocked access to auto hibern8 timer register

Wen Xiong (1):
      scsi: ipr: Fix softlockup when rescanning devices in petitboot

and the diffstat:

 drivers/scsi/ipr.c        |  3 ++-
 drivers/scsi/ipr.h        |  1 +
 drivers/scsi/ufs/ufshcd.c | 21 ++++++++++++++-------
 3 files changed, 17 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index ae45cbe98ae2..cd8db1349871 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9950,6 +9950,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 	ioa_cfg->max_devs_supported = ipr_max_devs;
 
 	if (ioa_cfg->sis64) {
+		host->max_channel = IPR_MAX_SIS64_BUSES;
 		host->max_id = IPR_MAX_SIS64_TARGETS_PER_BUS;
 		host->max_lun = IPR_MAX_SIS64_LUNS_PER_TARGET;
 		if (ipr_max_devs > IPR_MAX_SIS64_DEVS)
@@ -9958,6 +9959,7 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 					   + ((sizeof(struct ipr_config_table_entry64)
 					       * ioa_cfg->max_devs_supported)));
 	} else {
+		host->max_channel = IPR_VSET_BUS;
 		host->max_id = IPR_MAX_NUM_TARGETS_PER_BUS;
 		host->max_lun = IPR_MAX_NUM_LUNS_PER_TARGET;
 		if (ipr_max_devs > IPR_MAX_PHYSICAL_DEVS)
@@ -9967,7 +9969,6 @@ static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 					       * ioa_cfg->max_devs_supported)));
 	}
 
-	host->max_channel = IPR_VSET_BUS;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = IPR_MAX_CDB_LEN;
 	host->can_queue = ioa_cfg->max_cmds;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index a67baeb36d1f..b97aa9ac2ffe 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1300,6 +1300,7 @@ struct ipr_resource_entry {
 #define IPR_ARRAY_VIRTUAL_BUS			0x1
 #define IPR_VSET_VIRTUAL_BUS			0x2
 #define IPR_IOAFP_VIRTUAL_BUS			0x3
+#define IPR_MAX_SIS64_BUSES			0x4
 
 #define IPR_GET_RES_PHYS_LOC(res) \
 	(((res)->bus << 24) | ((res)->target << 8) | (res)->lun)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abd0e6b05f79..2d705694636c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3884,18 +3884,25 @@ EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
+	bool update = false;
 
-	if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
+	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit == ahit)
-		goto out_unlock;
-	hba->ahit = ahit;
-	if (!pm_runtime_suspended(hba->dev))
-		ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
-out_unlock:
+	if (hba->ahit != ahit) {
+		hba->ahit = ahit;
+		update = true;
+	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (update && !pm_runtime_suspended(hba->dev)) {
+		pm_runtime_get_sync(hba->dev);
+		ufshcd_hold(hba, false);
+		ufshcd_auto_hibern8_enable(hba);
+		ufshcd_release(hba);
+		pm_runtime_put(hba->dev);
+	}
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
