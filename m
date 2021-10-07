Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB23C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C35BF61074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242331AbhJGUcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:17 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:51765 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242334AbhJGUcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:11 -0400
Received: by mail-pj1-f42.google.com with SMTP id kk10so5815941pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xovr5aSMt2uSUC20pA1RBp5MP6CUZICgGZJSyXaXwcI=;
        b=y+HFBSqpoeAegk+h/tTd29H8HXqDOTvUJWh6fsZ9zaSyXdlBxVYjgnoKkS+P0d5iBY
         GRSTbFH6o3CVJefXWdMn9YxwLpp+PcMP/y7MA5OPFWVadSTuXnvb15MC7JQYWi/SR/8j
         ynkVh/SOKhxgVFlUZQIC/4nAcsAML5WHgjR/GamD7qUfAuaF2BkcomlWGb4cbiSCixvl
         KS0jo72nWkSzICWT6LeX95Cf6BhYnmOz935slu3HVMmeNiEgonvipSooFsXgHjp9BMOk
         P3B1NKPHrY/zVksDNMJLHgQNoT378F6RU9/a7TpHScnkeqSjXcDIzuCO8V6LF3Zkkr0N
         vUGQ==
X-Gm-Message-State: AOAM533dOI/EyQB+TxHrQTwjxtuygkiO6u/XDkmxhbnsqQkS0YCHMb4V
        vFc316SX930axvBNcZlxSr0=
X-Google-Smtp-Source: ABdhPJzChhGDS/ZyRNeTezPwRHRbMA6L3OVvoRckn9LcMuliNAhca4V00Egj9MtgzHAjaWd2Q326KA==
X-Received: by 2002:a17:902:9b8d:b0:13e:b693:c23d with SMTP id y13-20020a1709029b8d00b0013eb693c23dmr5708678plp.11.1633638617561;
        Thu, 07 Oct 2021 13:30:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 25/88] bnx2fc: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:20 -0700
Message-Id: <20211007202923.2174984-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index f2996a9b2f63..b9114113ee73 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -205,7 +205,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		sc_cmd->allowed);
 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 }
 
 struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
@@ -1610,7 +1610,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 	}
 
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 	if (io_req->wait_for_abts_comp) {
@@ -1853,7 +1853,7 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -2019,7 +2019,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		break;
 	}
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 }
 
