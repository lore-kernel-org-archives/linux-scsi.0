Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB684C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD4E96142A
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347186AbhI2WJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:43 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:39884 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347191AbhI2WJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:42 -0400
Received: by mail-pj1-f41.google.com with SMTP id ce20-20020a17090aff1400b0019f13f6a749so4951234pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyB+fddyW5gcgcAEXD5s3JCSHTBobhm9JdLXpErbHD4=;
        b=IbSmchEEv0ZKdPSJt/FlsPXDwzwdZPTbQlg7y0HL1Wv0ghV7htdwC3lYj2X0QXRIAG
         xHngLpTBRxGMmlx97XzJ+s+snNaRnTenJcW+AFP8MzgqEhNDvoWhaxU6FIxk3NVeQyGS
         pnsawXP3xKnoBhmM/MHY9sD/yGjmB63/+ulI6hYYQ+kKieou1sPOa/0hS4DkHNYsn5zE
         y+qgy47R3I4Dlt5ZRQ+gFPO6+tcvWNWhiREO7trd1bpm/f0aV/PbZ+/Kd1HMq1l+Yk3s
         H5ogh2Tx4ZT4SwVCItGd2Swg4cfKHtxNgfmHZ6hHzpZHZdufERJGYCZJBw23O0uaBJCF
         kvtA==
X-Gm-Message-State: AOAM533pKTTjPsXBl7BXNOkEZFQdEFQanT6rXwsJgAifvAiWYXO2wRBX
        QkJei8J9NzXIlNf29Lezbpc=
X-Google-Smtp-Source: ABdhPJwxnV6N7icJdVLjPaMDP2OzYZ+nAHY2dwvtWz/m6Nb/+cLtVgkTuawy6ICm1qAjJj9zKXbBIA==
X-Received: by 2002:a17:903:124f:b0:13e:25e6:f733 with SMTP id u15-20020a170903124f00b0013e25e6f733mr2078318plh.42.1632953280364;
        Wed, 29 Sep 2021 15:08:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 65/84] qla4xxx: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:41 -0700
Message-Id: <20210929220600.3509089-66-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
