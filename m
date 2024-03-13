Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9C38DDA
	for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2024 10:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710324641; cv=none; b=OWuXEGcHimHXV+/I3w5w8GqeAnYGgLnAOvjbegPSxet9COqJ6bzhUs1Km5DJplVp99eK+wCOFJoYtISCq5Fa8pBeRctRuTZrr3k0gi1dr1Agh0H+OoHw9ZftgwY3CVJepdAvC8vRnDDSpCFwp8GMSDkYQuShTcDfRPn1rxI5PDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710324641; c=relaxed/simple;
	bh=3vSbQHeuOTke+XGsLCMXq//JZatseVKnTr2eUY2H2zE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F1mXQCaXsoTi2JSwrkIu/o5RoTNNs+fut0jLZMxJ2ze6um/c6Nbk78yUBcB6QC7AT9lNNggnPEKl6O+LRoKkMpIQPij+2n5ryp7AihzPj1xM95kqQvOb2aZco0X414PcI5FV6EumyiV89OnJyRuWvUfCk1a41e16rTM34JVeRI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=EQpCK9JF; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EQpCK9JF"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e6ac741ff7so1209051b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Mar 2024 03:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1710324638; x=1710929438; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=wSXJ1AVHK7hlHS78VsfBkKCEa9VZ8J9Ksa9DuPSZqpw=;
        b=EQpCK9JFKHsN1fsltvBgQOctyWtSrRtvM80vK+07hgs0X8ABcvJWj4nAmuPgJTgnJP
         q8tql9Nm43cfRwvOFwLszD2uA65BDsKCfu89xB34sNdDb1pHD4ke+jzmcxuuODT5qoON
         BirKYgz4ZqVi1XcrG6NnLpoh6RVny6VmLsubE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710324638; x=1710929438;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wSXJ1AVHK7hlHS78VsfBkKCEa9VZ8J9Ksa9DuPSZqpw=;
        b=sru/v1ZhmHUEsSUQAa03zsqs3Bg3N/5eP1TFlPp8+q0pVjxQk53eNjmljLH9m+hBPO
         XddSIaybvc7mF4qkjz7XvnWMFWhckH/SOaLSNJ5I0kcXVDJJl16iTiEE6H3Wgz7BWWep
         /wU8lRMiPqCOqRQFPb8yiclvpTAQ+WfQr//rCieenVVJ2wmJcrOQUCj2wve4jOT136yx
         kBC/k/YP8oqkYwTqk4TmLHP4lCRV9NZ1/MshQU84sH2UMirnq31vOrVbTAaCJ8MqDDWL
         ttPV0Fov2pSDJXpAF7JluGj59ITdeh58ezGS6ldyrCVGj1mYUheTAkwPw2/ZEp8lyFH0
         X4ww==
X-Gm-Message-State: AOJu0Yyuo6iZ+b6p+WDqyz28jYAfN2C5OL7zswn5fjzNaEYoS1gfyhoi
	NC1rTX7u33frLz7RIkiaBMi7se6uEZUWt0KAPNaKuaa2ieh85nj80l2rpqpIa0vvX4V8/zgyEhs
	/Ae2jMvZB2DTLmlZW8hQQwE1qOdOBx+9GF5OQGZMe3khL1kb4/bVo7kfMvmbPAs8yldt3YKze8s
	FFgl0r2b6gr3UGaiTY+k8LXvywR4Yf2jX36RT5JBu9/kwnpA==
X-Google-Smtp-Source: AGHT+IH9xXKlX3+ymxKFkLKAMsIcerkK/E3RR2Wow/Swm+9EZyxT8fKNeHPsX1PFdYG8aweVYHwIxw==
X-Received: by 2002:a05:6a00:3d0b:b0:6e6:4946:985f with SMTP id lo11-20020a056a003d0b00b006e64946985fmr1922906pfb.11.1710324638214;
        Wed, 13 Mar 2024 03:10:38 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j18-20020a056a00175200b006e5af565b1dsm7570337pfc.201.2024.03.13.03.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 03:10:37 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v4 5/7] mpi3mr: Debug ability improvements
