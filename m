Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD245C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 21:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiGOV0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiGOV0O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 17:26:14 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D6974786
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:26:12 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id 72so5510374pge.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:26:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g0+xzAPEBgCb77lBIYpZ0BmG2rO6rleJg1wB3i4XeQA=;
        b=FaAEmWRJq0qwB1GhIAWSs4HiZS8U7xdXmVMkMNSEe+NgL+9cDEOJ88M5Sok8CAWu4l
         YHfP8l41ULdpcP9brsnLWe8aDA/oisov861AnZsQuC+XgdiGYAJiCQguTrhtaoNBVM1k
         2NPSsvlwyIhJOaCwLH4FCOo/dUySgoJfN4hV8hkFbD/KOqZCE9ihF14Rk/sTFl2ZCVKo
         +ER89rNxO2Z/nqda21LFks0gGV+1zYQXz3+cxm/zNCH3kgLTjvs/fT+wGHCywWLRy+01
         QVzyL8dBRSXviKdsxwX1fBZrcGkxeUna6eCNUKhfd1JwkyFG4fk95hyoVOb3u5M4gfxg
         iZ6w==
X-Gm-Message-State: AJIora9HstEpiJQFt4JFt59cpFWouWjfoCopEr/bL4B3vXwMy+m3IuDG
        Dbp7G8m2vBY6N76rGsN3IG0=
X-Google-Smtp-Source: AGRyM1sbSB/OH7gCNAUPaZbvhj05svElMKXnIy1u0wIsehy43/ghksiz78LwyCCsfUuskKlzTG28zg==
X-Received: by 2002:a62:d103:0:b0:528:c6c7:bd74 with SMTP id z3-20020a62d103000000b00528c6c7bd74mr15868128pfg.68.1657920371441;
        Fri, 15 Jul 2022 14:26:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:276e:f777:f438:e01d])
        by smtp.gmail.com with ESMTPSA id e35-20020a630f23000000b0040c40b022fbsm3535944pgl.94.2022.07.15.14.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 14:26:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 4/5] scsi: ufs: Add suspend/resume SCSI command processing support
Date:   Fri, 15 Jul 2022 14:25:14 -0700
Message-Id: <20220715212515.347664-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715212515.347664-1-bvanassche@acm.org>
References: <20220715212515.347664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This functionality is needed by UFS drivers to e.g. suspend SCSI command
processing while reprogramming encryption keys if the hardware does not
support concurrent I/O and key reprogramming.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
 include/ufs/ufshcd.h      |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5739e9d1b970..8363d2ff622c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1700,6 +1700,26 @@ static void ufshcd_ungate_work(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 }
 
+/*
+ * Block processing of new SCSI commands and wait until pending SCSI
+ * commands and TMFs have finished. ufshcd_exec_dev_cmd() and
+ * ufshcd_issue_devman_upiu_cmd() are not affected by this function.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us)
+{
+	return ufshcd_clock_scaling_prepare(hba, timeout_us);
+}
+EXPORT_SYMBOL_GPL(ufshcd_freeze_scsi_devs);
+
+/* Resume processing of SCSI commands. */
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba)
+{
+	ufshcd_clock_scaling_unprepare(hba, true);
+}
+EXPORT_SYMBOL_GPL(ufshcd_unfreeze_scsi_devs);
+
 /**
  * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_release.
  * Also, exit from hibern8 mode and set the link as active.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7fe1a926cd99..6d78bcbedb9e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1194,6 +1194,9 @@ void ufshcd_release(struct ufs_hba *hba);
 
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
 
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba);
+
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 				  int *desc_length);
 
