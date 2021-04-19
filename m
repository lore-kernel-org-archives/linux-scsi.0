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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B92C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6227261246
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Apr 2021 11:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhDSLDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 07:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbhDSLDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 07:03:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ECFC06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:03:02 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m6-20020a17090a8586b02901507e1acf0fso2821441pjn.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 04:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XiCf0jErV/wbAMsZnusT6l6xJPtfCTx/4dnwBQ7sTr4=;
        b=gNE3m3fYDNrktwLOqilJUfXQ6+9DNtAk+v4lYKFc96tuXhIBMAV6VxSsL4WHeKqxZB
         Ub3WmG+49oMII3IgqeK4utHpVA0U9QXeXUu3iuVFOP18HtXScdxLxjrmJmuXNGsPD8ue
         EW/CNgnqMud54H3waA71kZQHy+8fNaG4H7auA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XiCf0jErV/wbAMsZnusT6l6xJPtfCTx/4dnwBQ7sTr4=;
        b=qIg4ouoG+s/vFFbfErPGTVyuII9ZccXq2dDcGzWCJBN+38xoRb95IOjEEGYAUe60RE
         fVFNDlA7DIHKuAyZ5wJN2f1YSlkdYVkdDta/8HZvvBRpeszv1qBkivFIuxovBhrW7Md0
         CNBAlrYUxGu3DKyvcC18qMjU2+jnjikfthTz5E5Wvx49c4hl3sOrnNqe7jMg/W+TUcqO
         kMwiqHuflDENoYWk7qiTsj2BKCEh8nDl/QH9NKMEhhT+lpugXc2Kaj5VUObQDENMsB7h
         P7U3LRpuH6A8ZxtHQxc8DR3qilUCSOqdZscv2lNiuHY3oVFsLDk8cAFeUqVVj5DmrHUe
         /Rtw==
X-Gm-Message-State: AOAM532zTPW5lW1eINtLbCkGXPr+hzRSTg5MA9uLZNQRvT5hq5D4ltyh
        Ir6Ym2XPJ+V3m1VGk3sPquYgQcHU3BCMRbvGy3vzkIVL3qT0hh7IX7c+k+0vfqd9wkXIR2xSumK
        LmvcrzJ0XfZPHSU6YdDGst9hfcyCqUcSVlw+PKXbHoi3ljdIeIZZ2clLuGIswB1gsDXu7TL+0Fy
        pBLuq8bWFz
X-Google-Smtp-Source: ABdhPJwM76XG5HCUOx4ZdacwcDvoQFE+9eCy0xjWULfVjSwQEs0600Ov9A6fulmDwPapG/lhuRWFuA==
X-Received: by 2002:a17:90a:b112:: with SMTP id z18mr24952383pjq.18.1618830181116;
        Mon, 19 Apr 2021 04:03:01 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id k13sm11825736pfc.50.2021.04.19.04.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 04:03:00 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v3 21/24] mpi3mr: add support of PM suspend and resume
Date:   Mon, 19 Apr 2021 16:31:53 +0530
Message-Id: <20210419110156.1786882-22-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ecb03f05c0514509"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000ecb03f05c0514509

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 85 +++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ccee3e7359ec..05473b0f3c9e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3409,6 +3409,87 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 
 }
 
+#ifdef CONFIG_PM
+/**
+ * mpi3mr_suspend - PCI power management suspend callback
+ * @pdev: PCI device instance
+ * @state: New power state
+ *
+ * Change the power state to the given value and cleanup the IOC
+ * by issuing MUR and shutdown notification
+ *
+ * Return: 0 always.
+ */
+static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct mpi3mr_ioc *mrioc;
+	pci_power_t device_state;
+
+	if (!shost)
+		return 0;
+
+	mrioc = shost_priv(shost);
+	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
+		ssleep(1);
+	mrioc->stop_drv_processing = 1;
+	mpi3mr_cleanup_fwevt_list(mrioc);
+	scsi_block_requests(shost);
+	mpi3mr_stop_watchdog(mrioc);
+	mpi3mr_cleanup_ioc(mrioc, 1);
+
+	device_state = pci_choose_state(pdev, state);
+	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
+	    pdev, pci_name(pdev), device_state);
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, device_state);
+	mpi3mr_cleanup_resources(mrioc);
+
+	return 0;
+}
+
+/**
+ * mpi3mr_resume - PCI power management resume callback
+ * @pdev: PCI device instance
+ *
+ * Restore the power state to D0 and reinitialize the controller
+ * and resume I/O operations to the target devices
+ *
+ * Return: 0 on success, non-zero on failure
+ */
+static int mpi3mr_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct mpi3mr_ioc *mrioc;
+	pci_power_t device_state = pdev->current_state;
+	int r;
+
+	mrioc = shost_priv(shost);
+
+	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
+	    pdev, pci_name(pdev), device_state);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+	mrioc->pdev = pdev;
+	mrioc->cpu_count = num_online_cpus();
+	r = mpi3mr_setup_resources(mrioc);
+	if (r) {
+		ioc_info(mrioc, "%s: Setup resources failed[%d]\n",
+		    __func__, r);
+		return r;
+	}
+
+	mrioc->stop_drv_processing = 0;
+	mpi3mr_init_ioc(mrioc, 1);
+	scsi_unblock_requests(shost);
+	mpi3mr_start_watchdog(mrioc);
+
+	return 0;
+}
+#endif
+
+
 static const struct pci_device_id mpi3mr_pci_id_table[] = {
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_LSI_LOGIC, 0x00A5,
@@ -3424,6 +3505,10 @@ static struct pci_driver mpi3mr_pci_driver = {
 	.probe = mpi3mr_probe,
 	.remove = mpi3mr_remove,
 	.shutdown = mpi3mr_shutdown,
+#ifdef CONFIG_PM
+	.suspend = mpi3mr_suspend,
+	.resume = mpi3mr_resume,
+#endif
 };
 
 static int __init mpi3mr_init(void)
-- 
2.18.1


--000000000000ecb03f05c0514509
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJftFEmFLEiljm9IDrwHSgX55Dj/
zcWJDXY/UNEfbOOpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQxOTExMDMwMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCdNoF3sfhJd5k/VFU7uMGgHW91LW3hkkMy6w3MfJ0TWwV7
v84ZPHMEocFC16AktCRPtM2p9iwVDhfxLpkNwTZYoHrQQ9ZJxY6xDQIeK7Fgt0uO1BXaNsBhDFZ9
J2d1zDfksuS12m58rIykis1+0g7hblErzn52CUMsf4+mZzTh1db2v2wBGHmzYHiqK0GbZSzeTVt+
T50AcaFLMTwweRc3yXg01o3A5wb9oOCWLIQt41QK+/WD6V1ClC6ByufSO79EWnHVA0ZHfUnygM/s
B3QBqh9XgxkyIF4cOnnvX/tpdRfTagphBI81anQh8RMyFOLYO8K4pKw1QrjnUW1x5yBP
--000000000000ecb03f05c0514509--
