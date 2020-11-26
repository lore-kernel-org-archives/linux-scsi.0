Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D91C64E75
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAEA520DD4
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 09:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XI7TGlkm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733292AbgKZJqH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 04:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733263AbgKZJqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 04:46:06 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6820C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:46:06 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id n137so1192391pfd.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 01:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=JdWq9YU+uP+RJLT0L4P9eikVQJsLSrgeLGa5CvoxEZ8=;
        b=XI7TGlkm3KPY8cURyVKPNHKRkPWkBAWWzuFZoU8nyJycYGiUyN7f3feprzHOS2OV0O
         lWdZELUrdjRp3wSkoGxVglI1rRiE+6hCN1ShzxAgaE95kL6zwRXB+9KKqHUnnDq/CVLq
         wxPcZcw4HgrZNKKhcHSUCxAYPI7gfeF/FOi/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=JdWq9YU+uP+RJLT0L4P9eikVQJsLSrgeLGa5CvoxEZ8=;
        b=fihko9kQytVxp2Y68KR6OsRs7ybtvUsKIiIOFR9lWM0xiK8Plz4d6ALXPqYFVcaZ/b
         c3gB/F8MOGuf8p9u+U24PmNa8Zc9jAJGKUhYTQddme3QRU0dWqYqzqrNU3UMFE4lzNzq
         Gpfe7dBc0OlNT53dNiWFfz9X2Ed2T3GtYHLFYHoeG6HiFY/yk3FJ27Q0A7Bd6G3dRcUh
         tpWuyzUJ/4qNFSnz48t42g8AZVsX53JsHs0OKpE6Pwc2n58EiYc/1T2+hQBOlXqlEnBC
         j/4hDIVbiseWiYrQ9+ZLzxrLWl8N7YUONT8O+XFjraP7QyByj7BExqZQSo7yG1K+zqTe
         v7/A==
X-Gm-Message-State: AOAM5314t/SGprPgI+R7m9F+wXrsGpqnK2mRs7JC+LnuowGNA2wHu1pb
        voAwXRzwJRkVljfEweJ+fioogjwn2MXY7JILr+WEh7SEg/Q+E41wyLoTe0MH7PboznT3zOSPiay
        K5GI15rr22/wR6cKWiqdjAbVQZU1kWrHwWGh7WwFa724k5q7jKdmZQWYR3kBsWAzGpDt6Ic1lzE
        a6D+gtg2C3N1suGvCHnmcu5p8=
X-Google-Smtp-Source: ABdhPJyejhLwn92xeewRgh7Am+g+ad2niqnNDMmfzrZaEsaK41N3FcqOVK0xeCqw8tqqdrlamNOTtQ==
X-Received: by 2002:a17:90a:8:: with SMTP id 8mr2695627pja.236.1606383965588;
        Thu, 26 Nov 2020 01:46:05 -0800 (PST)
Received: from dhcp-10-123-20-14.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i10sm4343220pfk.206.2020.11.26.01.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 01:46:04 -0800 (PST)
From:   Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v1 7/8] mpt3sas: Handle trigger page support after reset.
Date:   Thu, 26 Nov 2020 15:13:10 +0530
Message-Id: <20201126094311.8686-8-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
References: <20201126094311.8686-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000afcd5005b4ff69d0"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000afcd5005b4ff69d0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Description:
Handle trigger page support after reset.
Prior to IOC reset, if firmware is not supporting trigger pages
and after reset if driver sees the firmware started supporting
trigger pages. (In case of a reset after firmware
upgrade) then the driver should handle this by writing the
already available trigger data from the driver’s internal data
structure to the corresponding trigger pages NVRAM region and
also update Trigger flags in Trigger Page-0 NVRAM region
accordingly.

