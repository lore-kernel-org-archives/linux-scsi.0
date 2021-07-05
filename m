Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_NO_TEXT,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F475C07E99
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 14:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131E961946
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 14:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhGEO5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 10:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhGEO5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 10:57:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C837C061574
        for <linux-scsi@vger.kernel.org>; Mon,  5 Jul 2021 07:54:54 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y2so3741153pff.11
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jul 2021 07:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=ITrlDOqHObdtThsykOyImIWdM8vJK/9uUKBUKUm0pE4=;
        b=NpzX3wmgUjV4l1QlFrrQDtPcHFrtmyxN7sXGOUojamBG+3lhL2H8z6IepMVRPlRhOz
         EHgEytzBXtW38pTiydT4dmIMalzEocwy0JiuBifOi7NIWqbJpvC/dlI7e3wGKF71WF/o
         iY7KqcWtjcrlFX+SmJK7CfuzXdcBMTfGiYf7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=ITrlDOqHObdtThsykOyImIWdM8vJK/9uUKBUKUm0pE4=;
        b=trGKIKgl/0s9Gmdjv8Ie3V8MEaIeyrk7JTgxMCWr94TuDVwQPsvr1u7Yq0gkgwAtqf
         Dhn2uSH4THAFmM88VfCRpF/ed/iztDtykcn9r1PxuVOEKPVAYpBO80lQedBBOPi35Rdm
         zi9TamFwSx4L9Qhj+OzNCyzy+x7nlQ3HnLpZDxuyETsAOWNrStl5FZlFz70lgdQ3zWUg
         fOycEJpA8EBVrjmxVHATQHOEflMUf4AcFeQ6Rhr412pizaemFTqFX10KF21CmlqE66PW
         9rIzes49dGNCB3GEQP+YBn4BZigt2gpIRtoGrVWcimLqaDUalbyQSnDrd4sQbpyByGTa
         vAKQ==
X-Gm-Message-State: AOAM532SjVW9C3PJwEWC2mu0TMi4zLfzSbSZv529zjV9hVYl+7bl/eeL
        QxVGYU34IWHymvvFuFwE1z+5+22Mr6hd1Yco/W7eQwZaYGUJx04kysffj5Faj+fTOMoEPmKoYaw
        0QtnkiPYE68Zb61wXK7GVQdKZ6Q+rM5X5xv8XP8ezcD0zDrd+9RCAFv5pluCZwIeyBTB2+bRIWo
        nAn34MkNvhXh1XyA==
X-Google-Smtp-Source: ABdhPJzCGktl5se7A3Z6JwR+1xqEcTubxDqLodqghIHqJWsYdqr+4SG8dKiHDPMfP1eQ0hFoyexE3A==
X-Received: by 2002:a63:8948:: with SMTP id v69mr13949430pgd.99.1625496893269;
        Mon, 05 Jul 2021 07:54:53 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g9sm12215162pfj.49.2021.07.05.07.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 07:54:52 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     thenzl@redhat.com, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Move IOC state to Ready state during shutdown
Date:   Mon,  5 Jul 2021 20:29:50 +0530
Message-Id: <20210705145951.32258-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f18ae105c6617cc9"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f18ae105c6617cc9
Content-Transfer-Encoding: 8bit

During shutdown just move the IOC state to Ready state
by issuing MUR. No need to free any IOC memory pools.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 32 ++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 ++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  7 +++++-
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c39955239d1c..19b1c0cf5f2a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2983,13 +2983,13 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_free_irq - free irq
+ * mpt3sas_base_free_irq - free irq
  * @ioc: per adapter object
  *
  * Freeing respective reply_queue from the list.
  */
-static void
-_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct adapter_reply_queue *reply_q, *next;
 
@@ -3191,12 +3191,12 @@ _base_check_and_enable_high_iops_queues(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * _base_disable_msix - disables msix
+ * mpt3sas_base_disable_msix - disables msix
  * @ioc: per adapter object
  *
  */
-static void
-_base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
+void
+mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc)
 {
 	if (!ioc->msix_enable)
 		return;
@@ -3304,8 +3304,8 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0; i < ioc->reply_queue_count; i++) {
 		r = _base_request_irq(ioc, i);
 		if (r) {
-			_base_free_irq(ioc);
-			_base_disable_msix(ioc);
+			mpt3sas_base_free_irq(ioc);
+			mpt3sas_base_disable_msix(ioc);
 			goto try_ioapic;
 		}
 	}
