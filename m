Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D552FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFA2161406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347119AbhI2WI5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:57 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:34683 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbhI2WIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:51 -0400
Received: by mail-pl1-f178.google.com with SMTP id b22so2540400pls.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mmXkXHC7jPXF6ngfzTLgOAlAjuEGtXNZiGanAoOn3tY=;
        b=NI+oaarSlQbWFllYwk4rkZ7DVeJ6dGcYGEANrVeiSrQVM7BEkNPEkT8AsxzlATwNi9
         LaAQMrZoClFTse/0PORhh+cybyazk6c2tXupCSfGKouHA8k2GzN7NHeyMuAsusHjWOUQ
         Vt/lE9WGU/7txfUQaddpgcp8HUweaNuaI6WanzLSUF6uHIQmhYmfnCX+jLiLsS7S/JR1
         FsDiav74smgMfD8cymr1Ow9UOj86mqMoe+8480k/k1oXkHxlObgxIYh/1p9ymzHKBR+b
         AKAdx4JiIvxqmqxE9pFXORNe6IwI9+hLM1/3gsm85PWhT6oHGTxrMPAKHXljtFgz60fZ
         5/Ag==
X-Gm-Message-State: AOAM530LjWw6N4ehHWS4N84RDix6QyPnW463IMvOGYpIfj644HGNA9RM
        x0XWJgp/iJzCNK98HIgX5UEDrPXSxR4=
X-Google-Smtp-Source: ABdhPJwH5iYegu2Et2V94JtLBwmh/ZCmuMDjl3d3ToU8Pg+Ve0knhoXZ0S2RzdQs1LIxoGT+QQ7X8A==
X-Received: by 2002:a17:90a:9306:: with SMTP id p6mr9057248pjo.119.1632953229329;
        Wed, 29 Sep 2021 15:07:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 32/84] fas216: Introduce struct fas216_cmd_priv
Date:   Wed, 29 Sep 2021 15:05:08 -0700
Message-Id: <20210929220600.3509089-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce a structure with driver-private data per SCSI command. This data
structure will be used by the next patch to store a function pointer.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/arxescsi.c |  1 +
 drivers/scsi/arm/cumana_2.c |  1 +
 drivers/scsi/arm/eesox.c    |  1 +
 drivers/scsi/arm/fas216.h   | 10 ++++++++++
 drivers/scsi/arm/powertec.c |  2 +-
 5 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 591414120754..7f667c198f6d 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -243,6 +243,7 @@ static struct scsi_host_template arxescsi_template = {
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
 	.eh_device_reset_handler	= fas216_eh_device_reset,
 	.eh_abort_handler		= fas216_eh_abort,
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
 	.can_queue			= 0,
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 9dcd912267e6..3c00d7773876 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -363,6 +363,7 @@ static struct scsi_host_template cumanascsi2_template = {
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
 	.eh_device_reset_handler	= fas216_eh_device_reset,
 	.eh_abort_handler		= fas216_eh_abort,
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
 	.can_queue			= 1,
 	.this_id			= 7,
 	.sg_tablesize			= SG_MAX_SEGMENTS,
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 5eb2415dda9d..1394590eecea 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -480,6 +480,7 @@ static struct scsi_host_template eesox_template = {
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
 	.eh_device_reset_handler	= fas216_eh_device_reset,
 	.eh_abort_handler		= fas216_eh_abort,
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
 	.can_queue			= 1,
 	.this_id			= 7,
 	.sg_tablesize			= SG_MAX_SEGMENTS,
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 847413ce14cf..abf960487314 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -310,6 +310,16 @@ typedef struct {
 	unsigned long		magic_end;
 } FAS216_Info;
 
+/* driver-private data per SCSI command. */
+struct fas216_cmd_priv {
+	void (*scsi_done)(struct scsi_cmnd *cmd);
+};
+
+static inline struct fas216_cmd_priv *fas216_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 /* Function: int fas216_init (struct Scsi_Host *instance)
  * Purpose : initialise FAS/NCR/AMD SCSI structures.
  * Params  : instance - a driver-specific filled-out structure
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 9cc73da4e876..8fec435cee18 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -286,7 +286,7 @@ static struct scsi_host_template powertecscsi_template = {
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
 	.eh_device_reset_handler	= fas216_eh_device_reset,
 	.eh_abort_handler		= fas216_eh_abort,
-
+	.cmd_size			= sizeof(struct fas216_cmd_priv),
 	.can_queue			= 8,
 	.this_id			= 7,
 	.sg_tablesize			= SG_MAX_SEGMENTS,
