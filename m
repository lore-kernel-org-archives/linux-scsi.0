Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2795C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjCDAcF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCDAbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:31:52 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750AA65441
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:51 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id n6so4541627plf.5
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFxngvs+9YQWf/cm0pKR7KdAZBfNtlH0C+J3zrjYTbg=;
        b=W7uaKwNcIefzMJLPKpaPh4SP2O6KEZPOLz4sX+fX1V2Viq4N0f4kRaydmFi5NE6vtC
         sg8Y6qlB+m110Dyq0L+Lk3LYuq7479aqyoKv4w+th57SB+EtlrJ2Chd5SSWegF74STkP
         z4OKTw2gc1/uhEcvIZJryW2vk+dV824JWRDM9NeK2WXYDOsl0bmyIgUHO2UnjKxFt+e/
         OEQXMjYGqyNjbDBd30lsiKimNtSruyGJs4Ou9syQIjLEiqDe73PKFnLnRSoRooOXK2OO
         5iX4p+sKmo7mdTtpZz86xu866CCEGvEYSWaTO+myirNgn07i77WCR4oQI6jnbTueIBvO
         cnDQ==
X-Gm-Message-State: AO0yUKXt4QXsg2qJUwgYFYPWVazLqaJqqKhWc+I2jC4fhEcZOGNoe0Ki
        8/ECIYph2JK7+TpZqOn+PXw=
X-Google-Smtp-Source: AK7set8O44FwcUFPyZGqL1jZmq6H424U2kZuHktJghuQVorzvyCJ2WeW49V5mo0KLRKdVXlFVEr0ig==
X-Received: by 2002:a17:902:c185:b0:19c:a3be:d9f7 with SMTP id d5-20020a170902c18500b0019ca3bed9f7mr3518012pld.11.1677889910892;
        Fri, 03 Mar 2023 16:31:50 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 07/81] scsi: message: fusion: Declare SCSI host template members const
Date:   Fri,  3 Mar 2023 16:29:49 -0800
Message-Id: <20230304003103.2572793-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host templates are not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptfc.c  | 2 +-
 drivers/message/fusion/mptsas.c | 2 +-
 drivers/message/fusion/mptspi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fac747109209..22e7779a332b 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -105,7 +105,7 @@ static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
 
-static struct scsi_host_template mptfc_driver_template = {
+static const struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptfc",
 	.show_info			= mptscsih_show_info,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 88fe4a860ae5..86f16f3ea478 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1997,7 +1997,7 @@ static enum scsi_timeout_action mptsas_eh_timed_out(struct scsi_cmnd *sc)
 }
 
 
-static struct scsi_host_template mptsas_driver_template = {
+static const struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
 	.show_info			= mptscsih_show_info,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 62089a8caa2f..6c5920db1e9d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -820,7 +820,7 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 	mptscsih_slave_destroy(sdev);
 }
 
-static struct scsi_host_template mptspi_driver_template = {
+static const struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
 	.show_info			= mptscsih_show_info,
