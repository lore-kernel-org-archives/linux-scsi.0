Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA8EC64E69
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3011E22384
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HNdbQgVz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgKOT1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgKOT1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:09 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94F0C0613D1
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:08 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id e21so10752115pgr.11
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=qwudjBN/ROO1zyQFa7La4PmYPG1TWfOhrPg3p+laIAk=;
        b=HNdbQgVzIi9trWTjUk2i2RukNkDWLbYLuTrwXxd2muakZ8WBezSm7TaClEsC/zfTWz
         tW0aU0rW4mHTY1xR5EhH7vaIz3g8Fy9nETsxNBE8vTVq0XY/yP/LM88r3ldN6uQ2t7g7
         7cML9oShvbLuwxN+wQq/5ED04RZW1cn76hpxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=qwudjBN/ROO1zyQFa7La4PmYPG1TWfOhrPg3p+laIAk=;
        b=bzzBvzwU9Yzd+1cgTT1bo5ZXO5jGYXomt8hJ0PnkgBxgzfpQpO4kj5vWOhNpRPVCYo
         Ca/Ne2Fc+lcOHiXtsCRzA8RrDDhiIwnnx4xCXYAdDg/r3a7VsFtBr0FDGB7BqVqdFH5v
         R/StMLSp/LQPwhap9/xdbIg5vq9TG/hPNCx0iziNR7ptfldbEEeowbBMyqSX53yJMqkc
         AeB9i9ACz3BCmyEFQPx2XpnHxI35Rv9n05ECdQgItODsrP+79s9OxitQWGp+nWC+g7Da
         +iKwUOn/Wl5N8aG+U4+n41gWabuHvcD1rCbKb/n+ShRpBe8fs7Is3iFBEYN243vOPYc2
         cIqw==
X-Gm-Message-State: AOAM5319NZF0+AdhEM9B+zGvSevJQRT1/bWW5kxB/iiiDqOEW44rNl/U
        UUYZbmdQs2ZJ8xYYJcHEo02rOaRRQkabQ6KRjaHms1FO7Tg1Q7COm8O/n4cgT62ADqwqJcT6x05
        4LnNmqEGXwoulAzaOQNlNYjqgxmOljyH7XFtWoByUFLw+KArU660ZhjsJKCQN9SD0+d8+CiA1IG
        GN4R8=
X-Google-Smtp-Source: ABdhPJyxfCZLJhTzx4tpC9NbFpk3KJ5EWOfuioFMl1g32wJoOwNbXznZNwfQuY7nryib36TrxjLNVg==
X-Received: by 2002:a62:8f82:0:b029:18b:2db7:41d9 with SMTP id n124-20020a628f820000b029018b2db741d9mr11057055pfd.66.1605468427640;
        Sun, 15 Nov 2020 11:27:07 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:06 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/17] lpfc: Refactor wqe structure definitions for common use
Date:   Sun, 15 Nov 2020 11:26:39 -0800
Message-Id: <20201115192646.12977-11-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005b4b9105b42a3f09"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005b4b9105b42a3f09
Content-Transfer-Encoding: 8bit

In preparation of reworking the driver to use a native SLI-4 WQE interface
for the SCSI and NVME io paths, start by commonizing the WQE exchange type
and command type attributes.

