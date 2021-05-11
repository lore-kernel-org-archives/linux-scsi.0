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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EF4C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 19:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A765617ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 19:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhEKTxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 May 2021 15:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhEKTxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 May 2021 15:53:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61AFC06138D
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 12:52:11 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id m124so16488296pgm.13
        for <linux-scsi@vger.kernel.org>; Tue, 11 May 2021 12:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aQDthXbkdWmKetycqCMcVCa3NGt9kd5rhmOaFO5JpOU=;
        b=GBxRcG2DsGU5B3BqlnaYv4GFU3FjH86uWKnG/KAfpX1tbp+f7Gr5PwPtCgn6IeXiUq
         f6kVJ4H0JXQ/zifWu/Wi7m4RUPr02Yq5oAaabwMdRv6YVwL9ku4Dcnbfh4C1HnAtvoyb
         bAb15X37/DXsi9s1DhTOXJhZmlcdKWmNhQLAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aQDthXbkdWmKetycqCMcVCa3NGt9kd5rhmOaFO5JpOU=;
        b=hM2ZVdyBc/fJU4KgQ78SJJLKQ98WvhLZgfK+uBGtvZkp7p4l/mPW5erKFvaYo3G/2y
         kJpHU6TkA/IkVtXM5BwINfNV4r8S1apuE9G35rbDtfTFXtvLEkk8vRrO3ZSYnxCHVhaN
         6UByDC3c//B/G9edYOepe5Ze3BRMvZZLes0Ea1aoHyJ9Sk4gls7OV+ZVFjz1qqxdaNM1
         miLk1Ez8N/sbWIVi48O0iJLnWvSLkvA3airq/q0ncEQWm5rIsIS4O/db9KTMKfAFPl3m
         GB1S1oKWCga+p/ad7YRbGynYSBM59yyeckZiv5bpmPPPOy5FalQqcPeOqdV17bRsAAmh
         Te+Q==
X-Gm-Message-State: AOAM530Ki2BoGWwW7Dcu15R1/nAPpN8zMRxY5eqvQv+JWCy7md5KyH1/
        aUTqy3A6ThTnOyQvdU3ml4ZU3r9bDFfvc/MlHAABFhGWFyWLgsvaVl0BfvyOh+7IYkLfoedMADD
        RWDRLtbBiSqFeQiwLDe4f1e0NTJFi2FWGAlW1bCDsWTlMY1otTS5ligX+2eEL4gYwxNeiID6hvi
        jwPhwWGA==
X-Google-Smtp-Source: ABdhPJyc6LIeOyRQhb0SHZsSPKuffc8ABJKXsYVCVygPGCHSf+cil7MiHdOuVR062nDyfFLqR7mf2g==
X-Received: by 2002:a62:64c7:0:b029:28e:d42f:63c with SMTP id y190-20020a6264c70000b029028ed42f063cmr32643444pfb.40.1620762730754;
        Tue, 11 May 2021 12:52:10 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b3sm6317581pfv.61.2021.05.11.12.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 12:52:10 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v4 20/24] mpi3mr: wait for pending IO completions upon detection of VD IO timeout
Date:   Wed, 12 May 2021 01:24:19 +0530
Message-Id: <20210511195423.2134562-21-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210511195423.2134562-1-kashyap.desai@broadcom.com>
References: <20210511195423.2134562-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000dc96dd05c2133ae0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000dc96dd05c2133ae0

Wait for (default 180 seconds) host IO completion if IO timeout is detected
on VDs

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  2 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 55 +++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index f871329f9382..b52a3d1c4371 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -102,6 +102,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
 #define MPI3MR_TSUPDATE_INTERVAL		900
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
+#define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 855027eaccad..34372dc4eb3f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3765,6 +3765,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		}
 	}
 
+	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
+
 	mpi3mr_ioc_disable_intr(mrioc);
 
 	if (snapdump) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index cca9c4e9149c..022356a1cd01 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2418,6 +2418,43 @@ static void mpi3mr_print_pending_host_io(struct mpi3mr_ioc *mrioc)
 	    mpi3mr_print_scmd, (void *)mrioc);
 }
 
+/**
+ * mpi3mr_wait_for_host_io - block for I/Os to complete
+ * @mrioc: Adapter instance reference
+ * @timeout: time out in seconds
+ * Waits for pending I/Os for the given adapter to complete or
+ * to hit the timeout.
+ *
+ * Return: Nothing
+ */
+void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout)
+{
+	enum mpi3mr_iocstate iocstate;
+	int i = 0;
+
+	iocstate = mpi3mr_get_iocstate(mrioc);
+	if (iocstate != MRIOC_STATE_READY)
+		return;
+
+	if (!mpi3mr_get_fw_pending_ios(mrioc))
+		return;
+	ioc_info(mrioc,
+	    "%s :Waiting for %d seconds prior to reset for %d I/O\n",
+	    __func__, timeout, mpi3mr_get_fw_pending_ios(mrioc));
+
+	for (i = 0; i < timeout; i++) {
+		if (!mpi3mr_get_fw_pending_ios(mrioc))
+			break;
+		iocstate = mpi3mr_get_iocstate(mrioc);
+		if (iocstate != MRIOC_STATE_READY)
+			break;
+		msleep(1000);
+	}
+
+	ioc_info(mrioc, "%s :Pending I/Os after wait is: %d\n", __func__,
+	    mpi3mr_get_fw_pending_ios(mrioc));
+}
+
 /**
  * mpi3mr_eh_host_reset - Host reset error handling callback
  * @scmd: SCSI command reference
@@ -2432,8 +2469,26 @@ static void mpi3mr_print_pending_host_io(struct mpi3mr_ioc *mrioc)
 static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 {
 	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_stgt_priv_data *stgt_priv_data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	u8 dev_type = MPI3_DEVICE_DEVFORM_VD;
 	int retval = FAILED, ret;
 
+	sdev_priv_data = scmd->device->hostdata;
+	if (sdev_priv_data && sdev_priv_data->tgt_priv_data) {
+		stgt_priv_data = sdev_priv_data->tgt_priv_data;
+		dev_type = stgt_priv_data->dev_type;
+	}
+
+	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
+		mpi3mr_wait_for_host_io(mrioc,
+		    MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
+		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
+			retval = SUCCESS;
+			goto out;
+		}
+	}
+
 	mpi3mr_print_pending_host_io(mrioc);
 	ret = mpi3mr_soft_reset_handler(mrioc,
 	    MPI3MR_RESET_FROM_EH_HOS, 1);
-- 
2.18.1


--000000000000dc96dd05c2133ae0
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFjAkWlr/rezgNj4roB2UN6YylVj
pWlreMPbAW0YjmKMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDUxMTE5NTIxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBP4LRHtnJB6oobTnZEpfBEX2xJ6dJ0IKmEJc73LO3srRh/
fSjcln3IonGzqsXydFGIpAV3z1iJfX+e+OlgDFzLxIAoW6Tiajy8yIkTlh2lOk6kIpNw2ul4rfio
DAixZKjOfLq5t+od6RFq9c2oMyXqBAF6DWO9WERGVcJ2k0OLT016gm781WLZO2viIQkkL0mW5+LZ
Cb3KUO7fgvlxTDWyh/vwSvZH/NfaYBfdkTq2FgIF4kAPkzsMQc2Fyp427Vt4WcllvOOB7Wiuvfha
6gc/jcVpvbw+vKG5osUECcbj61Edi/8I4oHC+pu3B60skaUnqCYx7fRCm2PK4q2YfNu5
--000000000000dc96dd05c2133ae0--