@@ -3342,8 +3342,8 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER *ioc)
 
 	dexitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
-	_base_free_irq(ioc);
-	_base_disable_msix(ioc);
+	mpt3sas_base_free_irq(ioc);
+	mpt3sas_base_disable_msix(ioc);
 
 	kfree(ioc->replyPostRegisterIndex);
 	ioc->replyPostRegisterIndex = NULL;
@@ -7613,14 +7613,14 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 }
 
 /**
- * _base_make_ioc_ready - put controller in READY state
+ * mpt3sas_base_make_ioc_ready - put controller in READY state
  * @ioc: per adapter object
  * @type: FORCE_BIG_HAMMER or SOFT_RESET
  *
  * Return: 0 for success, non-zero for failure.
  */
-static int
-_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
+int
+mpt3sas_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type)
 {
 	u32 ioc_state;
 	int rc;
@@ -7897,7 +7897,7 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->chip_phys && ioc->chip) {
 		mpt3sas_base_mask_interrupts(ioc);
 		ioc->shost_recovery = 1;
-		_base_make_ioc_ready(ioc, SOFT_RESET);
+		mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 		ioc->shost_recovery = 0;
 	}
 
@@ -8017,7 +8017,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->build_sg_mpi = &_base_build_sg;
 	ioc->build_zero_len_sge_mpi = &_base_build_zero_len_sge;
 
-	r = _base_make_ioc_ready(ioc, SOFT_RESET);
+	r = mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 	if (r)
 		goto out_free_resources;
 
@@ -8471,7 +8471,7 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADAPTER *ioc,
 	_base_pre_reset_handler(ioc);
 	mpt3sas_wait_for_commands_to_complete(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
-	r = _base_make_ioc_ready(ioc, type);
+	r = mpt3sas_base_make_ioc_ready(ioc, type);
 	if (r)
 		goto out;
 	_base_clear_outstanding_commands(ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d4834c8ee9c0..0c6c3df0038d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1730,6 +1730,10 @@ do {	ioc_err(ioc, "In func: %s\n", __func__); \
 	status, mpi_request, sz); } while (0)
 
 int mpt3sas_wait_for_ioc(struct MPT3SAS_ADAPTER *ioc, int wait_count);
+int
+mpt3sas_base_make_ioc_ready(struct MPT3SAS_ADAPTER *ioc, enum reset_type type);
+void mpt3sas_base_free_irq(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_base_disable_msix(struct MPT3SAS_ADAPTER *ioc);
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 866d118f7931..8e64a6f14542 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11295,7 +11295,12 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
-	mpt3sas_base_detach(ioc);
+	mpt3sas_base_mask_interrupts(ioc);
+	ioc->shost_recovery = 1;
+	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
+	ioc->shost_recovery = 0;
+	mpt3sas_base_free_irq(ioc);
+	mpt3sas_base_disable_msix(ioc);
 }
 
 
-- 
2.27.0


--000000000000f18ae105c6617cc9
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDweiFqOveutVpjfg0u3
vGSD9hFEox2+n2Bhm3XqDpdEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMDcwNTE0NTQ1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAJLEvaLJLTNPpCxh0KVnTZqDNR/tX26FmVJBIb
37dGzHWcZipJpzE/zuVDaWc+2kQtRASgsDhXuieUUNBAhm+BmcMC3Ak20utuJDkbKx0yWhpg9ORw
1+uyxBGGQ8HveCKKPFo4oF1fk/UovUkvKh5NjZrUPTfkXIo3UrG7L6IvhieaDyonausmVPUirIWa
8HTFEUFDtoLdDMLDtDZI0GiUeOQojT4NutngXqUf1Fg8PoFOvljVXN8fTioSeziThBrvnw7TWbSj
+NthOl1fg/b5iKLNw86AR+nA4cSowAN2X/10dmXoiqXLHoZm6qXW3Hc4E1GZtD1Z8cPdG8gHPu4x
--000000000000f18ae105c6617cc9--
