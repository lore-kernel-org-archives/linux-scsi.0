Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466F1C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 322386112D
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242623AbhJHU0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:36 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:44842 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242591AbhJHU0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:35 -0400
Received: by mail-pl1-f174.google.com with SMTP id t11so6837313plq.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vM4jbQskNaFDXzTVQqQG1k37VqAHDN3vzlXEf6ehPR8=;
        b=avNhTdgSHEVLU14ZgUZoFyICzVaeGoyoDObF4cWlRA49gSCaVDgQ1Hk57Iv1IvP58W
         mv6x65SGM6xpU5v7QdAGgW9ic7Ih53n4Q7+uXyo4fmuP/hSO+241HjJ4Yzl1ocWxEPoN
         fMNlo8jf7d1QrpGZBSiN1gsOtoEclrMZa0zXEGPKiRfty5deoXQfZnSi75lxA/XrJbl6
         SmYWClRaOQ9yXJpWaJBAAwCEixeZrV651MvWQ9D8PvisOWdM2ZMm5cWiY4+Ehrwj3o7u
         AaLHnkpeAYA/hiT5HCSblqtzWzHP5UyFdZJooEVV+usFlE1h3vhZFsQVBSzYiwNJ3rkv
         LsFg==
X-Gm-Message-State: AOAM531a59NmlKBmsPzkSPT0HayFRp68rvPsCVAxtc4yQDcEUCSyZw/v
        SnsP9bKopYFZvHDQLM57PpA=
X-Google-Smtp-Source: ABdhPJztviwLe4kPyLpr/OVCRZOWHt7hEVAaJih7pzWDM5TYv0y8NWPqJ75pFiC7krt1xkM5+Zjwgg==
X-Received: by 2002:a17:902:6f01:b0:13b:7b8b:84a3 with SMTP id w1-20020a1709026f0100b0013b7b8b84a3mr11180054plk.40.1633724679747;
        Fri, 08 Oct 2021 13:24:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v3 17/46] scsi: csiostor: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:24 -0700
Message-Id: <20211008202353.1448570-18-bvanassche@acm.org>
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
 
