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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B44DC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F2A61287
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 08:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhEMIfW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 04:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhEMIej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 04:34:39 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DEAC06174A
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s20so13969240plr.13
        for <linux-scsi@vger.kernel.org>; Thu, 13 May 2021 01:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dTnvLtWMOXnLFVeAzW3qil0lhu0pnig2d54hbsvG1tM=;
        b=LRXgbv8fBlQvXusA9DiFJi1DsDxdw0iPzf6LdZR0Yw7lh2mZADddJ6OxCv3nEixNaF
         8DIWOOJYXOwkI8w3fjhLcXSj58yLNZoTEVYT/rahse/M+sXtZrbfOd9Dl3es164B7fW6
         sSnHA7Q42Q3yIQO91gxzrgcLU6yKEpmeWscbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dTnvLtWMOXnLFVeAzW3qil0lhu0pnig2d54hbsvG1tM=;
        b=lwiuQny8zGcyVcFsjrVqOcrlYq++1Rcw8fIvfLSC8U6ZwSylP/W3WJG2koUhvIqlpt
         18bkuh5aq+CEUOFZf/6zB4BmyZXuxMdgfvVwFqsndTzq7/T7OWuJQ3dIzKPfpAwCsxdW
         okH2zdbJCj7oKwoKpAKU8MB2sANx9kRp8SGGojEv92JcSj6gwOi1ARA72c4TdyrA/W3k
         nPAKUKpT7SN4nDdmdroYKL2RuJhgUm/YI9et6psefJ2bDZ0cnNNUBvI/1u3IVJU4KYPP
         FD/y0zsvud0n6Jx0oYjf3MHvz+tzkk7nQ+F4nB1xUBJhPFXoQSrWf3I9pnEHx9EUN3nk
         6/hA==
X-Gm-Message-State: AOAM532i/FonKRLlyRT+7b5Kznlod2IT6KO5MgGYlsK5DQquVZi6Cxld
        E8QGKXD2rn02i9KnfKjqaO0plgXV17xkqBZIoIFgizmIwRAI08xXlklAqXlReyoRb5Ln7SmMIEN
        OLHO+vsC1aI7d9gFvp+r+/obXJP+6znx2VxGa0ScfnBs+LCvtWmNXbmcwl6AH3302RrUIWmnoo/
        2lF48BHg==
X-Google-Smtp-Source: ABdhPJy+5La6ZF6zpA/zp2dYY90iOH3Gm4rPOKXQAr/TZeLqryfk4mlFGawJnZQxkeCjRuGxrwDn4w==
X-Received: by 2002:a17:902:b609:b029:ec:e80d:7ebd with SMTP id b9-20020a170902b609b02900ece80d7ebdmr39501897pls.75.1620894809083;
        Thu, 13 May 2021 01:33:29 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i123sm1632468pfc.53.2021.05.13.01.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:33:28 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v5 16/24] mpi3mr: hardware workaround for UNMAP commands to nvme drives
Date:   Thu, 13 May 2021 14:06:00 +0530
Message-Id: <20210513083608.2243297-17-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
References: <20210513083608.2243297-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000057d89405c231fb64"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000057d89405c231fb64

The controller hardware can not handle certain unmap commands for NVMe
drives, this patch adds support in the driver to check those commands and
handle as appropriate.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 100 ++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 992a0e4d37d1..ad3390e02034 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2776,6 +2776,101 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	return retval;
 }
 
