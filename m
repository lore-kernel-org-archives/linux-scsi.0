Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE1AC433E4
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 247FB20791
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gMSph4gj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgFMDE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:04:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42736 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgFMDEu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:50 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200613030446epoutp04260ed64f865ea578867aeb67e7bdc641~X_3gf6npV2650126501epoutp044
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200613030446epoutp04260ed64f865ea578867aeb67e7bdc641~X_3gf6npV2650126501epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017486;
        bh=nPCI6KtKTzdjjbh5jTvGpI1fKN6gjrCt7WH8b1I6htY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMSph4gjrki4tkpX9PHqynDhq/D8nuc05UzweodDYsSa0Phuu5WUZnnHCkVX3LTOI
         X3Tl7wJ7hMd23ie8JbuA7iPU+neQLM8haodDLWp7gmVXc6EhtFVXB4iMBIbhdKeONe
         1+iicdh0FmglH0c2N4GlGnpO192gAF44r4AQmC0E=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200613030445epcas5p22381f9cc1696cef74b255cd0c2ac6a6d~X_3f2HxeO2889128891epcas5p2h;
        Sat, 13 Jun 2020 03:04:45 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.AA.09703.D4244EE5; Sat, 13 Jun 2020 12:04:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23~X_3fSw-zm1361613616epcas5p4f;
        Sat, 13 Jun 2020 03:04:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200613030445epsmtrp13c5a0bd3461baf1903fd21a10c3f83f0~X_3fPQeEl2520425204epsmtrp1U;
        Sat, 13 Jun 2020 03:04:45 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-54-5ee4424d0c09
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.62.08382.D4244EE5; Sat, 13 Jun 2020 12:04:45 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030443epsmtip2872aa0bacbe6873b50cf3ad6d932be1a~X_3dTtFM-0718207182epsmtip2B;
        Sat, 13 Jun 2020 03:04:43 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 04/10] scsi: ufs: introduce
 UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Date:   Sat, 13 Jun 2020 08:17:00 +0530
Message-Id: <20200613024706.27975-5-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42LZdlhTS9fX6Umcwfd2U4sH87axWbz8eZXN
        4tP6ZawW84+cY7W48LSHzeL8+Q3sFje3HGWx2PT4GqvF5V1z2CxmnN/HZNF9fQebxfLj/5gs
        /u/ZwW6xdOtNRgc+j8t9vUwem1Z1snlsXlLv0XJyP4vHx6e3WDz6tqxi9Dh+YzuTx+dNch7t
        B7qZAjijuGxSUnMyy1KL9O0SuDI+/tnGXLBdtGJGy1X2Bsa7gl2MnBwSAiYSK/a+Zu5i5OIQ
        EtjNKHF09ksWCOcTo8TFGycYIZxvjBLLPjSxwLR8XnwNKrGXUWLH3GvsEE4Lk8Sb2VtYQarY
        BLQl7k7fwgRiiwgISxz51sYIYjMLvGSS2PWoAMQWFoiSeP3qOdhUFgFViZV7FrJ1MXJw8ArY
        SHw8EgSxTF5i9YYDzCA2p4CtxMH/C5hAdkkIzOSQaP/ynRGiyEVi/ccL7BC2sMSr41ugbCmJ
        l/1t7CAzJQSyJXp2GUOEaySWzjsG9Yy9xIErc1hASpgFNCXW79KHuJJPovf3EyaITl6JjjYh
        iGpVieZ3V6E6pSUmdnezQtgeEg8WvIAGyQRGiXc/trFOYJSdhTB1ASPjKkbJ1ILi3PTUYtMC
        o7zUcr3ixNzi0rx0veT83E2M4BSj5bWD8eGDD3qHGJk4GA8xSnAwK4nwCoo/jBPiTUmsrEot
        yo8vKs1JLT7EKM3BoiTOq/TjTJyQQHpiSWp2ampBahFMlomDU6qB6UC3EreZdKVdlh6zfsDd
        STalJya9tJzjs7RGL7TmXHykULHbPHmV0993zmw4a2ZaXqF6o26SskR1TN+ar3lX58UdmJHU
        F8s+M7vGJfNih3birP3pjYE2E5xmrvAz9XnoZXFG95PMy9jYjZOj3v+x3l+udc96/f3Jy3+m
        Om97v2vePd1/mW9/rHNfyXJh07t357zKdY6zvW8NdzT583txrVdaiDHz1LIpE9iaX/2/nFrU
        HfTgz70vVivaYoUvXrKdLeYbOffZ1qNN9f0PPYX9oh/qzLCUTsqZO+vky7f35fzZGRKPhU+b
        zqZ9z0Bijf2ShGm3j7ds6lecG1+2RPubxNLJv1/IJDwM1P+aEjAlRYmlOCPRUIu5qDgRAOgX
        EXSgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvK6v05M4g6X3uS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mr4+Gcbc8F20YoZLVfZGxjvCnYxcnJICJhIfF58jRHEFhLY
        zSjRfS0JIi4tcX3jBHYIW1hi5b/nQDYXUE0Tk8TptwtZQRJsAtoSd6dvYQKxRYCKjnxrYwQp
        Yhb4ziRxYMIE5i5GDg5hgQiJ6X9DQGpYBFQlVu5ZyAYS5hWwkfh4JAhivrzE6g0HmEFsTgFb
        iYP/FzBB3GMjsfvoT9YJjHwLGBlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEh7eW
        5g7G7as+6B1iZOJgPMQowcGsJMIrKP4wTog3JbGyKrUoP76oNCe1+BCjNAeLkjjvjcKFcUIC
        6YklqdmpqQWpRTBZJg5OqQamc22tJ5O7HHntzq5b/ujrXYekCbvqeJMP63Zr7Q/QTd/x+vWe
        3lW1tSFKtSUnp3z0vH5r1xWvaw+2ME9bHWAj9fq59PrGPDdznzcPE5ZUyAi8fdu7gsvOUH7h
        ioItM6eli+4LL85d4/t6/3IVWZ07e9xyXv+803yb2/zt1JjQUOsY5pMmsiv2zKl3X2x8oUtm
        ya9sdW7JPocPn1JlSqwWVD1hvsgq3Rm/gSnhnNkJy/j8IO4opusvzbfrP9Z5wb54WYinuQ1b
        +nTuxFMawSqX3xUVrD/uVd1mH7R7yqsUV48SdffDPp+3mqfZaSjlsyt+2bBijmH+7VWtz5+d
        2JLR17nn1UGGsA+vUx89+fJZiaU4I9FQi7moOBEAatNthN4CAAA=
