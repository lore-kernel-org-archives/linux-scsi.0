Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8D4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhLTOEk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhLTOEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:32 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAD0C061574
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:31 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id l10so9489357pgm.7
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=BxWaGoOOXuE/kKsgfo6Nu6kv5cdw8K4G7hex2rrHxmo=;
        b=PN/AJBEhlsf4WitmdsRsSanYGt7JrukcnPbNuyf/qkRcEku/BjK8gg3VxrYbFKo9uE
         eAoW0dyWmfiWOSmhKv0hFM7wp7U/TxcfKXNYII90zammDR9WwZTrHc5XUVZUq5a0nQ/Y
         pieZBEKT0OVJA0ZY1dfWM/pCFZ7ZSEKhFefYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=BxWaGoOOXuE/kKsgfo6Nu6kv5cdw8K4G7hex2rrHxmo=;
        b=17miHxY1rWnsyP6cbTpWh6P/Jvi6OkxazX0XtGe9BGDvtcUawMs5cMIA5YEWccQTdc
         w8gbyr0gahLACNUgWZHVvvdfVCArXsCRMBiSOUW7IBXUOsly6h9n1vYj28OzFnirIrjM
         O7St4ch7L7XCnsN6NLGfxuGfagTQUiC09E36rXYmlgeWQRMncn7fsm7LpC072ABDX2l2
         +/thNDNpB/O8+oMcELg1JkrDq/6sOHqPNEkr2X8maXrQYmbEhXaftWL33Ypg90ByW3rx
         aCN2VjRmn3lGKEayAFtxcHjl6LkW8sh9P2MY5Jf3RPx8T19oTcSY+5/ADovhZzG4QCAl
         qmvQ==
X-Gm-Message-State: AOAM5339BkavnLRF/jpkIT3QJSKsm/epYWY2/s33hRXvUiTr3aRSnkYU
        zNxG+FbErceTy+hgUroPfHhq4dvsAQeAAvRxNGS7Igfzrb/OBaH/E4lX3yjU385I4O4bjFfLcPG
        YaMcBRVpYxH0X9JvvShfgsGyEvRt4t7PUpzvBXOq02J+loXkyQXKoWFeAeVmc5DN88uuuJRhBXj
        a7NPvjyJiB
X-Google-Smtp-Source: ABdhPJyZrixSvSvF0kgbhuLG/H0nrLaFU4KoGTgxW/q97OrCacs/XROQ2qgjUH/xQcIu3G6jfS2sEg==
X-Received: by 2002:a63:751a:: with SMTP id q26mr15202855pgc.529.1640009070621;
        Mon, 20 Dec 2021 06:04:30 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:30 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 13/25] mpi3mr: code refactor of IOC init patch - part2
Date:   Mon, 20 Dec 2021 19:41:47 +0530
Message-Id: <20211220141159.16117-14-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001d742f05d3945ecb"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001d742f05d3945ecb
Content-Transfer-Encoding: 8bit

Move out the IOC initialization's bring up
logic to mpi3mr_bring_ioc_ready routine.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 167 +++++++++++++++++---------------
 1 file changed, 89 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f7cdb21..163e8b9 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -10,6 +10,10 @@
 #include "mpi3mr.h"
 #include <linux/io-64-nonatomic-lo-hi.h>
 
+static int
+mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
+static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
+
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
 {
@@ -992,26 +996,105 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
  * Set Enable IOC bit in IOC configuration register and wait for
  * the controller to become ready.
  *
- * Return: 0 on success, -1 on failure.
+ * Return: 0 on success, appropriate error on failure.
  */
 static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 {
-	u32 ioc_config, timeout;
-	enum mpi3mr_iocstate current_state;
+	u32 ioc_config, ioc_status, timeout;
+	int retval = 0;
+	enum mpi3mr_iocstate ioc_state;
+	u64 base_info;
 
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
+	base_info = lo_hi_readq(&mrioc->sysif_regs->ioc_information);
+	ioc_info(mrioc, "ioc_status(0x%08x), ioc_config(0x%08x), ioc_info(0x%016llx) at the bringup\n",
+	    ioc_status, ioc_config, base_info);
+
+	/*The timeout value is in 2sec unit, changing it to seconds*/
+	mrioc->ready_timeout =
+	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
+	    MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT) * 2;
+
+	ioc_info(mrioc, "ready timeout: %d seconds\n", mrioc->ready_timeout);
+
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	ioc_info(mrioc, "controller is in %s state during detection\n",
+	    mpi3mr_iocstate_name(ioc_state));
+
+	if (ioc_state == MRIOC_STATE_BECOMING_READY ||
+	    ioc_state == MRIOC_STATE_RESET_REQUESTED) {
+		timeout = mrioc->ready_timeout * 10;
+		do {
+			msleep(100);
+		} while (--timeout);
+
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		ioc_info(mrioc,
+		    "controller is in %s state after waiting to reset\n",
+		    mpi3mr_iocstate_name(ioc_state));
+	}
+
+	if (ioc_state == MRIOC_STATE_READY) {
+		ioc_info(mrioc, "issuing message unit reset (MUR) to bring to reset state\n");
+		retval = mpi3mr_issue_and_process_mur(mrioc,
+		    MPI3MR_RESET_FROM_BRINGUP);
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		if (retval)
+			ioc_err(mrioc,
+			    "message unit reset failed with error %d current state %s\n",
+			    retval, mpi3mr_iocstate_name(ioc_state));
+	}
+	if (ioc_state != MRIOC_STATE_RESET) {
+		mpi3mr_print_fault_info(mrioc);
+		ioc_info(mrioc, "issuing soft reset to bring to reset state\n");
+		retval = mpi3mr_issue_reset(mrioc,
+		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
+		    MPI3MR_RESET_FROM_BRINGUP);
+		if (retval) {
+			ioc_err(mrioc,
+			    "soft reset failed with error %d\n", retval);
+			goto out_failed;
+		}
+	}
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	if (ioc_state != MRIOC_STATE_RESET) {
+		ioc_err(mrioc,
+		    "cannot bring controller to reset state, current state: %s\n",
+		    mpi3mr_iocstate_name(ioc_state));
+		goto out_failed;
+	}
+	mpi3mr_clear_reset_history(mrioc);
+	retval = mpi3mr_setup_admin_qpair(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to setup admin queues: error %d\n",
+		    retval);
+		goto out_failed;
+	}
+
+	ioc_info(mrioc, "bringing controller to ready state\n");
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_config |= MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
 	timeout = mrioc->ready_timeout * 10;
 	do {
-		current_state = mpi3mr_get_iocstate(mrioc);
-		if (current_state == MRIOC_STATE_READY)
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		if (ioc_state == MRIOC_STATE_READY) {
+			ioc_info(mrioc,
+			    "successfully transistioned to %s state\n",
+			    mpi3mr_iocstate_name(ioc_state));
 			return 0;
+		}
 		msleep(100);
 	} while (--timeout);
 
