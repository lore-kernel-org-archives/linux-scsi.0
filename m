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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF1BC2BB40
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC39227C3
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502029AbgLNQQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501971AbgLNQQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 11:16:50 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9E0C0617A7;
        Mon, 14 Dec 2020 08:15:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id d17so23286384ejy.9;
        Mon, 14 Dec 2020 08:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sS50UB5L3bUdbxvgL4D/ONfalNWTOYMqaYdu7fnXZ4k=;
        b=B3CRtl8RxyVbh7mdqk3rttFga6HL+eCGf4VikWH3wLhwcjOhH2nJ55S3fXA7SJWhCR
         A+T3tqhVNDuBnGy2AKnlFfpRtCc211Ca+nxo/kC74Oc8As7F9Vcc7vWfu3UyHxng/JJU
         3kOPqTGnscH6Fj8Z1xJKMhA3ceO+PSZbA80y2LZd4XrQSawxoZVmUInUsqAwA+DZHpV2
         ynkPSiUSmGUKvlRe07fogLzwqMLPGZ9r6IpKEUiLvWbK0qN9fjLpfBRIds0jA9hCZ8bg
         NG4ldNPmEuemUhn6+OTNvvlx+7u7xqrKFT8NsESC1r+IMOxgTGfkUYnNpeOlwiy1lMBA
         ByXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sS50UB5L3bUdbxvgL4D/ONfalNWTOYMqaYdu7fnXZ4k=;
        b=CXytKGw1IOAXQcZKbOUw6asv0PiXi6znBD8QoCkLUxJE7FjsgN83pHARXMfr8SgMFV
         m+E6cU/INL4cyf84CYthJ8oy9Ap5yxSnDoP72KPX2rs7195t+nFFheM7eSBwh2waapbn
         FZ1dLv3g3FpQQBVKU4OohHjv4zsM9/jhDchdsEswdc/6uF7JRqNzhuCGc2f5yL9HxGik
         7pdWu+8GTSPDWXWt1vcrH99a8uihtVp16HFI8wq+gQ6C3WMEKpwXCxxUPMDqZCfEMbuG
         Eud0jTFWG8uyppn8NbjFyImZhsotXqgJ+0+W499LRpRrcscqlgBZfAcnZZ8JN12EvHBh
         W2eQ==
X-Gm-Message-State: AOAM532X7XhlBGA6avQNrqMOzGRY6p14Rq4qujw8pjvCdnii/xmK/J0B
        ZJlb7VD1smT0Nl+onVlojDE=
X-Google-Smtp-Source: ABdhPJwhNPj1vhBeZ+FWlSwJX4Vbj90OThWstJmnDhXdYPaMeps2wpLU1IGvtwu8Z406B7/EjfB3aw==
X-Received: by 2002:a17:907:2071:: with SMTP id qp17mr7202793ejb.110.1607962536686;
        Mon, 14 Dec 2020 08:15:36 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id i13sm6646056edu.22.2020.12.14.08.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:15:36 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
Date:   Mon, 14 Dec 2020 17:15:02 +0100
Message-Id: <20201214161502.13440-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214161502.13440-1-huobean@gmail.com>
References: <20201214161502.13440-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Transaction Specific Fields (TSF) in the UPIU package could be CDB
(SCSI/UFS Command Descriptor Block), OSF (Opcode Specific Field), and
TM I/O parameter (Task Management Input/Output Parameter). But, currently,
we take all of these as CDB  in the UPIU trace. Thus makes user confuse
among CDB, OSF, and TM message. So fix it with this patch.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h     |  7 +++++++
 drivers/scsi/ufs/ufshcd.c  |  9 +++++----
 include/trace/events/ufs.h | 18 +++++++++++++++---
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index e04f6b5178c1..87076aa27e29 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -559,6 +559,13 @@ enum ufs_trace_str_t {
 	UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR
 };
 
