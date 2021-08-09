Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89CA7C43214
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5BF60F38
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhHIXFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:25 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38910 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhHIXFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:23 -0400
Received: by mail-pl1-f174.google.com with SMTP id a5so2658420plh.5
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPKq1F1MPTyTLjK6rpWD5zr2FjUTqF7F8c4lG2mKQnc=;
        b=nIbQNj6E/NsBtTDuluDXYOFgIIHi+dt63HS14NwDMYKwpZzF3q2ymhadM1rMCb5/cE
         l3B6m6J2C+DJOhnY9tfdOVa5LX1htrx2z+qILOvBznvFfWNzJi4fczHDbH7JtlKiV8LL
         0BtrfYNVXEBR3DB1e+ZR/+WrZJ9SLEZ8Whlo8VR55MtvPmJWeKEZRC0V+3T6dBtF98FG
         tx7l9WOSPWgg5a8f6XHO/A9vM7ekSaEmnZZniemhGYFoIuQqX5rqeSzHNi5rGZm4VPR9
         +1RRIC0dtd2KTBmOe2O+Z50uiFMi278FJxdtJRFPYg7Jw5USF6lmPajc+v6h9J6KIATd
         KUAw==
X-Gm-Message-State: AOAM533dKANasWJw9xc0RUfLr3PqKgvoHPogOPg4lhLcFTXelLveiBqo
        SkNHCxwNVjBGhZU1iPywxE0=
X-Google-Smtp-Source: ABdhPJwVXa2qm97y5YSjyAwsQYRLMUbceWFScaroQ8/ONTHz7GrsYgIbSsBIKEumE2MGSVvEKgurLw==
X-Received: by 2002:a17:902:e549:b029:12c:bf10:36c9 with SMTP id n9-20020a170902e549b029012cbf1036c9mr22027345plf.66.1628550302195;
        Mon, 09 Aug 2021 16:05:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:05:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 38/52] qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:41 -0700
Message-Id: <20210809230355.8186-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
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
index 868037c7d608..126ac7e24ea9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -854,7 +854,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		uint16_t hwq;
 		struct qla_qpair *qpair = NULL;
 
-		tag = blk_mq_unique_tag(cmd->request);
+		tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmd));
 		hwq = blk_mq_unique_tag_to_hwq(tag);
 		qpair = ha->queue_pair_map[hwq];
 
@@ -1763,7 +1763,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && blk_mq_request_started(cmd->request))
+		if (ret_cmd && blk_mq_request_started(scsi_cmd_to_rq(cmd)))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
