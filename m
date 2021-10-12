Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DFDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D836960F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhJLXir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:47 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:38655 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbhJLXip (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:45 -0400
Received: by mail-pg1-f176.google.com with SMTP id s75so554331pgs.5
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vM4jbQskNaFDXzTVQqQG1k37VqAHDN3vzlXEf6ehPR8=;
        b=gd8KJ7nePX2nDdJHzJ1wIFnC0qHwJCNLq7GZxe8MinqIva9yvgZjkX1Dy6QOaBMrYj
         Jij9kNmp3klcfJSTIimoOykHHglq3l8pG+Hg/wmgWdpYG/zo2WGR9TB1uziGrW4XqUDM
         OjI0oFbj9j5Cb3hMutvgtH6KzoqpH/R9ZyQ1r4JkhXiJdpPw7v8RHU0u9Y3Lxa1qhIC1
         +fjUTxKLMfzUvcqeQk7w5XBhP6AEt1fwum5W/GYR7xAJgqIkqrt0vvL5GWZJjcNB9x9o
         Oeik63RJ30jBKoKBUcgORQ4fCI6kN4vP9V+qceeWQdpL0P9+E3rJ4ZsA1N7OR2Lg9/NH
         s9lQ==
X-Gm-Message-State: AOAM533DoRn03HTk+F62KQmBhFw9aC8ksxQXl2Fd2gQAth8w/GB7b+5a
        PorXHo/E22x6ih5+uGOSGofGYpQLQRP/Dg==
X-Google-Smtp-Source: ABdhPJxTrR3ce89vRa0IVjylrrILp5w+xdETvMNKBUMwAc1fRa8JqDt63XxgevD+4d8/qZDao8SECg==
X-Received: by 2002:a65:47cd:: with SMTP id f13mr25112367pgs.439.1634081802714;
        Tue, 12 Oct 2021 16:36:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v4 17/46] scsi: csiostor: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:29 -0700
Message-Id: <20211012233558.4066756-18-bvanassche@acm.org>
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
 drivers/scsi/csiostor/csio_scsi.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..bcfae3859f4c 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1460,14 +1460,16 @@ static DEVICE_ATTR(disable_port, S_IWUSR, NULL, csio_disable_port);
 static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 		  csio_store_dbg_level);
 
-static struct device_attribute *csio_fcoe_lport_attrs[] = {
-	&dev_attr_hw_state,
-	&dev_attr_device_reset,
-	&dev_attr_disable_port,
-	&dev_attr_dbg_level,
+static struct attribute *csio_fcoe_lport_attrs[] = {
+	&dev_attr_hw_state.attr,
+	&dev_attr_device_reset.attr,
+	&dev_attr_disable_port.attr,
+	&dev_attr_dbg_level.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(csio_fcoe_lport);
+
 static ssize_t
 csio_show_num_reg_rnodes(struct device *dev,
 		     struct device_attribute *attr, char *buf)
@@ -1479,12 +1481,14 @@ csio_show_num_reg_rnodes(struct device *dev,
 
 static DEVICE_ATTR(num_reg_rnodes, S_IRUGO, csio_show_num_reg_rnodes, NULL);
 
-static struct device_attribute *csio_fcoe_vport_attrs[] = {
-	&dev_attr_num_reg_rnodes,
-	&dev_attr_dbg_level,
+static struct attribute *csio_fcoe_vport_attrs[] = {
+	&dev_attr_num_reg_rnodes.attr,
+	&dev_attr_dbg_level.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(csio_fcoe_vport);
+
 static inline uint32_t
 csio_scsi_copy_to_sgl(struct csio_hw *hw, struct csio_ioreq *req)
 {
@@ -2277,7 +2281,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.this_id		= -1,
 	.sg_tablesize		= CSIO_SCSI_MAX_SGE,
 	.cmd_per_lun		= CSIO_MAX_CMD_PER_LUN,
-	.shost_attrs		= csio_fcoe_lport_attrs,
+	.shost_groups		= csio_fcoe_lport_groups,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
 };
 
@@ -2296,7 +2300,7 @@ struct scsi_host_template csio_fcoe_shost_vport_template = {
 	.this_id		= -1,
 	.sg_tablesize		= CSIO_SCSI_MAX_SGE,
 	.cmd_per_lun		= CSIO_MAX_CMD_PER_LUN,
-	.shost_attrs		= csio_fcoe_vport_attrs,
+	.shost_groups		= csio_fcoe_vport_groups,
 	.max_sectors		= CSIO_MAX_SECTOR_SIZE,
 };
 
