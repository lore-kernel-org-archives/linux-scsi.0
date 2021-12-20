Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F95EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhLTOEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhLTOE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:27 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D33C06173E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:27 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g2so6912239pgo.9
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=cX7d0v6QwKQnbEZByyK3jRW5OekuhQCymDRiBXkfm1s=;
        b=g1ZR1Wrw09vIhfIa77xxv5PWO1i5IJjeyEZh1fbZPIyQpLzlXzOD+lfSTZchYomcs8
         ZVOcORCS3nzBjAyc+dr2WUNXWMFmIayOqhtt6lvv3eQJMmN4PJjyOPCjUn/I825bxfMe
         ck0QTGWgdlyFzT3Ke5y0ZL1DTSHFP3vCe08Q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=cX7d0v6QwKQnbEZByyK3jRW5OekuhQCymDRiBXkfm1s=;
        b=SL5t6Q8/iOCB4vWDZjxuTakuy06wxe4QI8RJj0suq+PNXWPJF3cORAeC+CxuyCifep
         Czf8tpqRAH+5qBTamKH/12L+fmSbvMMpAemVyFH3ZQLEoEnIu9Gd7VWupp5pUptZ0whS
         qI/x+rs7xkwepXuKT+wNGR95smVdjpjht5Wzk5TxCuPqIER5GwiAtiTHfwQCcqq9D4pV
         0NO9d9L8MWS+kDuDGc35GdAoYR3dA8DVKYoDiiY0AzI66g2lob7M3z3CQ7SZlfMLVW8P
         6QzkklRLzMCaD32NNCWe83p4OPCm4qepaVgTHe42LOvduzg5wLZDwSpjooWoG5Nzg60F
         pOZA==
X-Gm-Message-State: AOAM532jZ/WfivJpFubQjdMZZQQAEHvIUlEwQeymd+Lrqyk23ZaNNX8g
        OoWT43DBjnM5X/DRsPp2fYc0y4dEDWsVM6DHNuzrlb2I8pT88eYmV5AeOGsNqAEOjrmnS7KZtAg
        sBRnYa90CUM2LnHaUcDwFOqAlN2wSrG8aVn7zP0a/tIy+eIFUcXwYNQ/e42fhNqWlhV6PXv2yZM
        2Zs6ztp4JQ
X-Google-Smtp-Source: ABdhPJwU0vcUTy5BIolyD3zWjwkGy7skHiJy7if+Bjxl30Nap80tAf1AvNZz5jPscE4KKVDNazKJnQ==
X-Received: by 2002:a63:180b:: with SMTP id y11mr15447600pgl.317.1640009066340;
        Mon, 20 Dec 2021 06:04:26 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:25 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 11/25] mpi3mr: Fault IOC when internal commands gets timeout
Date:   Mon, 20 Dec 2021 19:41:45 +0530
Message-Id: <20211220141159.16117-12-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000db74dc05d3945d6b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000db74dc05d3945d6b
Content-Transfer-Encoding: 8bit

Save snapdump and fault the controller with the given
reason code if it is already not in the fault or not in
asynchronous reset. So that soft reset is issued
from the watchdog thread.  This will also be used
to handle initialization time faults/resets/timeout
as in those cases immediate soft reset invocation is
not required.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 114 ++++++++++++++++++--------------
 2 files changed, 67 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index fdbedf2..55a07f9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -916,5 +916,6 @@ void mpi3mr_flush_host_io(struct mpi3mr_ioc *mrioc);
 void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
 void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc);
+void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 6b534ed..b6d4e9d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1391,13 +1391,9 @@ static int mpi3mr_delete_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	wait_for_completion_timeout(&mrioc->init_cmds.done,
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		ioc_err(mrioc, "Issue DelRepQ: command timed out\n");
-		mpi3mr_set_diagsave(mrioc);
-		mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		ioc_err(mrioc, "delete reply queue timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
 		    MPI3MR_RESET_FROM_DELREPQ_TIMEOUT);
-		mrioc->unrecoverable = 1;
-
 		retval = -1;
 		goto out_unlock;
 	}
@@ -1617,12 +1613,9 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	wait_for_completion_timeout(&mrioc->init_cmds.done,
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		ioc_err(mrioc, "CreateRepQ: command timed out\n");
-		mpi3mr_set_diagsave(mrioc);
-		mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		ioc_err(mrioc, "create reply queue timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
 		    MPI3MR_RESET_FROM_CREATEREPQ_TIMEOUT);
-		mrioc->unrecoverable = 1;
 		retval = -1;
 		goto out_unlock;
 	}
@@ -1724,12 +1717,9 @@ static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
 	wait_for_completion_timeout(&mrioc->init_cmds.done,
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		ioc_err(mrioc, "CreateReqQ: command timed out\n");
-		mpi3mr_set_diagsave(mrioc);
-		if (mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
-		    MPI3MR_RESET_FROM_CREATEREQQ_TIMEOUT))
-			mrioc->unrecoverable = 1;
+		ioc_err(mrioc, "create request queue timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_CREATEREQQ_TIMEOUT);
 		retval = -1;
 		goto out_unlock;
 	}
@@ -1902,6 +1892,42 @@ out:
 	return retval;
 }
 