+/**
+ * mpi3mr_check_return_unmap - Whether an unmap is allowed
+ * @mrioc: Adapter instance reference
+ * @scmd: SCSI Command reference
+ *
+ * The controller hardware cannot handle certain unmap commands
+ * for NVMe drives, this routine checks those and return true
+ * and completes the SCSI command with proper status and sense
+ * data.
+ *
+ * Return: TRUE for not  allowed unmap, FALSE otherwise.
+ */
+static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
+	struct scsi_cmnd *scmd)
+{
+	unsigned char *buf;
+	u16 param_len, desc_len;
+
+	param_len = get_unaligned_be16(scmd->cmnd + 7);
+
+	if (!param_len) {
+		ioc_warn(mrioc,
+		    "%s: cdb received with zero parameter length\n",
+		    __func__);
+		scsi_print_command(scmd);
+		scmd->result = DID_OK << 16;
+		scmd->scsi_done(scmd);
+		return true;
+	}
+
+	if (param_len < 24) {
+		ioc_warn(mrioc,
+		    "%s: cdb received with invalid param_len: %d\n",
+		    __func__, param_len);
+		scsi_print_command(scmd);
+		scmd->result = (DRIVER_SENSE << 24) |
+		    SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x1A, 0);
+		scmd->scsi_done(scmd);
+		return true;
+	}
+	if (param_len != scsi_bufflen(scmd)) {
+		ioc_warn(mrioc,
+		    "%s: cdb received with param_len: %d bufflen: %d\n",
+		    __func__, param_len, scsi_bufflen(scmd));
+		scsi_print_command(scmd);
+		scmd->result = (DRIVER_SENSE << 24) |
+		    SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x1A, 0);
+		scmd->scsi_done(scmd);
+		return true;
+	}
+	buf = kzalloc(scsi_bufflen(scmd), GFP_ATOMIC);
+	if (!buf) {
+		scsi_print_command(scmd);
+		scmd->result = (DRIVER_SENSE << 24) |
+		    SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x55, 0x03);
+		scmd->scsi_done(scmd);
+		return true;
+	}
+	scsi_sg_copy_to_buffer(scmd, buf, scsi_bufflen(scmd));
+	desc_len = get_unaligned_be16(&buf[2]);
+
+	if (desc_len < 16) {
+		ioc_warn(mrioc,
+		    "%s: Invalid descriptor length in param list: %d\n",
+		    __func__, desc_len);
+		scsi_print_command(scmd);
+		scmd->result = (DRIVER_SENSE << 24) |
+		    SAM_STAT_CHECK_CONDITION;
+		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
+		    0x26, 0);
+		scmd->scsi_done(scmd);
+		kfree(buf);
+		return true;
+	}
+
+	if (param_len > (desc_len + 8)) {
+		scsi_print_command(scmd);
+		ioc_warn(mrioc,
+		    "%s: Truncating param_len(%d) to desc_len+8(%d)\n",
+		    __func__, param_len, (desc_len + 8));
+		param_len = desc_len + 8;
+		put_unaligned_be16(param_len, scmd->cmnd + 7);
+		scsi_print_command(scmd);
+	}
+
+	kfree(buf);
+	return false;
+}
+
 /**
  * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
  * @scmd: SCSI Command reference
@@ -2867,6 +2962,11 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
+	if ((scmd->cmnd[0] == UNMAP) &&
+	    (stgt_priv_data->dev_type == MPI3_DEVICE_DEVFORM_PCIE) &&
+	    mpi3mr_check_return_unmap(mrioc, scmd))
+		goto out;
+
 	host_tag = mpi3mr_host_tag_for_scmd(mrioc, scmd);
 	if (host_tag == MPI3MR_HOSTTAG_INVALID) {
 		scmd->result = DID_ERROR << 16;
-- 
2.18.1


--00000000000057d89405c231fb64
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQcAYJKoZIhvcNAQcCoIIQYTCCEF0CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3HMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBU8wggQ3oAMCAQICDHA7TgNc55htm2viYDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjU2MDJaFw0yMjA5MTUxMTQ1MTZaMIGQ
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFjAUBgNVBAMTDUthc2h5YXAgRGVzYWkxKTAnBgkqhkiG9w0B
CQEWGmthc2h5YXAuZGVzYWlAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAzPAzyHBqFL/1u7ttl86wZrWK3vYcqFH+GBe0laKvAGOuEkaHijHa8iH+9GA8FUv1cdWF
WY3c3BGA+omJGYc4eHLEyKowuLRWvjV3MEjGBG7NIVoIaTkH4R+6Xs1P4/9EmUA0WI881B3pTv5W
nHG54/aqGUDSRDyWVhK7TLqJQkkiYKB0kH0GkB/UfmU/pmCaV68w5J6l4vz/TG23hWJmTg1lW5mu
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKrr5ssRYAcXgwHJiP7p1288fL65
somkhm+y3YVL3k+HMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMzA4MzMyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCOf301OzXJ7d4Gsz8X+u7dLNse8/XPN970I3P8kUgF7+zd
UnxeLl74cc/KYQPqPpTLzNGZyxcoWiD/Mjq1DgWeshsrQVP+CxfgVEX4NiiGNlta6Lr3FLbr+71H
OvviaQUAXa+Wcyk2pxoMxe9b/PapO82LOOX1E93k9GiTISO1wDpt4IB4Ut1FvadEuDVZjc5vXZkT
ADJZWRG7QCK8Fjg9bG9ayHYql4rk99UwggrsRgphHagkT6QZCYxTBLz45AIFB/071y9rjgn8+aIf
0r5SKFu4ucmTzaaLj476VE1JhE2ZLeWMESPmYvom006h6OQ7xDNedI26XA0izZjUTsPG
--00000000000057d89405c231fb64--
