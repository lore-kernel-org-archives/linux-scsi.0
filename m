Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4273AC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B16216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404985AbfHIDCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33360 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id g2so45223478pfq.0
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JgIdHtV9aCIDldLq5OWl77GaMn0KPgFa+k2EqdwhVTA=;
        b=MbYEDuz1psNspI3ZzxIGRTYTgbS+J3TD5cf9OjqJwmkC7ECVPFxaZGpD4sRITtPGil
         xiN5amFUWsHw52VE5vuCqyoq3Ts6Rj82CkBbCfTuwSliFQgyUeBRaqPVyzfSlAZmo36V
         Tkr7nlyMHqN2QFBvaAj/yLUYNcKJGm8u/3L148zB7Yr9d8Z8E9AHVN+J8HbzdWUkkYhv
         qy7nU/LQ1ggY4Szz/E6leYQBQwWjhGJ+VQ9y2jpT+iR+diYHq/t520VfWEY8SUFKxbuH
         b/MW5gP/4Mn4BUL3SlxY+BIFdwxqQoUY8jNo/ObEOZ6x4trwGuhSxtCl0M5Gg8IY/xZS
         GFug==
X-Gm-Message-State: APjAAAXaANKdF2envEtQfdRfygO9P+dS8WLERmVVo0+lR5n/nJIGURzT
        vQWTx6L5RdLiv+KHzRQGLl0=
X-Google-Smtp-Source: APXvYqyI7oOblM+5AriCwyuOaYGqQygdn2ZJOWTKz1GuJ+oKJuAyWwgPJyYpDyP6xSJFAmE7duOy+w==
X-Received: by 2002:a62:7641:: with SMTP id r62mr18815379pfc.35.1565319765754;
        Thu, 08 Aug 2019 20:02:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 07/58] qla2xxx: Remove a superfluous forward declaration
Date:   Thu,  8 Aug 2019 20:01:28 -0700
Message-Id: <20190809030219.11296-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since qlt_make_local_sess() is defined before it is called, remove the
forward declaration of that function.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d0061ae1488e..4c5f9c02c379 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4106,8 +4106,6 @@ static inline int qlt_get_fcp_task_attr(struct scsi_qla_host *vha,
 	return fcp_task_attr;
 }
 
-static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *,
-					uint8_t *);
 /*
  * Process context for I/O path into tcm_qla2xxx code
  */
-- 
2.22.0

