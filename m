Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74525C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49628216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404934AbfHIDCj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33983 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404679AbfHIDCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so38878858pgc.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lBxjP+D4M1i/kOdPHpFxMOG2Yb1btZ96jFzZVNgNmMI=;
        b=samwQLRTruwmhzlA6UootvrqndWBFvnrhhTcIpEOGYXtMlvUXeL8OigDhVU8o2rF/d
         Ik09RZSPgiQIWMtMltVbW4sfmfXC40h9JeFlyZMeOysrtX2yEO4yr9pPjN8lSEEg1BCB
         TeGDGkkFjk39jkEMCp4cvLvIFfjuS2NKZlP//K7npFgeKpG09KgUlzJZkzywH48umI+r
         auNI1GOB0XeDiZmvf0HG9QxsUn6yMo3Fq7RocX7sowLT1VSFKflDgqC3TVVaQZ0DGQVv
         +TKgsI0l8B4HHcc4pVqSJww8sf5fICMf7BQsnMfj5M8ye+AsepNLErA0Wr8euSXdghEl
         2+qg==
X-Gm-Message-State: APjAAAX/sUuu4tLlDbi2sA0sIOPquhVStJk7chYySGK1IZ18dB/aKVcv
        ef0hPQG/Vg9itIzunWZ5MxQ=
X-Google-Smtp-Source: APXvYqyN1L5Ix8pQjQ2YzqYa7xsKkASxx7TrO80BAuKDj1XdGoQOyen8KyEGKyzEkXx55P0ooB3Izg==
X-Received: by 2002:aa7:9819:: with SMTP id e25mr18420927pfl.47.1565319757784;
        Thu, 08 Aug 2019 20:02:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 01/58] qla2xxx: Make qla2x00_abort_srb() again decrease the sp reference count
Date:   Thu,  8 Aug 2019 20:01:22 -0700
Message-Id: <20190809030219.11296-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since qla2x00_abort_srb() starts with increasing the reference count of
@sp, decrease that same reference count before returning.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 219d27d7147e ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands") # v5.2.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 17a3f91ba5a3..b667f13b62df 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1755,6 +1755,8 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
 		sp->comp = NULL;
 	}
+
+	atomic_dec(&sp->ref_count);
 }
 
 static void
-- 
2.22.0

