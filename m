Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF24EC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9738824679
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RSAvAD4A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfLTKcd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:33 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44604 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:33 -0500
Received: by mail-pf1-f193.google.com with SMTP id 195so4097358pfw.11
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZsRJ8f9W+k5Iq21ZS7NeLCiobZ4hrTpCp3bOqIziCwo=;
        b=RSAvAD4A/F0rJJcIbmx01athkij0iC8MFY/Wov8jEEyg8oFqalU6Lvxw2mrvXNmd2O
         hZhGcD45ymuNGAvkGuqrAcZLo0OpYgLv5ndFkYzVwSW3VmTGvQ4Dah3iQDm2iBFLb+i7
         65/IehRYmVvUt9/VXLOvHh4+dlIasHjN798yM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZsRJ8f9W+k5Iq21ZS7NeLCiobZ4hrTpCp3bOqIziCwo=;
        b=d2a3mmjnkCSflk7Bg7G3QxANL3exAf5abvj6tftnt4tg6G1N3g1H6wHE86p9uDjZUv
         4DYjF0h+3bGYtyHS3KdMliG2mWmxEAfoBLFWH83kazXCRBdwKoCGpTSQwF+MHMRxBzSs
         /I8WM4s5TDIcrziWqSrsie90DyYzXgj+iNSKVZR9PW51yFmAR+CJlEaVtl5nYk3A6W6c
         Cy6bEQrc9AnnlGLgGeY4t9lj7ukMc9WYXwz3EdBwqsxMI49WmAKFQlyflZgC0d5O+rYL
         WtUxO3mQ4aKon+kCiAsvFEAGAsTB1RUj6M+LT0RZeW/YFoaZLtNKhap6mlnks5r1YXUR
         hqqg==
X-Gm-Message-State: APjAAAUinQaAIFSlLFJ8hk6HyAyg7MtMb0zP6cB/ycDsVw9fr2VUS7G1
        nn9Aa12LA+5T+tYd6pfE8ppi8CWmouAoR4bH+YHrkDtitaynVKCJvBfjsXrROxPaT6o0LQ6sMu8
        IHJSCtAIf+aK+jXjnRrXfF2VxCA2qfc+DlC5bCDvJ6JuX4IfxTlPRNXTcByQSl56nLE13D8pxQU
        4L+YvwfKU8kCGOoFVgEQ==
X-Google-Smtp-Source: APXvYqy0YsItIH/er8UCrYochQ+udNwlqtnD+4beR04AZ4sCh7ceUtCgZnAVt0WQn88hSzt/iO9Dow==
X-Received: by 2002:a63:c250:: with SMTP id l16mr13713125pgg.38.1576837951867;
        Fri, 20 Dec 2019 02:32:31 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:31 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 03/10] mpt3sas: renamed _base_after_reset_handler function
Date:   Fri, 20 Dec 2019 05:32:03 -0500
Message-Id: <20191220103210.43631-4-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Renamed _base_after_reset_handler function to
_base_clear_outstanding_commands, so that it can
be used in multiple scenarios with suitable name
which matches with the operation it does.

Also renamed it's child functions.

There is no functional changes. This patch just renames
the functions.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 23 +++++++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  5 +++--
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  7 ++++---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  8 +++++---
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 848fbec..589b41d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7277,14 +7277,14 @@ static void _base_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_after_reset_handler - after reset handler
+ * _base_clear_outstanding_mpt_commands - clears outstanding mpt commands
  * @ioc: per adapter object
  */
