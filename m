Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2893C1B0D8
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5E52310E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgLFQn2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 11:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbgLFQn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 11:43:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591CBC0613D3;
        Sun,  6 Dec 2020 08:42:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c7so11125778edv.6;
        Sun, 06 Dec 2020 08:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XnNK85yQIqDf9XSgYG256xv+0HGL3Yjy71sTBa+LrtE=;
        b=ZmYXWaMfV7ng5TLBwop9hTTh6CZP4NC8fuCYrzeiKZU8WTs4fj1zjGty3upop0PieK
         0EZYA+MDWxgtPLpFxxTK5gzUu0UHh9l7Qv1j0gUAMZPup9m6ffpMZ2pBm5hDuQNQH36n
         1oyuNQgIl0o34dFX9+XGBO37K9fTGziu0Tw4iR+qlS7PFumX+nRuxEFSmvg3qVwJAqc6
         9gUk0YSth/m65FeTqYJ66ppJqK94up3t0aCRxP0C+uHz9cdPRvfLpHjH6xoZDDM2R2HZ
         4YsSLUAY/2ERlLfaooHjUokO/fOpXecb4ldvgMf+VW4lMXRXBS2wdo/g8E9uIt+a/2l0
         0ixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XnNK85yQIqDf9XSgYG256xv+0HGL3Yjy71sTBa+LrtE=;
        b=MZzRxvy2J4rx96NSje6UXAdoX4VuA/mwYIhYrf/2Duuayv1iynIsrqx2p4ecZJOVkM
         FqC7oOwwtJZ1WwWOOqv1bg0DlGPOZjkXRMbF9seRVaqZIPRCh8j2PpBh1QmIp1tILW7/
         SlP2S2Ip1Iql7walB5+3wz7kyPVAhxJ+dONgflmWbSywYpk9qPL0uN6cfRJsLfySqiWb
         UvBSOZ3MmYk5NJmY4NGu28fZ0UKWXVmoOBLqa8hCUhJqNbWYqZOXEy+acIIRWZwbBWNK
         c3DkxnHJoJ3x7JBL/qrkKCT3UvTeWXioF7PHaVzvlyNOMMoVcQZuN6aIL/4PDpptmMbc
         K+Gg==
X-Gm-Message-State: AOAM531YYyUINWsgafoDts0LZ7oNqyBiCLhdOG7afN+Z0MqTKldq5txR
        Vq5EdQpT8cJwmffXcXU/bsg=
X-Google-Smtp-Source: ABdhPJwOETKzaM7KMpytJ205AVMHQUCCEjcqRbrI1EqqZS28SUbKN8Hl4NuVddTUZOyeueYaJ/ud4w==
X-Received: by 2002:aa7:c652:: with SMTP id z18mr15916104edr.60.1607272965040;
        Sun, 06 Dec 2020 08:42:45 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e19sm9157524edr.61.2020.12.06.08.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 08:42:44 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
Date:   Sun,  6 Dec 2020 17:42:26 +0100
Message-Id: <20201206164226.6595-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206164226.6595-1-huobean@gmail.com>
References: <20201206164226.6595-1-huobean@gmail.com>
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
 drivers/scsi/ufs/ufshcd.c  |  9 +++++----
 include/trace/events/ufs.h | 10 +++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 29d7240a61bf..5b2219e44743 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -315,7 +315,8 @@ static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 {
 	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb);
+	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb,
+			  "CDB");
 }
 
 static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -329,7 +330,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 		rq_rsp = (struct utp_upiu_req *)hba->lrb[tag].ucd_rsp_ptr;
 
 	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq_rsp->header,
-			  &rq_rsp->qr);
+			  &rq_rsp->qr, "OSF");
 }
 
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
@@ -340,10 +341,10 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 
 	if (!strcmp("tm_send", str))
 		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
-				  &descp->input_param1);
+				  &descp->input_param1, "TM_INPUT");
 	else
 		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->rsp_header,
-				  &descp->output_param1);
+				  &descp->output_param1, "TM_OUTPUT");
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 0bd54a184391..68e8e97a9b47 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -295,15 +295,17 @@ TRACE_EVENT(ufshcd_uic_command,
 );
 
 TRACE_EVENT(ufshcd_upiu,
-	TP_PROTO(const char *dev_name, const char *str, void *hdr, void *tsf),
+	TP_PROTO(const char *dev_name, const char *str, void *hdr, void *tsf,
+		 const char *tsf_type),
 
-	TP_ARGS(dev_name, str, hdr, tsf),
+	TP_ARGS(dev_name, str, hdr, tsf, tsf_type),
 
 	TP_STRUCT__entry(
 		__string(dev_name, dev_name)
 		__string(str, str)
 		__array(unsigned char, hdr, 12)
 		__array(unsigned char, tsf, 16)
+		__string(tsf_type, tsf_type)
 	),
 
 	TP_fast_assign(
@@ -311,12 +313,14 @@ TRACE_EVENT(ufshcd_upiu,
 		__assign_str(str, str);
 		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
 		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
+		__assign_str(tsf_type, tsf_type);
 	),
 
 	TP_printk(
-		"%s: %s: HDR:%s, CDB:%s",
+		"%s: %s: HDR:%s, %s:%s",
 		__get_str(str), __get_str(dev_name),
 		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
+		__get_str(tsf_type),
 		__print_hex(__entry->tsf, sizeof(__entry->tsf))
 	)
 );
-- 
2.17.1

