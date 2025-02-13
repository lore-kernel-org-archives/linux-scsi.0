Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2A280034
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410825; cv=none; b=FdreoRkv+BFPOQ+Om34bq7jAqFqIvG8jl9AkUXZ2z8QVyrhhyED3k4EJcILbSTzAP5Z80xBk1DYveF9hcyvdwP9+euqbdeg0NeXzhmmGY8R0ycB3FY/06MOOurp8lzEL3v1FKQLtJDxOWzoz0IP/S3kczu/+koZH8IjU92SN+DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410825; c=relaxed/simple;
	bh=M/YtPeTCY9ZRpwHvWcY+ga+FpUApZ7jxAyPLNOfwH4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=KIVB8GPvMcfm7Mp4C2ZTm8InVfT1oL05sYehxM+SjubiBo6/yMP/bNFxLhcmLINn9gbM4Sr+e0YoEbi2z7guGzl9vN5UhX87QAng9P5TbbyUGxiI0YkU2PC9hG04Kp6ZcAwnLxf5y5Ugvzd6Wou4p95dGLKs4YQweLT1xgc7qfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aiRF8wZf; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aiRF8wZf"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-219f8263ae0so4510215ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 17:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1739410822; x=1740015622; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/DGJB0JzzRtTHLXpFc4GyUcj21D6vzncjn0rF4Hy3wM=;
        b=aiRF8wZf8cQJIXRqHxljXdJlYr8ZvijyYB44+z28H6T8NX7Ilac4dTS2eZOa17+X4O
         NVNVV3ViGoA3aJbVXsD137tmvh166gHTJCQXjbJreBAQhc6HLTs583lBHwaPSQoNtsBW
         XRMjXY3mH4e4/ScLK+bk73ZAy/JXzINPodcDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410822; x=1740015622;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/DGJB0JzzRtTHLXpFc4GyUcj21D6vzncjn0rF4Hy3wM=;
        b=Eu7OXNhoBzYCIWI+K8IoOiRhYH6QaOmU9vZA6ngy0rrQz4CpCvOkHpbze76zMDbM9y
         otJodQ3aCjGOVBo4mq6tMNQwqnYEGZ1PoiNs4kkscrWFvHjFAdqUkkEztlpmNK9NNuuo
         IOmvnsqTEfOKFWjEfh0CET141t0j7rsBclqHSI3cDUNo14LrL4y6GrwYc5cSKCY29zdO
         mNNwQMBBsmhSUjBeflgUlUfRAAX6wQIhmi2QvtjUtKIH4fKj2FutQPVPuGHiVID5p1fE
         tH5ySmObirTbiDHDekWhocC/01Yo31DWJRCxV1RChQmyR0Bvp57TBL3OjBcxQRTp63Cm
         WaVw==
X-Gm-Message-State: AOJu0YxNptS8Hl4yt9Z/rynxVSPh7f7vHM3nmQjylZ7wSJnS7b0U+noT
	pVoiu/fAtn/6pz8CK4fXkLNHACQKNXBxaDKmAmbZCYGzUq61gFY2fEf49Qzl8wF9KDknguI36g0
	mFS634zX/lvHKgY+tTmsrih5Q3+fsVF3A4w/JQRhVfPDZTbPcDyG8DWrPRh+pDdyN4KYAsNXqPL
	jv3ShLb/i1hxRTPt4AmaU606XpKbq6tJ3N2sgSDhgrNCWphWkAPdmdO/HDNyl9+Z9m
X-Gm-Gg: ASbGncuvBv/r8J3Z4flvB0GwAPb12+rh54Rig1YymGydqpOlu2gVMtB3T3YUIb/2oY3
	CYXmGnP1vhXCqbaXdX1a+d3i2w1IEW5UDwtVPmKUO5rQ3jJn6QS8slKmTYcHPnGpqNNpSVNmma9
	34WfT+pmwNbkw8qz+uJWjmFmmbl8V7RL7whUfaKSZrMDP/uhdGhWIeU7RzpRi64FDzmE2PjQswF
	VgzTohd3mfacZlZTYo0+rM7OvTzuGp9vV10iah/rEu8UlaPy6Iar2GZ32konioe8LCSOBjC8wzq
	MR1auFwaUFLHvnpEwIcUUt1xgm2p0FlZXeGFLpXb4UOvN1eb47vqe/34itUPUxYsBrw38PbBbE2
	Zo9K140trLOHLTe25rj8gzMk=
X-Google-Smtp-Source: AGHT+IEJsmn1rvVWy17dyx8jSyBAlMzTU43tLnWelExCP9jGEr6fT6M6KX7vhXZZJ7M9XjwSAfUD0A==
X-Received: by 2002:a05:6a21:3981:b0:1ee:69aa:b670 with SMTP id adf61e73a8af0-1ee69aab757mr4031665637.9.1739410821606;
        Wed, 12 Feb 2025 17:40:21 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242761714sm106145b3a.133.2025.02.12.17.40.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:40:21 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 1/5] mpt3sas: Update MPI headers to 02.00.62 version
