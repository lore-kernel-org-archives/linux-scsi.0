Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B96CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1270122AAA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbhAELgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbhAELgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:36:20 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6054C06179A;
        Tue,  5 Jan 2021 03:35:06 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n26so40764256eju.6;
        Tue, 05 Jan 2021 03:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QsQ8cgVNV6Ccy3Hjl/4rCw6U/yBCmG9PQRHC4wbZ0sQ=;
        b=r1HFfTQVOFjBuHWrjuqu+Lzn21SMtsBQjhBK7q3WhEuCa4u7BWLZaQ3KbTpoPWLTuL
         JpfVgA1Sb3dxPawh9zM2VXcjb7TbwzJygoZ1MFwAIcDluWYxJSALhQUzpY+ALGyNj7if
         DBMXFAsQx62dRDojGsWJzXKA+QhH9pVY6G0pdUpfIGOceswEIctkXqft2CrwJG63hxUN
         1dSuLS0GnxE9Ph4xqHliKsYwb7phbcfU2LkGO2Nt1hia+gbQKINQIAx2Yf8axqqf6PJP
         TpEaXuoip9UJp26wLb4e+g3uv6+xyRfknu/l7+WOpbmeKaKfC+DBGRMjSNU1bRCFV938
         BCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QsQ8cgVNV6Ccy3Hjl/4rCw6U/yBCmG9PQRHC4wbZ0sQ=;
        b=CbBctwvPKsXK8vJo/v9htCPkIIeuGcH3qNdjlIfi69Zzn/0+ZX3hfzxFxJnrtw2Fjs
         XG9oS2K6kRAHHibSmZS9RoSyi3+bXjEyxT09zU/lgKvoeD3dZ9aI7U0ZvO0EJ16n7DwN
         7DBt/rxdGa0AfkAiHQH3/QZuCnuqbHxtooy9RCbzsbnIKHLKFcQH2sUPu5h7vaEOFrE8
         D+zNCupL8rwiDuUWrx0xATMrsRR88DNVyRm56zyMh7qrrLqpF0f9VH9/hSibLawJAc2W
         hfC4dc2aGtiLYlyDAj2jjUTlYYQfUUJP/HU5X0AlHyA+d96qGQEtm5QTHYcQa/kcqDAn
         J21w==
X-Gm-Message-State: AOAM5302ei11v1XkXPnHyLHBloKFstHkHCc/6p6dF8QZYNp2SqGQjxyU
        85G8vKZ4D4XmpKVxJAbql5E=
X-Google-Smtp-Source: ABdhPJxEpH+SeXE2P+WlR2KJAUWYXSxNHqAB0H/h776V7B9g8/6x/tU0iokV8XWssL/3vExMaOTI8A==
X-Received: by 2002:a17:907:204b:: with SMTP id pg11mr72356728ejb.192.1609846505539;
        Tue, 05 Jan 2021 03:35:05 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n17sm24640772ejh.49.2021.01.05.03.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:35:04 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/6] scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
Date:   Tue,  5 Jan 2021 12:34:46 +0100
Message-Id: <20210105113446.16027-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105113446.16027-1-huobean@gmail.com>
References: <20210105113446.16027-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Transaction Specific Fields (TSF) in the UPIU package could be CDB
(SCSI/UFS Command Descriptor Block), OSF (Opcode Specific Field), and
TM I/O parameter (Task Management Input/Output Parameter). But, currently,
we take all of these as CDB  in the UPIU trace. Thus makes user confuse
among CDB, OSF, and TM message. So fix it with this patch.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h     |  7 +++++++
 drivers/scsi/ufs/ufshcd.c  |  9 +++++----
 include/trace/events/ufs.h | 18 +++++++++++++++---
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index ba24b504f85a..50f46f3bc8a2 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -554,6 +554,13 @@ enum ufs_trace_str_t {
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
index 4df17005e398..3be555e5410f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -312,7 +312,8 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	if (!trace_ufshcd_upiu_enabled())
 		return;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb);
+	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq->header, &rq->sc.cdb,
+			  UFS_TSF_CDB);
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -329,7 +330,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
 
 	trace_ufshcd_upiu(dev_name(hba->dev), str_t, &rq_rsp->header,
-			  &rq_rsp->qr);
+			  &rq_rsp->qr, UFS_TSF_OSF);
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -343,10 +344,10 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 
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
index 7613a5cd14de..e151477d645c 100644
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

