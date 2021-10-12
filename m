Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD1CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C796260F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhJLXi4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:56 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:39599 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbhJLXiz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:55 -0400
Received: by mail-pl1-f179.google.com with SMTP id c4so573153pls.6
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPxm0WzT6vqmWC/6Ibhv1IqkIJD1vpHs2ypKVoufU7w=;
        b=uZbLTkCuZgaRtX0F8o9phLsGWsqExWHeg7EmhyvV6t/lKYX5eb2yB9C5srImAWgXjb
         5iuX6sZX90RbZ/k0b/3NJTroI4T3t9yUCJOzbjvxpSxY42B96gZFYT8njfZQOIYD7kcD
         yYhmAJDZoL5eWLzvqCBAxn4Q6xUzh7iCmMX/6ciQM2Kgx0hza1GiynrbgzgE8uelGOOd
         BxJl2uoQfIAcFu9PGZI74Wgazf/LGB7fA0bZ79MJc2rpRpnDvtm67Z8eEIIjxRT2Z7SQ
         1pTZ2tFp9PknWu21W7rMMRd25eWJAYd57mcAQWgSaVFq1JW8iat0mzPCLjU5TWW80Me/
         s7fA==
X-Gm-Message-State: AOAM533bcWnuY/ZShxn91APITNpaEF1F/X8hcV19Mfd45ytk9EDoEkXS
        ajx2eRzLjDa/KJLuDfki/UU=
X-Google-Smtp-Source: ABdhPJzhkdRtyRQlmiYUtYgC1AxZAAKfYUCbA4rAeQHKEzeMLiO74Lvpj2c4iOtz9BlZpo+6/MRJmg==
X-Received: by 2002:a17:90a:1548:: with SMTP id y8mr9763262pja.151.1634081812569;
        Tue, 12 Oct 2021 16:36:52 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 24/46] scsi: ibmvfc: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:36 -0700
Message-Id: <20211012233558.4066756-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org>
References: <20211012233558.4066756-1-bvanassche@acm.org>
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
