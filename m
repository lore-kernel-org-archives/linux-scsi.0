Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49739C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F9A610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 20:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbhJHU0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:26:13 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:41872 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242416AbhJHU0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 16:26:09 -0400
Received: by mail-pf1-f171.google.com with SMTP id p1so9099187pfh.8
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 13:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSy9HxHylqv2QQOMeguWwGRixQQsbcPSN7ac2lLyVBI=;
        b=MxbfGKW9LZadR2FNXcFPk/ro7GkqK2bbhjrwS0wtk36wtOtwB0+fitqDM+9fsAVsIV
         lk1t5v0mqx481XTgGSkZ9IKbEFQtcaXFoSze2HBl6TC7heWMxe5IV6PCIsb2gKohdHP2
         rGCdSpD2Voe+ZBJGhPsA4FewwK0TaHWJP80fEsSyKnEf0r+6JkPunTKbz1pQDguRAwIC
         wvxQDFXppar8M9+hUbGwaMz5jvf/hNOqcMZRWY1IkFnSv4df20qiv7Fm+Yjkfw9XrzPy
         dDYIL2/DlvcRutIRyGGdRmkESCKGowp1tbzurmdy6lFWrUTcWSr2Ffcoty6sZkcAQIXi
         4nLA==
X-Gm-Message-State: AOAM531XTI5YI0ash36IcxmMQ6zZXpMJCluX+konqe5lE+rGc5j85tym
        Ne9WSwkyLwTA+S4lfiRFiK4=
X-Google-Smtp-Source: ABdhPJwemukT8rNfwgcjAid6+aQghtzxa5Dt7Q5pAjxmQ0Z+/QEby/UTBe2GKCwrwu0UOjwe5G3alw==
X-Received: by 2002:a63:3301:: with SMTP id z1mr6436264pgz.120.1633724653219;
        Fri, 08 Oct 2021 13:24:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a8e9:7950:57f8:970])
        by smtp.gmail.com with ESMTPSA id x21sm170858pfa.186.2021.10.08.13.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 13:24:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 09/46] scsi: 3w-xxxx: Switch to attribute groups
Date:   Fri,  8 Oct 2021 13:23:16 -0700
Message-Id: <20211008202353.1448570-10-bvanassche@acm.org>
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
 drivers/scsi/3w-xxxx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 4ee485ab2714..db4e5449d516 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -532,11 +532,13 @@ static struct device_attribute tw_host_stats_attr = {
 };
 
 /* Host attributes initializer */
-static struct device_attribute *tw_host_attrs[] = {
-	&tw_host_stats_attr,
+static struct attribute *tw_host_attrs[] = {
+	&tw_host_stats_attr.attr,
 	NULL,
 };
 
+ATTRIBUTE_GROUPS(tw_host);
+
 /* This function will read the aen queue from the isr */
 static int tw_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
 {
@@ -2242,7 +2244,7 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
-	.shost_attrs		= tw_host_attrs,
+	.shost_groups		= tw_host_groups,
 	.emulated		= 1,
 	.no_write_same		= 1,
 };
