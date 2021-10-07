Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E256C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2B860E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242257AbhJGUcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:43 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:41878 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhJGUck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:40 -0400
Received: by mail-pj1-f53.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so6140436pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p2HaRX5pPHaZGfEsseY/SfrdWg8TP+livibGzd6jccs=;
        b=o5fFJdEehYVGkKsa1KvbVpfCMgWASyLiNuwf4lKum/EDjCagW/5+A7N/ckFU0HuawG
         JU0QSCHfGn8O6+KqCW0htY5kZHK4pIDUUFnkg9AXoAh4+VN3d15TwGu6gY3jXJR/sC5k
         9oHG0qyhbyMGEBMOmrKLpc2fxShm8OQ08qI52uoH6+CuG0Kx/gGL0PUhqfvjQTAbguBQ
         pFOtcr3qH8tWYPnekAyJsGm5VB7s5Y7OlQhDjBRGVh3v/8yySnJqss5lUFNkjAAbI3J5
         e/vuaoWN1rW+c2dVsVknLAFeSacPomJabM4w+6P8SMZoQl4+nfd41yidI1d8Th4IlMGB
         I2kQ==
X-Gm-Message-State: AOAM530mrl9eDLyxLI4AK1wTLWHk1CLoIuWLshRhtoqtMMZnNI2SSnov
        haF8wi0F49nGVcPyugZ38vQOMZjSGPQ=
X-Google-Smtp-Source: ABdhPJykn5pgieNBQGOjMGSdpAFOfVjFqLQvG2yXHdsX/afcJw9s5pu8mhi+N2MXIGApJ+Hbsj1PFA==
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr7095333pjb.70.1633638645812;
        Thu, 07 Oct 2021 13:30:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 43/88] libfc: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:38 -0700
Message-Id: <20211007202923.2174984-44-bvanassche@acm.org>
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
 drivers/scsi/libfc/fc_fcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 509eacd7893d..871b11edb586 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1870,7 +1870,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -1880,7 +1880,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		 * online
 		 */
 		sc_cmd->result = DID_IMM_RETRY << 16;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		goto out;
 	}
 
@@ -2087,7 +2087,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 	list_del(&fsp->list);
 	sc_cmd->SCp.ptr = NULL;
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 
 	/* release ref from initial allocation in queue command */
 	fc_fcp_pkt_release(fsp);
