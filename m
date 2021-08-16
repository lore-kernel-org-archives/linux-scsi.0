Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B533C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B00560FD7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhHPQ3t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhHPQ3r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:29:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B08C061764
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id e19so21299301pla.10
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RIVK96bKPkdnIkHGr5K4QFuikQwUgsi8aLcsQ7LYOlc=;
        b=YamNtvq4tdQ9auNWQpwkazuQIX6qpyea3OxcuQyGzbyb+pNDpWECMxQA4qPp7jaE3W
         kSp2engzB3PhJ5l8HBtbCgqY+Q8ss5i0upAspGRZNnUMKOtDmZPP7TiZc6xFs1/k0N66
         dr2EmuWFPbAp5wmts4fMjFwRJ8w3CxreOo4TXcfna0zFBVsNky/Cj8O8PZFWYHJVzdpB
         vHhTc2rzc8DkbDe8NHRWSAyOJARvdLpAUU0bqWn+vCAB60I5VJuyCiTydmMKZ3dtIfvc
         hURU3LwqS5Y0nviDX4uWBELKW9SE0DEUHisLLS5rwdUmRGF77IK/1fu6w44n4J11kKia
         CWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RIVK96bKPkdnIkHGr5K4QFuikQwUgsi8aLcsQ7LYOlc=;
        b=fOimalAA+qOp5/UM+dK5eTufnpXOi/YVX4SRfr3q7rSCDWov6fViMoXvoFgDZVfwcg
         CKlFe7ZoVi1MEnvc/Y6zliGojyNzhG+Fj1hL75t9vTWmXOdS3iYSC57ctdFYKPNHzi8y
         EhId6ERunAApin8aZInXz99UFNJ0pZJ5Prjdf2QwjwrrbFNpsOiu1Ot89bu+hAwkThi3
         EiYLCwitrP80Hblct0I29fxv7mB1YWL/qJChf1gio3Adxtc7jUFmoJbHg/KqY4CKvIZE
         NQMAd4dlodiK0GBLHl4m3qTKL2HdwzOzQrA4gH64fPmKB8kbvt0YeyDGGqOPyDHOm3Ps
         nxig==
X-Gm-Message-State: AOAM533egZBhczhMXuH++4bzCPODRZrwZBLvJiZ7lMmDpFNo0xpvih8X
        b0iI2aNlSBn1cYkrkxidVmUewALv1Qc=
X-Google-Smtp-Source: ABdhPJx56PNodt0hUGH5Qu9xQ8boD3kqT6yTHZGD2Gy3aqRSHWMZhoDGuW01SM/cvC5pEBjHM17UtQ==
X-Received: by 2002:a17:902:850a:b029:12c:8da9:8bd2 with SMTP id bj10-20020a170902850ab029012c8da98bd2mr13774929plb.58.1629131355268;
        Mon, 16 Aug 2021 09:29:15 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 02/16] lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
Date:   Mon, 16 Aug 2021 09:28:47 -0700
Message-Id: <20210816162901.121235-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
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

