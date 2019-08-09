Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E866FC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C85CA216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405087AbfHIDDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39943 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404951AbfHIDDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so45218147pfp.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xPPzCwksd7Yiibe/aTFsdMKBu7OiSK72/xPXMMHtQfY=;
        b=UP5fsqjib4u+knKdfVcuwBcXE15OzchFyDpIg0oIour8O5Yz/BBVZC+0P+bO6MQwfb
         Y/AYBQVEsw7ByR1GEKWZRcUNlFu4hH1tmzrpTqXPyVsbAdaPv/385By0n0vJYRFX/P15
         /Jfd3T/Qs0hsnJke4/DkVxdUqK4u5wQMC9YgD9BBpCIqxKky1bH77hdY228mbWglRSN9
         6o3QfxdqZsocDxNgxrUWZ+NIxLu0Jvf5ZFBjrPTr/apGm/6WjhkDbmGGLPZp24bo8Ic6
         vaVo7zVJmmRV5QuNW/lSFkLASEnJXmjWDj/Vuaiqszd3mI1wABctmj+Z97y73CABQGXy
         BHEw==
X-Gm-Message-State: APjAAAVUV+NDyorW7kntuVUGlBt7Rg2ikxM88huUYmZN4SG3ZssDeDPW
        DHKIt8v5juuBMFKEgPSKg+Y=
X-Google-Smtp-Source: APXvYqy8QAkvSm28nkXBovhBvnmMZqZKXSoyQG4+m3v5RWJt9EtkCXXmW/bJHjC+INWlFdr/pIYOqA==
X-Received: by 2002:a62:fb15:: with SMTP id x21mr19511900pfm.233.1565319781598;
        Thu, 08 Aug 2019 20:03:01 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 19/58] qla2xxx: Fix session lookup in qlt_abort_work()
Date:   Thu,  8 Aug 2019 20:01:40 -0700
Message-Id: <20190809030219.11296-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pass the correct session ID to find_sess_by_s_id() instead of passing
an uninitialized variable.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 2d70c103fd2a ("[SCSI] qla2xxx: Add LLD target-mode infrastructure for >= 24xx series") # v3.5.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 12a3e77e0d02..ea22e62257cb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6198,7 +6198,6 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_port *sess = NULL;
 	unsigned long flags = 0, flags2 = 0;
-	uint32_t be_s_id;
 	uint8_t s_id[3];
 	int rc;
 
@@ -6211,8 +6210,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	s_id[1] = prm->abts.fcp_hdr_le.s_id[1];
 	s_id[2] = prm->abts.fcp_hdr_le.s_id[0];
 
-	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
-	    (unsigned char *)&be_s_id);
+	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
 	if (!sess) {
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
-- 
2.22.0

