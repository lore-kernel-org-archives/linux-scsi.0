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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457B0C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1417F64E44
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhBKXqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhBKXqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:17 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF767C0617AB
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:01 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so4732537pfk.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HojwSP4OY4K/DWvWvgLZZT3DYlNWcPTcaG9iktTxOp8=;
        b=nwZlavpoNYbn3VfvgCuITKnEZ8MCJImGMMJAfHOmfnCBX3TKNbUEf6PrP241FBhpDp
         AddvlKed9eBzTlbzAakCx5Figm1T/j9dcXc7R4KkfsxWT3FzSjM+FNpG6C07T4WQVkht
         YFJZQozPltFOfRp5FnQhzltTgX1yecsijCXmGv9MsoHaElWp5xx/+UVA2B2dBQ3c7mMM
         uvvrv1+ljR0myzhPZAJn3tBc1rLdrOy7v2uKUzpP4WdUe/LcflwoGETIcQ/ub527+0nn
         coClPP+uIFFbtXI5NBAytCiMXmzhz/lvMgmgwncwAZ8LSCL7t/TSWE9csnMPU7fIB5Au
         v8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HojwSP4OY4K/DWvWvgLZZT3DYlNWcPTcaG9iktTxOp8=;
        b=cTi48ZjibGeIW1/ROoKm6olFbO2/xgRsAGOR7taqURqWc4FLGPRRNL8j54wmvAW/SX
         qYh6yBUUU+moe+Uo81fiHZaf1EiN96Dxi8UkQgFAAZsFMrG5bpz5LmyD/jwL7RS2Fj7/
         woukai+XIwAVQViMp0jjiACJFEYX5Vym+QbKQ4hdu3gRiQ/vvuyFywtbb1WIazK86Mh2
         R4f3BTDGKqD1hN8aGsAuA/PtH1OxEN3lag1lyf6EFWTLy3jEzQYNyjGQO24vYVP7D+m+
         RBKmrkVkuz53+iQAgzS1MtN70FrJLuliH5ScACRu4dU00qMSo3PsglhoW6uGvaqIZlb2
         x8kw==
X-Gm-Message-State: AOAM530Ux+wcD1hJ7HknkObX+q6Suh5Uxfod89MgC/E1+Ico4VkB01S1
        pJHxshx1Ic18Mly5B/w5ZwLXhYGE0I0=
X-Google-Smtp-Source: ABdhPJyjL5divSReryA9JunU8x2lzcXmBs1d67UZGXFq1NuIbyl/z20t8Et2MaRk7WyWY+5re3ZF7w==
X-Received: by 2002:a62:78c8:0:b029:1d3:85cc:2133 with SMTP id t191-20020a6278c80000b02901d385cc2133mr404534pfc.65.1613087101390;
        Thu, 11 Feb 2021 15:45:01 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:01 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 15/22] lpfc: Fix nodeinfo debugfs output
Date:   Thu, 11 Feb 2021 15:44:36 -0800
Message-Id: <20210211234443.3107-16-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The debugfs nodeinfo output gets jumbled when  no rpri or a defer entry
is displayed. The misalignment makes it difficult to read.

Change the format to consistently print out a 4 character rpi, and turn
defer into a suffix.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index bc79a017e1a2..689c183485f7 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -869,7 +869,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 				"WWNN x%llx ",
 				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len += scnprintf(buf+len, size-len, "RPI:%03d ",
+			len += scnprintf(buf+len, size-len, "RPI:%04d ",
 					ndlp->nlp_rpi);
 		else
 			len += scnprintf(buf+len, size-len, "RPI:none ");
@@ -895,7 +895,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		if (ndlp->nlp_type & NLP_NVME_INITIATOR)
 			len += scnprintf(buf + len,
 					size - len, "NVME_INITIATOR ");
-		len += scnprintf(buf+len, size-len, "refcnt:%x",
+		len += scnprintf(buf+len, size-len, "refcnt:%d",
 			kref_read(&ndlp->kref));
 		if (iocnt) {
 			i = atomic_read(&ndlp->cmd_pending);
@@ -904,8 +904,11 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 					i, ndlp->cmd_qdepth);
 			outio += i;
 		}
-		len += scnprintf(buf + len, size - len, "defer:%x ",
-			ndlp->nlp_defer_did);
+		len += scnprintf(buf+len, size-len, " xpt:x%x",
+				 ndlp->fc4_xpt_flags);
+		if (ndlp->nlp_defer_did != NLP_EVT_NOTHING_PENDING)
+			len += scnprintf(buf+len, size-len, " defer:%x",
+					 ndlp->nlp_defer_did);
 		len +=  scnprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
-- 
2.26.2

