Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44106C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FD361287
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhEMIfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhEMIfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:35:13 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC8EC06138F
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c13so7627045pfv.4
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Aqbdxsc9bKyj2N+gjlOXY8Xqhn8AW8rILsn0n/HzgzI=;
        b=dbbF+QuICuk9vxK61aDCRpVgL8NZ02CXyUc2dSvFH8WQcjC089cyiMbrd+jJ7HxhxN
         r6TBSGXRx7D8HBmmfm/tNRO+xKme+5rwFG4+rpTRDH53F0bBUgH3+4BWKiWvL12Cz6IM
         DBMVHxZgE4pX+VT91H8D6fxXUBnlmKuaFf58c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Aqbdxsc9bKyj2N+gjlOXY8Xqhn8AW8rILsn0n/HzgzI=;
        b=RVvx/MFWWW3ClHg+Vim8f1jrs/su0REjPnvC3Yrel8bsuKqmF0q/TpMCV90HAQO0h2
         pO+D7IQ7+Z+tBQqpPwFjoXq1qujOiIwljKUWMh/Q2e+4Mqya4F1E0SabCWVD6eVKJ8aK
         mMhWWRG26P1zA+6LpBUFa8wNAQAACwzaFSihny4/BpANO0mLoHCFc9P9n/4sWY29L5eG
         Omoa5WXh2ceqc71nDwGer8U8GVtzGlms0Md2c2YYYsN96ZqgI5VrlSMlnQHkIEm4YfR7
         0+K7T5qpT3m8FwM3phBp26nt6DJlspPq37swbm4+NFMhfaH3pkFL+SVSSTEgNsbo0Qw2
         uetw==
X-Gm-Message-State: AOAM530USsPSi8k3ONF3VmbNcUamskRF1S37CXBaNnJ3XiIKgQB4tkJn
        xMub6sM6/indFb3CVQQUQL6FpE7hZnI7IdvJhOclkPnMGIlq4j6qPY85bR5FteL/r0rAj5ZMOKj
        7UubOZSJL2RMOFx9xPz0SiQTIhaUU3Om/yE73QZ0cL9DdXR2B8gPaxZstjdoQU/3DL+fy5yt26h
        PleAGnxA==
X-Google-Smtp-Source: ABdhPJyb01cDPO6jpwVyP7TrBiJxxEVtJr7Na/lSP+gZwVZ9tsF+mF6syFVyNoEmoRCCsIwlXxyIyg==
X-Received: by 2002:a63:b008:: with SMTP id h8mr15294692pgf.236.1620894827930;
        Thu, 13 May 2021 01:33:47 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i123sm1632468pfc.53.2021.05.13.01.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:33:47 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v5 22/24] mpi3mr: add support of DSN secure fw check
Date:   Thu, 13 May 2021 14:06:06 +0530
Message-Id: <20210513083608.2243297-23-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000765de605c231fc7c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000765de605c231fc7c

Read PCI_EXT_CAP_ID_DSN to know security status.

Driver will throw an warning message when a non-secure type controller
is detected. Purpose of this interface is to avoid interacting with
any firmware which is not secured/signed by Broadcom.
Any tampering on Firmware component will be detected by hardware
and it will be communicated to the driver to avoid any further
interaction with that component.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  9 ++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 80 +++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index b52a3d1c4371..35defe6e095c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -149,6 +149,15 @@ extern struct list_head mrioc_list;
 #define MPI3MR_IRQ_POLL_SLEEP			2
 #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
 
+/* Definitions for the controller security status*/
+#define MPI3MR_CTLR_SECURITY_STATUS_MASK	0x0C
+#define MPI3MR_CTLR_SECURE_DBG_STATUS_MASK	0x02
+
+#define MPI3MR_INVALID_DEVICE			0x00
+#define MPI3MR_CONFIG_SECURE_DEVICE		0x04
+#define MPI3MR_HARD_SECURE_DEVICE		0x08
+#define MPI3MR_TAMPERED_DEVICE			0x0C
+
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2f494bc8ea0d..7dbc4ae4a4f0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3197,6 +3197,75 @@ static inline void mpi3mr_init_drv_cmd(struct mpi3mr_drv_cmd *cmdptr,
 	cmdptr->host_tag = host_tag;
 }
 
