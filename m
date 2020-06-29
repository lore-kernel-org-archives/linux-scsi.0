Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BCBC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3B620702
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 22:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgF2WzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 18:55:14 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33496 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgF2WzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 18:55:13 -0400
Received: by mail-pj1-f68.google.com with SMTP id gc15so1258288pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 15:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JJfxNrKKcLvoNDjxOhPtlO9Z+XbDfNF+OP1B6dUZvjE=;
        b=AUJVF1pINgJObGhGU3h2n54SjI2IN+Z1FGBWa+rXMcNVt04HE/DZvCdwk/+FX7Kmwu
         RSAVJXtrkUOQG6eAVdJTisn0yxYdII1QIVY5XYXG3fcrZKvBOUFX92lr57ah9AHNFBID
         hbxRg6RyNDz1ZLImiQYUsh+NZOV+qJfcu9p7a4CNVpdkvV+/+XRsquhqov8HKLP7icNz
         fatlEJHxX+bbO0KSZAf7ad+o1qscdpP4Hn0Rhagw8NjgA3rlbBrzIvL3klVKtVqccdk7
         OCzRDgQt/IZO829iaNxP1TCZYs/uQVtfykeJA/Pot8kcoBwgzEoiCjZYYIotxcZZMfzp
         2aVA==
X-Gm-Message-State: AOAM530WezIUkXMBl1ETrbJpCvdoy/4bBqp7lglGW/v3VWIpzSPGtcz1
        Ncedl7Kzg3M3mwiqsEx6nbPLPU8ohlM=
X-Google-Smtp-Source: ABdhPJxXz6QQbMaZxz2VXwWshOd+Ka5zriFWu+z6lAGTZLhmVr+jDnOTZ0ySpkiDNdQxGeqkWTFsmQ==
X-Received: by 2002:a17:902:7204:: with SMTP id ba4mr14495971plb.250.1593471312710;
        Mon, 29 Jun 2020 15:55:12 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id mr8sm478379pjb.5.2020.06.29.15.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 15:55:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 5/9] qla2xxx: Remove a superfluous cast
Date:   Mon, 29 Jun 2020 15:54:50 -0700
Message-Id: <20200629225454.22863-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200629225454.22863-1-bvanassche@acm.org>
References: <20200629225454.22863-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove an unnecessary cast because it prevents the compiler to perform
type checking.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 88c0338a2ec7..67efde1d4b8e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -223,8 +223,7 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_job)
 
 		/* validate fcp priority data */
 
-		if (!qla24xx_fcp_prio_cfg_valid(vha,
-		    (struct qla_fcp_prio_cfg *) ha->fcp_prio_cfg, 1)) {
+		if (!qla24xx_fcp_prio_cfg_valid(vha, ha->fcp_prio_cfg, 1)) {
 			bsg_reply->result = (DID_ERROR << 16);
 			ret = -EINVAL;
 			/* If buffer was invalidatic int
