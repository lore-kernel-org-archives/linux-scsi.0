Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25BEC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AFA0610A5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhHMCJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbhHMCJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C74C061756
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:50 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id a8so13059502pjk.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIVK96bKPkdnIkHGr5K4QFuikQwUgsi8aLcsQ7LYOlc=;
        b=bW4EucJHhduN57eybmDumiDt/ur5UiyroFG/F0iFiB5OfAi4Xv4XpaqrBxvJtVg8fD
         XxM0oeLVyO8tak7eKS43tHfnM4ab02vt5xLcoRS5cY1nQBhNrO2TQO8k00yVz7230edg
         AmtJOnjCrdTZSUs3+E2ANNbLhKhJ/ASEabmHG4Dtqjpl68jkpKbejpGuqWZhO12pIUDp
         DPEpUunwy/u43/o/SIbvIw+mMrDqoXcA5ITZsH79ZuMPkVHnzrAULlYD9GLvzJL0VTjh
         zA+9lIEMQp0wZn1QI/IIPC3gfKu4UN36GxKGQLPKcXfsW7rqcBjYudvJNY26r9GOiFO+
         4r4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIVK96bKPkdnIkHGr5K4QFuikQwUgsi8aLcsQ7LYOlc=;
        b=KQwwNCHLI0M34wSuXPL+q/iKVPBBGytm/9UkZgl/QScRqWZQ1AW0Jo5vmKGm+EBRSH
         cpVcWkAHeFkrO7nS86+5tDqMPGhbDQ16C8kSEcUkANrjV59tRca5+CZmwTcFRLhioMNf
         QI7+0tZMMzGuyveWxayrmjgHaDk0kl2BY+ojPkOUFXoI5mi/w2BSTGvztmMZmCadjYSc
         kPnkhj/lUlPyD4ULaCLgkeyHrKKYI1Qf8brFz2k2YZ+zhW7OITYorz+UNrg+GHmMGMhQ
         X26+df7OMkPrCLXm+DLIcde/IOs7gSp96f0KJ5V/FiCTgXK5VHjmXgBtoQ852jS/SflQ
         3MSQ==
X-Gm-Message-State: AOAM530SIhD5LRsOJ2e6k4WoBvARey3CUTZ6BT5KU6kEhPB/APyiQ5/J
        sHySOaSzf4+/+P9N6u6S0VttgmQxv6U=
X-Google-Smtp-Source: ABdhPJxUn0VL4evKD3IvMiSL+LlWH1LHVM7Jyy9G7Hlr+9lQ2u6H8KgAapt3Q35Vag4txCOqwyWXKw==
X-Received: by 2002:a17:90a:990f:: with SMTP id b15mr151687pjp.188.1628820529475;
        Thu, 12 Aug 2021 19:08:49 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:49 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/16] lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
