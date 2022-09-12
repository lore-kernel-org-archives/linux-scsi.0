Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D18C6FA8A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 13:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiILNpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 09:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiILNpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 09:45:31 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C1C1CB3B
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 06:45:30 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id b75so3422514pfb.7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 06:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date;
        bh=Sp4HRuKUmj+sBwaXgteDwjmqjP4oIDle2DgpGiJ4wgo=;
        b=ZC2LS52N3hqvd3EQNzoi0cFGXTOaoT0GqtmNxjgrw0cs6+0gpR0BDXF0IWMYh2mEOE
         DaTfsoC1QuMtMW9Q2qpuZF0mV4OZIkCHwXx6k2p8FyZku66t4nMjOyDv9s7nW/TU9vjJ
         Q/FmoeN/4zdMC/rbKepX/83jtUdkn1TLL66NM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=Sp4HRuKUmj+sBwaXgteDwjmqjP4oIDle2DgpGiJ4wgo=;
        b=cpT94OTZaJ14ziampKDYYGmaPS+7uPmv3poPUJP8OUs1SBHfMry6lf3ayeoP+pkSZu
         9oMOGvOLbUH8bGtbG5fWqbDGIn1+obljjgoh9kh9ixBfhpf4X1V0N1sSNK2UA4eLhnUI
         OKWxZ7tzrM9hr0kxZbJpcLY+zswOPS9pllzr/6YzpuaTW2wy/WPJeTdkrRuZCIhrumF3
         Hbjq4I2biR9Xa+FQwKNlG2ieyiXGV0g71akeBLiHmeRZQdrLppRKgd+3MCYsReclBXSs
         i3aPDzf4qFhijCio5cOCXncpgp9731xtoEzZRo/JJ3g56gIWHzPdYSoutI05A9wVCfki
         5WzQ==
X-Gm-Message-State: ACgBeo1SyRSx0hFoPJS+P9L31z9jeRnoDxBRHveCDblvAbjFa87JEMCF
        R9n5Y1mpKvai16hgcmkCwEWiHSvCTijAXv2donQcw7tgvmDDHClQN3JVBE/WhSxHZg4TjBJh9s1
        O9WP0rlYcvt6BdIMnYubJ+rGO4MiI5x1/jDJ8eZ5CPuP53FtuOeb2Fap6yVi6rv7GwhI4n4YDug
        2TJLn6W1N2
X-Google-Smtp-Source: AA6agR5/UVVntOskEvYiPiB0mEBvdOLNYUDsxNOtpuB0j8HrlHN4H9zFUB82sdyccH04+/fVH35iQA==
X-Received: by 2002:a63:31d6:0:b0:434:af58:c988 with SMTP id x205-20020a6331d6000000b00434af58c988mr23254937pgx.29.1662990329800;
        Mon, 12 Sep 2022 06:45:29 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u7-20020a170903124700b00176e8f85146sm6112900plh.185.2022.09.12.06.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 06:45:29 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v2 2/9] mpi3mr: Support new power management framework
Date:   Mon, 12 Sep 2022 19:27:35 +0530
Message-Id: <20220912135742.11764-3-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220912135742.11764-1-sreekanth.reddy@broadcom.com>
References: <20220912135742.11764-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e7b3cf05e87b1b9a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000e7b3cf05e87b1b9a
Content-Transfer-Encoding: 8bit

Switched to the new generic PCI PM (Power Management)
framework. Also, removed unnecessary calls to the
PCI Helper functions (such as pci_set_power_state(),
pci_enable_wake(), pci_save_state(), pci_restore_state()
etc).

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 22f1a06..f1a6448 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5094,22 +5094,21 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	mpi3mr_cleanup_resources(mrioc);
 }
 
-#ifdef CONFIG_PM
 /**
  * mpi3mr_suspend - PCI power management suspend callback
- * @pdev: PCI device instance
- * @state: New power state
+ * @dev: Device struct
  *
  * Change the power state to the given value and cleanup the IOC
  * by issuing MUR and shutdown notification
  *
  * Return: 0 always.
  */
-static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+mpi3mr_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct mpi3mr_ioc *mrioc;
-	pci_power_t device_state;
 
 	if (!shost)
 		return 0;
@@ -5123,27 +5122,26 @@ static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
 	mpi3mr_stop_watchdog(mrioc);
 	mpi3mr_cleanup_ioc(mrioc);
 
-	device_state = pci_choose_state(pdev, state);
-	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
-	    pdev, pci_name(pdev), device_state);
-	pci_save_state(pdev);
+	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state\n",
+	    pdev, pci_name(pdev));
 	mpi3mr_cleanup_resources(mrioc);
-	pci_set_power_state(pdev, device_state);
 
 	return 0;
 }
 
 /**
  * mpi3mr_resume - PCI power management resume callback
- * @pdev: PCI device instance
+ * @dev: Device struct
  *
  * Restore the power state to D0 and reinitialize the controller
  * and resume I/O operations to the target devices
  *
  * Return: 0 on success, non-zero on failure
  */
-static int mpi3mr_resume(struct pci_dev *pdev)
+static int __maybe_unused
+mpi3mr_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct mpi3mr_ioc *mrioc;
 	pci_power_t device_state = pdev->current_state;
@@ -5156,9 +5154,6 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 
 	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
 	    pdev, pci_name(pdev), device_state);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
 	mrioc->pdev = pdev;
 	mrioc->cpu_count = num_online_cpus();
 	r = mpi3mr_setup_resources(mrioc);
@@ -5180,7 +5175,6 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 
 	return 0;
 }
-#endif
 
 static const struct pci_device_id mpi3mr_pci_id_table[] = {
 	{
@@ -5191,16 +5185,15 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
 
+static SIMPLE_DEV_PM_OPS(mpi3mr_pm_ops, mpi3mr_suspend, mpi3mr_resume);
+
 static struct pci_driver mpi3mr_pci_driver = {
 	.name = MPI3MR_DRIVER_NAME,
 	.id_table = mpi3mr_pci_id_table,
 	.probe = mpi3mr_probe,
 	.remove = mpi3mr_remove,
 	.shutdown = mpi3mr_shutdown,
-#ifdef CONFIG_PM
-	.suspend = mpi3mr_suspend,
-	.resume = mpi3mr_resume,
-#endif
+	.driver.pm = &mpi3mr_pm_ops,
 };
 
 static ssize_t event_counter_show(struct device_driver *dd, char *buf)
-- 
2.27.0


--000000000000e7b3cf05e87b1b9a
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEM5P3GnAUSKZWdbIFa3
EliCoAqA9HEV8iAC7kRkd0D+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDkxMjEzNDUzMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCt2aepkNVfALYxkW4fetyDr+lNKfkctifEGH9y
2G0NaawEWUq37ndg/ZVTJMRmMtNph91ujp2lYrsrQgi3p5ZympfSlmPgX5kG5IKPadkdjjb3VUJQ
EY4CtvweYuIxbMAx7GnkABQXup7gGBhruZe8FycLkRpTlZCqK/PODDPcsRZ7BoegSEzWMB8h/IWU
X0a0J/VtnsWrJeKaBkyUoE//xdOixkmXfoVI4S66TQRUD/S8EKzWreOjJn4sxT4ucGtJhMBa8fXX
QTkutxVtcmM9FJqF9Q3ptkUhxB7Iu2/zdOW2PN8dQapTpFPT7IAGaE/6AbrxtdXjtkNpXFUGsFUi
--000000000000e7b3cf05e87b1b9a--
