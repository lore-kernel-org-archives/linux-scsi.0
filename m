Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7D0C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCVTzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCVTzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:55:23 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C14521EE
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:55:22 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so15740625pjl.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTPeS6tBEMRDFCUaBbBw56D6tDM3vZchiMLIhTZmKIw=;
        b=tPHwhLEOZtFaRmlL9ppO3eakEJNK1+bbtxLA/Dz1Nj92EJLcqbCcycI+TR+nVGvQVz
         hHUN4GgeQP4A+TeYcjqdiM5lyDsbcScCCEE4bdAsvR5F5FIzyrsV+EtjcbeMiq/hcH0k
         8vuV/KfV+PD/wbUk5wx4xvlM9PqUsGvxW5IQKZqZtC3ZkQihmKYf+0G0fusXITfalMKP
         7l37LwrYQJ1Ct9pgeLQ24hoiMCQzLnZxstD4ZiwC9SDkHBDYVXwntxt00OCBvRY+Shnb
         fVB04NWQUfblvdEBp/0d/NLq4+vlv0n0VwFkg/Z4PrvrrLLO0QUQOQwUocA7HmQD5DNA
         Xq6A==
X-Gm-Message-State: AO0yUKXxyKog9o+J6uLuJ3NBg9Gb+k+vT2DB9dkqdh0KrYM/ygbEPOOG
        pGOMbzEkzrIf/s49kS16QitoOCnUgzw=
X-Google-Smtp-Source: AK7set8P7ly3wyJnPcpnCBs5WNZIUcqmOZ6LzOFHMrlyU9lecP14AxpTCfi5FIe3na36fuggqPtm4A==
X-Received: by 2002:a17:90b:164b:b0:236:73d5:82cf with SMTP id il11-20020a17090b164b00b0023673d582cfmr4730304pjb.9.1679514921687;
        Wed, 22 Mar 2023 12:55:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:55:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 01/80] scsi: qla2xxx: Refer directly to the qla2xxx_driver_template
Date:   Wed, 22 Mar 2023 12:53:56 -0700
Message-Id: <20230322195515.1267197-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
 drivers/scsi/qla2xxx/qla_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index aa0cf5ca6c1c..5258b07687a9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6395,8 +6395,7 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 		return -ENOMEM;
 	}
 
-	if (!(base_vha->host->hostt->supported_mode & MODE_TARGET))
-		base_vha->host->hostt->supported_mode |= MODE_TARGET;
+	qla2xxx_driver_template.supported_mode |= MODE_TARGET;
 
 	rc = btree_init64(&tgt->lun_qpair_map);
 	if (rc) {