Date:   Thu, 12 Aug 2021 19:07:58 -0700
Message-Id: <20210813020812.99014-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813020812.99014-1-jsmart2021@gmail.com>
References: <20210813020812.99014-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implement the SET_HOST_DATA mbox command to set date / time during
initialization.  It is used by the firmware for various purposes
including congestion management and firmware dumps.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h | 30 ++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c | 51 +++++++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index aadbb0de629d..658b9c558237 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3427,12 +3427,40 @@ struct lpfc_mbx_set_feature {
 
 
 #define LPFC_SET_HOST_OS_DRIVER_VERSION    0x2
+#define LPFC_SET_HOST_DATE_TIME		   0x4
+
+struct lpfc_mbx_set_host_date_time {
+	uint32_t word6;
+#define lpfc_mbx_set_host_month_WORD	word6
+#define lpfc_mbx_set_host_month_SHIFT	16
+#define lpfc_mbx_set_host_month_MASK	0xFF
+#define lpfc_mbx_set_host_day_WORD	word6
+#define lpfc_mbx_set_host_day_SHIFT	8
+#define lpfc_mbx_set_host_day_MASK	0xFF
+#define lpfc_mbx_set_host_year_WORD	word6
+#define lpfc_mbx_set_host_year_SHIFT	0
+#define lpfc_mbx_set_host_year_MASK	0xFF
+	uint32_t word7;
+#define lpfc_mbx_set_host_hour_WORD	word7
+#define lpfc_mbx_set_host_hour_SHIFT	16
+#define lpfc_mbx_set_host_hour_MASK	0xFF
+#define lpfc_mbx_set_host_min_WORD	word7
+#define lpfc_mbx_set_host_min_SHIFT	8
+#define lpfc_mbx_set_host_min_MASK	0xFF
+#define lpfc_mbx_set_host_sec_WORD	word7
+#define lpfc_mbx_set_host_sec_SHIFT     0
+#define lpfc_mbx_set_host_sec_MASK      0xFF
+};
+
 struct lpfc_mbx_set_host_data {
 #define LPFC_HOST_OS_DRIVER_VERSION_SIZE   48
 	struct mbox_header header;
 	uint32_t param_id;
 	uint32_t param_len;
-	uint8_t  data[LPFC_HOST_OS_DRIVER_VERSION_SIZE];
+	union {
+		uint8_t data[LPFC_HOST_OS_DRIVER_VERSION_SIZE];
+		struct  lpfc_mbx_set_host_date_time tm;
+	} un;
 };
 
 struct lpfc_mbx_set_trunk_mode {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 47dd13719901..9ff4abb966af 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7369,7 +7369,7 @@ lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	mbox->u.mqe.un.set_host_data.param_id = LPFC_SET_HOST_OS_DRIVER_VERSION;
 	mbox->u.mqe.un.set_host_data.param_len =
 					LPFC_HOST_OS_DRIVER_VERSION_SIZE;
-	snprintf(mbox->u.mqe.un.set_host_data.data,
+	snprintf(mbox->u.mqe.un.set_host_data.un.data,
 		 LPFC_HOST_OS_DRIVER_VERSION_SIZE,
 		 "Linux %s v"LPFC_DRIVER_VERSION,
 		 (phba->hba_flag & HBA_FCOE_MODE) ? "FCoE" : "FC");
@@ -7499,6 +7499,51 @@ static void lpfc_sli4_dip(struct lpfc_hba *phba)
 	}
 }
 
+static int
+lpfc_set_host_tm(struct lpfc_hba *phba)
+{
+	LPFC_MBOXQ_t *mboxq;
+	uint32_t len, rc;
+	struct timespec64 cur_time;
+	struct tm broken;
+	uint32_t month, day, year;
+	uint32_t hour, minute, second;
+	struct lpfc_mbx_set_host_date_time *tm;
+
+	mboxq = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mboxq)
+		return -ENOMEM;
+
+	len = sizeof(struct lpfc_mbx_set_host_data) -
+		sizeof(struct lpfc_sli4_cfg_mhdr);
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_SET_HOST_DATA, len,
+			 LPFC_SLI4_MBX_EMBED);
+
+	mboxq->u.mqe.un.set_host_data.param_id = LPFC_SET_HOST_DATE_TIME;
+	mboxq->u.mqe.un.set_host_data.param_len =
+			sizeof(struct lpfc_mbx_set_host_date_time);
+	tm = &mboxq->u.mqe.un.set_host_data.un.tm;
+	ktime_get_real_ts64(&cur_time);
+	time64_to_tm(cur_time.tv_sec, 0, &broken);
+	month = broken.tm_mon + 1;
+	day = broken.tm_mday;
+	year = broken.tm_year - 100;
+	hour = broken.tm_hour;
+	minute = broken.tm_min;
+	second = broken.tm_sec;
+	bf_set(lpfc_mbx_set_host_month, tm, month);
+	bf_set(lpfc_mbx_set_host_day, tm, day);
+	bf_set(lpfc_mbx_set_host_year, tm, year);
+	bf_set(lpfc_mbx_set_host_hour, tm, hour);
+	bf_set(lpfc_mbx_set_host_min, tm, minute);
+	bf_set(lpfc_mbx_set_host_sec, tm, second);
+
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	return rc;
+}
+
 /**
  * lpfc_sli4_hba_setup - SLI4 device initialization PCI function
  * @phba: Pointer to HBA context object.
@@ -7588,6 +7633,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		goto out_free_mbox;
 	}
 
+	rc = lpfc_set_host_tm(phba);
+	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
+			"6468 Set host date / time: Status x%x:\n", rc);
+
 	/*
 	 * Continue initialization with default values even if driver failed
 	 * to read FCoE param config regions, only read parameters if the
-- 
2.26.2

