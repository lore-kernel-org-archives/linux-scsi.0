Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78B6C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C258F216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405180AbfHIDDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41733 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so34751200pgg.8
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WhXhYc/R7zacGT2MZgZcpMF5ivuECz+vDnBBfxkXzoU=;
        b=Gj0L9PnxJnWoINV4r1JIO6u6WnjNZdna2QmGrZ1Hjg4UTxmVaAhaEpD8wFqyg8iB+G
         B5Fm9ZtsEOcdxKexhqR3JxAkCotMPXecjTKASInNKmql+DOiyd0fkvDB3kTiACjLyxZy
         HwxPyD+nt86dcMYnRNhkSPq4s6wy6DX9AFjkUdMo2TJ6/UVCfj+QrnEHKM9E0BRVRDTQ
         szxY0j2NNcT9m6XK8445wrN+90cgcH1RqZyTUeHL8VvIUu33Kt9g11916sBRad7XWlYJ
         pf94v+bNRzDmOVpGjaQqN6WNngBHcUDZs7gk+Y31N2wEgZTVUq2FFDEzz8ZC8mbCuJd6
         8krQ==
X-Gm-Message-State: APjAAAVG3KWm+HcES4guwM9JLpyhfeXEWeRZDAf6xS+u6UErqIPMIm9b
        pscgvuVRakd9QMCAKCqdkgI=
X-Google-Smtp-Source: APXvYqyd7kg6f/q5VutTltusBEMifgFUjUslsFrn4TCfsiEXWs9xq2YVsprok/9skMMRzrgheIaU7g==
X-Received: by 2002:a17:90a:26a1:: with SMTP id m30mr7332363pje.59.1565319793626;
        Thu, 08 Aug 2019 20:03:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 28/58] qla2xxx: Remove unreachable code from qla83xx_idc_lock()
Date:   Thu,  8 Aug 2019 20:01:49 -0700
Message-Id: <20190809030219.11296-29-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by Coverity.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 37e24987c852..2ba06a84c501 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5720,7 +5720,6 @@ qla83xx_idc_lock_recovery(scsi_qla_host_t *base_vha)
 void
 qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 {
-	uint16_t options = (requester_id << 15) | BIT_6;
 	uint32_t data;
 	uint32_t lock_owner;
 	struct qla_hw_data *ha = base_vha->hw;
@@ -5753,22 +5752,6 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 	}
 
 	return;
-
-	/* XXX: IDC-lock implementation using access-control mbx */
-retry_lock2:
-	if (qla83xx_access_control(base_vha, options, 0, 0, NULL)) {
-		ql_dbg(ql_dbg_p3p, base_vha, 0xb072,
-		    "Failed to acquire IDC lock. retrying...\n");
-		/* Retry/Perform IDC-Lock recovery */
-		if (qla83xx_idc_lock_recovery(base_vha) == QLA_SUCCESS) {
-			qla83xx_wait_logic();
-			goto retry_lock2;
-		} else
-			ql_log(ql_log_warn, base_vha, 0xb076,
-			    "IDC Lock recovery FAILED.\n");
-	}
-
-	return;
 }
 
 void
-- 
2.22.0