+/**
+ * mpi3mr_check_rh_fault_ioc - check reset history and fault
+ * controller
+ * @mrioc: Adapter instance reference
+ * @reason_code, reason code for the fault.
+ *
+ * This routine will save snapdump and fault the controller with
+ * the given reason code if it is not already in the fault or
+ * not asynchronosuly reset. This will be used to handle
+ * initilaization time faults/resets/timeout as in those cases
+ * immediate soft reset invocation is not required.
+ *
+ * Return:  None.
+ */
+void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code)
+{
+	u32 ioc_status, host_diagnostic, timeout;
+
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+	if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY) ||
+	    (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)) {
+		mpi3mr_print_fault_info(mrioc);
+		return;
+	}
+	mpi3mr_set_diagsave(mrioc);
+	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+	    reason_code);
+	timeout = MPI3_SYSIF_DIAG_SAVE_TIMEOUT * 10;
+	do {
+		host_diagnostic = readl(&mrioc->sysif_regs->host_diagnostic);
+		if (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS))
+			break;
+		msleep(100);
+	} while (--timeout);
+}
+
 /**
  * mpi3mr_sync_timestamp - Issue time stamp sync request
  * @mrioc: Adapter reference
@@ -2025,6 +2051,8 @@ static int mpi3mr_print_pkg_ver(struct mpi3mr_ioc *mrioc)
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
 		ioc_err(mrioc, "get package version timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
+		    MPI3MR_RESET_FROM_GETPKGVER_TIMEOUT);
 		retval = -1;
 		goto out_unlock;
 	}
@@ -2344,12 +2372,9 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 	wait_for_completion_timeout(&mrioc->init_cmds.done,
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		ioc_err(mrioc, "Issue IOCFacts: command timed out\n");
-		mpi3mr_set_diagsave(mrioc);
-		mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		ioc_err(mrioc, "ioc_facts timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
 		    MPI3MR_RESET_FROM_IOCFACTS_TIMEOUT);
-		mrioc->unrecoverable = 1;
 		retval = -1;
 		goto out_unlock;
 	}
@@ -2743,12 +2768,9 @@ static int mpi3mr_issue_iocinit(struct mpi3mr_ioc *mrioc)
 	wait_for_completion_timeout(&mrioc->init_cmds.done,
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		mpi3mr_set_diagsave(mrioc);
-		mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		mpi3mr_check_rh_fault_ioc(mrioc,
 		    MPI3MR_RESET_FROM_IOCINIT_TIMEOUT);
-		mrioc->unrecoverable = 1;
-		ioc_err(mrioc, "Issue IOCInit: command timed out\n");
+		ioc_err(mrioc, "ioc_init timed out\n");
 		retval = -1;
 		goto out_unlock;
 	}
@@ -2839,12 +2861,9 @@ static int mpi3mr_issue_event_notification(struct mpi3mr_ioc *mrioc)
 	wait_for_completion_timeout(&mrioc->init_cmds.done,
 	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
 	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-		ioc_err(mrioc, "Issue EvtNotify: command timed out\n");
-		mpi3mr_set_diagsave(mrioc);
-		mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+		ioc_err(mrioc, "event notification timed out\n");
+		mpi3mr_check_rh_fault_ioc(mrioc,
 		    MPI3MR_RESET_FROM_EVTNOTIFY_TIMEOUT);
-		mrioc->unrecoverable = 1;
 		retval = -1;
 		goto out_unlock;
 	}
@@ -3051,29 +3070,28 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
 		ioc_err(mrioc, "Issue PortEnable: Admin Post failed\n");
 		goto out_unlock;
 	}
-	if (!async) {
-		wait_for_completion_timeout(&mrioc->init_cmds.done,
-		    (pe_timeout * HZ));
-		if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
-			ioc_err(mrioc, "Issue PortEnable: command timed out\n");
-			retval = -1;
-			mrioc->scan_failed = MPI3_IOCSTATUS_INTERNAL_ERROR;
-			mpi3mr_set_diagsave(mrioc);
-			mpi3mr_issue_reset(mrioc,
-			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
-			    MPI3MR_RESET_FROM_PE_TIMEOUT);
-			mrioc->unrecoverable = 1;
-			goto out_unlock;
-		}
-		mpi3mr_port_enable_complete(mrioc, &mrioc->init_cmds);
+	if (async) {
+		mutex_unlock(&mrioc->init_cmds.mutex);
+		goto out;
 	}
+
+	wait_for_completion_timeout(&mrioc->init_cmds.done, (pe_timeout * HZ));
+	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "port enable timed out\n");
+		retval = -1;
+		mpi3mr_check_rh_fault_ioc(mrioc, MPI3MR_RESET_FROM_PE_TIMEOUT);
+		goto out_unlock;
+	}
+	mpi3mr_port_enable_complete(mrioc, &mrioc->init_cmds);
+
 out_unlock:
+	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&mrioc->init_cmds.mutex);
 out:
 	return retval;
 }
 
-/* Protocol type to name mapper structure*/
+/* Protocol type to name mapper structure */
 static const struct {
 	u8 protocol;
 	char *name;
-- 
2.27.0


--000000000000db74dc05d3945d6b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMYKsyGWj5Dz8aTDtdqN
gSLAh7I+WLvCHF4m6GHDKsTiMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQyNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCkSAMdP07EfGrl+v5lIU2TyFLTNdvRIAPuBCZt
CYkkqRrN3MZWzMnMZqLUZYZoEWuL83GMDHOLFEoEJlcuQ5b7PqFlzvZFpCiXUUYDnpLT2x9VRrlY
3K57qozz7RvjmT7Q3h0h3I/bx2dEfGZQ5QLDbI85VDHfGZ9RFA8nWm69i8Y5iywg8QTBmfKli6fz
CjBPTAjhe3kOuY7U4W6mcKWiU59PtuQVIX84YHE8x8B/zQVekdWC4ydnsYdldvukwRRy/MWtCNyk
EWpt+YwomWoFE6dIvQd6/2QgXSaxZ9ylk/eZ/6HlfDAcOoRa9zKwKrFKktNnfsBMwjhV6+Oz+Act
--000000000000db74dc05d3945d6b--
