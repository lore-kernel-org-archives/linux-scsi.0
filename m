Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0743C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAEAC60F3A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 23:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhJLXik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:38:40 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:38825 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbhJLXij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 19:38:39 -0400
Received: by mail-pj1-f41.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so3037892pjc.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 16:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdPWTIvQItNpTqfQHoMSC0Y/0kKay1uG25Wzw8miLo0=;
        b=2Fb146xHdtpJQYv/PsZoUkOE5dNwmkGgbNC2acyEqxosrQP5DmQTFltgSxRYqbAxa/
         QjiQHVGKKZ0eQrDMOIzFKmrRBDXSfVC2gVsAet55hYYWjbrD4ixi6hDdn7eCr6UfGIqX
         sh1nlfP9hHFG7ZgppKBqe9/SXIVSsaic8VgjvdXsHynbFesU0wd7ZR8kO1KezsAOQCZ/
         u3+ZC0RXJkF0GOPwPn7yyLb5b0isYRxwMCbmsGzLhBGPMvBGHy1pj9rYA3LajeotNl8G
         QBLYSyEvtMURRBkvD4zvMdmSo6W6KA9FBAZ94SJJEUd6s9GFrHbZYYaZ1ILbB1+lBnLv
         8HYw==
X-Gm-Message-State: AOAM533HDjglFWRNva8NoKG799p2ewzjAsqm6+3G9P95HGitUSiGr1as
        0C6Igqo8smo0t+Jhnbadl9E=
X-Google-Smtp-Source: ABdhPJzNLYfjrnh22eyYyJY6/qm1PdijzR0AtBZwIqSOxl/cPX/FO4aOLVp96+4dsC0nTIiD2aHkGw==
X-Received: by 2002:a17:90a:680c:: with SMTP id p12mr9264261pjj.33.1634081796913;
        Tue, 12 Oct 2021 16:36:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id pi9sm4336676pjb.31.2021.10.12.16.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:36:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 15/46] scsi: bnx2fc: Switch to attribute groups
Date:   Tue, 12 Oct 2021 16:35:27 -0700
Message-Id: <20211012233558.4066756-16-bvanassche@acm.org>
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
