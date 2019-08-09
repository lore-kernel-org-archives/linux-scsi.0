Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E051FC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBAF2216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405167AbfHIDDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38110 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:10 -0400
Received: by mail-pg1-f193.google.com with SMTP id z14so7868939pga.5
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=crH/Gv+AKHpJTuaNMw64rShb/oHl1oOuQgZgdwKfa2I=;
        b=REFGDE5W9T4fTuU0iYG8gPCc7gvA/S9L1ISS50t9qHqonOX7DppinJgU4Oa7WXkUj+
         AMnknz0+ZT9encPatkUDVt2mN0vbEjOMWAN6iOX9F9Hc62Fgq1XJ1oF1XKkVr1mPMQOs
         9IqfhKK8p8dYCYv1mwjWWPXAL07C92smmlAs7SF0fV3nPQf8+0Ax3Z9JrKZpM/ObJYBh
         eNNKegtEzh6/cxoysfN6M2cjuwd2CLjoc5k2W4KZuZEh3HYgTym7KFOEulK7qD7GebQk
         /pXNyI4Y1Bu107wIwry03nQp9tsIljwpwiHbv+5//UiDzyW6FXg8tZ1pDBr2FjUMKT6w
         pBEQ==
X-Gm-Message-State: APjAAAUkb0M5qVvHgD/sV2JT9d06rCLuWZc60l3xCj0gjGoqsv/n4TVg
        ZlXsWAZTEYG0o7EgnTmbv30=
X-Google-Smtp-Source: APXvYqzln7VpfzriTQPMiudd3WiTtPW9jDcLukihx4h4C6AD3flj7PXXFEvxyLe8XXBBlmReFagZ+g==
X-Received: by 2002:a62:7994:: with SMTP id u142mr19200355pfc.39.1565319789698;
        Thu, 08 Aug 2019 20:03:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 25/58] qla2xxx: Remove dead code
Date:   Thu,  8 Aug 2019 20:01:46 -0700
Message-Id: <20190809030219.11296-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since sess == NULL before 'goto out_term2' is executed, the code under
'if (sess)' cannot be reached. Hence remove that code. This was detected
by Coverity.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9cd5e2fba8ca..ba53329e8bf9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6249,9 +6249,6 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 out_term2:
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
-	if (sess)
-		ha->tgt.tgt_ops->put_sess(sess);
-
 out_term:
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_24xx_send_abts_resp(ha->base_qpair, &prm->abts,
-- 
2.22.0

