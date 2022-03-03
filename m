Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05A6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 13:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiCCNxE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiCCNxE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 08:53:04 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A19E1795DC
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 05:52:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id bx5so4629872pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 05:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version;
        bh=athXeL9enq5NDZ2c8XIOUaCPv0/mTgSdb3Eh7gkk5OI=;
        b=NhSd7RGEgJFvniyppuWF7xFSTMKP1j7HogVSLq6TYX4OXtCbkImxUrn/qwjcWv/kRn
         v2N+R5FVws9uyR9z30qEGL3GnjRWkAsbhvQGFUyfNcRYYCIgSgRdsEOPDqFJXK1a3RGJ
         l0ULWQHo/mYkX/s4rI32/jzh3cpXHbGqPtbMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=athXeL9enq5NDZ2c8XIOUaCPv0/mTgSdb3Eh7gkk5OI=;
        b=Ty4ddtrjUaZFblC30VqL2HVZDt/xpOgTid6rDzbW2GFBpOcAxzIHGWR70Bn63vCe5c
         egFkALZCP3KVmmhO2DGA7J8gYlrcdCuB3akF2rHij+tQphc7XkBF4oTyYSgu+7ayUIoZ
         4SH0k4h8Si7Sv8mRWMzszARNrWxrc/9vTUOVywgwkmd9aZ1C7Lb0aCfBbXSk72tfzDnd
         TbIWM4MXG4jpQPJEc1kmIGzhFbfVtw5bL0GBbpcxeSc3Js2HEjW3XWZL5ZJUbi5GEoAn
         jxLKTjw35MbmzbiAbliaJbfAh7SjA7ciSooNEL+GyXdpPwXbnttif82CQ24XPd3WvXSG
         hzSA==
X-Gm-Message-State: AOAM533q6NyNkLb1pb+v5ioL27H3iZn+8lH4CUaxrzAFD801mrSVEYnn
        iZs/cVQVWNjPfhOe1kxcrPjUhoiJC3cVuDL5tvN7qKxZyFCrBGpj4cIXTG/aeRfSJhOY/Y3hYFG
        rbH5tvWRZZqMVeAVXcT55RttA/0cxoEcHUPx7F/Avk5qUPRnJ73Uxe7dcj6Un5x38zOOakhrq4y
        eUIvr/emXgLLo=
X-Google-Smtp-Source: ABdhPJwduJDi9rzsgU6fSSckuTpDAPjQxLuSyxq41Mm4OBnCMdfl6T2xe0AWirkqP/G5jKn0dec8ZQ==
X-Received: by 2002:a17:90a:bf86:b0:1bd:6057:b77c with SMTP id d6-20020a17090abf8600b001bd6057b77cmr5418470pjs.72.1646315537343;
        Thu, 03 Mar 2022 05:52:17 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i128-20020a626d86000000b004f3f2929d7asm2579757pfc.217.2022.03.03.05.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 05:52:16 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Fix incorrect 4gb boundary check
Date:   Thu,  3 Mar 2022 19:32:30 +0530
Message-Id: <20220303140230.13098-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d3770905d950b49c"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d3770905d950b49c
Content-Transfer-Encoding: 8bit

Driver has to do a 4gb boundary check using the pool's
dma address instead of using a virtual address.

