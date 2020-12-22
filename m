Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8948EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5036C2310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLVKNx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgLVKNx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B61FC0611CE
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x18so7198873pln.6
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3E22nbE3JJs6pkP8gS53RBTY5lcxhD0ReUuj73hluVM=;
        b=cO4Za65y2ER9cdbwzOTrXmA7YqhpcoMdDkAiCYj2N62lWRkyjpkjhAksGL6lgd00bw
         mZlrmG7ZRTZUlwWveomdyJ+y2cxSI1raHfoZxQG7zZCtjJsQxoDfpL5dxHsb3pJEknEu
         KYgX/SEkj3lIg30P9OTwMVrHWA5mdTNmYDCPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=3E22nbE3JJs6pkP8gS53RBTY5lcxhD0ReUuj73hluVM=;
        b=LLbPdCOZLDYNhJSa8PxwoRYbDTEjnTVhiZGZvGRdzk5fzV1OsUaju7c+jfLbewNxy0
         LXMn4yLII0BJTOBOZ2gD5JvfnaZ+NliBCE9Z1OJUPp4nM0sdsIfUfdFqMjCeMIADdKlu
         uL++jzUHQi+tM2Z1OZz/U+YrUD9BmC/N3XJfwhPytu7x/SOKBATvuCQnMgC3YoPNYUv5
         0AieGqtum8vzCel8+OvHg8XuRFVfzy1ZwZzswswXhzh6dPy2HLGq0BRMzzHgaqtlTyTt
         rPqVal4wlhy8y5tMkpbJxLRIeFznuBezLv7DiSa6iBLdVM9cYLgn+IeU6FLBk0vUbfgn
         ZOUQ==
X-Gm-Message-State: AOAM533YsmRBS57SY0RDaQCf+8Wfsl5bWyuRcnJ048B41UmAQmftm4eQ
        ve7+UemqxqYnt96rK6f/AQzON+NszivXD1AonYuR9KKbu3BrCA6MVUHUZ24p5R6vsB3g6+pK4Ob
        d4u4CVK6xCG31RXS4Uv0fAlwks6O63JOGPuIxZSQ8N4Sd0TKR7JbYk7Szf+4JCUkZp+spnNxUjP
        CTd5O2hjtQ
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJyP6lA2SttxCridLDdXNpNpjI0YZxr0N5RLNbsThKMuWdL+ppK1ANZaTy2a+9d0C4g0l6vXCQ==
X-Received: by 2002:a17:902:ba84:b029:dc:f27:dd4e with SMTP id k4-20020a170902ba84b02900dc0f27dd4emr20140173pls.61.1608631994145;
        Tue, 22 Dec 2020 02:13:14 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:13:13 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 18/24] mpi3mr: add complete support of soft reset
Date:   Tue, 22 Dec 2020 15:41:50 +0530
Message-Id: <20201222101156.98308-19-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009d343f05b70ad27e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009d343f05b70ad27e
Content-Type: text/plain; charset="US-ASCII"

Unlock the host diagnostic registers and write the specific
reset type to that, wait for reset acknowledgment from the
controller, if the reset is not successful retry for the
predefined number of times

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 245 +++++++++++++++++++++++++++++++-
 2 files changed, 246 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 41a8689b46c9..1d51e42778f6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -189,6 +189,9 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_EVTACK_TIMEOUT = 19,
 	MPI3MR_RESET_FROM_CIACTVRST_TIMER = 20,
 	MPI3MR_RESET_FROM_GETPKGVER_TIMEOUT = 21,
+	MPI3MR_RESET_FROM_PELABORT_TIMEOUT = 22,
+	MPI3MR_RESET_FROM_SYSFS = 23,
+	MPI3MR_RESET_FROM_SYSFS_TIMEOUT = 24
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 4c4e21fb4ef3..36a68c488019 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -645,6 +645,100 @@ static const char *mpi3mr_iocstate_name(enum mpi3mr_iocstate mrioc_state)
 	return name;
 }
 
