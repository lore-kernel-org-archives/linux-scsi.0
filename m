Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABCDC0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 07:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjGMHyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 03:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjGMHx5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 03:53:57 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773101FC9
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 00:53:55 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6b91ad1f9c1so355686a34.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 00:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1689234834; x=1691826834;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=cOH1e2XTVntKzfAfPBAtAdyerJW6hT4Wj413mSCJsII=;
        b=FUq+7LhZ1eLe0VUzclzIZcnGhUWiiIcVoZrHWTWUlKXYh4FqORI0WW9OUtn0GYeesH
         m+SM+g3ZeWRIqIkKMOnjuniSBlz2KZx0hz377yfaDk4mSJ4EXAqroOCgLmvmTJz7dOe6
         w02oZcPHspu/q+ZwavhUJUfT9kD2Y/gCVcgTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689234834; x=1691826834;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOH1e2XTVntKzfAfPBAtAdyerJW6hT4Wj413mSCJsII=;
        b=UwP/1H1JZ8YdqfvBlnww5n7yLH88iVpb1nV3+2OIF+Ht2AvVOg2MTqEQxJ6prqgy1Y
         PSFBojb19c8mbl9AzpqvxaluOMsH8g6WXUgD5F62iU5nsXUz46zKPh8xuDziLr0dLEId
         jab8mGBwu4XmADjGBHZadD3q9DDtodEkaZeFh9aaQtOIYZNc7/aBB62+l7IQKXDHamVy
         okrp4uLZ3iHg0fy1qxqDNhB1z8F8YQJN/ahX84OwUWlivl3pWf4XRxvl04RU2NcBTR5k
         xnhZXkCumbxrpiJI5+4GIQ0mMN+aWaviUvPxWJ3hR1ZstfFbu/IWi0SOXc/8kAKutz9H
         OL2g==
X-Gm-Message-State: ABy/qLar0u6MQhAdGkoP6LsjTjw5FxsHZjSFma50iDm242NkDtwtHOs6
        RkrHzS5IuhxcY9f3NoG7F8wP8noWvkwXOlIZb3qXmkFkdbnoxRTHnqGPkt3T0txAD009j+CORo9
        KFgK6ghLLbpSmkOT1IlE0h5uV4tsSNWCBVMIW/78UWxINTYDB/KOD5itC6NuVlEw3iXZ1BbrnsX
        cRcKzfsA0q4w==
X-Google-Smtp-Source: APBJJlFYn/kQPqTtwMRLFuSsX8hu6MCVdtKETFLmvgEevfWgnAspo5ueYDd4Pf31Uz4WnMD27Vrpfg==
X-Received: by 2002:a9d:7308:0:b0:6b7:5717:bea4 with SMTP id e8-20020a9d7308000000b006b75717bea4mr1061211otk.31.1689234834440;
        Thu, 13 Jul 2023 00:53:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 20-20020a17090a199400b002639c4f81cesm12267519pji.3.2023.07.13.00.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 00:53:54 -0700 (PDT)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH v1 1/2] Perform additional retries if Doorbell read returns 0
Date:   Thu, 13 Jul 2023 13:23:01 +0530
Message-Id: <20230713075302.10073-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230713075302.10073-1-ranjan.kumar@broadcom.com>
References: <20230713075302.10073-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000045a52c060059a29f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000045a52c060059a29f
Content-Transfer-Encoding: 8bit

Doorbell and Host diagnostic registers could return 0 even
after 3 retries and that leads to occasional resets of the
controllers, hence increased the retry count to thirty.

Fixes: b899202901a8 ("mpt3sas: Add separate function for aero doorbell reads")
Cc: stable@vger.kernel.org
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 53 ++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++-
 2 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 53f5492579cb..efc9bc48db6f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -196,25 +196,27 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
 /**
  * _base_readl_aero - retry readl for max three times.
  * @addr: MPT Fusion system interface register address
- *
- * Retry the readl() for max three times if it gets zero value
+ *@retry_count: max no of retry
+
+ * Retry the readl() for max thirty times if it gets zero value
  * while reading the system interface register.
  */
+
 static inline u32
