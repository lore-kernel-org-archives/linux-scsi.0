Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38BEC49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72BDD206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DAiA/oRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbfIMNFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38495 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id w10so2119462plq.5
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FfSMgZ+bE6w5/hLtuP+nJc4ywC8zx9fcUfA8hJZsl+0=;
        b=DAiA/oRMaBOkoYljXYiPvnA/36bTIg20lAy7rk2ouYFLlYse6qaMkvl2fMXpUr6gMv
         fO3g+dCXEOUxB/7H/DgMwEdT0yOD6DveURIja40M2vTkRKxRINyzgZp6/e14IU8W9EPd
         ob4Vds0ra7TqmTZQkbUUIf3DdV0yL1YZHvrws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FfSMgZ+bE6w5/hLtuP+nJc4ywC8zx9fcUfA8hJZsl+0=;
        b=KGQAc9JIZUBy3bGFUCzqlX+hRfiByuVhaPiPJxPaZtsLz4MoUse1ebNgABRqOMyaPu
         WmRzwz/nsckjcyKwKOCXvipCdx+R+00901CyR2UkGOMVc0S6UgFDj6s6EjamG0iYPpZ2
         veS86deXEAYEPpfVSi2Uxb3p7yMnWLxHzrY0AkorcCxNQSVw9/1wQ6LZaj4hB1zD5fJY
         iuRvTzPK5vuk9TS3kdKfOcJ8XW49vGD9aKzUv2jBaI1A88CAnTBnSn3pTnlA6+kW+7x3
         85ybmYtvMX0VFbinCiCUr1vXd5W2kvjOui7nWfCa9Fk7E0DfHE5Xx4tUKEry+fbT5LWF
         LwJw==
X-Gm-Message-State: APjAAAVq1WqhV+kYuPrsq/PPJ/Sh7qZ9yWN1442qo8mHm5LSJNeQFa69
        al1bpva7aYS8OZfOtoT01z7FBQ==
X-Google-Smtp-Source: APXvYqzUAlNf9XUbifWbyU4eQBMd05qd62MNvnXSP1HkDCVZVa6ngsLkTmYGbZK8tnUI00UoAsX1ew==
X-Received: by 2002:a17:902:7085:: with SMTP id z5mr49462723plk.102.1568379912167;
        Fri, 13 Sep 2019 06:05:12 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:11 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 05/13] mpt3sas: Maintain owner of buffer through UniqueID
Date:   Fri, 13 Sep 2019 09:04:42 -0400
Message-Id: <1568379890-18347-6-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Problem statement:
Application A has registered a diag buffer and looking for particular
event to happen to release & read the trace buffer. Meanwhile
application B has unregister the diag buffer and now Application A
can't get the required diag buffer. So proper diag buffer ownership
is missing.

Improvement:
Each application has to maintain it's own Unique ID, Now driver has to
save the Application's UniqueID for each diag buffer type when diag buffer
is registered. And driver has to allow 'release', 'read' & 'unregister'
diag commands only if application's UniqueID matches with saved UniqueID
for the corresponding diag buffer type.

When diag buffer is registered by the driver then the UniqueID saved by
the driver is "BRCM" (i.e. 0x4252434D) for SAS3 and above generations
HBA devices. For SAS2 HBA's driver keeps the legacy UniqueID 0x07075900
for maintaining compatibility with the legacy SAS2 application and this
improvement won't be applicable for SAS2 HBA devices.

Any application can own the buffer registered by the driver by sending
diag register request to driver with same buffer type and size
(Application can get the buffer size by sending 'query' command). Then
driver changes the ownership of the buffer by saving application's
UniqueID for that corresponding buffer type.

Also application can re-register the diag buffer with same size without
un-registering it, but diag buffer should be released before re-registering
it. By allowing this, driver no need to deallocate and allocate a new
buffer for re-register command, same buffer can be re-used.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 114 ++++++++++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_ctl.h |   8 +++
 2 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 9b37a32..a14ff88 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1491,6 +1491,26 @@ _ctl_diag_capability(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type)
 	return rc;
 }
 
