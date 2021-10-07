Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1587C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF32B610A0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbhJGVVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:55 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:45689 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240647AbhJGVVx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:53 -0400
Received: by mail-pj1-f44.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so6190110pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVUJOXbf823uhhp9zXXJdESGWghAuwZbboXoOCO4TQ8=;
        b=O0cRFRMRvWZvoDahwFw+ShSMx+sgbeaiO2P7S8P447k3tLEXuD4IY2ykfMBRpkzsiD
         rEDpyAzSUAs5WZgNVye1dvcOEgom9zjYUDPXAnD3LpCNSpNDXFJKev006d61RJsg2gzR
         iEpU2AT7YQt7NqxmLTfdkY/qDpHYIjz+VGRnEuvJmrlX5b21duEVjeUN4N7/2fbYUT4F
         qiUXi9LuxTnWl39C7edzxCBMWOOQ39YrS/Av5ZOftLegS8sR0xCKtmq9FkSPPspndAyj
         mkY2nNGFB3DP5k/Nmg9nmqSFd5RZ6Uk/gP9YAwu2/3xrrcgd/a54V79J5mG7XOhTpIlS
         H69w==
X-Gm-Message-State: AOAM5337VOwa+rDMyitoY9VlZeF5QKJ/mzaiYw8sysQG1H+Xhzw3SUNk
        MKBYdGbK4VLdd4z8LH12u3Y0FMyf4ZImMA==
X-Google-Smtp-Source: ABdhPJxCOyHPw3L5fssXZG9w/WsxzttMretL2Fd4ZsdLAmR92kTJthLDvdEsSGiStRQlwNhMCTLwdQ==
X-Received: by 2002:a17:902:6b0b:b0:13a:18bf:1ece with SMTP id o11-20020a1709026b0b00b0013a18bf1ecemr5813538plk.49.1633641598846;
        Thu, 07 Oct 2021 14:19:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 23/46] scsi: ibmvscsi: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:29 -0700
Message-Id: <20211007211852.256007-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007211852.256007-1-bvanassche@acm.org>
References: <20211007211852.256007-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct device supports attribute groups directly but does not support
struct device_attribute directly. Hence switch to attribute groups.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50df7dd9cb91..b73009a7ad34 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2064,15 +2064,24 @@ static int ibmvscsi_host_reset(struct Scsi_Host *shost, int reset_type)
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
+static struct attribute *ibmvscsi_attrs[] = {
+	&ibmvscsi_host_vhost_loc.attr,
+	&ibmvscsi_host_vhost_name.attr,
+	&ibmvscsi_host_srp_version.attr,
+	&ibmvscsi_host_partition_name.attr,
+	&ibmvscsi_host_partition_number.attr,
+	&ibmvscsi_host_mad_version.attr,
+	&ibmvscsi_host_os_type.attr,
+	&ibmvscsi_host_config.attr,
+	NULL
+};
+
+static const struct attribute_group ibmvscsi_attr_group = {
+	.attrs = ibmvscsi_attrs
+};
+
+static const struct attribute_group *ibmvscsi_attr_groups[] = {
+	&ibmvscsi_attr_group,
 	NULL
 };
 
@@ -2095,7 +2104,7 @@ static struct scsi_host_template driver_template = {
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
-	.shost_attrs = ibmvscsi_attrs,
+	.shost_groups = ibmvscsi_attr_groups,
 };
 
 /**