X-CMS-MailID: 20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030445epcas5p4428da322cd9527d1075ff0f1ccc75d23@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some UFS host controllers like Exynos uses granularities of PRDT length and
offset as bytes, whereas others uses actual segment count.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ee30ed6cc805..ba093d0d0942 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2151,8 +2151,14 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		return sg_segments;
 
 	if (sg_segments) {
-		lrbp->utr_descriptor_ptr->prd_table_length =
-			cpu_to_le16((u16)sg_segments);
+
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
+			lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16((sg_segments *
+					sizeof(struct ufshcd_sg_entry)));
+		else
+			lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16((u16) (sg_segments));
 
 		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
 
@@ -3500,11 +3506,21 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
 
 		/* Response upiu and prdt offset should be in double words */
-		utrdlp[i].response_upiu_offset =
-			cpu_to_le16(response_offset >> 2);
-		utrdlp[i].prd_table_offset = cpu_to_le16(prdt_offset >> 2);
-		utrdlp[i].response_upiu_length =
-			cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
+			utrdlp[i].response_upiu_offset =
+				cpu_to_le16(response_offset);
+			utrdlp[i].prd_table_offset =
+				cpu_to_le16(prdt_offset);
+			utrdlp[i].response_upiu_length =
+				cpu_to_le16(ALIGNED_UPIU_SIZE);
+		} else {
+			utrdlp[i].response_upiu_offset =
+				cpu_to_le16(response_offset >> 2);
+			utrdlp[i].prd_table_offset =
+				cpu_to_le16(prdt_offset >> 2);
+			utrdlp[i].response_upiu_length =
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
+		}
 
 		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f8d08cb9caf7..a9b9ace9fc72 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -535,6 +535,12 @@ enum ufshcd_quirks {
 	 * enabled via HCE register.
 	 */
 	UFSHCI_QUIRK_BROKEN_HCE				= 1 << 8,
+
+	/*
+	 * This quirk needs to be enabled if the host controller regards
+	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
+	 */
+	UFSHCD_QUIRK_PRDT_BYTE_GRAN			= 1 << 9,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

