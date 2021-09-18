Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0D3C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7460610C7
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbhIRAKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:23 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:33510 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345072AbhIRAJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:26 -0400
Received: by mail-pf1-f172.google.com with SMTP id s16so2407820pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyB+fddyW5gcgcAEXD5s3JCSHTBobhm9JdLXpErbHD4=;
        b=L6d6zqz7DH5edZ2mph0dNiGtNVm+1htWuDuOk23lulOvxWXC585pOx7LxQTA6zKNKi
         G6SQ23/uYI1thsGp+qxtq9Q30RL8SauGerCq8FlmJhY3fPBbmM6bKNXO5TLcXLOIdtDO
         KBpeohYfrfmY58Nh36TYS1UVwXXpsViTNH1ElQo1UH6eYopzBMyt9zaho+aDzIpHPexG
         Wy75oqBLPsVk8nENHto3FJFMxPnm9E+VSxAlNc+dDjVwpC2Hlfdm45JvKHaHsfGr+3Mz
         ep5Ky/RMHWed4CBoIgvQmVukSd7gD6RB74ZGgANVw0IRQn/q11569gRyZhGDG9+tbJ1l
         wBmw==
X-Gm-Message-State: AOAM532MsDb1L4yMTYd3uTQI1/1+Sx9QJliAI3aa7EUg1zfNcUqKNzVr
        5lEeR0WePXG1K0gDmNIFaBZSgTh3TSQ=
X-Google-Smtp-Source: ABdhPJzXvHTW+3YEIR1g41jX1Coa+pTcM3oawqgRGzN9jM3iV1RdFW5d0cVsQ4iAtCiYBbuCnwWUBQ==
X-Received: by 2002:a63:ac43:: with SMTP id z3mr3291940pgn.14.1631923683709;
        Fri, 17 Sep 2021 17:08:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 65/84] qla4xxx: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:48 -0700
Message-Id: <20210918000607.450448-66-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f1ea65c6e5f5..76d0b59a9982 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4080,7 +4080,7 @@ void qla4xxx_srb_compl(struct kref *ref)
 
 	mempool_free(srb, ha->srb_mempool);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /**
@@ -4154,7 +4154,7 @@ static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc_fail_command:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	return 0;
 }
