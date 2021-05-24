Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EC7C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A0861159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhEXDLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:37 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:36838 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbhEXDLf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:35 -0400
Received: by mail-pg1-f169.google.com with SMTP id 27so17751441pgy.3
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPGevx85bLU+6qi7Uvzpo6mDMJ9dy3nzpBNYNSqgdm8=;
        b=QFtG+4nda8rsImVJk/Op8KXmnYpyCMgf2MLnwNilwcFU/c3auV7HGchN3BY4n6rMZJ
         o2zJlER5+I9laycHwmPW2JYNFyMeQyj+1FwpHptXdnrWWeP0ZRSz2/bzTym/07Zk4u0w
         BEH3R31rhqrxiX4UC0WYqNLW+zAWMfDvjD5k8TsF16Ia3gn6pwCxDKwgzpD4b/gOzTG0
         0awdA4wvW6ikGmRLcJ6eAyxDrYWmLPRD1YCE3S0m2uvxy64knmknSmSY5W62f7q8D7YL
         h8rSLIIT4rpacRfW+UmJ/qY2I5GZbPu+Fr1G1+reSY3bA24KyeN5wgHgZyMtRgs+CWPA
         Q+ug==
X-Gm-Message-State: AOAM532rvt54BasbDY3rCZdiHZC4wOKoFu+AZRUZDB8PP//ifuOCMcj8
        shcWkwoD3MsBtjcszosAAtc=
X-Google-Smtp-Source: ABdhPJzZvrbN69zTykbnm9FHA9FSndVYsxLyk7KTeDdqO3txzDthQlkO9TnxhIXOnhpNNK5WUh56iw==
X-Received: by 2002:a62:1ad1:0:b029:2e3:4a8b:d0c9 with SMTP id a200-20020a621ad10000b02902e34a8bd0c9mr19666048pfa.16.1621825806976;
        Sun, 23 May 2021 20:10:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 37/51] qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:42 -0700
Message-Id: <20210524030856.2824-38-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..c65e85db87d5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -849,7 +849,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		uint16_t hwq;
 		struct qla_qpair *qpair = NULL;
 
-		tag = blk_mq_unique_tag(cmd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
 
@@ -1742,7 +1742,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(cmd->request))
+		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
