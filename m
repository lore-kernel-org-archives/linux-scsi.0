Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858DDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647D660F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhJLXiR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:17 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:34711 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhJLXiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:15 -0400
Received: by mail-pl1-f176.google.com with SMTP id g5so587613plg.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/VigYoDqQaVLh8ZnJ8MkI1sXa+kkie0GLhmAN4WYaIg=;
        b=H++P9uK28jkh/NtVPGFq3nScpnBbNabjdCIWmqsFvrl/olW40J6pMI56juSLVCDwLK
         AZT9Wl8R1460ZrU3C6jJG0ZTT7wfMD+uXeMihJO4AOE4NYDyBANXxJawdomd39LWlGdK
         nxeskxIMIWwhL03D6beE8DLHwzgUdqqW+Erc2ZjjvSmkl7Fel6bFOuIZgwtmiUH/F8uJ
         sV6dBNQCzvDpwwhEfhuNQCA/26quraiCXDZRhIntoAdNRiq85qmM+NbEt1A2B8T3jzt/
         Q0jaCeCg7aiJ8TT6MOI/AdH6ZK+ZaujB2TbAWGlpPq+G+afZ7LlSlclwEjO5bdW2yyPv
         kIFw==
X-Gm-Message-State: AOAM530aHvWHCh1Hx6wIA1CKsY5G20pNIaEfxSVPJHQUCNV+a/+O7g5V
        jDGy/2bMImyK1cyuukatB5Q=
X-Google-Smtp-Source: ABdhPJwhFBoW1p9MTzsR9Ug5ufQneoR0OKJCABx/IK3V94T/Rw36wBg4cLYSUR8oSqr1fxCv+k08kg==
X-Received: by 2002:a17:902:c401:b0:13e:f5f2:f852 with SMTP id k1-20020a170902c40100b0013ef5f2f852mr32522401plk.29.1634081772492;
        Tue, 12 Oct 2021 16:36:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v4 04/46] RDMA/srp: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:16 -0700
Message-Id: <20211012233558.4066756-5-bvanassche@acm.org>
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
 drivers/infiniband/ulp/srp/ib_srp.c | 51 +++++++++++++++++------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 71eda91e810c..089e09bfe002 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1026,10 +1026,17 @@ static int srp_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  */
 static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 {
-	struct device_attribute **attr;
+	const struct attribute_group **g;
+	struct attribute **attr;
 
-	for (attr = shost->hostt->shost_attrs; attr && *attr; ++attr)
-		device_remove_file(&shost->shost_dev, *attr);
+	for (g = shost->hostt->shost_groups; *g; ++g) {
+		for (attr = (*g)->attrs; *attr; ++attr) {
+			struct device_attribute *dev_attr =
+				container_of(*attr, typeof(*dev_attr), attr);
+
+			device_remove_file(&shost->shost_dev, dev_attr);
+		}
+	}
 }
 
 static void srp_remove_target(struct srp_target_port *target)
@@ -3050,26 +3057,28 @@ static ssize_t allow_ext_sg_show(struct device *dev,
 
 static DEVICE_ATTR_RO(allow_ext_sg);
 
-static struct device_attribute *srp_host_attrs[] = {
-	&dev_attr_id_ext,
-	&dev_attr_ioc_guid,
-	&dev_attr_service_id,
-	&dev_attr_pkey,
-	&dev_attr_sgid,
-	&dev_attr_dgid,
-	&dev_attr_orig_dgid,
-	&dev_attr_req_lim,
-	&dev_attr_zero_req_lim,
-	&dev_attr_local_ib_port,
-	&dev_attr_local_ib_device,
-	&dev_attr_ch_count,
-	&dev_attr_comp_vector,
-	&dev_attr_tl_retry_count,
-	&dev_attr_cmd_sg_entries,
-	&dev_attr_allow_ext_sg,
+static struct attribute *srp_host_attrs[] = {
+	&dev_attr_id_ext.attr,
+	&dev_attr_ioc_guid.attr,
+	&dev_attr_service_id.attr,
+	&dev_attr_pkey.attr,
+	&dev_attr_sgid.attr,
+	&dev_attr_dgid.attr,
+	&dev_attr_orig_dgid.attr,
+	&dev_attr_req_lim.attr,
+	&dev_attr_zero_req_lim.attr,
+	&dev_attr_local_ib_port.attr,
+	&dev_attr_local_ib_device.attr,
+	&dev_attr_ch_count.attr,
+	&dev_attr_comp_vector.attr,
+	&dev_attr_tl_retry_count.attr,
+	&dev_attr_cmd_sg_entries.attr,
+	&dev_attr_allow_ext_sg.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(srp_host);
+
 static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
@@ -3090,7 +3099,7 @@ static struct scsi_host_template srp_template = {
 	.can_queue			= SRP_DEFAULT_CMD_SQ_SIZE,
 	.this_id			= -1,
 	.cmd_per_lun			= SRP_DEFAULT_CMD_SQ_SIZE,
-	.shost_attrs			= srp_host_attrs,
+	.shost_groups			= srp_host_groups,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct srp_request),
 };
