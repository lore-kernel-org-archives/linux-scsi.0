Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1DCC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DEC60F92
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhJLXix (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:53 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:43779 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhJLXiw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:52 -0400
Received: by mail-pj1-f53.google.com with SMTP id k23-20020a17090a591700b001976d2db364so862933pji.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SVOj+z+fC+OkziZLouFRzUSU9wn71Bv1br5KDIOkAMU=;
        b=c2j80SyBS5laptV6Tu0BtuOZ6Tz2/oGWEggV0sELjW+o7on8oTOPoYA7XPzzFi5WiX
         7fefaL4hjl06WRQc+6NqZ5bB2B7PioepQRQLV4JVJwrrZmHGjmZdKPMUAJiltF91Y3vf
         DtzDJTfsgLjf8sZ8DHS+RrjBbFPhgxwsNHIqPO86ZcYZLVzjuRQjM5lKRe1dqA4sT/Z6
         yO2I1E0sDiaFf+6H1uLZ/Ry7hc5Q2QZxq4xIAN2Ui5GBcNLdhzoOWaC0iz8309GaJYl5
         iP7lWbzVm8+OdktF/dnJupKeU1YCS3/hD0FD0MQ6GaSqxJ+/5ziLDGCOFHUsyUWWLLMZ
         Eqtw==
X-Gm-Message-State: AOAM5306tW4xgCxJ47E7U4421Fvc3ImIverpPEFZ+wTy7Y9Frwigsu7G
        2uxKetnkn1x610uyxc+ceQo=
X-Google-Smtp-Source: ABdhPJwQzs4OBa81jqzsZXMogq8HHtA/5dtonjJcBkSEA5KyZwPgqLqhXyZJqD4G0GlglgDL6fBmsw==
X-Received: by 2002:a17:902:bb95:b0:13e:6924:30e5 with SMTP id m21-20020a170902bb9500b0013e692430e5mr33144064pls.20.1634081809697;
        Tue, 12 Oct 2021 16:36:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 22/46] scsi: hptiop: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:34 -0700
Message-Id: <20211012233558.4066756-23-bvanassche@acm.org>
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
 drivers/scsi/hptiop.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 61cda7b7624f..7250c1d7fffb 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1150,12 +1150,14 @@ static struct device_attribute hptiop_attr_fw_version = {
 	.show = hptiop_show_fw_version,
 };
 
-static struct device_attribute *hptiop_attrs[] = {
-	&hptiop_attr_version,
-	&hptiop_attr_fw_version,
+static struct attribute *hptiop_host_attrs[] = {
+	&hptiop_attr_version.attr,
+	&hptiop_attr_fw_version.attr,
 	NULL
 };
 
+ATTRIBUTE_GROUPS(hptiop_host);
+
 static int hptiop_slave_config(struct scsi_device *sdev)
 {
 	if (sdev->type == TYPE_TAPE)
@@ -1172,7 +1174,7 @@ static struct scsi_host_template driver_template = {
 	.info                       = hptiop_info,
 	.emulated                   = 0,
 	.proc_name                  = driver_name,
-	.shost_attrs                = hptiop_attrs,
+	.shost_groups		    = hptiop_host_groups,
 	.slave_configure            = hptiop_slave_config,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
