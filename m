Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103D6C3F6B0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 13:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbiHDNBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239767AbiHDNA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 09:00:58 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019E163AE
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 06:00:57 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f28so11045456pfk.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2022 06:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc;
        bh=5lr/V3IcGYlzcMMUX0zaLSFXZuNQJVAbCP0x+AtM52U=;
        b=cLkB25K4Qg3eoev7jVEBzGsGBrUzL2ejk8h9ISpQBJQNZzQ/tWzyQwBFmiD6OR4Vsm
         V2ISYFAJB9LL023vuPmvdxDXFKUTz4t4Ty77qCehBsFOdTiaKP1vkig4gmNRyz2nzhjW
         QrOfXdpTpLXVoRAApJ6+hWiPHhHOwnAQOEUlM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=5lr/V3IcGYlzcMMUX0zaLSFXZuNQJVAbCP0x+AtM52U=;
        b=yDW6mVrIh9lSvhG1HRiIfrlejDs8U27pGXwBi5PWeXocq315ob0R7En51lQ6c1RYHw
         JGBbRXLzeSceOKW7uezUQ1P1Sc7wpGyCPFCA3IK6vc8nmpKJIExBU1v03dLKUBtTKaTD
         SAjHBPna40xgIOzA7mJpY/5aoqrGe5xSbByy7+y7jSZVvW8pNvszNApjDjArlqFl4wuj
         F1bhtrdSZDZh41GjXoAmx9M13TjAJkrGmNgytP1LStLk1JJgDf5SMY6DPjg5QVTZDlSL
         Y/x67GL2pS2Zo/XTTKiKVUCOohaTUYaiJlhBA4TNKHs/4JyCIwKPpAal4zRvH1wxRDxU
         S9uQ==
X-Gm-Message-State: ACgBeo2FylbTfnyedRj8boLfCR03j1cz2y7WJuQM/YphHKGHpWcPFqOG
        6ow0FxjKsaIHsr58CeYADxgzCAQABkGkaMvMGsNmIq1Njq5lXNx31Unu1jrDeILGMAGRddvS9XU
        6BG4mlN92GsDJMhkpHTvTDaLPKKOoEgBj1JBwLTcjHLfJYlYppD2cpsGgrHUguTfYS0aodmhX8q
        szZ4daqOmq
X-Google-Smtp-Source: AA6agR4l0K515mxZKhV7WRNpskTFLEg5X1lN3RAeyoiq3kbcZq5Dpk4Ka7bJ0Q82W3MQV7x5rO/hAg==
X-Received: by 2002:a05:6a00:2484:b0:52b:2be0:2191 with SMTP id c4-20020a056a00248400b0052b2be02191mr1645318pfv.51.1659618056090;
        Thu, 04 Aug 2022 06:00:56 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0052e2a1edab8sm934645pfq.24.2022.08.04.06.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 06:00:55 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 15/15] mpi3mr: Block IOs while refreshing target dev objects
Date:   Thu,  4 Aug 2022 18:42:26 +0530
Message-Id: <20220804131226.16653-16-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bb5bb005e569f087"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000bb5bb005e569f087
Content-Transfer-Encoding: 8bit

Block the IOs on the target devices until corresponding
target device's target dev objects are refreshed as part
of post controller reset operation.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 4c8ef9f..e7c461e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -424,6 +424,8 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
 			tgt_priv->io_throttle_enabled = 0;
 			tgt_priv->io_divert = 0;
 			tgt_priv->throttle_group = NULL;
+			if (tgtdev->host_exposed)
+				atomic_set(&tgt_priv->block_io, 1);
 		}
 	}
 }
@@ -835,6 +837,7 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
 	if (tgtdev->starget && tgtdev->starget->hostdata) {
 		tgt_priv = tgtdev->starget->hostdata;
+		atomic_set(&tgt_priv->block_io, 0);
 		tgt_priv->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
 	}
 
@@ -1077,6 +1080,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 		scsi_tgt_priv_data->dev_type = tgtdev->dev_type;
 		scsi_tgt_priv_data->io_throttle_enabled =
 		    tgtdev->io_throttle_enabled;
+		if (is_added == true)
+			atomic_set(&scsi_tgt_priv_data->block_io, 0);
 	}
 
 	switch (dev_pg0->access_status) {
@@ -4577,6 +4582,16 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 
+	if (atomic_read(&stgt_priv_data->block_io)) {
+		if (mrioc->stop_drv_processing) {
+			scmd->result = DID_NO_CONNECT << 16;
+			scsi_done(scmd);
+			goto out;
+		}
+		retval = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto out;
+	}
+
 	dev_handle = stgt_priv_data->dev_handle;
 	if (dev_handle == MPI3MR_INVALID_DEV_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4589,16 +4604,6 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
-	if (atomic_read(&stgt_priv_data->block_io)) {
-		if (mrioc->stop_drv_processing) {
-			scmd->result = DID_NO_CONNECT << 16;
-			scsi_done(scmd);
-			goto out;
-		}
-		retval = SCSI_MLQUEUE_DEVICE_BUSY;
-		goto out;
-	}
-
 	if (stgt_priv_data->dev_type == MPI3_DEVICE_DEVFORM_PCIE)
 		is_pcie_dev = 1;
 	if ((scmd->cmnd[0] == UNMAP) && is_pcie_dev &&
-- 
2.27.0


--000000000000bb5bb005e569f087
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOfdATp8+aOMy2reBnFn
1fUxbeEmrpbKRtgEQveSUYpPMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDgwNDEzMDA1NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCBMZFr8TFdncxeh7JS5QMSce2AfGAhX8OYzRun
mpBAxD5Qyo/Divz0kNhuHj6pOmaruJJR1CyDc9kmfS9Ob4bFgeU8/vSg1JuzSS/6r8oSpU1Ous57
fIZhgaYqDMEpCDMBhdHb3TJEo7Tu0TuFq+wdFsxSrmDwn+3m+2MuCSeIu1UxGG8kOh7qM89LmcSi
yKwA7z0s/iAE3IKWX5/K4AAwuIvrVHAJW8Cp9YICRaiJZM5JCR6bK5LThSUBqjx4l7OZ0mpiVt3x
LpLCyIrkrosrzM/hxdB0T6oM9oaLFD+ads6OIZXdIDLRIYuIVxhS3H6TUwSRZtbUwHfCY/AcmXVD
--000000000000bb5bb005e569f087--
