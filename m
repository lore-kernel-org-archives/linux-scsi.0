Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37389C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C9C61073
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242443AbhJHU0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:32 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36756 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242508AbhJHU03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:29 -0400
Received: by mail-pg1-f177.google.com with SMTP id 75so4165780pga.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdPWTIvQItNpTqfQHoMSC0Y/0kKay1uG25Wzw8miLo0=;
        b=a4vKR7Izhv97QvKwekrH6jKUxto7DbPIR8YSpBc1c6A+3GKEkvhQvPQbvZsT8LV4om
         1v/SksoOtgRTx2UCEgG3TDSCQZSHE72KOhS+3xgu4N9wATy0xmADPaCQpVGswquEJCwf
         TZP++eelDijkihfdxiilEqFyK80MDy2MlzhaUD7qqWd8yej/E/pFkpdQcZ9d8oYWzwsc
         48aIZG9235LkISmw8xPQCQPXiyYBy/Spy12jiHAt3JLicS75m5nodJZv/YNBnDkUT982
         8K9WOLKLkl/NoBTUTR48rCV8OcUb5Dd48Sz+xPCw+qKbyzIwcxFMVt7O45Sdv3fpe46U
         KdxA==
X-Gm-Message-State: AOAM5338SFOXWUxuoMl3T1XeamYo/TNvxtktcHa16+/3ESe8j+3Ql9FF
        5vIgvXQkzMogV7csiaZfTGA=
X-Google-Smtp-Source: ABdhPJwFJJUoiRgsFW3D9tNHF0x1IE18/pxcrCxKNdpNjLHGNTpyvvswuaSujRFrzAeWnYyaPvBG+A==
X-Received: by 2002:a05:6a00:26f7:b0:44c:7695:bfba with SMTP id p55-20020a056a0026f700b0044c7695bfbamr11965875pfw.12.1633724673917;
        Fri, 08 Oct 2021 13:24:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 15/46] scsi: bnx2fc: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:22 -0700
Message-Id: <20211008202353.1448570-16-bvanassche@acm.org>
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
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 8863a74e6c57..71fa62bd3083 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2951,11 +2951,13 @@ bnx2fc_tm_timeout_store(struct device *dev,
 static DEVICE_ATTR(tm_timeout, S_IRUGO|S_IWUSR, bnx2fc_tm_timeout_show,
 	bnx2fc_tm_timeout_store);
 
-static struct device_attribute *bnx2fc_host_attrs[] = {
-	&dev_attr_tm_timeout,
+static struct attribute *bnx2fc_host_attrs[] = {
+	&dev_attr_tm_timeout.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(bnx2fc_host);
+
 /*
  * scsi_host_template structure used while registering with SCSI-ml
  */
@@ -2977,7 +2979,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.max_sectors		= 0x3fbf,
 	.track_queue_depth	= 1,
 	.slave_configure	= bnx2fc_slave_configure,
-	.shost_attrs		= bnx2fc_host_attrs,
+	.shost_groups		= bnx2fc_host_groups,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
