Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1659C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhLTOEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbhLTOEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D37C06173F
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id k4so9489201pgb.8
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=54nQQal7gZO2EC6fSgoUKGMRJXZNVg+VcDigyuC9B0s=;
        b=LX8GdRmXtwOaneEFf2aDNRKh2opwGaH6BRD977inDS9A1MsQEkOkUOCWZGwWeYaZSk
         XWp54LM8xCP0yYbeYlEMoQ5GsAhXwCycyoXCbEf4QKTvyPbcKFjCo+hOisae591rzecX
         vm1pDTvnUCeuf70LiEHFz6DCYhUBmHh35/2Gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=54nQQal7gZO2EC6fSgoUKGMRJXZNVg+VcDigyuC9B0s=;
        b=FgQCYYEMTiWwlN5AJzoAhorsXrCEXnYPw4dK97e2Aj4R6QzurEvmqq2/9jRa9rxBxC
         bdy9J511dDR1mqwA7hlK+pxIt3zKvNC6gw+nYUFPCv2NUv7iqDG/r4S4ceOBHRAby05K
         6oXJDP1+XCYX1aF06krUYczSQrvoIVlsEZJTMtc/o26DqpiEuoo3+koZzRABx+SLqJ/Y
         xZKOA2a14JJmB69K1nIy82LjwHkVRRc4SaZ1jKpXKjXr2X1gzWngz6Uzbc5emrA72PDT
         nOCEedjQYdzk4m0G7rx0kAkQhuVR6IB5wrWbqHLmaYDK7XSSoS/Bqm2YqZ68jzvREyJj
         astw==
X-Gm-Message-State: AOAM533Ux99LgpJ6eJ0CoV4hW+2Ickqx1R3yOlveDtvdn58M9JomKf9O
        M1+DkpgACe/dzuonN/8nJgS1QgI0zoGCUOBYMylKeULpiviHAaJ2mfjWA8Gi52t9LuPe6HOB+aK
        AlLNrM8mfVUtG7bFjclQN6Glkav1NrFjZsTnpCOTumrfvirrRAa9uKtbvt57mHQPEPa9bVZ2Bjd
        MbynoRszqO
X-Google-Smtp-Source: ABdhPJyq4Ci+cXOZijpmk66ihpOALfrZajIgaSoJhMplfSUMwMb23j/y/hAgHuKkZkAaZRGusEHU/A==
X-Received: by 2002:a63:7981:: with SMTP id u123mr15089516pgc.360.1640009061869;
        Mon, 20 Dec 2021 06:04:21 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:21 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 09/25] mpi3mr: Handling unaligned PLL in unmap cmnds
Date:   Mon, 20 Dec 2021 19:41:43 +0530
Message-Id: <20211220141159.16117-10-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000097f03605d3945d2d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000097f03605d3945d2d
Content-Transfer-Encoding: 8bit

Below special handling is needed for UNMAP commands issued to
NVMe drives,

- On B0 boards, if the parameter list length is greater
than 24 and not 16byte multiple then truncate the
parameter list length to 16byte multiple.

- on A0 boards, if the parameter list length is greater
than block descriptor data length + 8 then truncate the
parameter list length to block descriptor data length + 8
value.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 36 ++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index e961bb2..2a153df 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3344,9 +3344,22 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 	struct scsi_cmnd *scmd)
 {
 	unsigned char *buf;
-	u16 param_len, desc_len;
-
-	param_len = get_unaligned_be16(scmd->cmnd + 7);
+	u16 param_len, desc_len, trunc_param_len;
+
+	trunc_param_len = param_len = get_unaligned_be16(scmd->cmnd + 7);
+
+	if (mrioc->pdev->revision) {
+		if ((param_len > 24) && ((param_len - 8) & 0xF)) {
+			trunc_param_len -= (param_len - 8) & 0xF;
+			dprint_scsi_command(mrioc, scmd, MPI3_DEBUG_SCSI_ERROR);
+			dprint_scsi_err(mrioc,
+			    "truncating param_len from (%d) to (%d)\n",
+			    param_len, trunc_param_len);
+			put_unaligned_be16(trunc_param_len, scmd->cmnd + 7);
+			dprint_scsi_command(mrioc, scmd, MPI3_DEBUG_SCSI_ERROR);
+		}
+		return false;
+	}
 
 	if (!param_len) {
 		ioc_warn(mrioc,
@@ -3406,12 +3419,12 @@ static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (param_len > (desc_len + 8)) {
+		trunc_param_len = desc_len + 8;
 		scsi_print_command(scmd);
-		ioc_warn(mrioc,
-		    "%s: Truncating param_len(%d) to desc_len+8(%d)\n",
-		    __func__, param_len, (desc_len + 8));
-		param_len = desc_len + 8;
-		put_unaligned_be16(param_len, scmd->cmnd + 7);
+		dprint_scsi_err(mrioc,
+		    "truncating param_len(%d) to desc_len+8(%d)\n",
+		    param_len, trunc_param_len);
+		put_unaligned_be16(trunc_param_len, scmd->cmnd + 7);
 		scsi_print_command(scmd);
 	}
 
@@ -3466,6 +3479,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	u32 scsiio_flags = 0;
 	struct request *rq = scsi_cmd_to_rq(scmd);
 	int iprio_class;
+	u8 is_pcie_dev = 0;
 
 	sdev_priv_data = scmd->device->hostdata;
 	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
@@ -3510,8 +3524,10 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
-	if ((scmd->cmnd[0] == UNMAP) &&
-	    (stgt_priv_data->dev_type == MPI3_DEVICE_DEVFORM_PCIE) &&
+	if (stgt_priv_data->dev_type == MPI3_DEVICE_DEVFORM_PCIE)
+		is_pcie_dev = 1;
+	if ((scmd->cmnd[0] == UNMAP) && is_pcie_dev &&
+	    (mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
 	    mpi3mr_check_return_unmap(mrioc, scmd))
 		goto out;
 
-- 
2.27.0


--00000000000097f03605d3945d2d
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIC1NGefkjaMOmUnHpS+d
tYztR8oxZq8dIS8UqHsOgXBxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCLcC8zhdPHhkx0KuoboikvbO6iQ2R3ad5xHPjk
9QDIjC55cUJgHvEI6hdgkn/CR4Sw/5s8kONXu9phBdpWu8WE3rSbgBy4FcwqIRRbSoYYeZ3QuKW9
f1MREAnsx3GeYLHF7iHZOLzG5scbBLkMZj/HxtQMX4C9gRHe71UFlvqWzuV5VGn6J4Os7q+ffsir
ohTP1Cucc7UvQdYl0B+FByO14GhWHKokSKX+EK6dskIwBy8cVT72kQ+GWvjdQbe217/KUuvWLLP+
bPSGaiJBlvD09JZGXwm2NcfwUQmwTdJeYD4m6YE1ZrsQ0pGzVfuFRc6ZAizVcp6tqkszln4+WPad
--00000000000097f03605d3945d2d--
