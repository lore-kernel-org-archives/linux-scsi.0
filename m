Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F8CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF6160ED4
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhJLXiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:22 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43687 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhJLXiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:19 -0400
Received: by mail-pg1-f173.google.com with SMTP id r2so532240pgl.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTNedSEFjqtd+pJzmAKavcMIBaVjV9fuMU4exKPIasc=;
        b=hDGg9LMGE4TRBUBVkzCKijW5ytAgFV4cLMM1oTdruqyr6R480FuttXrA0DINsgnFN3
         6AAJyEb5TkLAom3FpyCgdsxVVGhl+Z4+/2dngloq7A5dOP8QkqKZdxexN2BkQUA4Ig3b
         TLGwpA5BysCcL6WpnGkPh9BzG/nXdKzufStNsOcJqHB+dtnQwrmoxKgysFONyazQPffW
         NS4a2pbAkDRAZnrJDaU27E4OB8ihYCjt0e1qt1HYhgzthDIfT87henwSaGF6wb0TeEbi
         RiNbSMgWvPa77wOkTsTWGxDP5597OVTPWDCr8rc041h6LYBbV86gtB1+6284iwoMjwzY
         xlfw==
X-Gm-Message-State: AOAM530xGApTlIq6dvQK5ACSRnfVudWVQ7oWo1irwzEuk3nmclQbMCN3
        aMPvQ69dO9IzCGN9W9d+UVA=
X-Google-Smtp-Source: ABdhPJxk6tgC+Bokf1Hz/mZDm51s9sbvwoMkaWh6q9P4oCJZSyLub9QlUUDgUk+chuB6k/++Js3Raw==
X-Received: by 2002:a62:7b87:0:b0:44d:3e28:a2ac with SMTP id w129-20020a627b87000000b0044d3e28a2acmr5406430pfc.67.1634081776940;
        Tue, 12 Oct 2021 16:36:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 07/46] scsi: 3w-9xxx: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:19 -0700
Message-Id: <20211012233558.4066756-8-bvanassche@acm.org>
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
 drivers/scsi/3w-9xxx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e41cc354cc8a..a2a42f29bc06 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -197,11 +197,13 @@ static struct device_attribute twa_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *twa_host_attrs[] = {
-	&twa_host_stats_attr,
+static struct attribute *twa_host_attrs[] = {
+	&twa_host_stats_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(twa_host);
+
 /* File operations struct for character device */
 static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
@@ -1990,7 +1992,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_APACHE_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= twa_host_attrs,
+	.shost_groups		= twa_host_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
