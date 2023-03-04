Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8004EC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCDAbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCDAbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:16 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F95A6513C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:12 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id a9so4499010plh.11
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTsamwyLc8UXLyoqJsUD/xqrPKg5PKq0Pk6Ao0xpXeM=;
        b=7Tkty2/9CMaaCkd7EkbmB0LO3wmoDrUUMqEb/spyeTmR0RFU/DTxxNVdq4MeOP+wgk
         HZVcaUGrCiGgN4Pdzmn9zZ1jfiPaP5QlgVpCz3aj3oqdhGHsG4iee9ZmmY5Ut12Qn97G
         a7bXdRIGrVPxU/iy83Qrb2rovNgdCd6hymgdvrnTPg+ZOvJc3rqpKaNgbelaebTq13Bc
         31L4rDwsDZ99Bv/kxqJLUVBvKi6Zd4pDco5VumR9sYIbLWbw8Adp3jJUbw5qx1EVc+bF
         zlhpXOi7DMAZnQ6WypgTZTrYVXhEZmTGJHB5saURpSysSUOlhsxTp4X2FRJBws51PvWS
         9K9w==
X-Gm-Message-State: AO0yUKWzJlPrsFqd+o3NugF66YKc+p7MPNIXBq18M4ynfOsLcoFFkwCZ
        xb5F/o6N9WhoqxIGqG16J+S++pp++pA=
X-Google-Smtp-Source: AK7set+nhmMysWZVGxahsGDY9UU4mGIA5NCQcqN+wKe1iHYwr2H/cGS92wec22BGONuTI8NFQUHqFg==
X-Received: by 2002:a17:902:c948:b0:19a:a4f3:6d4c with SMTP id i8-20020a170902c94800b0019aa4f36d4cmr4473708pla.67.1677889871762;
        Fri, 03 Mar 2023 16:31:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 01/81] scsi: qla2xxx: Refer directly to the qla2xxx_driver_template
Date:   Fri,  3 Mar 2023 16:29:43 -0800
Message-Id: <20230304003103.2572793-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Access the qla2xxx_driver_template data structure directly instead of via
the host pointer. This patch prepares for declaring the 'hostt' pointer
const.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index aa0cf5ca6c1c..8d9a6aa3ea61 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6395,8 +6395,8 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 		return -ENOMEM;
 	}
 
-	if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
-		base_vha->host->hostt->supported_mode |= MODE_TARGET;
+	if (!(qla2xxx_driver_template.supported_mode & MODE_TARGET))
+		qla2xxx_driver_template.supported_mode |= MODE_TARGET;
 
 	rc = btree_init64(&tgt->lun_qpair_map);
 	if (rc) {