Date: Wed, 13 Mar 2024 15:37:44 +0530
Message-Id: <20240313100746.128951-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240313100746.128951-1-ranjan.kumar@broadcom.com>
References: <20240313100746.128951-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000008d600a061387fccf"

--0000000000008d600a061387fccf
Content-Transfer-Encoding: 8bit

Driver updated to include OS type in fault/reset reason code.
MPI request sent through IOCTL now automatically dumped on timeout.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403081903.q3Dq54zZ-lkp@intel.com/
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h     | 10 +++++++---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 21 ++++++++++++++-------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 21 ++++++++++++++-------
 3 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 06359915a48d..dca8390c33ec 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -63,7 +63,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_DRIVER_AUTHOR	"Broadcom Inc. <mpi3mr-linuxdrv.pdl@broadcom.com>"
 #define MPI3MR_DRIVER_DESC	"MPI3 Storage Controller Device Driver"
 
-#define MPI3MR_NAME_LENGTH	32
+#define MPI3MR_NAME_LENGTH	64
 #define IOCNAME			"%s: "
 
 #define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)
@@ -294,6 +294,10 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT = 30,
 };
 
+#define MPI3MR_RESET_REASON_OSTYPE_LINUX	1
+#define MPI3MR_RESET_REASON_OSTYPE_SHIFT	28
+#define MPI3MR_RESET_REASON_IOCNUM_SHIFT	20
+
 /* Queue type definitions */
 enum queue_type {
 	MPI3MR_DEFAULT_QUEUE = 0,
@@ -1142,7 +1146,7 @@ struct mpi3mr_ioc {
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;
 
-	char watchdog_work_q_name[20];
+	char watchdog_work_q_name[50];
 	struct workqueue_struct *watchdog_work_q;
 	struct delayed_work watchdog_work;
 	spinlock_t watchdog_lock;
@@ -1336,7 +1340,7 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc);
 void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
 
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
-			      u32 reset_reason, u8 snapdump);
+			      u16 reset_reason, u8 snapdump);
 void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 0380996b5ad2..38f63bc7ef3b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1598,26 +1598,33 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		rval = -EAGAIN;
 		if (mrioc->bsg_cmds.state & MPI3MR_CMD_RESET)
 			goto out_unlock;
-		dprint_bsg_err(mrioc,
-		    "%s: bsg request timedout after %d seconds\n", __func__,
-		    karg->timeout);
-		if (mrioc->logging_level & MPI3_DEBUG_BSG_ERROR) {
-			dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
+		if (((mpi_header->function != MPI3_FUNCTION_SCSI_IO) &&
+		    (mpi_header->function != MPI3_FUNCTION_NVME_ENCAPSULATED))
+		    || (mrioc->logging_level & MPI3_DEBUG_BSG_ERROR)) {
+			ioc_info(mrioc, "%s: bsg request timedout after %d seconds\n",
+			    __func__, karg->timeout);
+			if (!(mrioc->logging_level & MPI3_DEBUG_BSG_INFO)) {
+				dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
 			    "bsg_mpi3_req");
 			if (mpi_header->function ==
-			    MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH) {
+			    MPI3_FUNCTION_MGMT_PASSTHROUGH) {
 				drv_buf_iter = &drv_bufs[0];
 				dprint_dump(drv_buf_iter->kern_buf,
 				    rmc_size, "mpi3_mgmt_req");
+				}
 			}
 		}
 		if ((mpi_header->function == MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) ||
-		    (mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO))
+			(mpi_header->function == MPI3_BSG_FUNCTION_SCSI_IO)) {
+			dprint_bsg_err(mrioc, "%s: bsg request timedout after %d seconds,\n"
+				"issuing target reset to (0x%04x)\n", __func__,
+				karg->timeout, mpi_header->function_dependent);
 			mpi3mr_issue_tm(mrioc,
 			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 			    mpi_header->function_dependent, 0,
 			    MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
 			    &mrioc->host_tm_cmds, &resp_code, NULL);
+		}
 		if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) &&
 		    !(mrioc->bsg_cmds.state & MPI3MR_CMD_RESET))
 			mpi3mr_soft_reset_handler(mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index ae0e2c6cd2af..fe5ed1a2b9a3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -11,7 +11,7 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 static int
-mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
+mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u16 reset_reason);
 static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
 static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
