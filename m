Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736D4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C222610E5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbhJHU0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:08 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:35518 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhJHU0G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:06 -0400
Received: by mail-pg1-f170.google.com with SMTP id e7so4177714pgk.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTNedSEFjqtd+pJzmAKavcMIBaVjV9fuMU4exKPIasc=;
        b=gN4I/GQ/Yw5ZoJpLjRY6dWFNP6Xs8v/k2Yjabrzmm81RcKLzHyxMy6JTFfDqnhgPZv
         Gqo2TOh0BDfTulpEqvL1zqklqGBQZ3PoeaJy7ndafJGbGnBBZfidLjRy84y2Gsb19/bY
         RVtR3CONhCcNbxj+cjWmBfxpokPKKC5+nyZqujwry5+eIzuoDqWG7dTGLq7tce60YD9x
         9s/VuyVZ/J/STiug0BTBuZObQaEYV3MQag0RXsGh3CAT70etZKiIyeE71Zdn9YojpTme
         lEm+AXR8f+sg63o1VpKPkH9tJaqPgOQr0dJHIzF0UKCoWlJXvhJSuRRQSNM2o/aD0LQl
         ZCJA==
X-Gm-Message-State: AOAM533f9BBehV0Rs9yCl91fdA86m8o9OWB1zM4yTrbvoXsb9CImOGVT
        uj8CgpjyocxDnsuobkm7STw=
X-Google-Smtp-Source: ABdhPJw/HBS2B3jakbuOmGNgvRTI4WXjCQoqOu0LsIPXIiafYaZXRTKm4NPc321NcRFOrhwdSjOCuA==
X-Received: by 2002:a63:b04c:: with SMTP id z12mr6252804pgo.371.1633724650527;
        Fri, 08 Oct 2021 13:24:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 07/46] scsi: 3w-9xxx: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:14 -0700
Message-Id: <20211008202353.1448570-8-bvanassche@acm.org>
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