Implementation:
Add ioc->supports_trigger_pages, this feature supported flag is
used to determine whether the pages needs update or not. And also
this feature supporting flag needs to be updated for every reset as
it is possible that FW won’t support trigger pages before reset
and start supporting after reset or vice versa.
(In case of FW upgrade or downgrade)

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 50 ++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ce3ef9e..b129f37 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5073,6 +5073,35 @@ _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 		_base_get_mpi_diag_triggers(ioc);
 }
 
+/**
+ * _base_update_diag_trigger_pages - Update the driver trigger pages after
+ *			online FW update, incase updated FW supports driver
+ *			trigger pages.
+ * @ioc : per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
+{
+
+	if (ioc->diag_trigger_master.MasterData)
+		mpt3sas_config_update_driver_trigger_pg1(ioc,
+		    &ioc->diag_trigger_master, 1);
+
+	if (ioc->diag_trigger_event.ValidEntries)
+		mpt3sas_config_update_driver_trigger_pg2(ioc,
+		    &ioc->diag_trigger_event, 1);
+
+	if (ioc->diag_trigger_scsi.ValidEntries)
+		mpt3sas_config_update_driver_trigger_pg3(ioc,
+		    &ioc->diag_trigger_scsi, 1);
+
+	if (ioc->diag_trigger_mpi.ValidEntries)
+		mpt3sas_config_update_driver_trigger_pg4(ioc,
+		    &ioc->diag_trigger_mpi, 1);
+}
+
 /**
  * _base_static_config_pages - static start of day config pages
  * @ioc: per adapter object
@@ -5082,7 +5111,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 {
 	Mpi2ConfigReply_t mpi_reply;
 	u32 iounit_pg1_flags;
-
+	int tg_flags = 0;
 	ioc->nvme_abort_timeout = 30;
 	mpt3sas_config_get_manufacturing_pg0(ioc, &mpi_reply, &ioc->manu_pg0);
 	if (ioc->ir_firmware)
@@ -5162,6 +5191,25 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->is_gen35_ioc) {
 		if (ioc->is_driver_loading)
 			_base_get_diag_triggers(ioc);
+		else {
+			/*
+			 * In case of online HBA FW update operation,
+			 * check whether updated FW supports the driver trigger
+			 * pages or not.
+			 * - If previous FW has not supported driver trigger
+			 *   pages and newer FW supports them then update these
+			 *   pages with current diag trigger values.
+			 * - If previous FW has supported driver trigger pages
+			 *   and new FW doesn't support them then disable
+			 *   support_trigger_pages flag.
+			 */
+			tg_flags = _base_check_for_trigger_pages_support(ioc);
+			if (!ioc->supports_trigger_pages && tg_flags != -EFAULT)
+				_base_update_diag_trigger_pages(ioc);
+			else if (ioc->supports_trigger_pages &&
+			    tg_flags == -EFAULT)
+				ioc->supports_trigger_pages = 0;
+		}
 	}
 }
 
-- 
2.27.0


--000000000000afcd5005b4ff69d0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg/T+PrkRq8EM0wOGYsdy1XT9MEDnAxn9YKY697Df5
JfcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAxMTI2MDk0NjA2
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAILLThNdY3RTgCSwz66ygDV+/XTQ9c1hL+GoaSbkrT3ydBv7nS3fgX+bk99C
3AF9pioSHu9LpBud9fXYINX2IPwaUij2mn4bfiB17fliwgZeyDsQES3i2rSerB4NGrIRBzRb/zFO
H9rlfAPMh3nXAJn/OuQUv5hYOSmS6gpkbB0/sdj+r6eAL/TvssCaG5thGZq3iwEGTcPvHQUDqmbK
BM8kmBCHsIXzyvAnrP6+e8+btfqKOVp5s3vS72ZpC/nBtMkRGk3ygFTgL80NpGJBBxoja47j28iC
neE0X79d3FBcvR4+sthD1nIZAUdqzDNbFtBAdE9rZllJamuraHqKflk=
--000000000000afcd5005b4ff69d0--
