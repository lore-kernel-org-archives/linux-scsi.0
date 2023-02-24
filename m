Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E35C61DA3
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 14:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjBXOoN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 09:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjBXOoF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 09:44:05 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3011689A
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:44:03 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so6365705pjn.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Feb 2023 06:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pCSVyte/o5B+z6Oc0FZZkMKAqKb8UhZ5biDRytHoip8=;
        b=cZYI0BKJ0JnZIze7cj6BbfFLTK6lMG0Ysg0+UN/Wn8qk9Gu+89kfebL/p/m8gLTYzn
         b3aQ3HNsRwTqBQoMzTfv6aJuNdePtu/vfuzeWL9JDm8BgIiL+SAGaZqxSVrk/ui15Kk3
         aiqZhBl+/N4tsmkJ1TkpkJTjRUbVgQnSgjeSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pCSVyte/o5B+z6Oc0FZZkMKAqKb8UhZ5biDRytHoip8=;
        b=4CV/3+dmCU48lU0fLdBdv0C5P8ah8YXwTe3PLs9aZyI2fR/G3YT8FjrowAkvrodlor
         5qf5B18PGZjL/jkPXNwCMl4kIHE8+tM07UOABGw6Itb8S20do6oRl4jvq1ceHIgNUx42
         Wtrg+TC2WA/MZ1G/CI1pIsHYfWPB3tRCIlqeSg18TgKrqKTwDjr4rt54lvdI/3VTw27E
         +Go6QHyH+17dirWcYczXtjfGLXYAyxbTInx9rwZiYiwtslSvgCtFI0YC4v3h4KUgeX3t
         C0Oh8Oflj7W06eFvT9QcikDNik/q+YBjW47p1y+l/f2by2FVkc3o7FpbpxyV7VvRXIYc
         vqIA==
X-Gm-Message-State: AO0yUKWnhG/woomnCXSNbXLFzbX+yscHDWuE66ajRHXDBR4n8PxKX5yD
        bkcc0Yw6hXu0NwLkCf6PrbWZaaIbA3V0n5TmcBQxw7SCx3BAxxO789WaJaWHiwQENj2GHpsPHeK
        HRkGEy68EwiuiKQ6zxeXvO75S4bHlfzwj7M0nPBIThdwGChc2UnUivzwMjmMrK1/n5fGnad1JYD
        hGR0Mu6dw=
X-Google-Smtp-Source: AK7set8vHjC1YXkrmj5AnVVjpATdwd+0tK9Qi8OwX2EvDmrSv8lT2R4/9WZvbuUGeYUobqG6GtBd9w==
X-Received: by 2002:a17:902:e547:b0:19a:abb0:1e with SMTP id n7-20020a170902e54700b0019aabb0001emr19749210plf.38.1677249842356;
        Fri, 24 Feb 2023 06:44:02 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902a9c500b00186748fe6ccsm8911549plr.214.2023.02.24.06.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:44:02 -0800 (PST)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 03/15] mpi3mr: Avoid escalating to higher level reset when target is removed
Date:   Fri, 24 Feb 2023 06:43:08 -0800
Message-Id: <20230224144320.10601-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
References: <20230224144320.10601-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000141cce05f57329a9"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000141cce05f57329a9
Content-Transfer-Encoding: 8bit

SCSI error handling has taking place for timed out IOs on a drive and
the corresponding drive is removed, then stop escalating to higher level
of reset by returning the TUR with "I_T NEXUS LOSS OCCURRED" sense key.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index dd3a84f73e1b..3677473a0211 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3994,10 +3994,14 @@ static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 	dev_handle = stgt_priv_data->dev_handle;
 	if (stgt_priv_data->dev_removed) {
+		struct scmd_priv *cmd_priv = scsi_cmd_priv(scmd);
 		sdev_printk(KERN_INFO, scmd->device,
 		    "%s:target(handle = 0x%04x) is removed, target reset is not issued\n",
 		    mrioc->name, dev_handle);
-		retval = FAILED;
+		if (!cmd_priv->in_lld_scope || cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID)
+			retval = SUCCESS;
+		else
+			retval = FAILED;
 		goto out;
 	}
 	sdev_printk(KERN_INFO, scmd->device,
@@ -4062,10 +4066,14 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 	dev_handle = stgt_priv_data->dev_handle;
 	if (stgt_priv_data->dev_removed) {
+		struct scmd_priv *cmd_priv = scsi_cmd_priv(scmd);
 		sdev_printk(KERN_INFO, scmd->device,
 		    "%s: device(handle = 0x%04x) is removed, device(LUN) reset is not issued\n",
 		    mrioc->name, dev_handle);
-		retval = FAILED;
+		if (!cmd_priv->in_lld_scope || cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID)
+			retval = SUCCESS;
+		else
+			retval = FAILED;
 		goto out;
 	}
 	sdev_printk(KERN_INFO, scmd->device,
@@ -4623,13 +4631,24 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
+	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	dev_handle = stgt_priv_data->dev_handle;
+
+	/* Avoid error handling escalation when device is removed or blocked */
+
+	if (scmd->device->host->shost_state == SHOST_RECOVERY &&
+		scmd->cmnd[0] == TEST_UNIT_READY &&
+		(stgt_priv_data->dev_removed || (dev_handle == MPI3MR_INVALID_DEV_HANDLE))) {
+		scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
+		scsi_done(scmd);
+		goto out;
+	}
+
 	if (mrioc->reset_in_progress) {
 		retval = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
 
-	stgt_priv_data = sdev_priv_data->tgt_priv_data;
-
 	if (atomic_read(&stgt_priv_data->block_io)) {
 		if (mrioc->stop_drv_processing) {
 			scmd->result = DID_NO_CONNECT << 16;
@@ -4640,7 +4659,6 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
-	dev_handle = stgt_priv_data->dev_handle;
 	if (dev_handle == MPI3MR_INVALID_DEV_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scsi_done(scmd);
-- 
2.31.1


--000000000000141cce05f57329a9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIB1uVXc/nXSkIOjbxfbOvD088S0m0xOi
6mLomXd/omYBMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDIy
NDE0NDQwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAX2obNbnFVvlaOnfVxu99FNpNDfsvo/+FSg54PwOrQ/eCqne8a
vFN7sgO6cD33oh/lBFCJ7xcuHrplUDk3e7vfpsuqBno+kvAla+FHproYkZm54Q/Kd2IJPArHR7WH
ykYJbG3ldwaZSDDbK3y/48m1ySVjNAEgqCo41aHDvH91Ka/ukomTKDoeX6uqiVtBeZOLepfvA+wR
gp0V5uBr2NkE1iacyEiUXL5AlATJrCy1L3CWmVsJkQnQ/JvZWgJN3hNKa2/WkkXF8ijdKRk7Cei0
MvrllKLVlSfbkkg041GYSM6R1THtXrcCwf7LT5RxEidwkyvc4M9MryaZMJ1v+o4u
--000000000000141cce05f57329a9--
