Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAF4C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 460B5610E5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbhJHU0q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:46 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:38588 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242653AbhJHU0p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:45 -0400
Received: by mail-pl1-f177.google.com with SMTP id x4so6893568pln.5
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPxm0WzT6vqmWC/6Ibhv1IqkIJD1vpHs2ypKVoufU7w=;
        b=h+/MNE+Z2ontsVebPMqPf7Lw0R3FY4CdcXQQKV1oID6WMK/X7/AqPjlmzmqq7md8bp
         a6WEt6MEl3l+2/OF8i+XsN862kARzgeAjAzcu6qGFowARpa5IA28Xbv7JQf92lgO9uxg
         7VhsXRN0j0AXMZxqGUMGPS0pMVD0ZKfzNwMuedc/e6roWOSKDccNLLREt2euJ0Vd3AN9
         LOK9ns7/qNMMY7TZWVh0cExPFMdH+oqVRgiojCN1n9hJFK4GlKGHomqh4GM18EiNlwhE
         Ef6gxTznT3r/m0wHzhW76sBTwcfRC8rk4skqoQLk0ogdkDsmgn0/2EHvJH/lHDz3c+aW
         QZAA==
X-Gm-Message-State: AOAM531Aose4nNtr/wFiObh4YJN0X5b7zUvpfT7Rt+hdVl5c9uFaKboO
        n92QC28OF/nvNljGD0DPWYk=
X-Google-Smtp-Source: ABdhPJwqcI84T4WEMXAV20pN6wguDWFyW1TlhzK60NWdUH6maZ1LYHwMbkfM60gWlNBqrs78/SWz/g==
X-Received: by 2002:a17:902:bf07:b0:138:e32d:9f2e with SMTP id bi7-20020a170902bf0700b00138e32d9f2emr11165444plb.59.1633724689707;
        Fri, 08 Oct 2021 13:24:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 24/46] scsi: ibmvfc: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:31 -0700
Message-Id: <20211008202353.1448570-25-bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/ibmvfc.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1f1586ad48fe..bc3a608be136 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3588,18 +3588,20 @@ static struct bin_attribute ibmvfc_trace_attr = {
 };
 #endif
 
-static struct device_attribute *ibmvfc_attrs[] = {
-	&dev_attr_partition_name,
-	&dev_attr_device_name,
-	&dev_attr_port_loc_code,
-	&dev_attr_drc_name,
-	&dev_attr_npiv_version,
-	&dev_attr_capabilities,
-	&dev_attr_log_level,
-	&dev_attr_nr_scsi_channels,
+static struct attribute *ibmvfc_host_attrs[] = {
+	&dev_attr_partition_name.attr,
+	&dev_attr_device_name.attr,
+	&dev_attr_port_loc_code.attr,
+	&dev_attr_drc_name.attr,
+	&dev_attr_npiv_version.attr,
+	&dev_attr_capabilities.attr,
+	&dev_attr_log_level.attr,
+	&dev_attr_nr_scsi_channels.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(ibmvfc_host);
+
 static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IBM POWER Virtual FC Adapter",
@@ -3620,7 +3622,7 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
 	.max_sectors = IBMVFC_MAX_SECTORS,
-	.shost_attrs = ibmvfc_attrs,
+	.shost_groups = ibmvfc_host_groups,
 	.track_queue_depth = 1,
 	.host_tagset = 1,
 };
