Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994A2C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjCVUC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjCVUCO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:02:14 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564826BC35
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:15 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id l7so2457811pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xeu7xruEVKfGMyukiTiO0Ah5kOsdbVW08mhQJ5MQnkM=;
        b=GmGaoHH8wH6BsmLB/bRVK6zOnSIgy6pp5opFCPLT2UPPn4CrFeBqkfuk156lW0n73k
         xvpwKLlzeZpydkWn4g70EEm6zE6yQ5SbzM0dGZKgFPiRTecbqGtR9SONmFODLgLfYkU2
         +PjygViHQB7HVQj/QecgNqDjXTTgKltcmdbpaqMdi+DVMaMsREuGrHCUvUGRpgtty1UA
         owAXPqAQrG3KtIfMZP3/VDzRv/0WRuJxGVPWTT5nN5NfVqyNl1bj0RcTKSUWBLeQSuI5
         sLVu+9yZFWHCyV0yPOrwdtPonZxhUmzZ3qFMEFyLjrBLQM2lFlzNvKTdHt2QVdSOJ3Az
         okXg==
X-Gm-Message-State: AO0yUKXB3smq22+hmETQp6vaV+2211W2EjSUmD6lRnnlO9pHQy4E3BX8
        ati55B4bvXZbq6ro+k5gczU=
X-Google-Smtp-Source: AK7set8ijN/pICOt3ZpVvpIIan7Vpm9zb26JL6gw8TQ8/nur8cDFks8fGr09xq6UXVOg3SyK3cXn6g==
X-Received: by 2002:a17:90b:180d:b0:234:d3a:2a38 with SMTP id lw13-20020a17090b180d00b002340d3a2a38mr4801977pjb.43.1679515131359;
        Wed, 22 Mar 2023 12:58:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 76/80] scsi: xen-scsifront: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:11 -0700
Message-Id: <20230322195515.1267197-77-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 71a3bb83984c..caae61aa2afe 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -770,7 +770,7 @@ static void scsifront_sdev_destroy(struct scsi_device *sdev)
 	}
 }
 
-static struct scsi_host_template scsifront_sht = {
+static const struct scsi_host_template scsifront_sht = {
 	.module			= THIS_MODULE,
 	.name			= "Xen SCSI frontend driver",
 	.queuecommand		= scsifront_queuecommand,