+/**
+ * osintfc_mrioc_security_status -Check controller secure status
+ * @pdev: PCI device instance
+ *
+ * Read the Device Serial Number capability from PCI config
+ * space and decide whether the controller is secure or not.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int
+osintfc_mrioc_security_status(struct pci_dev *pdev)
+{
+	u32 cap_data;
+	int base;
+	u32 ctlr_status;
+	u32 debug_status;
+	int retval = 0;
+
+	base = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
+	if (!base) {
+		dev_err(&pdev->dev,
+		    "%s: PCI_EXT_CAP_ID_DSN is not supported\n", __func__);
+		return -1;
+	}
+
+	pci_read_config_dword(pdev, base + 4, &cap_data);
+
+	debug_status = cap_data & MPI3MR_CTLR_SECURE_DBG_STATUS_MASK;
+	ctlr_status = cap_data & MPI3MR_CTLR_SECURITY_STATUS_MASK;
+
+	switch (ctlr_status) {
+	case MPI3MR_INVALID_DEVICE:
+		dev_err(&pdev->dev,
+		    "%s: Non secure ctlr (Invalid) is detected: DID: 0x%x: SVID: 0x%x: SDID: 0x%x\n",
+		    __func__, pdev->device, pdev->subsystem_vendor,
+		    pdev->subsystem_device);
+		retval = -1;
+		break;
+	case MPI3MR_CONFIG_SECURE_DEVICE:
+		if (!debug_status)
+			dev_info(&pdev->dev,
+			    "%s: Config secure ctlr is detected\n",
+			    __func__);
+		break;
+	case MPI3MR_HARD_SECURE_DEVICE:
+		break;
+	case MPI3MR_TAMPERED_DEVICE:
+		dev_err(&pdev->dev,
+		    "%s: Non secure ctlr (Tampered) is detected: DID: 0x%x: SVID: 0x%x: SDID: 0x%x\n",
+		    __func__, pdev->device, pdev->subsystem_vendor,
+		    pdev->subsystem_device);
+		retval = -1;
+		break;
+	default:
+		retval = -1;
+			break;
+	}
+
+	if (!retval && debug_status) {
+		dev_err(&pdev->dev,
+		    "%s: Non secure ctlr (Secure Dbg) is detected: DID: 0x%x: SVID: 0x%x: SDID: 0x%x\n",
+		    __func__, pdev->device, pdev->subsystem_vendor,
+		    pdev->subsystem_device);
+		retval = -1;
+	}
+
+	return retval;
+}
+
 /**
  * mpi3mr_probe - PCI probe callback
  * @pdev: PCI device instance
@@ -3219,6 +3288,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost = NULL;
 	int retval = 0, i;
 
+	if (osintfc_mrioc_security_status(pdev)) {
+		warn_non_secure_ctlr = 1;
+		return 1; /* For Invalid and Tampered device */
+	}
+
 	shost = scsi_host_alloc(&mpi3mr_driver_template,
 	    sizeof(struct mpi3mr_ioc));
 	if (!shost) {
@@ -3335,6 +3409,9 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 
+	if (!shost)
+		return;
+
 	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
@@ -3453,6 +3530,9 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 	pci_power_t device_state = pdev->current_state;
 	int r;
 
+	if (!shost)
+		return 0;
+
 	mrioc = shost_priv(shost);
 
 	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
-- 
2.18.1


--000000000000765de605c231fc7c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDCcx6MIqFdnHW4fGFQNp43EPMLg
QjpuVye1PQb3fGRgMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMzA4MzM0OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCpCrnvJ2g76LaHOg2okBIEbT9bKpB9oGNkicq+ttlMI0Zg
Gn7MvzKC5rbPHbjFDBgCZ3oF43lNGj7cCx+CPxI7/qAv5wrcfFN4CQH3WWfV1isO8bMGlyN76RY2
fxilkAlWghpAYyhb6W7EW7/r9TvsddUZdmBbZnRPvQO/WjhnK0LNMab6tYeRjVOD+tn1k7c0ITxR
x+PFsS1TKQvqzAoL462bx+X0LsYr2/NijMJPmGww/lqFiKZVVTRmAPoOo94zVIcyQFHko6WY65+J
ov+i494/CyAGWxsXQFEtzDt/ItEFDi/SOQ5GvtphEiEK+BViDUuykb6S1xS71vMmN3sT
--000000000000765de605c231fc7c--