While adjusting these options also noted the variance in the pbde field.
Fix this by setting templates to 0 and in nvme, which explicitly uses this
option, setting the value.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h   | 10 +++++++---
 drivers/scsi/lpfc/lpfc_nvme.c  | 20 +++++++++++---------
 drivers/scsi/lpfc/lpfc_nvmet.c |  6 +++---
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 49f5559f5fed..26a9057fb042 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4386,9 +4386,11 @@ struct wqe_common {
 #define wqe_ebde_cnt_SHIFT    0
 #define wqe_ebde_cnt_MASK     0x0000000f
 #define wqe_ebde_cnt_WORD     word10
-#define wqe_nvme_SHIFT        4
-#define wqe_nvme_MASK         0x00000001
-#define wqe_nvme_WORD         word10
+#define wqe_xchg_SHIFT        4
+#define wqe_xchg_MASK         0x00000001
+#define wqe_xchg_WORD         word10
+#define LPFC_SCSI_XCHG	      0x0
+#define LPFC_NVME_XCHG	      0x1
 #define wqe_oas_SHIFT         6
 #define wqe_oas_MASK          0x00000001
 #define wqe_oas_WORD          word10
@@ -4886,6 +4888,8 @@ struct lpfc_grp_hdr {
 #define NVME_READ_CMD		0x0
 #define FCP_COMMAND_DATA_OUT	0x1
 #define NVME_WRITE_CMD		0x1
+#define COMMAND_DATA_IN		0x0
+#define COMMAND_DATA_OUT	0x1
 #define FCP_COMMAND_TRECEIVE	0x2
 #define FCP_COMMAND_TRSP	0x3
 #define FCP_COMMAND_TSEND	0x7
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 60f4fbffc4ee..c5acf6800fb6 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -98,16 +98,16 @@ lpfc_nvme_cmd_template(void)
 
 	/* Word 10 - dbde, wqes is variable */
 	bf_set(wqe_qosd, &wqe->fcp_iread.wqe_com, 0);
-	bf_set(wqe_nvme, &wqe->fcp_iread.wqe_com, 1);
+	bf_set(wqe_xchg, &wqe->fcp_iread.wqe_com, LPFC_NVME_XCHG);
 	bf_set(wqe_iod, &wqe->fcp_iread.wqe_com, LPFC_WQE_IOD_READ);
 	bf_set(wqe_lenloc, &wqe->fcp_iread.wqe_com, LPFC_WQE_LENLOC_WORD4);
 	bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 0);
 	bf_set(wqe_wqes, &wqe->fcp_iread.wqe_com, 1);
 
 	/* Word 11 - pbde is variable */
-	bf_set(wqe_cmd_type, &wqe->fcp_iread.wqe_com, NVME_READ_CMD);
+	bf_set(wqe_cmd_type, &wqe->fcp_iread.wqe_com, COMMAND_DATA_IN);
 	bf_set(wqe_cqid, &wqe->fcp_iread.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 1);
+	bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 0);
 
 	/* Word 12 - is zero */
 
@@ -139,16 +139,16 @@ lpfc_nvme_cmd_template(void)
 
 	/* Word 10 - dbde, wqes is variable */
 	bf_set(wqe_qosd, &wqe->fcp_iwrite.wqe_com, 0);
-	bf_set(wqe_nvme, &wqe->fcp_iwrite.wqe_com, 1);
+	bf_set(wqe_xchg, &wqe->fcp_iwrite.wqe_com, LPFC_NVME_XCHG);
 	bf_set(wqe_iod, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_LENLOC_WORD4);
 	bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 0);
 	bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
 
 	/* Word 11 - pbde is variable */
-	bf_set(wqe_cmd_type, &wqe->fcp_iwrite.wqe_com, NVME_WRITE_CMD);
+	bf_set(wqe_cmd_type, &wqe->fcp_iwrite.wqe_com, COMMAND_DATA_OUT);
 	bf_set(wqe_cqid, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 1);
+	bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 0);
 
 	/* Word 12 - is zero */
 
@@ -178,14 +178,14 @@ lpfc_nvme_cmd_template(void)
 
 	/* Word 10 - dbde, wqes is variable */
 	bf_set(wqe_qosd, &wqe->fcp_icmd.wqe_com, 1);
-	bf_set(wqe_nvme, &wqe->fcp_icmd.wqe_com, 1);
+	bf_set(wqe_xchg, &wqe->fcp_icmd.wqe_com, LPFC_NVME_XCHG);
 	bf_set(wqe_iod, &wqe->fcp_icmd.wqe_com, LPFC_WQE_IOD_NONE);
 	bf_set(wqe_lenloc, &wqe->fcp_icmd.wqe_com, LPFC_WQE_LENLOC_NONE);
 	bf_set(wqe_dbde, &wqe->fcp_icmd.wqe_com, 0);
 	bf_set(wqe_wqes, &wqe->fcp_icmd.wqe_com, 1);
 
 	/* Word 11 */