+/* Reset reason to name mapper structure*/
+static const struct {
+	enum mpi3mr_reset_reason value;
+	char *name;
+} mpi3mr_reset_reason_codes[] = {
+	{ MPI3MR_RESET_FROM_BRINGUP, "timeout in bringup" },
+	{ MPI3MR_RESET_FROM_FAULT_WATCH, "fault" },
+	{ MPI3MR_RESET_FROM_IOCTL, "application invocation" },
+	{ MPI3MR_RESET_FROM_EH_HOS, "error handling" },
+	{ MPI3MR_RESET_FROM_TM_TIMEOUT, "TM timeout" },
+	{ MPI3MR_RESET_FROM_IOCTL_TIMEOUT, "IOCTL timeout" },
+	{ MPI3MR_RESET_FROM_MUR_FAILURE, "MUR failure" },
+	{ MPI3MR_RESET_FROM_CTLR_CLEANUP, "timeout in controller cleanup" },
+	{ MPI3MR_RESET_FROM_CIACTIV_FAULT, "component image activation fault" },
+	{ MPI3MR_RESET_FROM_PE_TIMEOUT, "port enable timeout" },
+	{ MPI3MR_RESET_FROM_TSU_TIMEOUT, "time stamp update timeout" },
+	{ MPI3MR_RESET_FROM_DELREQQ_TIMEOUT, "delete request queue timeout" },
+	{ MPI3MR_RESET_FROM_DELREPQ_TIMEOUT, "delete reply queue timeout" },
+	{
+		MPI3MR_RESET_FROM_CREATEREPQ_TIMEOUT,
+		"create request queue timeout"
+	},
+	{
+		MPI3MR_RESET_FROM_CREATEREQQ_TIMEOUT,
+		"create reply queue timeout"
+	},
+	{ MPI3MR_RESET_FROM_IOCFACTS_TIMEOUT, "IOC facts timeout" },
+	{ MPI3MR_RESET_FROM_IOCINIT_TIMEOUT, "IOC init timeout" },
+	{ MPI3MR_RESET_FROM_EVTNOTIFY_TIMEOUT, "event notify timeout" },
+	{ MPI3MR_RESET_FROM_EVTACK_TIMEOUT, "event acknowledgment timeout" },
+	{
+		MPI3MR_RESET_FROM_CIACTVRST_TIMER,
+		"component image activation timeout"
+	},
+	{
+		MPI3MR_RESET_FROM_GETPKGVER_TIMEOUT,
+		"get package version timeout"
+	},
+	{ MPI3MR_RESET_FROM_SYSFS, "sysfs invocation" },
+	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
+};
+
+/**
+ * mpi3mr_reset_rc_name - get reset reason code name
+ * @reason_code: reset reason code value
+ *
+ * Map reset reason to an NULL terminated ASCII string
+ *
+ * Return: Name corresponding to reset reason value or NULL.
+ */
+static const char *mpi3mr_reset_rc_name(enum mpi3mr_reset_reason reason_code)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_reset_reason_codes); i++) {
+		if (mpi3mr_reset_reason_codes[i].value == reason_code) {
+			name = mpi3mr_reset_reason_codes[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+/* Reset type to name mapper structure*/
+static const struct {
+	u16 reset_type;
+	char *name;
+} mpi3mr_reset_types[] = {
+	{ MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET, "soft" },
+	{ MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, "diag fault" },
+};
+
+/**
+ * mpi3mr_reset_type_name - get reset type name
+ * reset_type: reset type value
+ *
+ * Map reset type to an NULL terminated ASCII string
+ *
+ * Return: Name corresponding to reset type value or NULL.
+ */
+static const char *mpi3mr_reset_type_name(u16 reset_type)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(mpi3mr_reset_types); i++) {
+		if (mpi3mr_reset_types[i].reset_type == reset_type) {
+			name = mpi3mr_reset_types[i].name;
+			break;
+		}
+	}
+	return name;
+}
 
 /**
  * mpi3mr_print_fault_info - Display fault information
@@ -808,6 +902,48 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	return -1;
 }
 
+/**
+ * mpi3mr_soft_reset_success - Check softreset is success or not
+ * @ioc_status: IOC status register value
+ * @ioc_config: IOC config register value
+ *
+ * Check whether the soft reset is successful or not based on
+ * IOC status and IOC config register values.
+ *
+ * Return: True when the soft reset is success, false otherwise.
+ */
+static inline bool
+mpi3mr_soft_reset_success(u32 ioc_status, u32 ioc_config)
+{
+	if (!((ioc_status & MPI3_SYSIF_IOC_STATUS_READY) ||
+	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) ||
+	    (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC)))
+		return true;
+	return false;
+}
+
+/**
+ * mpi3mr_diagfault_success - Check diag fault is success or not
+ * @mrioc: Adapter reference
+ * @ioc_status: IOC status register value
+ *
+ * Check whether the controller hit diag reset fault code.
+ *
+ * Return: True when there is diag fault, false otherwise.
+ */
+static inline bool mpi3mr_diagfault_success(struct mpi3mr_ioc *mrioc,
+	u32 ioc_status)
+{
+	u32 fault;
+
+	if (!(ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT))
+		return false;
+	fault = readl(&mrioc->sysif_regs->Fault) & MPI3_SYSIF_FAULT_CODE_MASK;
+	if (fault == MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET)
+		return true;
+	return false;
+}
+
 /**
  * mpi3mr_set_diagsave - Set diag save bit for snapdump
  * @mrioc: Adapter reference
@@ -832,14 +968,117 @@ static inline void mpi3mr_set_diagsave(struct mpi3mr_ioc *mrioc)
  * @reset_type: Reset type
  * @reset_reason: Reset reason code
  *
- * TBD
+ * Unlock the host diagnostic registers and write the specific
+ * reset type to that, wait for reset acknowledgment from the
+ * controller, if the reset is not successful retry for the
+ * predefined number of times.
  *
  * Return: 0 on success, non-zero on failure.
  */
 static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 	u32 reset_reason)
 {
-	return 0;
+	int retval = -1;
+	u8 unlock_retry_count, reset_retry_count = 0;
+	u32 host_diagnostic, timeout, ioc_status, ioc_config;
+
+	pci_cfg_access_lock(mrioc->pdev);
+	if ((reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) &&
+	    (reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT))
+		goto out;
+	if (mrioc->unrecoverable)
+		goto out;
+retry_reset:
+	unlock_retry_count = 0;
+	mpi3mr_clear_reset_history(mrioc);
+	do {
+		ioc_info(mrioc,
+		    "Write magic sequence to unlock host diag register (retry=%d)\n",
+		    ++unlock_retry_count);
+		if (unlock_retry_count >= MPI3MR_HOSTDIAG_UNLOCK_RETRY_COUNT) {
+			writel(reset_reason, &mrioc->sysif_regs->Scratchpad[0]);
+			mrioc->unrecoverable = 1;
+			goto out;
+		}
+
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH,
+		    &mrioc->sysif_regs->WriteSequence);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_1ST,
+		    &mrioc->sysif_regs->WriteSequence);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
+		    &mrioc->sysif_regs->WriteSequence);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_3RD,
+		    &mrioc->sysif_regs->WriteSequence);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_4TH,
+		    &mrioc->sysif_regs->WriteSequence);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_5TH,
+		    &mrioc->sysif_regs->WriteSequence);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_6TH,
+		    &mrioc->sysif_regs->WriteSequence);
+		usleep_range(1000, 1100);
+		host_diagnostic = readl(&mrioc->sysif_regs->HostDiagnostic);
+		ioc_info(mrioc,
+		    "wrote magic sequence: retry_count(%d), host_diagnostic(0x%08x)\n",
+		    unlock_retry_count, host_diagnostic);
+	} while (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE));
+
+	writel(reset_reason, &mrioc->sysif_regs->Scratchpad[0]);
+	ioc_info(mrioc, "%s reset due to %s(0x%x)\n",
+	    mpi3mr_reset_type_name(reset_type),
+	    mpi3mr_reset_rc_name(reset_reason), reset_reason);
+	writel(host_diagnostic | reset_type,
+	    &mrioc->sysif_regs->HostDiagnostic);
+	timeout = mrioc->ready_timeout * 10;
+	if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) {
+		do {
+			ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
+			if (ioc_status &
+			    MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) {
+				mpi3mr_clear_reset_history(mrioc);
+				ioc_config =
+				    readl(&mrioc->sysif_regs->IOCConfiguration);
+				if (mpi3mr_soft_reset_success(ioc_status,
+				    ioc_config)) {
+					retval = 0;
+					break;
+				}
+			}
+			msleep(100);
+		} while (--timeout);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
+		    &mrioc->sysif_regs->WriteSequence);
+	} else if (reset_type == MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT) {
+		do {
+			ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
+			if (mpi3mr_diagfault_success(mrioc, ioc_status)) {
+				retval = 0;
+				break;
+			}
+			msleep(100);
+		} while (--timeout);
+		mpi3mr_clear_reset_history(mrioc);
+		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
+		    &mrioc->sysif_regs->WriteSequence);
+	}
+	if (retval && ((++reset_retry_count) < MPI3MR_MAX_RESET_RETRY_COUNT)) {
+		ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
+		ioc_config = readl(&mrioc->sysif_regs->IOCConfiguration);
+		ioc_info(mrioc,
+		    "Base IOC Sts/Config after reset try %d is (0x%x)/(0x%x)\n",
+		    reset_retry_count, ioc_status, ioc_config);
+		goto retry_reset;
+	}
+
+out:
+	pci_cfg_access_unlock(mrioc->pdev);
+	ioc_status = readl(&mrioc->sysif_regs->IOCStatus);
+	ioc_config = readl(&mrioc->sysif_regs->IOCConfiguration);
+
+	ioc_info(mrioc,
+	    "Base IOC Sts/Config after %s reset is (0x%x)/(0x%x)\n",
+	    (!retval)?"successful":"failed", ioc_status,
+	    ioc_config);
+	return retval;
 }
 
 /**
@@ -3432,6 +3671,8 @@ int mpi3mr_diagfault_reset_handler(struct mpi3mr_ioc *mrioc,
 {
 	int retval = 0;
 
+	ioc_info(mrioc, "Entry: reason code: %s\n",
+	    mpi3mr_reset_rc_name(reset_reason));
 	mrioc->reset_in_progress = 1;
 
 	mpi3mr_ioc_disable_intr(mrioc);
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000009d343f05b70ad27e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgb/lQfY/f
6WsdFSOW1G9L2BB2tQv9RE3//ydxt05tDLEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMzE0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAG+E8+58CaEV7CEOLGuLPbJspyvs
v9vGAumLbWKBXOhEZn+nsu3TjyUnIjeKhhKLfMvxLtfncgD+xTcup0B5aAAy0xM6ILMfghhDgQ/w
x45lj1brotvjZNQcdykH61hciQZca7zoH5H9kOoXaZbxnowWoFP8EMko12fgqehURQJslUF+7R57
moSZeulpmBhW1N/uwXAX37ueaSgPpuvDXpIe7L+TfJpZAwZJQj/z2Eua4L7Y424XO3h6ydAT4uYR
OdHvTuKEQ19qddfa0+adNIyfrbxikRsYfgWXd6qylsbHUNp8njlVd34j6DfTgEXpCCnDOsVigSeN
0K4uZs/4ig4=
--0000000000009d343f05b70ad27e--
