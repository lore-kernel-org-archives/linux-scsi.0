Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3524FC2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 09:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4862068E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 09:44:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GBu1uRaD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgKDJoE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 04:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgKDJoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 04:44:03 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F36C0613D3;
        Wed,  4 Nov 2020 01:44:03 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id z3so10463258pfz.6;
        Wed, 04 Nov 2020 01:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kWJsCx4EQF8uXSgei7plJ9RR+HrNgfh8GxBgpJCy8ss=;
        b=GBu1uRaDmb8QPh6FX7PmLpFaX3oh0yFIKEjPPKUwIHP4XzF0RtlsmAnn5eNilm+l/o
         GK4NjFn+DB+fhz+4WYGywEuvsyFpjtc2HTJmmkxschYhP2X3mt99J9KKLN6GkMWloI4s
         /MCdXA8LNSch/zTgvb2Qe4jafdHMeA5lYfXxUcz7GtKLjPn2b+RcybjXMX4t9kaRYL/J
         pQrJiFUJlauAhN14G/sdnOwHDAMoMf8qJBkSK0fmJ+67n8RxjXR7xDdiU0lf4uQMM0AU
         Zx8TGmNt7/Hx0KLCL0+P6a/z710rJcKot/ufluBoRzWoPCBNeesOtNtjsMdZSTBa81Rh
         shzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kWJsCx4EQF8uXSgei7plJ9RR+HrNgfh8GxBgpJCy8ss=;
        b=TmI190ch9zxtxoDPsJDl+thf8ARmS7vPqMCfi58WlbzJ8a3sw/lIBFpqueXVDvXOWa
         LBRXGTQhCeclQotzFGrsvNgC8dW0CUo/KpLqA7Ggd+Ep3IGbip1IicA/+fwbUJCWDwli
         eAjSLHblg5v9mwIBvk5U4QRIW3epnaZjntyAj/Ga1f9SGk4J9aH88kBYLZFaeg5lDfuD
         vRr/GXyO1lnnP9yZ1VBLN2IdANIvZFCqarIIbyCcFUvcBUWS95M/i5bK1FD/48zgoBc0
         R5KJtMf+K/ZJtqIobuP636bwz5RgwERgcWMQE130gjzhgN+GdyHtVwhDYZepExMoSAFk
         YUzg==
X-Gm-Message-State: AOAM531nRSkL0YjPzImydVnvBUA8N8oPDLR7Wam0ThW9Bm8ZkRubGqtq
        H9NlJS4dBss/9WBNsd71DA==
X-Google-Smtp-Source: ABdhPJzyxRUbu8mhR63eWnntpxXM+mZwoE3c+3Hu3tPLIkdXYhsDnOUL9pb+5cs+Zssm+8d9lLlIkA==
X-Received: by 2002:a17:90a:5d82:: with SMTP id t2mr3634750pji.42.1604483043378;
        Wed, 04 Nov 2020 01:44:03 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id e5sm2003487pjd.0.2020.11.04.01.44.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 01:44:02 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        martin.petersen@oracle.com, jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] scsi: lpfc: use the normal helper to get the device
Date:   Wed,  4 Nov 2020 17:43:57 +0800
Message-Id: <1604483037-24060-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Here we could use the normal helper kobj_to_dev() to get the device
to simplify code.

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e94eac194676..779c7880481d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4380,8 +4380,7 @@ sysfs_drvr_stat_data_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
-	struct device *dev = container_of(kobj, struct device,
-		kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
@@ -6309,7 +6308,7 @@ sysfs_ctlreg_write(struct file *filp, struct kobject *kobj,
 		   char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
@@ -6369,7 +6368,7 @@ sysfs_ctlreg_read(struct file *filp, struct kobject *kobj,
 {
 	size_t buf_off;
 	uint32_t * tmp_ptr;
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-- 
2.20.0