-_base_readl_aero(const volatile void __iomem *addr)
+_base_readl_aero(const volatile void __iomem *addr, u8 retry_count)
 {
 	u32 i = 0, ret_val;
 
 	do {
 		ret_val = readl(addr);
 		i++;
-	} while (ret_val == 0 && i < 3);
+	} while (ret_val == 0 && i < retry_count);
 
 	return ret_val;
 }
 
 static inline u32
-_base_readl(const volatile void __iomem *addr)
+_base_readl(const volatile void __iomem *addr, u8 retry_count)
 {
 	return readl(addr);
 }
@@ -940,7 +942,7 @@ mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc)
 
 	dump_stack();
 
-	doorbell = ioc->base_readl(&ioc->chip->Doorbell);
+	doorbell = ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT);
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		mpt3sas_print_fault_code(ioc, doorbell &
 		    MPI2_DOORBELL_DATA_MASK);
@@ -1617,10 +1619,10 @@ mpt3sas_base_mask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 	u32 him_register;
 
 	ioc->mask_interrupts = 1;
-	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask);
+	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask, READL_RETRY_SHORT_COUNT);
 	him_register |= MPI2_HIM_DIM + MPI2_HIM_RIM + MPI2_HIM_RESET_IRQ_MASK;
 	writel(him_register, &ioc->chip->HostInterruptMask);
-	ioc->base_readl(&ioc->chip->HostInterruptMask);
+	ioc->base_readl(&ioc->chip->HostInterruptMask, READL_RETRY_SHORT_COUNT);
 }
 
 /**
@@ -1634,7 +1636,7 @@ mpt3sas_base_unmask_interrupts(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 him_register;
 
-	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask);
+	him_register = ioc->base_readl(&ioc->chip->HostInterruptMask, READL_RETRY_SHORT_COUNT);
 	him_register &= ~MPI2_HIM_RIM;
 	writel(him_register, &ioc->chip->HostInterruptMask);
 	ioc->mask_interrupts = 0;
@@ -6686,7 +6688,7 @@ mpt3sas_base_get_iocstate(struct MPT3SAS_ADAPTER *ioc, int cooked)
 {
 	u32 s, sc;
 
-	s = ioc->base_readl(&ioc->chip->Doorbell);
+	s = ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT);
 	sc = s & MPI2_IOC_STATE_MASK;
 	return cooked ? sc : s;
 }
@@ -6760,7 +6762,8 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	count = 0;
 	cntdn = 1000 * timeout;
 	do {
-		int_status = ioc->base_readl(&ioc->chip->HostInterruptStatus);
+		int_status = ioc->base_readl(&ioc->chip->HostInterruptStatus,
+						READL_RETRY_SHORT_COUNT);
 		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
 			dhsprintk(ioc,
 				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
@@ -6786,7 +6789,8 @@ _base_spin_on_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	count = 0;
 	cntdn = 2000 * timeout;
 	do {
-		int_status = ioc->base_readl(&ioc->chip->HostInterruptStatus);
+		int_status = ioc->base_readl(&ioc->chip->HostInterruptStatus,
+						READL_RETRY_SHORT_COUNT);
 		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
 			dhsprintk(ioc,
 				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
@@ -6824,14 +6828,15 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	count = 0;
 	cntdn = 1000 * timeout;
 	do {
-		int_status = ioc->base_readl(&ioc->chip->HostInterruptStatus);
+		int_status = ioc->base_readl(&ioc->chip->HostInterruptStatus,
+						READL_RETRY_SHORT_COUNT);
 		if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
 			dhsprintk(ioc,
 				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
 					   __func__, count, timeout));
 			return 0;
 		} else if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
-			doorbell = ioc->base_readl(&ioc->chip->Doorbell);
+			doorbell = ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT);
 			if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_FAULT) {
 				mpt3sas_print_fault_code(ioc, doorbell);
@@ -6871,7 +6876,7 @@ _base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	count = 0;
 	cntdn = 1000 * timeout;
 	do {
-		doorbell_reg = ioc->base_readl(&ioc->chip->Doorbell);
+		doorbell_reg = ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT);
 		if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
 			dhsprintk(ioc,
 				  ioc_info(ioc, "%s: successful count(%d), timeout(%d)\n",
@@ -7019,13 +7024,13 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	__le32 *mfp;
 
 	/* make sure doorbell is not in use */
