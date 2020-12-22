Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6377DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 164692310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLVKNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgLVKNn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:43 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66ADC06179C
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:08 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z21so8082379pgj.4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hSFuTn4c87Zp1tlZj/IOFhsdE2XdxzRXMSEk2Co6yxY=;
        b=VAakUyiAoIIzrdXh0nr3Iv5+jL8ZVaIyJDdIu29oxLnUcC8L82XXBzL8SnbMXa5Uwu
         nsQJfb0umzGWdL04JovnqMYbfnDIrY4vcggUCVXq8913/hXl9Xdwofmni6v0y7nask9T
         EyK+/OVXI9szMqaZI7GrqqF9mqtm6MUd79Yfc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=hSFuTn4c87Zp1tlZj/IOFhsdE2XdxzRXMSEk2Co6yxY=;
        b=dXEeMLXPuV4y1vqdzk1NbykuUfNdVqooU4knRNr7SLdfX8HRRflRdzGLF0ch5Fgf2R
         lWCW9MaBArFFRMLYZm9EyiBSP6DhmyHIrCl1gzuW7UZ9y9IXJ7weq2ZAc7fEX7f7Y3bz
         1Yh3HkJAn9+VxYDdCQm1mq/ETurf1jIroE9/sukMGGlepEoMpNJKlu0wkRH9dIJ6O4+7
         lRzNV3Dj6vt18dsBfACogUa3JHwU2Ph9fcjHFYRVobton6RvI24x7dWNIu7mKV/s3JsV
         TzhIVElNDgPAOvJme+q3N998+Z1pi24tMN5uD0xD2l1dnmf6JOUkbilFZX/Atgus2sBZ
         OLVw==
X-Gm-Message-State: AOAM532+Twjc76hBB1vN07vFskTd/gKHyQom+iAdU8gsucZkYCS8zsRI
        O4hHoCCJZkyqAyWAcDQulJmBQ2aJtjaFBGiLRTwLDfvH3V73WRQN45AHX2og2C4C9kCsx5BppK4
        pux7IovgmEMxRWswNySsniGi7AG/7iXmxbxB2ESgmcl5t5Gc0WSEISSKSvbh8yWj4R/si3Wo8BX
        IKCAALsWGJ
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJx9ydENXooi6qrljDeWmobQ4alFvT5KN7AvOE/enGw9oIObCJV7cf2AH4Sdp083FIgospMInQ==
X-Received: by 2002:a63:c00e:: with SMTP id h14mr16187937pgg.108.1608631988049;
        Tue, 22 Dec 2020 02:13:08 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:13:07 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 16/24] mpi3mr: hardware workaround for UNMAP commands to nvme drives
Date:   Tue, 22 Dec 2020 15:41:48 +0530
Message-Id: <20201222101156.98308-17-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003fbd0705b70ad22d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000003fbd0705b70ad22d
Content-Type: text/plain; charset="US-ASCII"

The controller hardware can not handle certain unmap commands for NVMe
drives, this patch adds support in the driver to check those commands and
handle as appropriate.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 07a7b1efbc4f..742cf45d4878 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2865,6 +2865,100 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
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
+		    "%s: CDB received with zero parameter length\n",
+		    __func__);
+		scsi_print_command(scmd);
+		scmd->result = DID_OK << 16;
+		scmd->scsi_done(scmd);
+		return true;
+	}
+
+	if (param_len < 24) {
+		ioc_warn(mrioc,
+		    "%s: CDB received with invalid param_len: %d\n",
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
+		    "%s: CDB received with param_len: %d bufflen: %d\n",
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
+		put_unaligned_be16(param_len, scmd->cmnd+7);
+		scsi_print_command(scmd);
+	}
+
+	kfree(buf);
+	return false;
+}
 
 /**
  * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
@@ -2957,6 +3051,11 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
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


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--0000000000003fbd0705b70ad22d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgT7E3MoqS
FjuynMQPLK6al4YivfdzBqYmIYA23iY6JFkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMzA4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFe6BrD5MtZZmPOqWJwJd/jBtEIv
4yfR7FN4452AJBO7rlBGxTwqV8Zd78oV4oWDXdAlT2k9FhuM2zCiMl/+IV6pme/agoUOPbGba9Gj
ehdIohtp8jBXyRydB6P5SOpKlSCb2oJNabZOficKCdfTRGCVRx8hFqDC9MAqNPjmfHFTopkQa36d
6WqAuVENm6/nxvZqNJUpZ3ZheF/1/Q5Ky59rfF3V41TemQFlLuh93UbHizvqdgwFlk96nNJ3MMUZ
Ut386ELoRLTMVh83nbWY1SlBJozlEBwXn1p40eL8lz1bX75Hb4F09czCn+9foefkPbQ41GbEgp80
mlugdPqAz4M=
--0000000000003fbd0705b70ad22d--