+/*
+ * Transaction Specific Fields (TSF) type in the UPIU package, this enum is
+ * used in include/trace/events/ufs.h for UFS command trace.
+ */
+enum ufs_trace_tsf_t {
+	UFS_TSF_CDB, UFS_TSF_OSF, UFS_TSF_TM_INPUT, UFS_TSF_TM_OUTPUT
+};
 
 /**
  * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descriptor
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 742f5d11f8e5..66794cb8d5c9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -315,7 +315,8 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb);
+	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb,
+			  UFS_TSF_CDB);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -332,7 +333,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
 
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq_rsp->header,
-			  &rq_rsp->qr);
+			  &rq_rsp->qr, UFS_TSF_OSF);
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -346,10 +347,10 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 
 	if (str_t == UFS_TM_SEND)
 		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->req_header,
-				  &descp->input_param1);
+				  &descp->input_param1, UFS_TSF_TM_INPUT);
 	else
 		trace_ufshcd_upiu(dev_name(hba->dev), str_t, &descp->rsp_header,
-				  &descp->output_param1);
+				  &descp->output_param1, UFS_TSF_TM_OUTPUT);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 1f2e2db4eb17..c8cff8fc0c21 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -48,6 +48,12 @@
 	EM(UFS_TM_COMP,		"tm_complete")			\
 	EMe(UFS_TM_ERR,		"tm_complete_err")
 
+#define UFS_CMD_TRACE_TSF_TYPES					\
+	EM(UFS_TSF_CDB,		"CDB")		                \
+	EM(UFS_TSF_OSF,		"OSF")		                \
+	EM(UFS_TSF_TM_INPUT,	"TM_INPUT")                     \
+	EMe(UFS_TSF_TM_OUTPUT,	"TM_OUTPUT")
+
 /* Enums require being exported to userspace, for user tool parsing */
 #undef EM
 #undef EMe
@@ -58,6 +64,7 @@ UFS_LINK_STATES;
 UFS_PWR_MODES;
 UFSCHD_CLK_GATING_STATES;
 UFS_CMD_TRACE_STRINGS
+UFS_CMD_TRACE_TSF_TYPES
 
 /*
  * Now redefine the EM() and EMe() macros to map the enums to the strings
@@ -70,6 +77,8 @@ UFS_CMD_TRACE_STRINGS
 
 #define show_ufs_cmd_trace_str(str_t)	\
 				__print_symbolic(str_t, UFS_CMD_TRACE_STRINGS)
+#define show_ufs_cmd_trace_tsf(tsf)	\
+				__print_symbolic(tsf, UFS_CMD_TRACE_TSF_TYPES)
 
 TRACE_EVENT(ufshcd_clk_gating,
 
@@ -311,15 +320,16 @@ TRACE_EVENT(ufshcd_uic_command,
 
 TRACE_EVENT(ufshcd_upiu,
 	TP_PROTO(const char *dev_name, enum ufs_trace_str_t str_t, void *hdr,
-		 void *tsf),
+		 void *tsf, enum ufs_trace_tsf_t tsf_t),
 
-	TP_ARGS(dev_name, str_t, hdr, tsf),
+	TP_ARGS(dev_name, str_t, hdr, tsf, tsf_t),
 
 	TP_STRUCT__entry(
 		__string(dev_name, dev_name)
 		__field(enum ufs_trace_str_t, str_t)
 		__array(unsigned char, hdr, 12)
 		__array(unsigned char, tsf, 16)
+		__field(enum ufs_trace_tsf_t, tsf_t)
 	),
 
 	TP_fast_assign(
@@ -327,12 +337,14 @@ TRACE_EVENT(ufshcd_upiu,
 		__entry->str_t = str_t;
 		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
 		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
+		__entry->tsf_t = tsf_t;
 	),
 
 	TP_printk(
-		"%s: %s: HDR:%s, CDB:%s",
+		"%s: %s: HDR:%s, %s:%s",
 		show_ufs_cmd_trace_str(__entry->str_t), __get_str(dev_name),
 		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
+		show_ufs_cmd_trace_tsf(__entry->tsf_t),
 		__print_hex(__entry->tsf, sizeof(__entry->tsf))
 	)
 );
-- 
2.17.1

