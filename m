Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21307C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0929216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405192AbfHIDDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35510 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id u14so45241986pfn.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uKFSoaQZBXoP3+VjWkEadEGh6t1J2IqtjRaXRdP4wB8=;
        b=fRrskKGj+Y2w73hdktsEY5XHn+I64beWqlAofVMhsWJTTmZvM/jFP5T3SrW9QEMCZT
         /9ESncfbDv1oes0LbBDaiGwVfG9J2TPH++UV8wyhR3Qnm3pKfG5UTKzpTKFwmjTLYalv
         vDZjrqG9vZBIV9OWG0KR8hqrdFVPkS1tDD2OH9l0FQAgecY2Obkueba1D961mePzvg2F
         8mPv53R/Xka8tYQzZKe/VbJCv0Fj0rd++OFtQ6IdcAiPxuCSHuVU7AlxwGa5vukyBYm2
         P9S02wkjnRhsQw76shF64GG3YtUGxU5DcPPKRZCaDD4m6r5IGakDzs2er+nA+DtKqvDu
         xsxA==
X-Gm-Message-State: APjAAAVndiE8M5ZxJXFn+jgK9wMkyZNwDV2fr5+VeJm1mR0cKOGyYzcv
        CnVV3XLkWQMRUVK7VLrvp7pVGSz2
X-Google-Smtp-Source: APXvYqygco203evI8uTbJAtuKy3zco9IGWC0ojpbwwzY6sLi0MCSqOx5ogJiyJOEqmv/UxokqsgQiQ==
X-Received: by 2002:a17:90a:9bc5:: with SMTP id b5mr7220554pjw.109.1565319797762;
        Thu, 08 Aug 2019 20:03:17 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 31/58] qla2xxx: Always check the qla2x00_wait_for_hba_online() return value
Date:   Thu,  8 Aug 2019 20:01:52 -0700
Message-Id: <20190809030219.11296-32-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes several Coverity complaints about not always checking
the qla2x00_wait_for_hba_online() return value.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_attr.c   | 3 ++-
 drivers/scsi/qla2xxx/qla_target.c | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2b92d4659934..e3de20918efb 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -724,7 +724,8 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 			break;
 		} else {
 			/* Make sure FC side is not in reset */
-			qla2x00_wait_for_hba_online(vha);
+			WARN_ON_ONCE(qla2x00_wait_for_hba_online(vha) !=
+				     QLA_SUCCESS);
 
 			/* Issue MPI reset */
 			scsi_block_requests(vha->host);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ba53329e8bf9..d20e0c21710e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6673,7 +6673,8 @@ qlt_enable_vha(struct scsi_qla_host *vha)
 	} else {
 		set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
 		qla2xxx_wake_dpc(base_vha);
-		qla2x00_wait_for_hba_online(base_vha);
+		WARN_ON_ONCE(qla2x00_wait_for_hba_online(base_vha) !=
+			     QLA_SUCCESS);
 	}
 	mutex_unlock(&ha->optrom_mutex);
 }
@@ -6704,7 +6705,9 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	qla2xxx_wake_dpc(vha);
-	qla2x00_wait_for_hba_online(vha);
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+		ql_dbg(ql_dbg_tgt, vha, 0xe081,
+		       "qla2x00_wait_for_hba_online() failed\n");
 }
 
 /*
-- 
2.22.0

