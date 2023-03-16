Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45771C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 11:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCPLCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCPLCr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 07:02:47 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371942BD3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 04:02:46 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso5498896pjc.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 04:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678964566;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1e6sd+iqPYSj3saO2b3H259lVccRxjAWhdpUcWBve8w=;
        b=bcAEI6ZZ7PAunmATlFUORcbf103Ke1nVZ/7bMeQ0/c/hp3nGZM5Sig3NLr36UuNhQM
         KC7Du0Qm1ty428bb/OO68MJUZPHeIOMgoMSmW2jWlVugIrZ/cSR2dP4MzQVS4M8R0c8T
         JSj7LU72YMh9/TIfb7/RcbImmpx99gOa3fxYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678964566;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1e6sd+iqPYSj3saO2b3H259lVccRxjAWhdpUcWBve8w=;
        b=JymLDBwr0yIswiCgdfGWwohm0GU2AuQ15YV8BTrKqMOnx68AQCRvwhzrV7YpoSeHQw
         0S08L3p+rqdFgUUbz2nlhUIKw3orHXf31s7tkezx4ykr86VdiYNirJRoSHlx5VF8cKXb
         ZtQSIDGEMfQG5Ce0+jSSwr2JrqGnIk6qUcuLsMZhoEiujQN5dN2odQo+UdHuJCsim1qG
         AtYTfvUqRDQBs4yfWqI/y3zStnYSegd7lVpo9VT2+Nh+3lxR8fwIG4is6Y4uFGXsquAn
         jAfaWIULSMZUXkyC8jeW1S6vdWPG+VLzv69Nf3mwLaLn8RUhefPhy3IogVCn8fkQo3zF
         FlNg==
X-Gm-Message-State: AO0yUKWpQ0aH0F/ldWLCa8e6ghAWpywocSZ7WXxwpp+D41dNeMS6mER3
        424Rar/ZG1Hfj26mhOfuYN+F/QGyKvm+CRHlMgp6jfOaXn7rlofRseLdEcazmECtBDkxq2IlQCO
        anHrSZs9AbemOxVbj0age8j8L9JdqYwNXtQo3O8FhKaZeFrK/qAgoYEn9lUGPJjTf9+cKMXDJvw
        iyr8RClOfrEQ==
X-Google-Smtp-Source: AK7set+ALayAwJdGzhM1IzAGjBdH1Tb7RQzH3rOmS3s6rfMRa631DlB3MHkFcOTg/ve7BXrFz3YHyQ==
X-Received: by 2002:a17:902:f109:b0:19e:8bfe:7d68 with SMTP id e9-20020a170902f10900b0019e8bfe7d68mr2393360plb.11.1678964565999;
        Thu, 16 Mar 2023 04:02:45 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id kb5-20020a170903338500b0019a6cce2060sm5343590plb.57.2023.03.16.04.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 04:02:45 -0700 (PDT)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 4/8] mpi3mr: Avoid escalating to higher level reset when target is removed
Date:   Thu, 16 Mar 2023 16:32:05 +0530
Message-Id: <20230316110209.60145-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
References: <20230316110209.60145-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009322e805f7026688"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009322e805f7026688
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
index 7ebd00dfd396..b5daa76e8628 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4015,10 +4015,14 @@ static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
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
@@ -4083,10 +4087,14 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
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
@@ -4644,13 +4652,24 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
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
@@ -4661,7 +4680,6 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
-	dev_handle = stgt_priv_data->dev_handle;
 	if (dev_handle == MPI3MR_INVALID_DEV_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scsi_done(scmd);
-- 
2.31.1


--0000000000009322e805f7026688
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOqnR5CINJDpsqGj93/1RrtMlEaTmV7p
twMFvFPvkAx1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMx
NjExMDI0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBiKNYL7jeVlL2S1p8fl7tacxLIfI3obmRLTog6spOYnRPV+DWZ
I2UyAwa3IYjRfT40Lg+LXyhokjdwxImaoNAzQQ2IQNzzc+/Bd485j7k5yRAVCRty7E2QD9TWmK2X
S4ti3yq9dRYHzsRgMWv6W/RJk0dRI05GvmwIbSVR+mvOLxiiljzxt95AW2gqVrmRFEUO4p3kOHfH
iG1cmR4mkafk7sU1HVG7rgTgvYBt3w+7V/Urwx08+3+xH6fgp8GuA5BgjncwApnFtF09vKRs2PaT
dYGoIr4A4Iov+we8vq9qHvE5M/G0498Q3o1sKYlfeQGtetX6YFF7lxgxyXwkCy+y
--0000000000009322e805f7026688--