-	if ((ioc->base_readl(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
+	if ((ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
 		return -EFAULT;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
-	if (ioc->base_readl(&ioc->chip->HostInterruptStatus) &
+	if (ioc->base_readl(&ioc->chip->HostInterruptStatus, READL_RETRY_SHORT_COUNT) &
 	    MPI2_HIS_IOC2SYS_DB_STATUS)
 		writel(0, &ioc->chip->HostInterruptStatus);
 
@@ -7068,7 +7073,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	}
 
 	/* read the first two 16-bits, it gives the total length of the reply */
-	reply[0] = le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
+	reply[0] = le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 	if ((_base_wait_for_doorbell_int(ioc, 5))) {
@@ -7076,7 +7081,7 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			__LINE__);
 		return -EFAULT;
 	}
-	reply[1] = le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell)
+	reply[1] = le16_to_cpu(ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT)
 	    & MPI2_DOORBELL_DATA_MASK);
 	writel(0, &ioc->chip->HostInterruptStatus);
 
@@ -7087,10 +7092,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			return -EFAULT;
 		}
 		if (i >=  reply_bytes/2) /* overflow case */
-			ioc->base_readl(&ioc->chip->Doorbell);
+			ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT);
 		else
 			reply[i] = le16_to_cpu(
-			    ioc->base_readl(&ioc->chip->Doorbell)
+			    ioc->base_readl(&ioc->chip->Doorbell, READL_RETRY_COUNT)
 			    & MPI2_DOORBELL_DATA_MASK);
 		writel(0, &ioc->chip->HostInterruptStatus);
 	}
@@ -7949,14 +7954,14 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 			goto out;
 		}
 
-		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic, READL_RETRY_COUNT);
 		drsprintk(ioc,
 			  ioc_info(ioc, "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
 				   count, host_diagnostic));
 
 	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
 
-	hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
+	hcb_size = ioc->base_readl(&ioc->chip->HCBSize, READL_RETRY_SHORT_COUNT);
 
 	drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
 	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
@@ -7969,7 +7974,7 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
 	for (count = 0; count < (300000000 /
 		MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
 
-		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
+		host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic, READL_RETRY_COUNT);
 
 		if (host_diagnostic == 0xFFFFFFFF) {
 			ioc_info(ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 05364aa15ecd..b4e57b89915d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -160,6 +160,15 @@
 
 #define IOC_OPERATIONAL_WAIT_COUNT	10
 
+/*
+ *Due to hardware specific behaviour
+ *retry count is increased from 3 to 30.
+ *Delay is not needed as retry count fulfill
+ *the desired requirement
+ */
+#define READL_RETRY_COUNT              30
+#define READL_RETRY_SHORT_COUNT		3
+
 /*
  * NVMe defines
  */
@@ -994,7 +1003,7 @@ typedef void (*NVME_BUILD_PRP)(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 funcdep);
 typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16 smid);
-typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr);
+typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr, u8 retry_count);
 /*
  * To get high iops reply queue's msix index when high iops mode is enabled
  * else get the msix index of general reply queues.
-- 
2.31.1


--00000000000045a52c060059a29f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEID8VBIMAbRA1dmv5k3QiC7XCuFYpwC+B
Ch0IpIVsMYJvMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDcx
MzA3NTM1NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAyEYXaOL3h7khV2oIuvBbsSlreSz+imsJXYTPeF4I3jsp+2dEV
qUsepSosZZ4p3K/jugeE1HaFVQIxQmcz/K3JGVJ/fgRLM/vf1kYavb8GYVDUZLlX9zrMj3y8fB9d
hTz79aJOretxWEyrWRxiMMucjj82z7KP0PDMvNmWp/AHWd/QicXYmC11/AImUxp//YhODOrMiSwu
Ts51zfPVbzy9HGAk04fJ8zP7M4He7kbccOv4VvUVqwBx0o1rUs/3XqtzLS6jHIL8/wcVnlYWLia8
r98R6+ZEuhE1O7yEsaj70Bi/JlTAF2esEnh5WZ9Yo+1QaDKO8rm7KB68NSRDtCf4
--00000000000045a52c060059a29f--
