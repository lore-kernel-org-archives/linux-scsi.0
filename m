Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB857C433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9EE3613B8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 02:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344378AbhDGCFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 22:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344303AbhDGCFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 22:05:07 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4426C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  6 Apr 2021 19:04:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso493665pje.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Apr 2021 19:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AaN8an06OWJwHqkiDWD/jfO+DU4VBQ1oMOgLAiwh8Fc=;
        b=T3Bvx1Ub0ctScjM92DwcYLetm2tc2U+MV7rUD6F0brrmed9xczan+o2/QsHCthcZUs
         QlNxPg/lmHqcJ/nyMkShPx3NugXj7BESEYJaSiYXpejg1CVZUr17l3wY9kWnLfv0w59y
         HGUTOY5q//blc2K2nyQDwb72J3E4W3Rhs4OQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AaN8an06OWJwHqkiDWD/jfO+DU4VBQ1oMOgLAiwh8Fc=;
        b=VEhzKYoVxNu+y/iV8qex9S5dXVQkw8HIQ/XAv7e0Xyr57/7gziirI0pIDiLaB1fe5h
         KGotXMXu66RWvOH8mvoN8ezs53oWGggRfN1qYlpqEdSwJCFZrWgpGNryLgskYNE1fgbZ
         ogcwPTgWg8S74vjEf8SmVRm1VWpkmzvqfXc5rh+yK+0gQ7i/9Kmlxv6Xpvc2iLH8gb7K
         Pe8cf2WK8YnwtTybMdFGFixoXCfwy09scnOT7/XAe4TyHVboKr4DtKfo3heKLoNQc5CA
         SzqFrjLpHj38pxYIpIsl5CLX7LViKSoALSRvu+slCZFCAoqtrEnB57VvhqW2vAqrTwx+
         bhEA==
X-Gm-Message-State: AOAM531SNuxY4b2CwWgUAjmunpO2ZAFYLeNPetJ18oZPzJYLfvFCIDPy
        tCknom5hpefCmNdYLA13QWyE6gsY4ubM7uc2M23t75751wcSRhpKYAqbb+cRWGDKf2+EH9nJIkP
        8FJhH7t+g859lxxLCj2sYAvkYPGwnjZqgkzpGdl8XX/dGuBjbHRF1Baj65idehcmUWh7dJ/6gcr
        qayJajIQ==
X-Google-Smtp-Source: ABdhPJxs0TFBqqgBRb/6J6DUo3pMb7YRUqodT81NHKS2T/5FDlGsTft0fuT2NQXmE4WVAMTTD1CRCg==
X-Received: by 2002:a17:902:6541:b029:e6:27a4:80fb with SMTP id d1-20020a1709026541b02900e627a480fbmr892887pln.15.1617761098009;
        Tue, 06 Apr 2021 19:04:58 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9sm3435858pja.50.2021.04.06.19.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 19:04:57 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH v2 20/24] mpi3mr: wait for pending IO completions upon detection of VD IO timeout
Date:   Wed,  7 Apr 2021 07:34:47 +0530
Message-Id: <20210407020451.924822-21-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210407020451.924822-1-kashyap.desai@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009a631a05bf585b7b"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009a631a05bf585b7b

Wait for (default 180 seconds) host IO completion if IO timeout is detected
on VDs

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  2 ++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 45 +++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index ff3e68a6d0b5..505df0e7b852 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -102,6 +102,7 @@ extern struct list_head mrioc_list;
 #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
 #define MPI3MR_TSUPDATE_INTERVAL		900
 #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
+#define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 79a9f98c736e..f09330bb4b8a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3775,6 +3775,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		}
 	}
 
+	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
+
 	mpi3mr_ioc_disable_intr(mrioc);
 
 	if (snapdump) {
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8cf591a031b5..0976352f423f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2434,6 +2434,43 @@ static void mpi3mr_print_pending_host_io(struct mpi3mr_ioc *mrioc)
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
@@ -2459,6 +2496,14 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 		dev_type = stgt_priv_data->dev_type;
 	}
 
+	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
+		mpi3mr_wait_for_host_io(mrioc,
+		    MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
+		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
+			retval = SUCCESS;
+			goto out;
+		}
+	}
 	mpi3mr_print_pending_host_io(mrioc);
 	ret = mpi3mr_soft_reset_handler(mrioc,
 	    MPI3MR_RESET_FROM_EH_HOS, 1);
-- 
2.18.1


--0000000000009a631a05bf585b7b
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
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEdhONiMervx6AZ4akqzl0WE4TFB
Sm3CPLxeyk0Siu62MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQwNzAyMDQ1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCK9BI6vcq5u0o20ciAoeuPS3G8tvrxnQCKZacZB/oCNkmd
nlG9f8w+O151rSzyISaV3KkRh59uuWR8agjumF+IiieXKfLq7W1eXSsemjxbK9WVFbcDdSPFsXXj
HrUeSiU5aH7vxMQV6Ld2vi0B/cUTamyMVf7gXHvzLewV1RoubbedcpANqH3vzc/xTejLUJivarpf
f8aJzbu4oHRjaB27XWv22p/ZEKfzNYM0hjRiw2cOgDnULsBJZGIun4AzUPzpIjxLT8q6+tVvE4z+
Qay5KdRxysH2e2SUVm3/gVQ/taUg9uLhUCM1ucw7VtxgXIyzN7enpJaXvuH3y+Zi2Yal
--0000000000009a631a05bf585b7b--
