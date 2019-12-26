Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC84DC2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7940B20838
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="c3mTvOvD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfLZLOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:14:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39429 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:14:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id 20so5825297wmj.4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cvD+oCgv59nRSn58CRf0F08rB1XjT1Y0Wk8kZP93ymw=;
        b=c3mTvOvDjBhTHNwawGCGdQN6I2/fhfjQnP/wxWucI1nbNAMGjghBWbjq6WautxD/eu
         g7fdjCXoFEhjZAG6b9B8muOkt16ACwnb3+Cw4FOC51rWf4YMUxYb2rlrkW0tUeGTk3Cj
         gWLhVqCFwIGAzDyvRb3GAiOBhk4c8JYgjrS4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cvD+oCgv59nRSn58CRf0F08rB1XjT1Y0Wk8kZP93ymw=;
        b=pXI51oqz6HjaGS4DMoL1dFrgdqsUlwDotGWEy4y6gdDkgIjlV7+PZI9UA0dLIjAOpv
         0s632NXHT+QW7FsiAE0q/yqkr7ToVYW6L+JpH8VAKA3MxMwQoJBR2rvwDpO5p4UGEKkv
         +kxMmN+oLsu/iPAqzihlbvV3EOEwQteSVn2/593iJ4UfXwm3FVXSiXIcamsBtcFkIJsE
         HHmRTdwGvdZUO1XMWtVgYl3qkrlyw39g6DVQYSoPU8TL7IWz30s0qB1NPe2dBMrGQZEa
         AnNDJcgPyHpQvUhmrLa4zOcX8Uk4CCp3VPbI/EZx/aZiANzKM4hynfc6M+U197mp4hUK
         GgGw==
X-Gm-Message-State: APjAAAUXYhj6oOCNjh+Q7izwcVihS2HYYbZRgdywSwHlbBC0qDkxUSPJ
        S44fOxHlHxeiW0AdMWQOIfZwLY+89crklXMXzx2NI1RmeSswVu9WzFPFJpaeLVmIeLnyGnprd2f
        chD7g63ijfLcbhUggFS3TTwx7fSHlRI+wVD63njyjAg92iz/5M9nvAD/vU0vuJt+h+LFe2mkLWI
        +RnAD55giz
X-Google-Smtp-Source: APXvYqxkSLEof7jatnOtUYfm4OM+QBWLjz1+YubREgdxPCejBS57uwsVqMGFBRRuvWGjYFLec3If3A==
X-Received: by 2002:a1c:b7c4:: with SMTP id h187mr13735160wmf.105.1577358852052;
        Thu, 26 Dec 2019 03:14:12 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:14:11 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 08/10] mpt3sas: Print function name in which cmd timed out
Date:   Thu, 26 Dec 2019 06:13:31 -0500
Message-Id: <20191226111333.26131-9-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
References: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Print the function name in which MPT command got
timed out. So that it will be easy to analyze in which
path corresponding MPT command got timeout in first
failure instance of log itself.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c   | 14 ++++++-------
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  5 +++++
 drivers/scsi/mpt3sas/mpt3sas_config.c |  7 ++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 30 +++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 15 +++++++-------
 5 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3b6e13d..aa43c66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5984,10 +5984,9 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	    ioc->ioc_link_reset_in_progress)
 		ioc->ioc_link_reset_in_progress = 0;
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
-		issue_reset =
-			mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->base_cmds.status, mpi_request,
-				sizeof(Mpi2SasIoUnitControlRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc, ioc->base_cmds.status,
+		    mpi_request, sizeof(Mpi2SasIoUnitControlRequest_t)/4,
+		    issue_reset);
 		goto issue_host_reset;
 	}
 	if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID)
@@ -6060,10 +6059,9 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
-		issue_reset =
-			mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->base_cmds.status, mpi_request,
-				sizeof(Mpi2SepRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->base_cmds.status, mpi_request,
+		    sizeof(Mpi2SepRequest_t)/4, issue_reset);
 		goto issue_host_reset;
 	}
 	if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 9a097c0..6ab726b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1579,6 +1579,11 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc);
 
 u8 mpt3sas_base_check_cmd_timeout(struct MPT3SAS_ADAPTER *ioc,
 	u8 status, void *mpi_request, int sz);
+#define mpt3sas_check_cmd_timeout(ioc, status, mpi_request, sz, issue_reset) \
+do {	ioc_err(ioc, "In func: %s\n", __func__); \
+	issue_reset = mpt3sas_base_check_cmd_timeout(ioc, \
+	status, mpi_request, sz); } while (0)
+
 int mpt3sas_wait_for_ioc(struct MPT3SAS_ADAPTER *ioc, int wait_count);
 
 /* scsih shared API */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 9912ea4..62ddf53 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -303,6 +303,7 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	u8 retry_count, issue_host_reset = 0;
 	struct config_request mem;
 	u32 ioc_status = UINT_MAX;