Fixes: d6adc251dd2f("mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ebb61b47dc2f..a10ceaa8f881 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5723,14 +5723,13 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
  */
 
 static int
-mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
+mpt3sas_check_same_4gb_region(dma_addr_t start_address, u32 pool_sz)
 {
-	long reply_pool_end_address;
+	dma_addr_t end_address;
 
-	reply_pool_end_address = reply_pool_start_address + pool_sz;
+	end_address = start_address + pool_sz - 1;
 
-	if (upper_32_bits(reply_pool_start_address) ==
-		upper_32_bits(reply_pool_end_address))
+	if (upper_32_bits(start_address) == upper_32_bits(end_address))
 		return 1;
 	else
 		return 0;
@@ -5791,7 +5790,7 @@ _base_allocate_pcie_sgl_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 		}
 
 		if (!mpt3sas_check_same_4gb_region(
-		    (long)ioc->pcie_sg_lookup[i].pcie_sgl, sz)) {
+		    ioc->pcie_sg_lookup[i].pcie_sgl_dma, sz)) {
 			ioc_err(ioc, "PCIE SGLs are not in same 4G !! pcie sgl (0x%p) dma = (0x%llx)\n",
 			    ioc->pcie_sg_lookup[i].pcie_sgl,
 			    (unsigned long long)
@@ -5846,8 +5845,8 @@ _base_allocate_chain_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 			    GFP_KERNEL, &ctr->chain_buffer_dma);
 			if (!ctr->chain_buffer)
 				return -EAGAIN;
-			if (!mpt3sas_check_same_4gb_region((long)
-			    ctr->chain_buffer, ioc->chain_segment_sz)) {
+			if (!mpt3sas_check_same_4gb_region(
+			    ctr->chain_buffer_dma, ioc->chain_segment_sz)) {
 				ioc_err(ioc,
 				    "Chain buffers are not in same 4G !!! Chain buff (0x%p) dma = (0x%llx)\n",
 				    ctr->chain_buffer,
@@ -5883,7 +5882,7 @@ _base_allocate_sense_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	    GFP_KERNEL, &ioc->sense_dma);
 	if (!ioc->sense)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->sense, sz)) {
+	if (!mpt3sas_check_same_4gb_region(ioc->sense_dma, sz)) {
 		dinitprintk(ioc, pr_err(
 		    "Bad Sense Pool! sense (0x%p) sense_dma = (0x%llx)\n",
 		    ioc->sense, (unsigned long long) ioc->sense_dma));
@@ -5916,7 +5915,7 @@ _base_allocate_reply_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	    &ioc->reply_dma);
 	if (!ioc->reply)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz)) {
+	if (!mpt3sas_check_same_4gb_region(ioc->reply_dma, sz)) {
 		dinitprintk(ioc, pr_err(
 		    "Bad Reply Pool! Reply (0x%p) Reply dma = (0x%llx)\n",
 		    ioc->reply, (unsigned long long) ioc->reply_dma));
@@ -5951,7 +5950,7 @@ _base_allocate_reply_free_dma_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
 	    GFP_KERNEL, &ioc->reply_free_dma);
 	if (!ioc->reply_free)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_free, sz)) {
+	if (!mpt3sas_check_same_4gb_region(ioc->reply_free_dma, sz)) {
 		dinitprintk(ioc,
 		    pr_err("Bad Reply Free Pool! Reply Free (0x%p) Reply Free dma = (0x%llx)\n",
 		    ioc->reply_free, (unsigned long long) ioc->reply_free_dma));
@@ -5990,7 +5989,7 @@ _base_allocate_reply_post_free_array(struct MPT3SAS_ADAPTER *ioc,
 	    GFP_KERNEL, &ioc->reply_post_free_array_dma);
 	if (!ioc->reply_post_free_array)
 		return -EAGAIN;
-	if (!mpt3sas_check_same_4gb_region((long)ioc->reply_post_free_array,
+	if (!mpt3sas_check_same_4gb_region(ioc->reply_post_free_array_dma,
 	    reply_post_free_array_sz)) {
 		dinitprintk(ioc, pr_err(
 		    "Bad Reply Free Pool! Reply Free (0x%p) Reply Free dma = (0x%llx)\n",
@@ -6055,7 +6054,7 @@ base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
 			 * resources and set DMA mask to 32 and allocate.
 			 */
 			if (!mpt3sas_check_same_4gb_region(
-				(long)ioc->reply_post[i].reply_post_free, sz)) {
+				ioc->reply_post[i].reply_post_free_dma, sz)) {
 				dinitprintk(ioc,
 				    ioc_err(ioc, "bad Replypost free pool(0x%p)"
 				    "reply_post_free_dma = (0x%llx)\n",
-- 
2.27.0


--000000000000d3770905d950b49c
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMx1Xj2CO5RJEBKmk5xr
HgwlnE4o2kWoWLgLZvFhjpuwMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDMwMzEzNTIxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDCvXL0iFfXxDJK816hotcXDFOnq64iyfYNk2Kd
4DoTi5JcwAiX7wIlHFnjiD9X8M4lUodI5PHpf3ktJk4okmJtyuWw2mkvmO5ED6822dw24VJxSr3t
nRZYc7vndi36UASziFPz2lrlaI16/o07BRUjl0zXFfVZoQFcTaP6Hwth5QwRPsiAu7asFDXASV22
z97+Prb311Ue1UWPJ2YBb3OkZxmTR0FmcOZ7NgKVjPuxkKEcM6EvtrphqcXzUmAszbzXzsRhLKE3
Jp8IYOm8Hidl8NcrOXKhu0VrhpTNnpUGaGAKMFT9jTX4ZUDy389qW9p/g7xsQX/dMkoo0g/+e8Vu
--000000000000d3770905d950b49c--
