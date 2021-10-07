Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B70C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9308061130
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhJGVVE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:21:04 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:41564 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhJGVVC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:21:02 -0400
Received: by mail-pg1-f178.google.com with SMTP id v11so1025412pgb.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZK7eJotaZDZgeIfzkKRbZRNkiJy+HAFbh7qlU1ZIZgw=;
        b=idmLYq0ARLNI6Cf+HgoAuHGunqmO0H2IIFHmAHSkmCQWexuwG/S3NMu2nToCevbbFb
         79ICQjFdSRym3BeUCuLn2SxMiHTxPuaRktjSutwzAKw0QOY0qVUznV8uTE0cngC87s/S
         fIWAZB/lepu18+7x1Fa2ed/3Jy4Nma3aoHrYJl/SRLhyhggPRu4Cm+7B3WYV0RMki6lz
         z7whkkFnxujG5tp7V7KRpfBd3K+wNk4QV8RWztMUpqg0q+yRrAYfkDohMjGhaXUkkBkA
         SMmLfUaXPQ8oHloepEPpzQ9jKk1E5w/OnwAA6qjSQYyIx30qCBGaRV06aBadJIP28KfP
         wihw==
X-Gm-Message-State: AOAM533Cd5aGQx/H119RjZD+1/o0F5YkaZZkVYqnD8GNXlP9pp4d7Ypo
        AARGiNqS0Qt0+01QMUb6O+kKpOwiNgdRYA==
X-Google-Smtp-Source: ABdhPJwCj5yDYQPeGRsB7hY/A+F6PrQvfURHZFoP+Kk0DlW16IL35qz56ECAuOo1Mndl0SpiDLXe3w==
X-Received: by 2002:a63:8bc4:: with SMTP id j187mr1515301pge.402.1633641547848;
        Thu, 07 Oct 2021 14:19:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id o2sm243290pgc.47.2021.10.07.14.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 14:19:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v2 04/46] RDMA/srp: Switch to attribute groups
Date:   Thu,  7 Oct 2021 14:18:10 -0700
Message-Id: <20211007211852.256007-5-bvanassche@acm.org>
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
 drivers/infiniband/ulp/srp/ib_srp.c | 58 ++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 71eda91e810c..8de4d6f6ce9e 100644
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
@@ -3050,23 +3057,32 @@ static ssize_t allow_ext_sg_show(struct device *dev,
 
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
+	NULL
+};
+
+static const struct attribute_group srp_host_attr_group = {
+	.attrs = srp_host_attrs
+};
+
+static const struct attribute_group *srp_host_attr_groups[] = {
+	&srp_host_attr_group,
 	NULL
 };
 
@@ -3090,7 +3106,7 @@ static struct scsi_host_template srp_template = {
 	.can_queue			= SRP_DEFAULT_CMD_SQ_SIZE,
 	.this_id			= -1,
 	.cmd_per_lun			= SRP_DEFAULT_CMD_SQ_SIZE,
-	.shost_attrs			= srp_host_attrs,
+	.shost_groups			= srp_host_attr_groups,
 	.track_queue_depth		= 1,
 	.cmd_size			= sizeof(struct srp_request),
 };
