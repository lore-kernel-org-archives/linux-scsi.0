Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EF4C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7856A61246
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbhDSLDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbhDSLDf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:03:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0E3C06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:03:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso13138138pjg.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=h0+l23vsgfigLhdVmU1L4CywDGaqL8QE5B5iUKfHbb4=;
        b=LZfxC9YJoBispuvQtHtJT7OyoI6sVvPNBLfLJ4lwl9aR45u2Wj6yoGwlwoyy5r+b6Z
         4FkkEkTHljzhwdF4AK9dAx3VzdADnyoP2aYXdFpg4kE5+6jVUfAFxOllXRyNrUpg1oi/
         j1cekUAyKd19w9XPv+H0LQ8pMblcyJWoqPRAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=h0+l23vsgfigLhdVmU1L4CywDGaqL8QE5B5iUKfHbb4=;
        b=EkYb1Z7yq3vPWQ9fnkOCgZGUnL84eVzwSCumcuDG+BCLsaXjYN/JYKqEmanuM73RCx
         vrRvqi8mzlTdn1K/A3mzUz7WorwCNcfg4Vc4SdH6JcQNhCgBaved81l5iu3WK1amMO7k
         bNzbtBTshAVJDihiOfaZjXmGdn58+zfLfstfV5an7PnKnkeTne65kzwj+VGYoGnWRLxn
         FWRQZyJGy9as9D8oVxOBbG+s8a177tv0u0i1FQfTngVfEQOyiMcU1atwbptuUDRMheCY
         4Pi0kSLEDv2yL3OqsnM4tR3g7kH4b722176l+0mSJqLJLweevt4MO4nclk65soR7cEWm
         FQjQ==
X-Gm-Message-State: AOAM530oxTktBlqUGVe5tCNJYkQMJ/T07xdGOe50qnNZs2AR5TE/wWoB
        /Iwt4kL55wiOlkxMbJ4c+i3C+jP7Yg0PmIcEMXocRKyM/ojYdZ9L/WFn5m6Yfn1fR8RVB58NJLO
        yMX35DrZ6kRjL2erqBnjY1ih3wDOaFBcp9dbfrkbRKUslQwGpblfGlPrPMWMpwSCyDpn6BMLycB
        I1vaCXbWeT
X-Google-Smtp-Source: ABdhPJwMsKJt2p84pC+1pfN3wcY3wGxphUBNGOw96PxmiPymz1t4wtTfuHQJUhVKwA+gl5a1EE6L3A==
X-Received: by 2002:a17:902:8c94:b029:ec:9762:2e13 with SMTP id t20-20020a1709028c94b02900ec97622e13mr9092393plo.83.1618830183966;
        Mon, 19 Apr 2021 04:03:03 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k13sm11825736pfc.50.2021.04.19.04.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 04:03:03 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v3 22/24] mpi3mr: add support of DSN secure fw check
Date:   Mon, 19 Apr 2021 16:31:54 +0530
Message-Id: <20210419110156.1786882-23-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001800f405c05146e4"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000001800f405c05146e4

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

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  9 ++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 80 +++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 505df0e7b852..db9cb11db3bf 100644
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
index 05473b0f3c9e..836005ce6999 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3206,6 +3206,75 @@ static inline void mpi3mr_init_drv_cmd(struct mpi3mr_drv_cmd *cmdptr,
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
@@ -3228,6 +3297,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -3344,6 +3418,9 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 
+	if (!shost)
+		return;
+
 	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
@@ -3464,6 +3541,9 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 	pci_power_t device_state = pdev->current_state;
 	int r;
 
+	if (!shost)
+		return 0;
+
 	mrioc = shost_priv(shost);
 
 	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
-- 
2.18.1


--0000000000001800f405c05146e4
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBUKvSubyU4IoG3+jv9dn83CTCG5
QWKSm3FO9uW29nZ/MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExMDMwNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQByg14na0q8UpM8fhepKD7mQS5J6uldeNASe1rTtr2QKfe/
el8t1YsBVCDVLKYbtCXkqfqGjPRysKlObLJp7May473DfOPTcOl9YD1AmDbBZ+yaMuPpj6tUzjME
7iO5RYuwCAnKlhfhJgqDBZBYtGF/qVHwdlPnqmmDq3nxVuv+N8pCLK74NZJNIZvAe0a3j+ITCE4O
582v5aWil14E39IbjTfD14wXYiXVc5N+/35IClxEY62OkOyTumJFr98aLmiK7bA+KxuTZnSGwu+9
z8588mgku/SKZ/q7GGd15Nc/KBbmtAIIX2j6RACFIAtqfnXTUZrUotPdt6fi6xwSyU7l
--0000000000001800f405c05146e4--