+	u8 issue_reset = 0;
 
 	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT3_CMD_NOT_USED) {
@@ -385,9 +386,9 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
 			_config_display_some_debug(ioc,
 			    smid, "config_request", NULL);
-		mpt3sas_base_check_cmd_timeout(ioc,
-			ioc->config_cmds.status, mpi_request,
-			sizeof(Mpi2ConfigRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->config_cmds.status, mpi_request,
+		    sizeof(Mpi2ConfigRequest_t)/4, issue_reset);
 		retry_count++;
 		if (ioc->config_cmds.smid == smid)
 			mpt3sas_base_free_smid(ioc, smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 7a9df9c..62e5528 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1028,10 +1028,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		ioc->ignore_loginfos = 0;
 	}
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
-		issue_reset =
-			mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->ctl_cmds.status, mpi_request,
-				karg.data_sge_offset);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->ctl_cmds.status, mpi_request,
+		    karg.data_sge_offset, issue_reset);
 		goto issue_host_reset;
 	}
 
@@ -1741,10 +1740,9 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
-		issue_reset =
-			mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->ctl_cmds.status, mpi_request,
-				sizeof(Mpi2DiagBufferPostRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->ctl_cmds.status, mpi_request,
+		    sizeof(Mpi2DiagBufferPostRequest_t)/4, issue_reset);
 		goto issue_host_reset;
 	}
 
@@ -2116,6 +2114,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	u16 ioc_status;
 	u32 ioc_state;
 	int rc;
+	u8 reset_needed = 0;
 
 	dctlprintk(ioc, ioc_info(ioc, "%s\n",
 				 __func__));
@@ -2123,6 +2122,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	rc = 0;
 	*issue_reset = 0;
 
+
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
 	if (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
 		if (ioc->diag_buffer_status[buffer_type] &
@@ -2165,9 +2165,10 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
-		*issue_reset = mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->ctl_cmds.status, mpi_request,
-				sizeof(Mpi2DiagReleaseRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->ctl_cmds.status, mpi_request,
+		    sizeof(Mpi2DiagReleaseRequest_t)/4, reset_needed);
+		 *issue_reset = reset_needed;
 		rc = -EFAULT;
 		goto out;
 	}
@@ -2425,10 +2426,9 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	    MPT3_IOCTL_DEFAULT_TIMEOUT*HZ);
 
 	if (!(ioc->ctl_cmds.status & MPT3_CMD_COMPLETE)) {
-		issue_reset =
-			mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->ctl_cmds.status, mpi_request,
-				sizeof(Mpi2DiagBufferPostRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->ctl_cmds.status, mpi_request,
+		    sizeof(Mpi2DiagBufferPostRequest_t)/4, issue_reset);
 		goto issue_host_reset;
 	}
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 68f40e3..b33fff8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2730,6 +2730,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 	u16 smid = 0;
 	u32 ioc_state;
 	int rc;
+	u8 issue_reset = 0;
 
 	lockdep_assert_held(&ioc->tm_cmds.mutex);
 
@@ -2789,9 +2790,10 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, u64 lun,
 	ioc->put_smid_hi_priority(ioc, smid, msix_task);
 	wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
-		if (mpt3sas_base_check_cmd_timeout(ioc,
-			ioc->tm_cmds.status, mpi_request,
-			sizeof(Mpi2SCSITaskManagementRequest_t)/4)) {
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->tm_cmds.status, mpi_request,
+		    sizeof(Mpi2SCSITaskManagementRequest_t)/4, issue_reset);
+		if (issue_reset) {
 			rc = mpt3sas_base_hard_reset_handler(ioc,
 					FORCE_BIG_HAMMER);
 			rc = (!rc) ? SUCCESS : FAILED;
@@ -7759,10 +7761,9 @@ _scsih_ir_fastpath(struct MPT3SAS_ADAPTER *ioc, u16 handle, u8 phys_disk_num)
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
 
 	if (!(ioc->scsih_cmds.status & MPT3_CMD_COMPLETE)) {
-		issue_reset =
-			mpt3sas_base_check_cmd_timeout(ioc,
-				ioc->scsih_cmds.status, mpi_request,
-				sizeof(Mpi2RaidActionRequest_t)/4);
+		mpt3sas_check_cmd_timeout(ioc,
+		    ioc->scsih_cmds.status, mpi_request,
+		    sizeof(Mpi2RaidActionRequest_t)/4, issue_reset);
 		rc = -EFAULT;
 		goto out;
 	}
-- 
2.18.1

