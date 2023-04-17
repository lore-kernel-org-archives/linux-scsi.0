Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71780C77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDQTGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjDQTGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:06:10 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B5D76A6
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63b78525ac5so840550b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681758360; x=1684350360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3HBwzcR3cBD4MiYbP/IRrqSm0Yf6zhUBT3XLShYEg8=;
        b=OO+f4opA6I7iEKRXltSNaoiuvNNefTVsTHpafBCSJbU70u7iyCu4eAVbYECP79OQcX
         qlKPDfbvWpkNBcdmLRhAgfn38bFmmGUsf4aI6GzoBtqVGaSPpRDVbq/b1nPKkLto7GMD
         hPQxp3K+LG2zE46NaTOYjwrzxtVQRYrQMVsi4Snf42F09/bBo9GCpnAdQ2wBQpqToM7I
         Is1ROZccq4asuo08BOilUTJPknSTBULIIbPrJObqQpoJmWnkoZiQzqM+N+1N9gcE1DYG
         qeAGOt4tizrvwPKr/inLjgPlvxc9mOxr+zI17GHD3wNTCrLG0MBzoNOz45+AHheprM6V
         V2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758360; x=1684350360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3HBwzcR3cBD4MiYbP/IRrqSm0Yf6zhUBT3XLShYEg8=;
        b=GWAwxfDmyDAs4/u6d6xb+XOidxiXCwXvqdmDl6J1Bm7fC0OFyinTBK7cLGGkQ5pEL1
         vzIRaATADW/cAp8/gEnEZEUQvJlR9koOQrrQHg36rqh6QHFRBKcLNr4/CRWEHqplgmDE
         J+yEhFJlBnVeCj8W+Zyr2aETMJXBisAkF25kLQdIJWFcQNsS3heD7wMR/eYLkn/DzsNc
         WVCEC3dEuFX4nmtOCqQX/CE0LSG3jYMLFSM6ekNd+hqJHRM+7hmQNlPdwNfPlRXLV5x3
         K/5gvQ4jcSkOrOL4e8CsD1FBnXqdEGbISI/g8q/PBYAMS3qvBR0ZikfvTIu5PoUXiMzi
         K80g==
X-Gm-Message-State: AAQBX9e/GMKxM+kXkk3wyJdl+VLVLFmOhesVzMV1n4jqXEyzQqYmkVex
        8O0GzPaQrmr+UoeNY9zAzm8ZlI4+LY4=
X-Google-Smtp-Source: AKy350Zjd+Hac7Hr433Ic1K5Q4PT68S+lAGB5ZoSNv8nayMdkojY6AxrIPXd4UsfkzTMkvy8KB6sDg==
X-Received: by 2002:a05:6a00:4106:b0:635:4f6:2f38 with SMTP id bu6-20020a056a00410600b0063504f62f38mr12578004pfb.2.1681758359775;
        Mon, 17 Apr 2023 12:05:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x18-20020aa793b2000000b0063b7c42a070sm4291439pff.68.2023.04.17.12.05.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Apr 2023 12:05:59 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 3/7] lpfc: Match lock ordering of lpfc_cmd->buf_lock and hbalock for abort paths
Date:   Mon, 17 Apr 2023 12:15:54 -0700
Message-Id: <20230417191558.83100-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230417191558.83100-1-justintee8345@gmail.com>
References: <20230417191558.83100-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI version of the abort handler routine, lpfc_abort_handler, takes
the lpfc_cmd->buf_lock and then phba->hbalock.

Make the same change for the NVME abort path, lpfc_nvme_fcp_abort, to have
consistent lock ordering logic between the two abort paths.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 44 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index adda70423c77..82730a89ecb5 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1893,38 +1893,38 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 			 pnvme_rport->port_id,
 			 pnvme_fcreq);
 
-	/* If the hba is getting reset, this flag is set.  It is
-	 * cleared when the reset is complete and rings reestablished.
-	 */
-	spin_lock_irqsave(&phba->hbalock, flags);
-	/* driver queued commands are in process of being flushed */
-	if (phba->hba_flag & HBA_IOQ_FLUSH) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "6139 Driver in reset cleanup - flushing "
-				 "NVME Req now.  hba_flag x%x\n",
-				 phba->hba_flag);
-		return;
-	}
-
 	lpfc_nbuf = freqpriv->nvme_buf;
 	if (!lpfc_nbuf) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6140 NVME IO req has no matching lpfc nvme "
 				 "io buffer.  Skipping abort req.\n");
 		return;
 	} else if (!lpfc_nbuf->nvmeCmd) {
-		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "6141 lpfc NVME IO req has no nvme_fcreq "
 				 "io buffer.  Skipping abort req.\n");
 		return;
 	}
-	nvmereq_wqe = &lpfc_nbuf->cur_iocbq;
 
 	/* Guard against IO completion being called at same time */
-	spin_lock(&lpfc_nbuf->buf_lock);
+	spin_lock_irqsave(&lpfc_nbuf->buf_lock, flags);
+
+	/* If the hba is getting reset, this flag is set.  It is
+	 * cleared when the reset is complete and rings reestablished.
+	 */
+	spin_lock(&phba->hbalock);
+	/* driver queued commands are in process of being flushed */
+	if (phba->hba_flag & HBA_IOQ_FLUSH) {
+		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&lpfc_nbuf->buf_lock, flags);
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+				 "6139 Driver in reset cleanup - flushing "
+				 "NVME Req now.  hba_flag x%x\n",
+				 phba->hba_flag);
+		return;
+	}
+
+	nvmereq_wqe = &lpfc_nbuf->cur_iocbq;
 
 	/*
 	 * The lpfc_nbuf and the mapped nvme_fcreq in the driver's
@@ -1971,8 +1971,8 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	ret_val = lpfc_sli4_issue_abort_iotag(phba, nvmereq_wqe,
 					      lpfc_nvme_abort_fcreq_cmpl);
 
-	spin_unlock(&lpfc_nbuf->buf_lock);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&lpfc_nbuf->buf_lock, flags);
 
 	/* Make sure HBA is alive */
 	lpfc_issue_hb_tmo(phba);
@@ -1998,8 +1998,8 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	return;
 
 out_unlock:
-	spin_unlock(&lpfc_nbuf->buf_lock);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&lpfc_nbuf->buf_lock, flags);
 	return;
 }
 
-- 
2.38.0