-	bf_set(wqe_cmd_type, &wqe->fcp_icmd.wqe_com, FCP_COMMAND);
+	bf_set(wqe_cmd_type, &wqe->fcp_icmd.wqe_com, COMMAND_DATA_IN);
 	bf_set(wqe_cqid, &wqe->fcp_icmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
 	bf_set(wqe_pbde, &wqe->fcp_icmd.wqe_com, 0);
 
@@ -1570,7 +1570,9 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 				le32_to_cpu(first_data_sgl->sge_len);
 			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
 			bde->tus.w = cpu_to_le32(bde->tus.w);
-			/* wqe_pbde is 1 in template */
+
+			/* Word 11 */
+			bf_set(wqe_pbde, &wqe->generic.wqe_com, 1);
 		} else {
 			memset(&wqe->words[13], 0, (sizeof(uint32_t) * 3));
 			bf_set(wqe_pbde, &wqe->generic.wqe_com, 0);
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f62ea5a8f59e..fe8b3a80e3c8 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -105,7 +105,7 @@ lpfc_nvmet_cmd_template(void)
 	/* Word 9  - reqtag, rcvoxid is variable */
 
 	/* Word 10 - wqes, xc is variable */
-	bf_set(wqe_nvme, &wqe->fcp_tsend.wqe_com, 1);
+	bf_set(wqe_xchg, &wqe->fcp_tsend.wqe_com, LPFC_NVME_XCHG);
 	bf_set(wqe_dbde, &wqe->fcp_tsend.wqe_com, 1);
 	bf_set(wqe_wqes, &wqe->fcp_tsend.wqe_com, 0);
 	bf_set(wqe_xc, &wqe->fcp_tsend.wqe_com, 1);
@@ -153,7 +153,7 @@ lpfc_nvmet_cmd_template(void)
 	/* Word 10 - xc is variable */
 	bf_set(wqe_dbde, &wqe->fcp_treceive.wqe_com, 1);
 	bf_set(wqe_wqes, &wqe->fcp_treceive.wqe_com, 0);
-	bf_set(wqe_nvme, &wqe->fcp_treceive.wqe_com, 1);
+	bf_set(wqe_xchg, &wqe->fcp_treceive.wqe_com, LPFC_NVME_XCHG);
 	bf_set(wqe_iod, &wqe->fcp_treceive.wqe_com, LPFC_WQE_IOD_READ);
 	bf_set(wqe_lenloc, &wqe->fcp_treceive.wqe_com, LPFC_WQE_LENLOC_WORD12);
 	bf_set(wqe_xc, &wqe->fcp_tsend.wqe_com, 1);
@@ -195,7 +195,7 @@ lpfc_nvmet_cmd_template(void)
 
 	/* Word 10 wqes, xc is variable */
 	bf_set(wqe_dbde, &wqe->fcp_trsp.wqe_com, 1);
-	bf_set(wqe_nvme, &wqe->fcp_trsp.wqe_com, 1);
+	bf_set(wqe_xchg, &wqe->fcp_trsp.wqe_com, LPFC_NVME_XCHG);
 	bf_set(wqe_wqes, &wqe->fcp_trsp.wqe_com, 0);
 	bf_set(wqe_xc, &wqe->fcp_trsp.wqe_com, 0);
 	bf_set(wqe_iod, &wqe->fcp_trsp.wqe_com, LPFC_WQE_IOD_NONE);
-- 
2.26.2


--0000000000005b4b9105b42a3f09
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQPwYJKoZIhvcNAQcCoIIQMDCCECwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2UMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFQTCCBCmgAwIBAgIMfmKtsn6cI8G7HjzCMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE3MDU0
NjI0WhcNMjIwOTE4MDU0NjI0WjCBjDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRQwEgYDVQQDEwtKYW1l
cyBTbWFydDEnMCUGCSqGSIb3DQEJARYYamFtZXMuc21hcnRAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0B4Ym0dby5rc/1eyTwvNzsepN0S9eBGyF45ltfEmEmoe
sY3NAmThxJaLBzoPYjCpfPWh65cxrVIOw9R3a9TrkDN+aISE1NPyyHOabU57I8bKvfS8WMpCQKSJ
pDWUbzanP3MMP4C2qbJgQW+xh9UDzBi8u69f40kP+cLEPNJWbz0KxNNp7H/4zWNyTouJRtO6QKVh
XqR+mg0QW4TJlH5sJ7NIbVGZKzs0PEbUJJJw0zJsp3m0iS6AzNFtTGHWVO1me58DIYR/VDSiY9Sh
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgJASR8RIH9Ub8b6DH
WAtUBr4fkG0174Md/xa6hv5OXR0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzA4WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBABjsIdTwmbPtoILr3r9zzH+tPxDjJYqqKqWC
lNcuCIa1NFhiLyOtdzVawV2GiElsD5RoVjft8rIY4CZI/U6fB9E9HwHZ9/suYHHsFvMO79A4etTn
+8s91+tO8in1Ior/5Ghsljpb22EF/SBL2CQijdAZSMep7XKj7wEnkKgip26UXDsELZ0opUIUHLci
/EyJ4ZjsNmIvlHiCHBdB5kJ/V0LgUxu+KXqxjlbmI12rYALbf29v3mhZhNMm/6Uy6EknQSQ4NK4Z
n9ZCYIC7jY4unx2Tl5g9cqpYCDvsrz2InG9Ut/RvIF/8szyCccj723Ct+XyItvOP/q0t7aqB9d2m
yg4=
--0000000000005b4b9105b42a3f09--
