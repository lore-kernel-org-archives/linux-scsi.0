Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8D7C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47BAD610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhJHU0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:46 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:39760 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242494AbhJHU0o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:44 -0400
Received: by mail-pj1-f53.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso9673944pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kE5LxnwFISAmV7U8eafLq9RYsn5crmFkr10V2Fc9Pow=;
        b=n5FpZF004Ryn9+x/l5CaRPrKSiFz1k7aigZLrEQXBtoiP0Tplfoo6JpWafzyN9bgFc
         ZZr+15pyyJzwMDHVKFYnzkkrlDpg5KoW3fXoYLUI49Fhpq2FGe+y+KhS7sG2s3DyEOWZ
         CiYuYqz+5rHAWjABAr0alH9HwNnDAr/homtNc4YOKlsHI9Pqit9f04oxaDB66NiYJhuz
         rYFqGb9cLRx5K2hZZb884MqIrMNAgA2KOaxKi77oSLqPpM9Ru52Uo/jiFDeZmEdVH5Lz
         m3/jONR2LIrAoZpp6sLsN/JWbU7/zhHxAiF12G1tkYlWPRjeHizS39aPfvFFSGSDbUfF
         YGzg==
X-Gm-Message-State: AOAM533+AyQNRKTw3UTT1QmF379WkbZ+4O8Qv3xGiH1JMetO7LglpNCQ
        7YskHvXkjB/9IRSQ5t5Z4JE=
X-Google-Smtp-Source: ABdhPJwVAAI2kOD24k3rZEAcEmJ+o72Vk2bWBfhs/zL5zJ2MppHrJ0QjTdFFshk46NF18ZFiMnkvCg==
X-Received: by 2002:a17:902:9a83:b0:13e:5b1e:aa40 with SMTP id w3-20020a1709029a8300b0013e5b1eaa40mr11400171plp.41.1633724688331;
        Fri, 08 Oct 2021 13:24:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 23/46] scsi: ibmvscsi: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:30 -0700
Message-Id: <20211008202353.1448570-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008202353.1448570-1-bvanassche@acm.org>
References: <20211008202353.1448570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50df7dd9cb91..053ca437d2a8 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2064,18 +2064,20 @@ static int ibmvscsi_host_reset(struct Scsi_Host *shost, int reset_type)
 	return 0;
 }
 
-static struct device_attribute *ibmvscsi_attrs[] = {
-	&ibmvscsi_host_vhost_loc,
-	&ibmvscsi_host_vhost_name,
-	&ibmvscsi_host_srp_version,
-	&ibmvscsi_host_partition_name,
-	&ibmvscsi_host_partition_number,
-	&ibmvscsi_host_mad_version,
-	&ibmvscsi_host_os_type,
-	&ibmvscsi_host_config,
+static struct attribute *ibmvscsi_host_attrs[] = {
+	&ibmvscsi_host_vhost_loc.attr,
+	&ibmvscsi_host_vhost_name.attr,
+	&ibmvscsi_host_srp_version.attr,
+	&ibmvscsi_host_partition_name.attr,
+	&ibmvscsi_host_partition_number.attr,
+	&ibmvscsi_host_mad_version.attr,
+	&ibmvscsi_host_os_type.attr,
+	&ibmvscsi_host_config.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(ibmvscsi_host);
+
 /* ------------------------------------------------------------
  * SCSI driver registration
  */
@@ -2095,7 +2097,7 @@ static struct scsi_host_template driver_template = {
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
-	.shost_attrs = ibmvscsi_attrs,
+	.shost_groups = ibmvscsi_host_groups,
 };
 
 /**