Date: Wed, 12 Feb 2025 17:26:52 -0800
Message-Id: <1739410016-27503-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Updated MPI header files to version 02.00.62.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h      |  9 ++++-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |  5 +++
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  | 54 ++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index 6de35b32223c..b181b113fc80 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -125,6 +125,12 @@
  * 06-24-19  02.00.55  Bumped MPI2_HEADER_VERSION_UNIT
  * 08-01-19  02.00.56  Bumped MPI2_HEADER_VERSION_UNIT
  * 10-02-19  02.00.57  Bumped MPI2_HEADER_VERSION_UNIT
+ * 07-20-20  02.00.58  Bumped MPI2_HEADER_VERSION_UNIT
+ * 03-30-21  02.00.59  Bumped MPI2_HEADER_VERSION_UNIT
+ * 06-03-22  02.00.60  Bumped MPI2_HEADER_VERSION_UNIT
+ * 09-20-23  02.00.61  Bumped MPI2_HEADER_VERSION_UNIT
+ * 09-13-24  02.00.62  Bumped MPI2_HEADER_VERSION_UNIT
+ *                     Added MPI2_FUNCTION_MCTP_PASSTHROUGH
  *  --------------------------------------------------------------------------
  */
 
@@ -165,7 +171,7 @@
 
 
 /* Unit and Dev versioning for this MPI header set */
-#define MPI2_HEADER_VERSION_UNIT            (0x39)
+#define MPI2_HEADER_VERSION_UNIT            (0x3E)
 #define MPI2_HEADER_VERSION_DEV             (0x00)
 #define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
 #define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
