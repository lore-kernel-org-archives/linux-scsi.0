Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3E0C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47DC360E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbhJGUcb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:32:31 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:38441 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbhJGUcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:32:25 -0400
Received: by mail-pf1-f174.google.com with SMTP id k26so6316714pfi.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mmXkXHC7jPXF6ngfzTLgOAlAjuEGtXNZiGanAoOn3tY=;
        b=4/nPbAFuNh5npmtVU9BGIwtnSc3Q6ZOGw8/xJ3JlUcRc8XMNKeqgFNsMS4n0UIvoX8
         8ErDUJf9ilojW47waDNaju+KFeTwcvvHK8pCa+ln9/3w7gtHAjhVg4nMQnI7bDh7V/cF
         Mgd7jGpTLS+LLOhA0g131ntymnYAoVr5H26oRDIqaD36Ct6gbUdaGt2flYC20n47fzXS
         pCSRfrzIJyP3q9ezVKmK8pfM8fbEEJiKTk0YqmRfyntIATX97O0oIbHPYfKHtb7HTIKt
         5jcbf8ASC50Ad2/EAOuxZnnxVaPGZ/K/oGvkAuIGHSgeGtcYxLNfFxhOAWWz9YWsm++8
         ZnwA==
X-Gm-Message-State: AOAM533tlouEDkrz6t4DlSBfgy9NkaZ71R9lOHuMkbLhvJncrzIiuKvo
        CIWus7A7aMYqVrlp+YYXaFM=
X-Google-Smtp-Source: ABdhPJwK4OgEebjuixljToJolTHtNKsSLpSXr62u8Nyc7Av9TpBQLhnge4fJczsgC1sCgUuhoKbgcw==
X-Received: by 2002:a62:b50d:0:b0:44b:b81f:a956 with SMTP id y13-20020a62b50d000000b0044bb81fa956mr5936528pfe.27.1633638630812;
        Thu, 07 Oct 2021 13:30:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:30:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 32/88] fas216: Introduce struct fas216_cmd_priv
Date:   Thu,  7 Oct 2021 13:28:27 -0700
Message-Id: <20211007202923.2174984-33-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
