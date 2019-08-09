Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C4BC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D054216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405194AbfHIDDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45980 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so45082240pgp.12
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p6QLIAxBOg2UTvDL+5RbvLJuu9lJX9yxfnzUQe+FHBU=;
        b=Ly3HAFyNoNVepq2rd5zJK9Tke5lqwyo56+MqFQmVU79nJqdeScNeh30Dt61i3r1Rv2
         BuiBXX7k489jY5OY1UguYdDXKVwH2ZxcFcHMhFKAjPwpRm8f7k/cJMfUQ44UvQCf1CBa
         2BbqKN0jDS/1ObkNDnDj3PEUV34+XDXqXQPKpbMltY0bijkUifZnp+EO/J7UPN+jzhYm
         UA4dpq67eo53yaSiYTr6VhDYYzarPU72wXjoU5VpwF/hjG4WuTQ38iZxne9XLbMeZYf3
         3tlYfnvFVV8Cn8Q9GO3Saqkj+SgcOwt+Kr7MZE50FeegfVwnSDntjb4khRI+5Q/DhMcL
         xFXg==
X-Gm-Message-State: APjAAAU0vcPXN+HeGJd6Q7wrjB1XJR/XyNqA32XCusqqi/Fj8gOPw6pS
        XumBkpVilzNO0fVL2qlm7eM=
X-Google-Smtp-Source: APXvYqymsqWvgDx12aHWN5P0eNCiuZ7xZeFDpMlNZcmSh6dDNp03vnJPhw7l6r+BYkUrht8mQ6IYLw==
X-Received: by 2002:a65:6552:: with SMTP id a18mr15944953pgw.208.1565319799040;
        Thu, 08 Aug 2019 20:03:19 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 32/58] qla2xxx: Declare fourth qla2x00_set_model_info() argument const
Date:   Thu,  8 Aug 2019 20:01:53 -0700
Message-Id: <20190809030219.11296-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it clear to humans and also to the compiler that the string passed
as fourth argument is not modified.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h  | 4 ++--
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 6f6801722a09..fc54e7c86463 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -822,8 +822,8 @@ extern int qla82xx_device_state_handler(scsi_qla_host_t *);
 extern void qla8xxx_dev_failed_handler(scsi_qla_host_t *);
 extern void qla82xx_clear_qsnt_ready(scsi_qla_host_t *);
 
-extern void qla2x00_set_model_info(scsi_qla_host_t *, uint8_t *,
-				   size_t, char *);
+extern void qla2x00_set_model_info(scsi_qla_host_t *, uint8_t *, size_t,
+				   const char *);
 extern int qla82xx_mbx_intr_enable(scsi_qla_host_t *);
 extern int qla82xx_mbx_intr_disable(scsi_qla_host_t *);
 extern void qla82xx_start_iocbs(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cab5f2f90714..1fd9a086748e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4426,7 +4426,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 
 inline void
 qla2x00_set_model_info(scsi_qla_host_t *vha, uint8_t *model, size_t len,
-	char *def)
+		       const char *def)
 {
 	char *st, *en;
 	uint16_t index;
-- 
2.22.0