@@ -669,6 +675,7 @@ typedef union _MPI2_REPLY_DESCRIPTORS_UNION {
 #define MPI2_FUNCTION_PWR_MGMT_CONTROL              (0x30)
 #define MPI2_FUNCTION_SEND_HOST_MESSAGE             (0x31)
 #define MPI2_FUNCTION_NVME_ENCAPSULATED             (0x33)
+#define MPI2_FUNCTION_MCTP_PASSTHROUGH              (0x34)
 #define MPI2_FUNCTION_MIN_PRODUCT_SPECIFIC          (0xF0)
 #define MPI2_FUNCTION_MAX_PRODUCT_SPECIFIC          (0xFF)
 
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
index 587f7d248219..77259fc96b94 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
@@ -251,6 +251,7 @@
  * 12-17-18  02.00.47  Swap locations of Slotx2 and Slotx4 in ManPage 7.
  * 08-01-19  02.00.49  Add MPI26_MANPAGE7_FLAG_X2_X4_SLOT_INFO_VALID
  *                     Add MPI26_IOUNITPAGE1_NVME_WRCACHE_SHIFT
+ * 09-13-24  02.00.50  Added PCIe 32 GT/s link rate
  */
 
 #ifndef MPI2_CNFG_H
@@ -1121,6 +1122,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_7 {
 #define MPI2_IOUNITPAGE7_PCIE_SPEED_5_0_GBPS        (0x01)
 #define MPI2_IOUNITPAGE7_PCIE_SPEED_8_0_GBPS        (0x02)
 #define MPI2_IOUNITPAGE7_PCIE_SPEED_16_0_GBPS       (0x03)
+#define MPI2_IOUNITPAGE7_PCIE_SPEED_32_0_GBPS       (0x04)
 
 /*defines for IO Unit Page 7 ProcessorState field */
 #define MPI2_IOUNITPAGE7_PSTATE_MASK_SECOND         (0x0000000F)
@@ -2301,6 +2303,7 @@ typedef struct _MPI2_CONFIG_PAGE_SASIOUNIT_1 {
 #define MPI2_SASIOUNIT1_CONTROL_CLEAR_AFFILIATION                   (0x0001)
 
 /*values for SAS IO Unit Page 1 AdditionalControlFlags */
+#define MPI2_SASIOUNIT1_ACONTROL_PROD_SPECIFIC_1                    (0x8000)
 #define MPI2_SASIOUNIT1_ACONTROL_DA_PERSIST_CONNECT                 (0x0100)
 #define MPI2_SASIOUNIT1_ACONTROL_MULTI_PORT_DOMAIN_ILLEGAL          (0x0080)
 #define MPI2_SASIOUNIT1_ACONTROL_SATA_ASYNCHROUNOUS_NOTIFICATION    (0x0040)
@@ -3591,6 +3594,7 @@ typedef struct _MPI2_CONFIG_PAGE_EXT_MAN_PS {
 #define MPI26_PCIE_NEG_LINK_RATE_5_0                    (0x03)
 #define MPI26_PCIE_NEG_LINK_RATE_8_0                    (0x04)
 #define MPI26_PCIE_NEG_LINK_RATE_16_0                   (0x05)
+#define MPI26_PCIE_NEG_LINK_RATE_32_0                   (0x06)
 
 
 /****************************************************************************
@@ -3700,6 +3704,7 @@ typedef struct _MPI26_CONFIG_PAGE_PIOUNIT_1 {
 #define MPI26_PCIEIOUNIT1_MAX_RATE_5_0                              (0x30)
 #define MPI26_PCIEIOUNIT1_MAX_RATE_8_0                              (0x40)
 #define MPI26_PCIEIOUNIT1_MAX_RATE_16_0                             (0x50)
+#define MPI26_PCIEIOUNIT1_MAX_RATE_32_0                             (0x60)
 
 /*values for PCIe IO Unit Page 1 DMDReportPCIe */
 #define MPI26_PCIEIOUNIT1_DMDRPT_UNIT_MASK                          (0x80)
diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
index d92852591134..c0a8ebb6299c 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_ioc.h
@@ -179,6 +179,7 @@
  *                     Added MPI26_IOCFACTS_CAPABILITY_COREDUMP_ENABLED
  *                     Added MPI2_FW_DOWNLOAD_ITYPE_COREDUMP
  *                     Added MPI2_FW_UPLOAD_ITYPE_COREDUMP
+ * 9-13-24    02.00.39 Added MPI26_MCTP_PASSTHROUGH messages
  * --------------------------------------------------------------------------
  */
 
@@ -382,6 +383,7 @@ typedef struct _MPI2_IOC_FACTS_REPLY {
 /*ProductID field uses MPI2_FW_HEADER_PID_ */
 
 /*IOCCapabilities */
+#define MPI26_IOCFACTS_CAPABILITY_MCTP_PASSTHRU         (0x00800000)
 #define MPI26_IOCFACTS_CAPABILITY_COREDUMP_ENABLED      (0x00200000)
 #define MPI26_IOCFACTS_CAPABILITY_PCIE_SRIOV            (0x00100000)
 #define MPI26_IOCFACTS_CAPABILITY_ATOMIC_REQ            (0x00080000)
@@ -1798,5 +1800,57 @@ typedef struct _MPI26_IOUNIT_CONTROL_REPLY {
 	Mpi26IoUnitControlReply_t,
 	*pMpi26IoUnitControlReply_t;
 
+/****************************************************************************
+ *  MCTP Passthrough messages (MPI v2.6 and later only.)
+ ****************************************************************************/
+
+/* MCTP Passthrough Request Message */
+typedef struct _MPI26_MCTP_PASSTHROUGH_REQUEST {
+	U8                      MsgContext;         /* 0x00 */
+	U8                      Reserved1[2];       /* 0x01 */
+	U8                      Function;           /* 0x03 */
+	U8                      Reserved2[3];       /* 0x04 */
+	U8                      MsgFlags;           /* 0x07 */
+	U8                      VP_ID;              /* 0x08 */
+	U8                      VF_ID;              /* 0x09 */
+	U16                     Reserved3;          /* 0x0A */
+	U32                     Reserved4;          /* 0x0C */
+	U8                      Flags;              /* 0x10 */
+	U8                      Reserved5[3];       /* 0x11 */
+	U32                     Reserved6;          /* 0x14 */
+	U32                     H2DLength;          /* 0x18 */
+	U32                     D2HLength;          /* 0x1C */
+	MPI25_SGE_IO_UNION      H2DSGL;             /* 0x20 */
+	MPI25_SGE_IO_UNION      D2HSGL;             /* 0x30 */
+} MPI26_MCTP_PASSTHRUOGH_REQUEST,
+	*PTR_MPI26_MCTP_PASSTHROUGH_REQUEST,
+	Mpi26MctpPassthroughRequest_t,
+	*pMpi26MctpPassthroughRequest_t;
+
+/* values for the MsgContext field */
+#define MPI26_MCTP_MSG_CONEXT_UNUSED            (0x00)
+
+/* values for the Flags field */
+#define MPI26_MCTP_FLAGS_MSG_FORMAT_MPT         (0x01)
+
+/* MCTP Passthrough Reply Message */
+typedef struct _MPI26_MCTP_PASSTHROUGH_REPLY {
+	U8                      MsgContext;         /* 0x00 */
+	U8                      Reserved1;          /* 0x01 */
+	U8                      MsgLength;          /* 0x02 */
+	U8                      Function;           /* 0x03 */
+	U8                      Reserved2[3];       /* 0x04 */
+	U8                      MsgFlags;           /* 0x07 */
+	U8                      VP_ID;              /* 0x08 */
+	U8                      VF_ID;              /* 0x09 */
+	U16                     Reserved3;          /* 0x0A */
+	U16                     Reserved4;          /* 0x0C */
+	U16                     IOCStatus;          /* 0x0E */
+	U32                     IOCLogInfo;         /* 0x10 */
+	U32                     ResponseDataLength; /* 0x14 */
+} MPI26_MCTP_PASSTHRUOGH_REPLY,
+	*PTR_MPI26_MCTP_PASSTHROUGH_REPLY,
+	Mpi26MctpPassthroughReply_t,
+	*pMpi26MctpPassthroughReply_t;
 
 #endif
-- 
2.43.0

