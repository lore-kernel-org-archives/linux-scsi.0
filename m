Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FCCC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhLTOEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhLTOEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:36 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF39C061401
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:36 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id v25so4401405pge.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=YSud9AYv114NQxl501NNFTjwP/ugNnXMRXF2t3ZBqlM=;
        b=M+otdVNxtoneHKFhae3t85l40U1sd88K9A/6TE9vgUg5jcdCpJ/5G2IxTVIdAs4DXI
         uup9oi4cRE8RyLV5xSNscDnDLCfZiG8JM4ky+vSFghRWkr20FZpZMsclaJCXdzBJ5OkG
         q+vwHxBWvjs8ktBlPVJdBiuY4u7/2KZuVptJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=YSud9AYv114NQxl501NNFTjwP/ugNnXMRXF2t3ZBqlM=;
        b=Nf39OVEo0F3YqRgdGsfl0b2Idao+glI7WiK7hqgszDQ8x9zOfkB1zPDjdg7+jkdtug
         SdtI9DPbpD8vKZMtq+J9rt4jwNDvufiDiz0ukd2APdBQl9QKmYMfacjwHqA4Xh5qw5a3
         Lr1Gj08hvJJ6WbpU7pfQx2HwQJ0RDHKUbN1X3N+T04qEXAFo09aD/b7SB3BdQDC7fTGo
         HY/yxgR6xhc2j4PqVFalFAvmtBKy+mtotuQ73DoBqvv5oQcXgURKeK6yRrf3Cb2xW4QE
         D0bmRGLwkowZtHhCuUpszqY+TEbQ9VfIEkIu6zBN3RN//Y1VJ844j1c82LwCrcrlFPeS
         DKTA==
X-Gm-Message-State: AOAM533YwIS198iesPW1c1eRWu3UbOQkyDVf7DnsiEatdS9Yfj6cePwq
        POd+JBFxXSaDVuDZK3wHPK5TZEOpvxViReZHn+Ymk9zVRzld32dTSSQWW4JCAzUsjdTbX21i9UH
        wfWpFfoRTwgUl1NR1YUTarWewHWFkXZbcJpI/+Sw1kINCANsCvJ6DUgF7Wrt92OH3NWi/KW4PhA
        iC2yxvQQj2
X-Google-Smtp-Source: ABdhPJwVrsyenEP9uaHg47/Phel3IyQOy9J37qFVlvV2Fh95aeTeLMwzfyWSoGZssDDXKvO6k0AkmA==
X-Received: by 2002:a63:9854:: with SMTP id l20mr15100734pgo.536.1640009075115;
        Mon, 20 Dec 2021 06:04:35 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:34 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 15/25] mpi3mr: Add IOC reinit function
Date:   Mon, 20 Dec 2021 19:41:49 +0530
Message-Id: <20211220141159.16117-16-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000062284605d3945e5f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000062284605d3945e5f
Content-Transfer-Encoding: 8bit

Adding IOC reinitialization function.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 116 +++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index bad708a..a7cd02f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3568,10 +3568,124 @@ out_failed_noretry:
 	return retval;
 }
 
