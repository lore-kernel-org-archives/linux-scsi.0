Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ex4wA3UJ"
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EF3DE
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 07:27:11 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1d0ccda19eeso12720615ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 07:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1701876430; x=1702481230; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lsbMtaCHeDpWRSYvsY+iHmFytTvYqXWxBqixrjfiSGo=;
        b=Ex4wA3UJzx/9GCxaZmrXteYy7GmeuoVx02lu0v+wO/FWmUZvJcTCR7y9Uzc+uD0BRq
         6btnHcDqToGEvNGR+Gvaop/mOmxE7dfiFimPtkIgTffflBPphhuqgw/XgEszkQwZonG9
         gaVVem9/gGKuPQRqx8MUmAw4kFVa5aCI795OQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701876430; x=1702481230;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsbMtaCHeDpWRSYvsY+iHmFytTvYqXWxBqixrjfiSGo=;
        b=cmmSZtznpAbW50l4urWqOVrBOZjGsrB/xhj5BhkrORXu+JyAEluGxchkXeklpoXD09
         8mChQ7+/XabP9j28Q+EvpOcaAnwU5yNxUAVgS2QSJ8u8LHmewxS3ho9jTpAnJ4vvZwGk
         Lruk5WetL8Uvo6zx7iF5L7bJkpRx+PASSvHXZes7pIgm8F5ybWOFRatG+/RoceznQFvO
         S/nYE9PMhsYcbvYSygrTCKaH+eOIp67bkjQm1y5+vKDDaQ+MaZ0+9hpJNMf5q0/Vh3MV
         +wbx3xM/A7gH37IQ80I0hR972YPZH1i9a2GSNvQVbVoqAe5lhYr+4hUDfgFqLB26BjMM
         e2Tg==
X-Gm-Message-State: AOJu0YwH64K9NX1jlC9KB6QWvSu6CpGKseI5sxLjuYG6/3thdpeAxGSm
	R7FUqWne1owHsHy+V+I7kCg4HVQhuqENNW4NrQQCpGjRCzAErutHp3Y8e2dabO0fjCaDCwnY6HM
	C+j1W80Ea7e7HC1q/qIkZE+8eQDatagxOpZE9sC9of+nZ3XDyTMXij63xtcuCB8KIKLxXkMNgCi
	YXTQBw6mITMQ==
X-Google-Smtp-Source: AGHT+IGaQ1jGEFMr3PsijV2jO4vNH1rR0DaY8/mcPIkDOZ9AthYKIzR6TarpvcmrqMrlNjtLxFDVkg==
X-Received: by 2002:a17:902:7d8a:b0:1d0:d04a:7bfa with SMTP id a10-20020a1709027d8a00b001d0d04a7bfamr815248plm.90.1701876430233;
        Wed, 06 Dec 2023 07:27:10 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b001cfc2e0a82fsm12182553plg.26.2023.12.06.07.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 07:27:08 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 1/4] mpi3mr: Improve Shutdown times when firmware has faulted
Date: Wed,  6 Dec 2023 20:55:10 +0530
Message-Id: <20231206152513.71253-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231206152513.71253-1-ranjan.kumar@broadcom.com>
References: <20231206152513.71253-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000001ba350060bd8fc1f"

--0000000000001ba350060bd8fc1f
Content-Transfer-Encoding: 8bit

The driver monitors the controller state periodically while
waiting for the shutdown notification MPI request to complete.
If the firmware is faulty, the driver resets the controller and
re-issues the shutdown notification. The driver will make three
attempts to complete the shutdown process and will not retry the
notification request if the controller reset is unsuccessful.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 36 +++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 3de1ee05c44e..e44e262748ea 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -158,6 +158,7 @@ extern atomic64_t event_counter;
 /* Controller Reset related definitions */
 #define MPI3MR_HOSTDIAG_UNLOCK_RETRY_COUNT	5
 #define MPI3MR_MAX_RESET_RETRY_COUNT		3
