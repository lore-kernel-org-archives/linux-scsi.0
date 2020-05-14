Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD07AC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEE12065C
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JIDWNnyl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgENAxG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46136 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730124AbgENAxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:53:05 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200514005302epoutp04b708375152ae5b0ca79b00f115a04dab~Ovt6qwOVx0770907709epoutp04Q
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:53:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200514005302epoutp04b708375152ae5b0ca79b00f115a04dab~Ovt6qwOVx0770907709epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417582;
        bh=nPCI6KtKTzdjjbh5jTvGpI1fKN6gjrCt7WH8b1I6htY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIDWNnyl+XfuRRDnU3d+KgrMk0nzdqPUK/FFTRjbvwVmw3f3OCbKM1DkjEG6eQhf0
         PGh9m92Kj39McQEFOp7bihys70ZyjenuDEk2ow9Mva6hSXD+4D55oW+CA7rTZmViY+
         gdI/c46vhcm3LVMO5QdkuHqNVmS5/bQ3oLqasC5o=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200514005301epcas5p12b499e4a67f841847287592c8d0d802a~Ovt6FMEZK1507415074epcas5p1H;
        Thu, 14 May 2020 00:53:01 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.45.10010.D669CBE5; Thu, 14 May 2020 09:53:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200514005300epcas5p4ce7ba7fe62567e7ba0066c96473853b2~Ovt5NBVm_0641706417epcas5p4H;
        Thu, 14 May 2020 00:53:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514005300epsmtrp170edd15e00d54c024bd519712b5f3565~Ovt5L31Oz1129711297epsmtrp1L;
        Thu, 14 May 2020 00:53:00 +0000 (GMT)
X-AuditID: b6c32a49-735ff7000000271a-03-5ebc966d3c8b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.D3.18461.C669CBE5; Thu, 14 May 2020 09:53:00 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005258epsmtip2e0d7cfb9638c1a1d72cfc65a6b2f4d8c~Ovt3TdqWN0066800668epsmtip2I;
        Thu, 14 May 2020 00:52:58 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 04/10] scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN
 quirk
Date:   Thu, 14 May 2020 06:09:08 +0530
Message-Id: <20200514003914.26052-5-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42LZdlhTXTd32p44g+5nghYP5m1js3j58yqb
        xaf1y1gt5h85x2px/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFv/37GC3
        WLr1JqMDr8flvl4mj02rOtk8Ni+p92g5uZ/F4+PTWywefVtWMXp83iTn0X6gmymAI4rLJiU1
        J7MstUjfLoEr4+OfbcwF20UrZrRcZW9gvCvYxcjJISFgIrHz3FG2LkYuDiGB3YwS764cY4dw
        PjFKfD7ezwxSJSTwjVHixicmmI7F576zQhTtZZS49ewLI4TTwiQx/chMVpAqNgFtibvTt4B1
        iAgISxz51sYIYjML3GCSeLDSBcQWFgiSaNrWzQJiswioSszdshhsG6+AjcTT+efYIbbJS6ze
        cAAszilgK7HlyzGwzRICnRwS677fhypykZi84RYLhC0s8er4Fqi4lMTL/jYgmwPIzpbo2WUM
        Ea6RWDrvGFS5vcSBK3NYQEqYBTQl1u/ShziTT6L39xMmiE5eiY42IYhqVYnmd1ehOqUlJnZ3
        s0LYHhKnj65kgQTDBEaJ3R/uM05glJ2FMHUBI+MqRsnUguLc9NRi0wLDvNRyveLE3OLSvHS9
        5PzcTYzgdKLluYPx7oMPeocYmTgYDzFKcDArifD6rd8dJ8SbklhZlVqUH19UmpNafIhRmoNF
        SZz3dNqWOCGB9MSS1OzU1ILUIpgsEwenVANTzK/1ga5H+v/yP4u+Xr06k3Nh/qzo2hctQTpT
        6kJ2a/wzL8uUWMrHYlfR7Gpvef/31DmJGXOvVMnKtZ1uD8huXfb1cZ92dcbuCrnPoqLdshoN
        04XF/blkH9csVPNwbJ3YILn/lrfUFiaDPKOiWB9lztz7/Y/azht67bH+F8JhtEzm3PeLq8sU
        b2v/84jNMz+oU3rQhjc+7uwjLYs266nRvncn+DbH+7pyK84ItTy72vVonP+dLI9zphtFPxnb
        6G+3W3Nx/qJvAvxVj/9G+n7Oydhy4vI7t4cJK1cf2/UxTiR0y1ShlwlNC299MBE492pj9SMm
        uaLnCnu48y7flVgjxRJSvGBHlJ3wktMnFiuxFGckGmoxFxUnAgAKIhw5lgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvG7OtD1xBiumSFg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujI9/tjEXbBetmNFylb2B8a5gFyMnh4SAicTic99Zuxi5OIQEdjNKXLtwghUi
        IS1xfeMEdghbWGLlv+fsEEVNTBKX3j1hA0mwCWhL3J2+hQnEFgEqOvKtjRHEZhZ4xiRx6mEp
        iC0sECDxfe8isDiLgKrE3C2LmUFsXgEbiafzz0EtkJdYveEAWJxTwFZiy5djYEcIAdUsW7OM
        cQIj3wJGhlWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMHhrKW5g3H7qg96hxiZOBgP
        MUpwMCuJ8Pqt3x0nxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQimCwT
        B6dUA5Of/J0bJQk5Ez7p7cs5846tb+Hl1todZw+dSf+yl+mjiwJztfWBPYvs2qLjGhRMdv3a
        vtiv1OH8p40RoWL1U4Qm32o6NNuwyF5urm51R0Gh7USxDUvcv56IEY9WnmUn25KhV9J47cmB
        f0+6FoV8etqfI3L0GY/0nYaskL8tJk8kt+hz6W7ZfTHX8M+TZYHvLux62nPlab61vceTDxfy
        dqxa8komd4NTTGhFgU1J+on4OQXbdr27mqhz656E37VNUvb3zr62k/24zn3nBJ595dN6RPry
        /7yRzpN6fiC2Wi/lx/bXt7jz+DPvdiXcM83fxvniyDyboxZtOcKyLM80Xqi5V6T7Lp8te8LX
        J32Fu4QSS3FGoqEWc1FxIgAijn9D1gIAAA==
X-CMS-MailID: 20200514005300epcas5p4ce7ba7fe62567e7ba0066c96473853b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005300epcas5p4ce7ba7fe62567e7ba0066c96473853b2
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005300epcas5p4ce7ba7fe62567e7ba0066c96473853b2@epcas5p4.samsung.com>
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