+/**
+ * mpi3mr_reinit_ioc - Re-Initialize the controller
+ * @mrioc: Adapter instance reference
+ * @is_resume: Called from resume or reset path
+ *
+ * This the controller re-initialization routine, executed  from
+ * the soft reset handler or resume callback. creates
+ * operational reply queue pairs, allocate required memory for
+ * reply pool, sense buffer pool, issue IOC init request to the
+ * firmware, unmask the events and issue port enable to discover
+ * SAS/SATA/NVMe devices and RAID volumes.
+ *
+ * Return: 0 on success and non-zero on failure.
+ */
 int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 {
+	int retval = 0;
+	u8 retry = 0;
+	struct mpi3_ioc_facts_data facts_data;
 
-	return 0;
+retry_init:
+	dprint_reset(mrioc, "bringing up the controller to ready state\n");
+	retval = mpi3mr_bring_ioc_ready(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to bring to ready state\n");
+		goto out_failed_noretry;
+	}
+
+	if (is_resume) {
+		dprint_reset(mrioc, "setting up single ISR\n");
+		retval = mpi3mr_setup_isr(mrioc, 1);
+		if (retval) {
+			ioc_err(mrioc, "failed to setup ISR\n");
+			goto out_failed_noretry;
+		}
+	} else
+		mpi3mr_ioc_enable_intr(mrioc);
+
+	dprint_reset(mrioc, "getting ioc_facts\n");
+	retval = mpi3mr_issue_iocfacts(mrioc, &facts_data);
+	if (retval) {
+		ioc_err(mrioc, "failed to get ioc_facts\n");
+		goto out_failed;
+	}
+
+	mpi3mr_process_factsdata(mrioc, &facts_data);
+
+	mpi3mr_print_ioc_info(mrioc);
+
+	dprint_reset(mrioc, "sending ioc_init\n");
+	retval = mpi3mr_issue_iocinit(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to send ioc_init\n");
+		goto out_failed;
+	}
+
+	dprint_reset(mrioc, "getting package version\n");
+	retval = mpi3mr_print_pkg_ver(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to get package version\n");
+		goto out_failed;
+	}
+
+	if (is_resume) {
+		dprint_reset(mrioc, "setting up multiple ISR\n");
+		retval = mpi3mr_setup_isr(mrioc, 0);
+		if (retval) {
+			ioc_err(mrioc, "failed to re-setup ISR\n");
+			goto out_failed_noretry;
+		}
+	}
+
+	dprint_reset(mrioc, "creating operational queue pairs\n");
+	retval = mpi3mr_create_op_queues(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to create operational queue pairs\n");
+		goto out_failed;
+	}
+
+	if (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q) {
+		ioc_err(mrioc,
+		    "cannot create minimum number of operatioanl queues expected:%d created:%d\n",
+		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
+		goto out_failed_noretry;
+	}
+
+	dprint_reset(mrioc, "enabling events\n");
+	retval = mpi3mr_enable_events(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "failed to enable events\n");
+		goto out_failed;
+	}
+
+	ioc_info(mrioc, "sending port enable\n");
+	retval = mpi3mr_issue_port_enable(mrioc, 0);
+	if (retval) {
+		ioc_err(mrioc, "failed to issue port enable\n");
+		goto out_failed;
+	}
+
+	ioc_info(mrioc, "controller %s completed successfully\n",
+	    (is_resume)?"resume":"re-initialization");
+	return retval;
+out_failed:
+	if (retry < 2) {
+		retry++;
+		ioc_warn(mrioc, "retrying controller %s, retry_count:%d\n",
+		    (is_resume)?"resume":"re-initialization", retry);
+		mpi3mr_memset_buffers(mrioc);
+		goto retry_init;
+	}
+out_failed_noretry:
+	ioc_err(mrioc, "controller %s is failed\n",
+	    (is_resume)?"resume":"re-initialization");
+	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
+	    MPI3MR_RESET_FROM_CTLR_CLEANUP);
+	mrioc->unrecoverable = 1;
+	return retval;
 }
 
 /**
-- 
2.27.0


--00000000000062284605d3945e5f
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIolyrecctGcPKlxHgOo
NB/F1jMlpuYxRSSoMpok8JhyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAP0J1ZfO1HqI8x8DjkGgL5Nl/u5Ao7/cYdgfyl
GzbP6JDSIO1E64p6UNSuWYam5/JyiCK/lwaZg89yS24eEB450nvimzEhJQy7iWRb797oyAF1f4pk
wppe7AHvdC3aF4wCkunQM8/RVv25cAqjvRKZ1P4vml+I73/3zhqNK4+PHvU1E4PMYGTDBhT0qqWA
1EZupKGGti5v0cZ6h31hxwVtHCh+1z0kp40Uv3H1QK7xLvC8eDL2ToySHAG2sKLcu0nbYufVu2fA
t4KlYW9EZ5sofMk6rwMXAN+idSN5+VAsouQuy/kXze2oHmLqkpK19MVgr+17fno8+t/HyHLSLDIM
--00000000000062284605d3945e5f--
