Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FCAC2D0C0
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70FE124682
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 10:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JHVtR7Uy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfLTKct (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 05:32:49 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36424 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTKct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 05:32:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id x184so4980370pfb.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 02:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wf+0hKmtTTCL5KJ/dtqwS48oYkpw/3jpGakHdRmZMNQ=;
        b=JHVtR7UyYeIAZDiX5vw534U5XqhTEKC6T4KkmppBVi4uPhKqHP7g4Sz/eqicT8L0pD
         q1LjmEDRQvNmJldhhpYRu043hqIiEV3OUJUp0SXPbQTBjylSOMzULxI48O/A/ngP+atd
         sciIwYyFIOkHu0qy3PrRWmQqaod8DLdRa8K48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wf+0hKmtTTCL5KJ/dtqwS48oYkpw/3jpGakHdRmZMNQ=;
        b=WYIQNIrGRs7n/EGSxHPS5xQ36E/HJC76fGfdChaKvN0z3ihMsQiEHhOciDfygGeXzb
         nLLjLZTcghCbQ2aNGXdq4GooYOMNOUxcalzg+92P5sI455UCuIpNaiBawpxHxi8a8PIi
         HAJWsd2j22XUUT1lePSnh1YHd43lK0+xUMUa7UijN0mSZuT6Dhp8DTnbZ3VQbSzwjXeT
         IyOwAoxZxay/4B8XIrvtI4KKKDfAhhUa+zxZCqyqa/318b5MpTAgqL2vHKyl7exwvPNp
         O8r6w8BoXIoW4S7wFVzapmKoUmBAgUQuXJutfkCXkOdnO3eDWslcOpmcykPFiPif6b0p
         SJkQ==
X-Gm-Message-State: APjAAAV0j7DnhpWAq8QcS/hYK29ImaxPZ1HH97z9WIiPeL1VtmP18Oe1
        lBxXALdMrAigp4Oc3xyZcTj/86FuXUilRJiR4JJ5vjZAB1zCP1uvt0YZCjtwHh4d4SLBBz/hLMW
        RLM/5Gf6svZUN6PkZre/8R9NhFscrQjM/BbMWh/THTmKe9cvpLnuaWqjgdkrjA/XByuzdhG9tB5
        w9nhD/OVU9XvgmsxFy/A==
X-Google-Smtp-Source: APXvYqwqoCZsic2OqWGxLFOuFYAOAM/RDp61ISah+lWsFAqKMAtF2DAxnSpT5JE9vEtPcu9TDeZ1zg==
X-Received: by 2002:aa7:951c:: with SMTP id b28mr14804635pfp.97.1576837968033;
        Fri, 20 Dec 2019 02:32:48 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 200sm12185364pfz.121.2019.12.20.02.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:32:47 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 08/10] mpt3sas: Print function name in which cmd timed out
Date:   Fri, 20 Dec 2019 05:32:08 -0500
Message-Id: <20191220103210.43631-9-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Print the function name in which MPT command got
timed out. So that it will be easy to analyze in which
path corresponding MPT command got timeout in first
failure instance of log itself.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
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

