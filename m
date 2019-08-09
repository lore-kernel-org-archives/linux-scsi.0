Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD815C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8575216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405160AbfHIDDJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46711 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so44346822plz.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dOiT/iBgJSjDxX+CwlqFnHYj8smLVjwQzY09IJvXKI=;
        b=chxTHFjWtDzh2Id0dv5dQbAfvHbGVp7uu4MGQ+JDnJ+55wF1bBuWm838AUEXODQrv/
         mJAWk2uJQDz0gY9esk8nQtoY0EG6MAPlQOUBafMQz/pXdg5vEjkvnOkX0AS1HqOefa8q
         7Jd4lzcK9ifHFXMw3xL9d13BCk3MfUlV8B84yOiB+ao9Pzi5pbi22FnEYgWs7/NgtQ2t
         KvnSO0Cd+4o+7pnzSEj4UsIbIwUVmAoJ/pl2bq1WoliPIrVGp64oVsbRNZKn/1nxbcPr
         jr7nRN6DvgsnGXGSqt1bGRzacb98Xq8KXbgNm0AQLfDmXlCipPR4Fy4xeK9FE81sNgWX
         Rsng==
X-Gm-Message-State: APjAAAVA6b2fxau7qsZVPWMq7WU6YiHOw32IgqWmdWAW4xehNNUUHrXa
        bgg2WUFfcPjEt1wO9AoxNLo=
X-Google-Smtp-Source: APXvYqycR/SjxkiTJBKB6ixr2/Afm7EwzSKQcb1m4WpjBJMumQTMktsaLhEPxWXTXNoH1xj6oFUzEA==
X-Received: by 2002:a17:902:166:: with SMTP id 93mr1760602plb.195.1565319788450;
        Thu, 08 Aug 2019 20:03:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 24/58] qla2xxx: Complain if parsing the version string fails
Date:   Thu,  8 Aug 2019 20:01:45 -0700
Message-Id: <20190809030219.11296-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a Coverity complaint about not checking the sscanf()
return value.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index de696a07532e..7ed481dd8ee6 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -860,8 +860,9 @@ qla27xx_driver_info(struct qla27xx_fwdt_template *tmp)
 {
 	uint8_t v[] = { 0, 0, 0, 0, 0, 0 };
 
-	sscanf(qla2x00_version_str, "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
-	    v+0, v+1, v+2, v+3, v+4, v+5);
+	WARN_ON_ONCE(sscanf(qla2x00_version_str,
+			    "%hhu.%hhu.%hhu.%hhu.%hhu.%hhu",
+			    v+0, v+1, v+2, v+3, v+4, v+5) != 6);
 
 	tmp->driver_info[0] = v[3] << 24 | v[2] << 16 | v[1] << 8 | v[0];
 	tmp->driver_info[1] = v[5] << 8 | v[4];
-- 
2.22.0