-	return -1;
+out_failed:
+	ioc_state = mpi3mr_get_iocstate(mrioc);
+	ioc_err(mrioc,
+	    "failed to bring to ready state,  current state: %s\n",
+	    mpi3mr_iocstate_name(ioc_state));
+	return retval;
 }
 
 /**
@@ -3372,10 +3455,6 @@ static int mpi3mr_enable_events(struct mpi3mr_ioc *mrioc)
 int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 {
 	int retval = 0;
-	enum mpi3mr_iocstate ioc_state;
-	u64 base_info;
-	u32 timeout;
-	u32 ioc_status, ioc_config;
 	struct mpi3_ioc_facts_data facts_data;
 
 	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
@@ -3390,74 +3469,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 		}
 	}
 
-	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-
-	ioc_info(mrioc, "SOD status %x configuration %x\n",
-	    ioc_status, ioc_config);
-
-	base_info = lo_hi_readq(&mrioc->sysif_regs->ioc_information);
-	ioc_info(mrioc, "SOD base_info %llx\n",	base_info);
-
-	/*The timeout value is in 2sec unit, changing it to seconds*/
-	mrioc->ready_timeout =
-	    ((base_info & MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_MASK) >>
-	    MPI3_SYSIF_IOC_INFO_LOW_TIMEOUT_SHIFT) * 2;
-
-	ioc_info(mrioc, "IOC ready timeout %d\n", mrioc->ready_timeout);
-
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	ioc_info(mrioc, "IOC in %s state during detection\n",
-	    mpi3mr_iocstate_name(ioc_state));
-
-	if (ioc_state == MRIOC_STATE_BECOMING_READY ||
-	    ioc_state == MRIOC_STATE_RESET_REQUESTED) {
-		timeout = mrioc->ready_timeout * 10;
-		do {
-			msleep(100);
-		} while (--timeout);
-
-		ioc_state = mpi3mr_get_iocstate(mrioc);
-		ioc_info(mrioc,
-		    "IOC in %s state after waiting for reset time\n",
-		    mpi3mr_iocstate_name(ioc_state));
-	}
-
-	if (ioc_state == MRIOC_STATE_READY) {
-		retval = mpi3mr_issue_and_process_mur(mrioc,
-		    MPI3MR_RESET_FROM_BRINGUP);
-		if (retval) {
-			ioc_err(mrioc, "Failed to MU reset IOC error %d\n",
-			    retval);
-		}
-		ioc_state = mpi3mr_get_iocstate(mrioc);
-	}
-	if (ioc_state != MRIOC_STATE_RESET) {
-		mpi3mr_print_fault_info(mrioc);
-		retval = mpi3mr_issue_reset(mrioc,
-		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
-		    MPI3MR_RESET_FROM_BRINGUP);
-		if (retval) {
-			ioc_err(mrioc,
-			    "%s :Failed to soft reset IOC error %d\n",
-			    __func__, retval);
-			goto out_failed;
-		}
-	}
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	if (ioc_state != MRIOC_STATE_RESET) {
-		retval = -1;
-		ioc_err(mrioc, "Cannot bring IOC to reset state\n");
-		goto out_failed;
-	}
-
-	retval = mpi3mr_setup_admin_qpair(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to setup admin Qs: error %d\n",
-		    retval);
-		goto out_failed;
-	}
-
 	retval = mpi3mr_bring_ioc_ready(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "Failed to bring ioc ready: error %d\n",
-- 
2.27.0


--0000000000001d742f05d3945ecb
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDz3Ft7bKTbJQM345sCO
18qdU8MTRYi5Atb8MsWuVfItMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBkP/G8CzgsxfKHo1V49GMtdDOg9fkefOg4dHTB
qjaKKJW3/I0zrGBaqqQF9bTgrTLpsOerKyy4EmBCqDsh7JZd6lM0uAmZJnmxBnnszKlTIUzupGq/
SM0V1UAbvlyu4uupFOZP/G0ruFOr8s4E1NQkXr/OUN9FRqQ9ufwzduhSUAf4gruEMFhKNyEezCSH
ZxFbu3ku4pqudxeLbzWUqVkdpfPKRdRBTL6Q6+r4Wc0YuKTi2SGEKELn9OPZczqmfW4Dnm/IwV04
TKawsbI0Yu16u2Unp+4UW+wjo5chTX3ssJyHOIjl4G8VDwUwFVsX6P78U7b39pM4Vjyzgu5b3eME
--0000000000001d742f05d3945ecb--
