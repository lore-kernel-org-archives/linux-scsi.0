Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9D9C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F5C60F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhJLXij (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:39 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:43715 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbhJLXig (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:36 -0400
Received: by mail-pg1-f181.google.com with SMTP id r2so532744pgl.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0oytqwBYbr35Z6MtPz7HCBDp8jm+jqZ/k5dsTUcnRlA=;
        b=O3GvtAJUJb0fzhmxZVY3AKbl0YR3VfbrxWu6US3+kClZgTwr+mxHDKMadCqyBbIChf
         csCqR2pDRTj/oANVHSOGbNea3DvaynNsADb+RbFFHjLtKskpZ7dNnPb73tD+RVj2r3ux
         0p3XbSTFCLnAZsveo9me2QzS/6c1PQPlqNppb2JZvT/HGhoKhaP/Y7JsbhaOdcdNO/tb
         RCQrLckLubMS1H5zvfyq1iWrj8nTpuK1VKbzvK1bRFEXco3YSinQIN/2cHQoV5MJgbuN
         HduAkgKhV9jUhY/wq7PRTenCyD6luMHOhE7kmSks4igJg7uz6XNtHG8g0Rz8tjZCIn8d
         XVYg==
X-Gm-Message-State: AOAM530oLMbuMVuIjpi/K473ahrHTbTvDz+mgj1Pd6Efw2Y6/W83d9jj
        N++oQJGpOVJyQG4bEbqlTg8=
X-Google-Smtp-Source: ABdhPJyu9FvO0PrKAzab5zgVOTwmUkyIe+US027x8BE9L/rTcWrS/GPq6Jm9dkBZl1bxdx7XBi6YYw==
X-Received: by 2002:a63:3756:: with SMTP id g22mr11587415pgn.279.1634081794033;
        Tue, 12 Oct 2021 16:36:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 13/46] scsi: be2iscsi: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:25 -0700
Message-Id: <20211012233558.4066756-14-bvanassche@acm.org>
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
 drivers/scsi/be2iscsi/be_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index e70f69f791db..ab55681145f8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -163,17 +163,20 @@ DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
 	     beiscsi_active_session_disp, NULL);
 DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
 	     beiscsi_free_session_disp, NULL);
-static struct device_attribute *beiscsi_attrs[] = {
-	&dev_attr_beiscsi_log_enable,
-	&dev_attr_beiscsi_drvr_ver,
-	&dev_attr_beiscsi_adapter_family,
-	&dev_attr_beiscsi_fw_ver,
-	&dev_attr_beiscsi_active_session_count,
-	&dev_attr_beiscsi_free_session_count,
-	&dev_attr_beiscsi_phys_port,
+
+static struct attribute *beiscsi_attrs[] = {
+	&dev_attr_beiscsi_log_enable.attr,
+	&dev_attr_beiscsi_drvr_ver.attr,
+	&dev_attr_beiscsi_adapter_family.attr,
+	&dev_attr_beiscsi_fw_ver.attr,
+	&dev_attr_beiscsi_active_session_count.attr,
+	&dev_attr_beiscsi_free_session_count.attr,
+	&dev_attr_beiscsi_phys_port.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(beiscsi);
+
 static char const *cqe_desc[] = {
 	"RESERVED_DESC",
 	"SOL_CMD_COMPLETE",
@@ -391,7 +394,7 @@ static struct scsi_host_template beiscsi_sht = {
 	.eh_abort_handler = beiscsi_eh_abort,
 	.eh_device_reset_handler = beiscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_session_reset,
-	.shost_attrs = beiscsi_attrs,
+	.shost_groups = beiscsi_groups,
 	.sg_tablesize = BEISCSI_SGLIST_ELEMENTS,
 	.can_queue = BE2_IO_DEPTH,
 	.this_id = -1,
