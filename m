Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E26C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6D460ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhJLXjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:39:36 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:33649 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbhJLXjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:39:35 -0400
Received: by mail-pg1-f179.google.com with SMTP id a73so594320pge.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/gRYdV8ppD542yrylViIFRkjZwU5xUz0hfGUfTZhAQ=;
        b=NNpHxJiz1pJcdFZ1vteXUHPVFBs0xnw/+U/Md3XdyyVAgeSXqSpvbLqju4bkSnLTUc
         uTVkLJ5/x3IrUMBT146pdyu8scg6TI6kHN5UubBQJyrZodaxW1UiJdD8BICLyBHrNt41
         BBOCvyAiZLDuzOA3uZ4vdPQQaa+NkhJWdSp1K6rm3UK+P1CgC65OZ8olPXH9LtTdtNHe
         GabCmmYd0I9o3IW0uumP2udAe9wb2JdUEXVJj0w75zUwea56DD59tXc2ztz8wS6QZjq4
         3TTLd2wZBTcjsQc1lnMXmsnowtaGbqOpUiCnjv8owkcFxyuuR2TdZIXL04gVAAgecQAL
         bXTw==
X-Gm-Message-State: AOAM530aObqak3m8Mu14xFokaXg0BxMbHCuD8I1n7RbU2DiCNiEkoArL
        JaAvnDw3/mtVosQLYN8ha4E=
X-Google-Smtp-Source: ABdhPJweao+Qlb1xH9ytbNb6/j5d8qa3FEePLO6XQR1jzd6uDlI39q9r2ERR3AXzOgWi9WZh+4D6Xg==
X-Received: by 2002:a65:64d7:: with SMTP id t23mr24867798pgv.237.1634081852452;
        Tue, 12 Oct 2021 16:37:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:37:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v4 45/46] scsi: usb: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:57 -0700
Message-Id: <20211012233558.4066756-46-bvanassche@acm.org>
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

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/usb/storage/scsiglue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5a971b83e3f..4e5a928f0368 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -588,11 +588,13 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
 }
 static DEVICE_ATTR_RW(max_sectors);
 
-static struct device_attribute *sysfs_device_attr_list[] = {
-	&dev_attr_max_sectors,
+static struct attribute *usb_sdev_attrs[] = {
+	&dev_attr_max_sectors.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(usb_sdev);
+
 /*
  * this defines our host template, with which we'll allocate hosts
  */
@@ -653,7 +655,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	.skip_settle_delay =		1,
 
 	/* sysfs device attributes */
-	.sdev_attrs =			sysfs_device_attr_list,
+	.sdev_groups =			usb_sdev_groups,
 
 	/* module management */
 	.module =			THIS_MODULE
