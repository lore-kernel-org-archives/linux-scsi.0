Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE103C83F14
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 09:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbjH2JCD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 05:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbjH2JBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 05:01:35 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FE2107
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 02:01:32 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68a6f6a66e1so2982458b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 02:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1693299691; x=1693904491;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=HP7bPTh2t64yvkD1jIQj3kbAWr2Z8YpfIsxVcB/C1rM=;
        b=h3cC/h1kUlPEMJOwWTjRJ6b6V/X+ZO+S+8TZdlwiLYyeR72ucq9WdvExnKYwXEKagQ
         RwmQOxvkuY11N+nEFC+2/T5IGeyjCIWjpqcRJIjZPo87iwrCl26E+RxXNjG/KmCkz58S
         YXKSL9orwY6mGBiPfK9uAfu0O8+wDcX78z/cw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693299691; x=1693904491;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HP7bPTh2t64yvkD1jIQj3kbAWr2Z8YpfIsxVcB/C1rM=;
        b=lT+Dq28EC4ZKt+Ky9Y/2VKlbdUwNML9rLUHYNNQaJY5w5IF0nH2wCqZ4rrpsc40dpu
         LLErNySO9F49tForpE091ymlPZfEE2p4gX5oaJ/OPPubdIBnb/ssBMbo9j/xJJdYXBOx
         0EB7RXELBX2/B9y0ZRBAr51QF56zSi80JPSVKLDrf/D+FIsPFI1cV4kxzSzJzESF6tkR
         N6eF2Z4KVLrPKJgDDw7tJDujyJ4BvtjEZeGsf3Hrd+T8oXIHQxti2jasGxRPQG1T7ZMw
         ZkH1jP3zH63cgRbDF/ih7vwMVFEA+xYYma6ZmMUpERa8miZVwg6DjeG7b34RU7+IuNHq
         LGOA==
X-Gm-Message-State: AOJu0YxfSHASysqS8Udb+5xRnGcG8rYKE9brSywBgqjAuv5bqxnxauw8
        EbbW991FYUnJE+Jv/MGPKAHwQW5/QaJmghoSmIoTUw9XpeJbOZeDBeLDDdcR0MlV/cxryiu8G7Z
        QGhbsjNPbWJCxRlWDeWah+QyTDnJjtu2+ZWBOJBAI9rp9LuZYxgdlSwnZR2+c8cSti7Z4WJ6QpZ
        ZLomKzqagVlg==
X-Google-Smtp-Source: AGHT+IGyDFPVF2QTGCBpsAGURoq3UrAbYpxYJ4jTn/jqU6Jdv168VvJIBEu1kudcEeXBC76MIZfZfQ==
X-Received: by 2002:a05:6a00:a13:b0:68a:4e3c:eb43 with SMTP id p19-20020a056a000a1300b0068a4e3ceb43mr22116593pfh.10.1693299691425;
        Tue, 29 Aug 2023 02:01:31 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id c27-20020a63725b000000b0056456fff676sm8589978pgn.66.2023.08.29.02.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 02:01:30 -0700 (PDT)
From:   Ranjan Kumar <ranjan.kumar@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        sumit.saxena@broadcom.com, Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 2/2] mpt3sas: Removing volatile qualifier
Date:   Tue, 29 Aug 2023 14:30:20 +0530
Message-Id: <20230829090020.5417-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230829090020.5417-1-ranjan.kumar@broadcom.com>
References: <20230829090020.5417-1-ranjan.kumar@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a25fab06040c0e44"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000a25fab06040c0e44
Content-Transfer-Encoding: 8bit

Removing reduntant volatile qualifier

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2.h     | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2.h b/drivers/scsi/mpt3sas/mpi/mpi2.h
index ed3923f8db4f..6de35b32223c 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2.h
@@ -199,7 +199,7 @@
 *
 *****************************************************************************/
 
-typedef volatile struct _MPI2_SYSTEM_INTERFACE_REGS {
+typedef struct _MPI2_SYSTEM_INTERFACE_REGS {
 	U32 Doorbell;		/*0x00 */
 	U32 WriteSequence;	/*0x04 */
 	U32 HostDiagnostic;	/*0x08 */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5284584e4cd2..61a32bf00747 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -139,7 +139,7 @@ static void
 _base_clear_outstanding_commands(struct MPT3SAS_ADAPTER *ioc);
 
 static u32
-_base_readl_ext_retry(const volatile void __iomem *addr);
+_base_readl_ext_retry(const void __iomem *addr);
 
 /**
  * mpt3sas_base_check_cmd_timeout - Function
@@ -204,7 +204,7 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
  * while reading the system interface register.
  */
 static inline u32
-_base_readl_aero(const volatile void __iomem *addr)
+_base_readl_aero(const void __iomem *addr)
 {
 	u32 i = 0, ret_val;
 
@@ -217,7 +217,7 @@ _base_readl_aero(const volatile void __iomem *addr)
 }
 
 static u32
-_base_readl_ext_retry(const volatile void __iomem *addr)
+_base_readl_ext_retry(const void __iomem *addr)
 {
 	u32 i, ret_val;
 
@@ -231,7 +231,7 @@ _base_readl_ext_retry(const volatile void __iomem *addr)
 }
 
 static inline u32
-_base_readl(const volatile void __iomem *addr)
+_base_readl(const void __iomem *addr)
 {
 	return readl(addr);
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 10055c7e4a9f..1be0850ca17a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -994,7 +994,7 @@ typedef void (*NVME_BUILD_PRP)(struct MPT3SAS_ADAPTER *ioc, u16 smid,
 typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 funcdep);
 typedef void (*PUT_SMID_DEFAULT) (struct MPT3SAS_ADAPTER *ioc, u16 smid);
-typedef u32 (*BASE_READ_REG) (const volatile void __iomem *addr);
+typedef u32 (*BASE_READ_REG) (const void __iomem *addr);
 /*
  * To get high iops reply queue's msix index when high iops mode is enabled
  * else get the msix index of general reply queues.
-- 
2.31.1


--000000000000a25fab06040c0e44
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICmKUNPHwSd4Df1yj+fnDnhkw5VFXSf/
hvBSthNRziUcMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDgy
OTA5MDEzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA71G3cT4tsbVG5ulk2NK5BK9Ggciq1/+vho9eoAwQMM6RXLmZn
1m1NCFVFXNve61RJfifz1btQN5MBYYUmGEoqilGxKgUbHsND/dHvvghWeb9vO2vMnqINqSSTtdBT
adQgQO92hmgEEyxDk07q71FAWT4fM3UOzVKPX3E7o389soyoVvocIKjaOyKaX7qbeEGLaM5rkGfn
XJPQ4LmY6BxW4bENoehE5ZTm0Sj0IpcH+h6TN0WjQu47dXq1NarbpNvk/MnJV8L9+rhOm5IbJ9zP
KievULRs3d2fOJyG+xB3rEiu2Hc+pZH96yyN/9x82cVAlnZ+600PLbyhMfVd8Qvf
--000000000000a25fab06040c0e44--