@@ -1195,7 +1195,7 @@ static inline void mpi3mr_clear_reset_history(struct mpi3mr_ioc *mrioc)
 static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	u32 reset_reason)
 {
-	u32 ioc_config, timeout, ioc_status;
+	u32 ioc_config, timeout, ioc_status, scratch_pad0;
 	int retval = -1;
 
 	ioc_info(mrioc, "Issuing Message unit Reset(MUR)\n");
@@ -1204,7 +1204,11 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 		return retval;
 	}
 	mpi3mr_clear_reset_history(mrioc);
-	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
+	scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
+			 MPI3MR_RESET_REASON_OSTYPE_SHIFT) |
+			(mrioc->facts.ioc_num <<
+			 MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
+	writel(scratch_pad0, &mrioc->sysif_regs->scratchpad[0]);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_config &= ~MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
@@ -1520,11 +1524,11 @@ static inline void mpi3mr_set_diagsave(struct mpi3mr_ioc *mrioc)
  * Return: 0 on success, non-zero on failure.
  */
 static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
-	u32 reset_reason)
+	u16 reset_reason)
 {
 	int retval = -1;
 	u8 unlock_retry_count = 0;
-	u32 host_diagnostic, ioc_status, ioc_config;
+	u32 host_diagnostic, ioc_status, ioc_config, scratch_pad0;
 	u32 timeout = MPI3MR_RESET_ACK_TIMEOUT * 10;
 
 	if ((reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) &&
@@ -1576,6 +1580,9 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 		    unlock_retry_count, host_diagnostic);
 	} while (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE));
 
+	scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
+	    MPI3MR_RESET_REASON_OSTYPE_SHIFT) | (mrioc->facts.ioc_num <<
+	    MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
 	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
 	writel(host_diagnostic | reset_type,
 	    &mrioc->sysif_regs->host_diagnostic);
@@ -2581,7 +2588,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	unsigned long flags;
 	enum mpi3mr_iocstate ioc_state;
 	u32 fault, host_diagnostic, ioc_status;
-	u32 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
+	u16 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
 	if (mrioc->reset_in_progress)
 		return;
@@ -4968,7 +4975,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
  * Return: 0 on success, non-zero on failure.
  */
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
-	u32 reset_reason, u8 snapdump)
+	u16 reset_reason, u8 snapdump)
 {
 	int retval = 0, i;
 	unsigned long flags;
-- 
2.31.1


--0000000000008d600a061387fccf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC/ZrIzcBRzs71XsLnoO1b/hDjyk7JzK
WJIvOOiKtitmMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMx
MzEwMTAzOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAck5Qzv7oU2cWXSeg2z5ndrNRmqhUi5UGzw+zvRD3t76O+x9Lr
XXf+WyOoHKtmYlPyFmrFRY+t2a6NFX8sNffwigLzC9Kq7pAg6+qXXUZQJ1QE325j9TZb3dWhtNiH
6U6oeNPvSo5o+RmSLa07mAa9kJuFXqRM6O06xmBwsvo5MyZaJS2pizJYYl6M7u7cx5FtzcuphV9O
55BpLEYuQE9IOvKImPTSZjLpjlwz5zYEfQrWH3TFmUAmWcu5S0LOcv33GzGb4XVcQHY6r/BF6hXt
cm/NnCVV7/JH5lnkPUR9nCUX4X5YiNOqlgBFjwM7hB8i0JxIQNCavOMJKO8zONrx
--0000000000008d600a061387fccf--