+#define MPI3MR_MAX_SHUTDOWN_RETRY_COUNT		2
 
 /* ResponseCode definitions */
 #define MPI3MR_RI_MASK_RESPCODE		(0x000000FF)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d8c57a0a518f..9e4a075fd7f0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4555,9 +4555,10 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
  */
 static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 {
-	u32 ioc_config, ioc_status;
-	u8 retval = 1;
+	u32 ioc_config, ioc_status, shutdown_action;
+	u8 retval = 1, retry = 0;
 	u32 timeout = MPI3MR_DEFAULT_SHUTDOWN_TIME * 10;
+	u32 timeout_remaining = 0;
 
 	ioc_info(mrioc, "Issuing shutdown Notification\n");
 	if (mrioc->unrecoverable) {
@@ -4572,15 +4573,16 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
+	shutdown_action = MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL |
+	    MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-	ioc_config |= MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL;
-	ioc_config |= MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
+	ioc_config |= shutdown_action;
 
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
 	if (mrioc->facts.shutdown_timeout)
 		timeout = mrioc->facts.shutdown_timeout * 10;
-
+	timeout_remaining = timeout;
 	do {
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 		if ((ioc_status & MPI3_SYSIF_IOC_STATUS_SHUTDOWN_MASK)
@@ -4588,8 +4590,26 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 			retval = 0;
 			break;
 		}
+		if (mrioc->unrecoverable)
+			break;
+		if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) {
+			mpi3mr_print_fault_info(mrioc);
+			if (retry >= MPI3MR_MAX_SHUTDOWN_RETRY_COUNT)
+				break;
+			if (mpi3mr_issue_reset(mrioc,
+			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
+			    MPI3MR_RESET_FROM_CTLR_CLEANUP))
+				break;
+			ioc_config =
+			    readl(&mrioc->sysif_regs->ioc_configuration);
+			ioc_config |= shutdown_action;
+			writel(ioc_config,
+			    &mrioc->sysif_regs->ioc_configuration);
+			timeout_remaining = timeout;
+			retry++;
+		}
 		msleep(100);
-	} while (--timeout);
+	} while (--timeout_remaining);
 
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
@@ -4598,11 +4618,11 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 		if ((ioc_status & MPI3_SYSIF_IOC_STATUS_SHUTDOWN_MASK)
 		    == MPI3_SYSIF_IOC_STATUS_SHUTDOWN_IN_PROGRESS)
 			ioc_warn(mrioc,
-			    "shutdown still in progress after timeout\n");
+			    "shutdown still in progress\n");
 	}
 
 	ioc_info(mrioc,
-	    "Base IOC Sts/Config after %s shutdown is (0x%x)/(0x%x)\n",
+	    "ioc_status/ioc_config after %s shutdown is (0x%x)/(0x%x)\n",
 	    (!retval) ? "successful" : "failed", ioc_status,
 	    ioc_config);
 }
-- 
2.31.1


--0000000000001ba350060bd8fc1f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICUrqUkIvTBlhIxwyx8IvgfvCcgCCyO+
bCnhTiyclHDqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTIw
NjE1MjcxMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDgZF6SQTFEhMT3GqnT1RHWLtraXb4YbdRBm2tiN5oTPGF+oAlM
NdFAOQ9wFmx0XMH4cQO1DV9d4JYnTTqmfevI8zW7BoU6jkDV8YZwXyRcQk+okldf3QXCB2kxoGmx
USHxFhy49ud31PrBHgylGkumeiKtC9+annHWgWWzr03UyjMbpnproSeak2NBlXtjUOzYEYw6MV46
79P2TCu0YAerfoKOjZgMQcCar7Uv3So2ptnWFUWkWAu7oH2klyOHAU59K5yCqcO6vER+pq9814So
UZjDtkFFUeOxLmdUPciD7RHpktZut0y9sLPaD4EyH0GDSuDCeMn3wnHQNaD1//Fu
--0000000000001ba350060bd8fc1f--
