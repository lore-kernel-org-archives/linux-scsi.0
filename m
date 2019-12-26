Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D4AC2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE292075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ev3/2sq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfLZLN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:13:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45155 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfLZLN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:13:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id j42so23364027wrj.12
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3Y9O4gCLw+kl86CAin/kkdVAfAUbemez3n20VNximog=;
        b=Ev3/2sq4ou8zxJc7WMq+5tu9sSXO7NODnwjfByDz/sEknhrJPasrBckr3sUtoZViog
         YyCZI6iSQtbPnDJLh/IAAx6/N2WJefyAzO9Rt2MoH+UZxemJ+Oi0othUhFOUjx/aj2Za
         +gW5mnmiTMfeHBb3SJdno3o3qrCsRMv9kSYd4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3Y9O4gCLw+kl86CAin/kkdVAfAUbemez3n20VNximog=;
        b=hf/gWVwxBOlJ6iO5MGOSzKcIMQcqCBFwncr56wLhQoiJOsa/f2GPcSIGG2upGYd/mQ
         JaRm245G6iyNl4okrUBFntm4BBNWo54q88FFzo5FqY5/lsk6Ix4LY11B9ajLWgijYjn1
         hNsTRCkL429/pOc7h12S3UmvM8iBpq7zlTePwnfxZ067JzvZQwMFveUa6UE7ohb63Y3B
         rouE9bnSl0PKPGn/+oYiEUfAeeaUzm7SBom4PfzSCs9nuVutrwaRE4F7TomcgONyRYHV
         9pvVn1pAUwhTXiBzg1exjBFYEWrk0Mh5zaUX+QNyRxcCxv0y6sD5WbgL2Up9vp0rzD2f
         cL7A==
X-Gm-Message-State: APjAAAVn63r2yT5r7FqXN2Kj7TNIFTbVRn2TW07TANYOE2gEPkuC32p+
        MmwQLbzh4saT6aCWHkSAFh2SpTYpCDLNlt3DerDN72Ir7vhiuWcAPjshlS6QWW7MEnvOEwo6pnP
        iTEbbOwhCfg9EUfLafu0+BKOHLtfNiBCbgLqnQlK3ThqiiPcoy0WiNg+JxGJDll0iNyiezqqb9c
        KwGJQatFxC
X-Google-Smtp-Source: APXvYqzqrNjPAhn6ue+ROtqOtFZ6qRovwXd1V5Jdi3I9V6mtr/1h1n2TZQzwvpBZzNDMtrNIVXcd1w==
X-Received: by 2002:adf:82f3:: with SMTP id 106mr46069719wrc.69.1577358836064;
        Thu, 26 Dec 2019 03:13:56 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:13:55 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 03/10] mpt3sas: renamed _base_after_reset_handler function
Date:   Thu, 26 Dec 2019 06:13:26 -0500
Message-Id: <20191226111333.26131-4-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
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

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
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