-static void _base_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
+static void
+_base_clear_outstanding_mpt_commands(struct MPT3SAS_ADAPTER *ioc)
 {
-	mpt3sas_scsih_after_reset_handler(ioc);
-	mpt3sas_ctl_after_reset_handler(ioc);
-	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_AFTER_RESET\n", __func__));
+	dtmprintk(ioc,
+	    ioc_info(ioc, "%s: clear outstanding mpt cmds\n", __func__));
 	if (ioc->transport_cmds.status & MPT3_CMD_PENDING) {
 		ioc->transport_cmds.status |= MPT3_CMD_RESET;
 		mpt3sas_base_free_smid(ioc, ioc->transport_cmds.smid);
@@ -7317,6 +7317,17 @@ static void _base_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/**
+ * _base_clear_outstanding_commands - clear all outstanding commands
+ * @ioc: per adapter object
+ */
+static void _base_clear_outstanding_commands(struct MPT3SAS_ADAPTER *ioc)
+{
+	mpt3sas_scsih_clear_outstanding_scsi_tm_commands(ioc);
+	mpt3sas_ctl_clear_outstanding_ioctls(ioc);
+	_base_clear_outstanding_mpt_commands(ioc);
+}
+
 /**
  * _base_reset_done_handler - reset done handler
  * @ioc: per adapter object
@@ -7484,7 +7495,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	r = _base_make_ioc_ready(ioc, type);
 	if (r)
 		goto out;
-	_base_after_reset_handler(ioc);
+	_base_clear_outstanding_commands(ioc);
 
 	/* If this hard reset is called while port enable is active, then
 	 * there is no reason to call make_ioc_operational
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a4f308f..70f3a76 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1567,7 +1567,8 @@ struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
 u8 mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 	u32 reply);
 void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc);
-void mpt3sas_scsih_after_reset_handler(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_scsih_clear_outstanding_scsi_tm_commands(
+	struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_scsih_reset_done_handler(struct MPT3SAS_ADAPTER *ioc);
 
 int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
@@ -1701,7 +1702,7 @@ void mpt3sas_ctl_exit(ushort hbas_to_enumerate);
 u8 mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 	u32 reply);
 void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc);
-void mpt3sas_ctl_after_reset_handler(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_ctl_clear_outstanding_ioctls(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_ctl_reset_done_handler(struct MPT3SAS_ADAPTER *ioc);
 u8 mpt3sas_ctl_event_callback(struct MPT3SAS_ADAPTER *ioc,
 	u8 msix_index, u32 reply);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 6874cf0..4e726ef 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -478,14 +478,15 @@ void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt3sas_ctl_reset_handler - reset callback handler (for ctl)
+ * mpt3sas_ctl_reset_handler - clears outstanding ioctl cmd.
  * @ioc: per adapter object
  *
  * The handler for doing any required cleanup or initialization.
  */
-void mpt3sas_ctl_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
+void mpt3sas_ctl_clear_outstanding_ioctls(struct MPT3SAS_ADAPTER *ioc)
 {
-	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_AFTER_RESET\n", __func__));
+	dtmprintk(ioc,
+	    ioc_info(ioc, "%s: clear outstanding ioctl cmd\n", __func__));
 	if (ioc->ctl_cmds.status & MPT3_CMD_PENDING) {
 		ioc->ctl_cmds.status |= MPT3_CMD_RESET;
 		mpt3sas_base_free_smid(ioc, ioc->ctl_cmds.smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c451e57..785835a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9334,15 +9334,17 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * mpt3sas_scsih_after_reset_handler - reset callback handler (for scsih)
+ * mpt3sas_scsih_clear_outstanding_scsi_tm_commands - clears outstanding
+ *							scsi & tm cmds.
  * @ioc: per adapter object
  *
  * The handler for doing any required cleanup or initialization.
  */
 void
-mpt3sas_scsih_after_reset_handler(struct MPT3SAS_ADAPTER *ioc)
+mpt3sas_scsih_clear_outstanding_scsi_tm_commands(struct MPT3SAS_ADAPTER *ioc)
 {
-	dtmprintk(ioc, ioc_info(ioc, "%s: MPT3_IOC_AFTER_RESET\n", __func__));
+	dtmprintk(ioc,
+	    ioc_info(ioc, "%s: clear outstanding scsi & tm cmds\n", __func__));
 	if (ioc->scsih_cmds.status & MPT3_CMD_PENDING) {
 		ioc->scsih_cmds.status |= MPT3_CMD_RESET;
 		mpt3sas_base_free_smid(ioc, ioc->scsih_cmds.smid);
-- 
2.18.1

