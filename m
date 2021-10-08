Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF52FC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9CCD610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbhJHU0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:37 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:43797 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhJHU0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:37 -0400
Received: by mail-pf1-f175.google.com with SMTP id 187so9093330pfc.10
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I0c+nV8p2rT/HmjUOeDz34YoCK9/gAs2RcO0O3Za1pc=;
        b=RYDKrDO5QGgScTTKL0dxRjov78/2Fk2weC82urkvjrF6zvLUS4LifSBM3jCNE5oNPs
         wlX/iWwAenL7l57aCXXyNchBjuc2Q5p1g34rjBO2Fbsh5GnFCnn1WnRhoL0p2h9JKO8O
         AFqs+2kyssXL91KJwQOSJEq87cLiVuGrslWbafVhviz7QIxoQscKV9beTOgaV8uBM/vB
         wO93bfZLGJ15kvWaMBZ6ah6Ei0iJlqrmGLFuixs/ZsA1sHt1/UlkkuJBRYmEcScod2Df
         GiWe8g88JGsKOXfYsaHPWu1LQsaBeKnlwp/md6XFHpi4y1HcvVMHo0g2YpszLDHCZhpf
         jMKA==
X-Gm-Message-State: AOAM533JLaS2TlYoIGL3EV3K81NkpNDF05qH2112RIZ105M1w88/mKVW
        v3OFP23NiSjdRMgQtHXzLgw=
X-Google-Smtp-Source: ABdhPJwfcUCYkUvqgq9ZlVSrUpAv9h3s6aDSrQ23U1lAW5wd3EdGV0rYSk0NkOyEq9SOqscaTpIYUw==
X-Received: by 2002:a63:7b48:: with SMTP id k8mr4208487pgn.208.1633724681186;
        Fri, 08 Oct 2021 13:24:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 18/46] scsi: cxlflash: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:25 -0700
Message-Id: <20211008202353.1448570-19-bvanassche@acm.org>
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
 drivers/scsi/cxlflash/main.c | 40 ++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b2730e859df8..0c806dc95e89 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3103,33 +3103,37 @@ static DEVICE_ATTR_RW(irqpoll_weight);
 static DEVICE_ATTR_RW(num_hwqs);
 static DEVICE_ATTR_RW(hwq_mode);
 
-static struct device_attribute *cxlflash_host_attrs[] = {
-	&dev_attr_port0,
-	&dev_attr_port1,
-	&dev_attr_port2,
-	&dev_attr_port3,
-	&dev_attr_lun_mode,
-	&dev_attr_ioctl_version,
-	&dev_attr_port0_lun_table,
-	&dev_attr_port1_lun_table,
-	&dev_attr_port2_lun_table,
-	&dev_attr_port3_lun_table,
-	&dev_attr_irqpoll_weight,
-	&dev_attr_num_hwqs,
-	&dev_attr_hwq_mode,
+static struct attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0.attr,
+	&dev_attr_port1.attr,
+	&dev_attr_port2.attr,
+	&dev_attr_port3.attr,
+	&dev_attr_lun_mode.attr,
+	&dev_attr_ioctl_version.attr,
+	&dev_attr_port0_lun_table.attr,
+	&dev_attr_port1_lun_table.attr,
+	&dev_attr_port2_lun_table.attr,
+	&dev_attr_port3_lun_table.attr,
+	&dev_attr_irqpoll_weight.attr,
+	&dev_attr_num_hwqs.attr,
+	&dev_attr_hwq_mode.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(cxlflash_host);
+
 /*
  * Device attributes
  */
 static DEVICE_ATTR_RO(mode);
 
-static struct device_attribute *cxlflash_dev_attrs[] = {
-	&dev_attr_mode,
+static struct attribute *cxlflash_dev_attrs[] = {
+	&dev_attr_mode.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(cxlflash_dev);
+
 /*
  * Host template
  */
@@ -3150,8 +3154,8 @@ static struct scsi_host_template driver_template = {
 	.this_id = -1,
 	.sg_tablesize = 1,	/* No scatter gather support */
 	.max_sectors = CXLFLASH_MAX_SECTORS,
-	.shost_attrs = cxlflash_host_attrs,
-	.sdev_attrs = cxlflash_dev_attrs,
+	.shost_groups = cxlflash_host_groups,
+	.sdev_groups = cxlflash_dev_groups,
 };
 
 /*
