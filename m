Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC66C2BB9A
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1E262247F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 20:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503170AbgLNUVy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503122AbgLNUVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 15:21:46 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C70FC0617A7;
        Mon, 14 Dec 2020 12:20:33 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id x16so24375612ejj.7;
        Mon, 14 Dec 2020 12:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T7NLv1aBqZpZKVuxYL8PCGe79bEsa2C7xJDZKccReFI=;
        b=vNMzE3CqO0q8FAX55WJ6hWyD8sVTymC7/Rox4k7ek5F4NxxtbS9VCoODIQlxcBGCRd
         9YqTq3iw2Ij1VwMcduadK0pkiHlg1tXU3WU+w1p1voSkwzAZtKs3cSazklCUW5nctM6y
         DZUElglf+Mk8PxapJn7hXMoFFlbN+YQ/CfLqHkMMTgTkwBHQkDoPN69eewcb2fg0dS+R
         l2/QC4zyiN/QBetvVDVf1DjIjFLSFdF2ONhFcwm3cdmdbiTkz6EkZY7HkVdYn6yCS1Cp
         BGlLc6P7Zo/3WPXuGjFN6Dk6FvprMvb/wvaJdVqTIDPnISBrj0VYo1guB9L5QpZ+SvWf
         vOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T7NLv1aBqZpZKVuxYL8PCGe79bEsa2C7xJDZKccReFI=;
        b=O+d8Kg2evSQuoay7Vac7a6SKBtPO/vqTeD3eJKn1Yn9Aax2+vswifKRcKcZR4v/d2x
         iuwuDpw/AC0mUV/ZQenU9GnyM6kZGqRGM2xaqSRRoNSqTKM4KIoE0ALUcFFZg/ibIv0Z
         9GlXQI56ss6V14YqgDa339AgsjkKUFgijUGKBVtbDBBFIaPMdba0G9XXstyVnWxhZH51
         Ugr2xGAaSV/33Zh+Xpqsr3//9cMUg79EHOCU5wbHeawoi1smiSIIUBu1+kfpjk5nFFDw
         1vOroyzsQi54sbmkMfej27Xg8GSTJ6h+BjbQk8tvn55kx4VgV+3kYbakUnGDa2tmOZfM
         TQTA==
X-Gm-Message-State: AOAM531uNQe7re/mmIaST+3/3kCgPgwoIxwgB/o0p4/ClmUmXIsD2s96
        VsBwqA1qaZ1WtxqtVEi/iVk=
X-Google-Smtp-Source: ABdhPJwJK43XdswlUi5IX2q9kT87LzTRLPajeZuDBjxA/uJrjhvg4UEPORZmiGQNTZsjSDb03IPk9Q==
X-Received: by 2002:a17:906:a011:: with SMTP id p17mr23727087ejy.30.1607977232008;
        Mon, 14 Dec 2020 12:20:32 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id r7sm9334634edh.86.2020.12.14.12.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:20:31 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org, joe@perches.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
Date:   Mon, 14 Dec 2020 21:20:14 +0100
Message-Id: <20201214202014.13835-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214202014.13835-1-huobean@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
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
index 2cf983b3de1a..58ba7402d0c3 100644
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
index 335a8d6b490f..0e25a569d95a 100644
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