+/**
+ * _ctl_diag_get_bufftype - return diag buffer type
+ *              either TRACE, SNAPSHOT, or EXTENDED
+ * @ioc: per adapter object
+ * @unique_id: specifies the unique_id for the buffer
+ *
+ * returns MPT3_DIAG_UID_NOT_FOUND if the id not found
+ */
+static u8
+_ctl_diag_get_bufftype(struct MPT3SAS_ADAPTER *ioc, u32 unique_id)
+{
+	u8  index;
+
+	for (index = 0; index < MPI2_DIAG_BUF_TYPE_COUNT; index++) {
+		if (ioc->unique_id[index] == unique_id)
+			return index;
+	}
+
+	return MPT3_DIAG_UID_NOT_FOUND;
+}
 
 /**
  * _ctl_diag_register_2 - wrapper for registering diag buffer support
@@ -1538,11 +1558,65 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
 		return -EPERM;
 	}
 
+	if (diag_register->unique_id == 0) {
+		ioc_err(ioc,
+		    "%s: Invalid UID(0x%08x), buffer_type(0x%02x)\n", __func__,
+		    diag_register->unique_id, buffer_type);
+		return -EINVAL;
+	}
+
 	if (ioc->diag_buffer_status[buffer_type] &
 	    MPT3_DIAG_BUFFER_IS_REGISTERED) {
-		ioc_err(ioc, "%s: already has a registered buffer for buffer_type(0x%02x)\n",
-			__func__, buffer_type);
-		return -EINVAL;
+		/*
+		 * If driver posts buffer initially, then an application wants
+		 * to Register that buffer (own it) without Releasing first,
+		 * the application Register command MUST have the same buffer
+		 * type and size in the Register command (obtained from the
+		 * Query command). Otherwise that Register command will be
+		 * failed. If the application has released the buffer but wants
+		 * to re-register it, it should be allowed as long as the
+		 * Unique-Id/Size match.
+		 */
+
+		if (ioc->unique_id[buffer_type] == MPT3DIAGBUFFUNIQUEID &&
+		    ioc->diag_buffer_sz[buffer_type] ==
+		    diag_register->requested_buffer_size) {
+
+			if (!(ioc->diag_buffer_status[buffer_type] &
+			     MPT3_DIAG_BUFFER_IS_RELEASED)) {
+				dctlprintk(ioc, ioc_info(ioc,
+				    "%s: diag_buffer (%d) ownership changed. old-ID(0x%08x), new-ID(0x%08x)\n",
+				    __func__, buffer_type,
+				    ioc->unique_id[buffer_type],
+				    diag_register->unique_id));
+
+				/*
+				 * Application wants to own the buffer with
+				 * the same size.
+				 */
+				ioc->unique_id[buffer_type] =
+				    diag_register->unique_id;
+				rc = 0; /* success */
+				goto out;
+			}
+		} else if (ioc->unique_id[buffer_type] !=
+		    MPT3DIAGBUFFUNIQUEID) {
+			if (ioc->unique_id[buffer_type] !=
+			    diag_register->unique_id ||
+			    ioc->diag_buffer_sz[buffer_type] !=
+			    diag_register->requested_buffer_size ||
+			    !(ioc->diag_buffer_status[buffer_type] &
+			    MPT3_DIAG_BUFFER_IS_RELEASED)) {
+				ioc_err(ioc,
+				    "%s: already has a registered buffer for buffer_type(0x%02x)\n",
+				    __func__, buffer_type);
+				return -EINVAL;
+			}
+		} else {
+			ioc_err(ioc, "%s: already has a registered buffer for buffer_type(0x%02x)\n",
+			    __func__, buffer_type);
+			return -EINVAL;
+		}
 	}
 
 	if (diag_register->requested_buffer_size % 4)  {
@@ -1689,7 +1763,9 @@ mpt3sas_enable_diag_buffer(struct MPT3SAS_ADAPTER *ioc, u8 bits_to_register)
 		ioc->diag_trigger_master.MasterData =
 		    (MASTER_TRIGGER_FW_FAULT + MASTER_TRIGGER_ADAPTER_RESET);
 		diag_register.buffer_type = MPI2_DIAG_BUF_TYPE_TRACE;
-		diag_register.unique_id = 0x7075900;
+		diag_register.unique_id =
+		    (ioc->hba_mpi_version_belonged == MPI2_VERSION) ?
+		    (MPT2DIAGBUFFUNIQUEID):(MPT3DIAGBUFFUNIQUEID);
 
 		if (trace_buff_size != 0) {
 			diag_register.requested_buffer_size = trace_buff_size;
@@ -1815,7 +1891,13 @@ _ctl_diag_unregister(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	dctlprintk(ioc, ioc_info(ioc, "%s\n",
 				 __func__));
 
-	buffer_type = karg.unique_id & 0x000000ff;
+	buffer_type = _ctl_diag_get_bufftype(ioc, karg.unique_id);
+	if (buffer_type == MPT3_DIAG_UID_NOT_FOUND) {
+		ioc_err(ioc, "%s: buffer with unique_id(0x%08x) not found\n",
+		    __func__, karg.unique_id);
+		return -EINVAL;
+	}
+
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
 		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
 			__func__, buffer_type);
@@ -1899,7 +1981,7 @@ _ctl_diag_query(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 		return -EINVAL;
 	}
 
-	if (karg.unique_id & 0xffffff00) {
+	if (karg.unique_id) {
 		if (karg.unique_id != ioc->unique_id[buffer_type]) {
 			ioc_err(ioc, "%s: unique_id(0x%08x) is not registered\n",
 				__func__, karg.unique_id);
@@ -2065,7 +2147,13 @@ _ctl_diag_release(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	dctlprintk(ioc, ioc_info(ioc, "%s\n",
 				 __func__));
 
-	buffer_type = karg.unique_id & 0x000000ff;
+	buffer_type = _ctl_diag_get_bufftype(ioc, karg.unique_id);
+	if (buffer_type == MPT3_DIAG_UID_NOT_FOUND) {
+		ioc_err(ioc, "%s: buffer with unique_id(0x%08x) not found\n",
+		    __func__, karg.unique_id);
+		return -EINVAL;
+	}
+
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
 		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
 			__func__, buffer_type);
@@ -2149,7 +2237,13 @@ _ctl_diag_read_buffer(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	dctlprintk(ioc, ioc_info(ioc, "%s\n",
 				 __func__));
 
-	buffer_type = karg.unique_id & 0x000000ff;
+	buffer_type = _ctl_diag_get_bufftype(ioc, karg.unique_id);
+	if (buffer_type == MPT3_DIAG_UID_NOT_FOUND) {
+		ioc_err(ioc, "%s: buffer with unique_id(0x%08x) not found\n",
+		    __func__, karg.unique_id);
+		return -EINVAL;
+	}
+
 	if (!_ctl_diag_capability(ioc, buffer_type)) {
 		ioc_err(ioc, "%s: doesn't have capability for buffer_type(0x%02x)\n",
 			__func__, buffer_type);
@@ -3202,7 +3296,9 @@ host_trace_buffer_enable_store(struct device *cdev,
 		} else
 			diag_register.requested_buffer_size = (1024 * 1024);
 
-		diag_register.unique_id = 0x7075900;
+		diag_register.unique_id =
+		    (ioc->hba_mpi_version_belonged == MPI2_VERSION) ?
+		    (MPT2DIAGBUFFUNIQUEID):(MPT3DIAGBUFFUNIQUEID);
 		ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] = 0;
 		_ctl_diag_register_2(ioc,  &diag_register);
 	} else if (!strcmp(str, "release")) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 18b46fa..d1a6ab1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -95,6 +95,14 @@
 #define MPT3DIAGREADBUFFER _IOWR(MPT3_MAGIC_NUMBER, 30, \
 	struct mpt3_diag_read_buffer)
 
+/* Trace Buffer default UniqueId */
+#define MPT2DIAGBUFFUNIQUEID (0x07075900)
+#define MPT3DIAGBUFFUNIQUEID (0x4252434D)
+
+/* UID not found */
+#define MPT3_DIAG_UID_NOT_FOUND (0xFF)
+
+
 /**
  * struct mpt3_ioctl_header - main header structure
  * @ioc_number -  IOC unit number
-- 
1.8.3.1

