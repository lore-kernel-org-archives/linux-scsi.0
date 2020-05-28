Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BFAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A692100A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bRrQd0Le"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgE1BdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:33:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63099 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgE1Bcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:36 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200528013233epoutp0128bbda91abde7b9d7bee3f9de0245602~TDSbAjo4r2169721697epoutp01v
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200528013233epoutp0128bbda91abde7b9d7bee3f9de0245602~TDSbAjo4r2169721697epoutp01v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629553;
        bh=nPCI6KtKTzdjjbh5jTvGpI1fKN6gjrCt7WH8b1I6htY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRrQd0LeajYCAte3aAjCOZkZSJ1BskOV9DwBpoNSoZ6ECPPmtJy27XThrWZoGmLVw
         l7a7CjgqNwfNv69Fegj9GlqZsAUnJ8viOKK6zz7KKJuFdc54/k4VYaIauJyJb6QNg/
         TQA/Hx4Fb+8Sk8qayaA1MFycK9V9GJwX/7hPZlxM=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200528013233epcas5p26c92f0b7581b5876dd2fcca5e40a41d9~TDSalIsZx3096230962epcas5p2D;
        Thu, 28 May 2020 01:32:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.58.09703.0B41FCE5; Thu, 28 May 2020 10:32:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200528013232epcas5p32fecbbebc06909ff1fa7136481891dc1~TDSZ4QDgy1669616696epcas5p3v;
        Thu, 28 May 2020 01:32:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200528013232epsmtrp27b820d590b40f2cb85edddf2d38360a8~TDSZ3bBjY2193121931epsmtrp2C;
        Thu, 28 May 2020 01:32:32 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-cb-5ecf14b0f5b6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.E7.08382.0B41FCE5; Thu, 28 May 2020 10:32:32 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013230epsmtip10d37aa13c3f1b2b8c6fc3854ac5b9c0a~TDSYBGXfv1640116401epsmtip1k;
        Thu, 28 May 2020 01:32:30 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 04/10] scsi: ufs: introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN
 quirk
Date:   Thu, 28 May 2020 06:46:52 +0530
Message-Id: <20200528011658.71590-5-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42LZdlhTS3eDyPk4g00vjS0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxsc/25gLtotWzGi5yt7AeFewi5GTQ0LAROJ+93L2LkYuDiGB3YwSk9bMYQRJ
        CAl8YpRYt4sDIvGNUeLZsvWMMB3fp+6D6tjLKPF1xU1mCKeFSeL+2242kCo2AW2Ju9O3MIHY
        IgLCEke+tYF1MwvcYJJ4sNIFxBYWCJb4e2shWJxFQFXiy7w57CA2r4CNxLHmE2wQ2+QlVm84
        ALSAg4NTwFZi7wQHkF0SAp0cEq1TetlA4hICLhI/7qdBlAtLvDq+hR3ClpL4/G4vVEm2RM8u
        Y4hwjcTSecdYIGx7iQNX5rCAlDALaEqs36UPcSSfRO/vJ0wQnbwSHW1CENWqEs3vrkJ1SktM
        7O5mhSjxACpPh4TBBEaJppvNTBMYZWchDF3AyLiKUTK1oDg3PbXYtMAoL7Vcrzgxt7g0L10v
        OT93EyM4kWh57WB8+OCD3iFGJg7GQ4wSHMxKIrxOZ0/HCfGmJFZWpRblxxeV5qQWH2KU5mBR
        EudV+nEmTkggPbEkNTs1tSC1CCbLxMEp1cDUnBHPY/tJiqm9n137QsuBS6cnXOHfbCx20+3i
        5KdPHyzlzrsX9Fvb8NirldlZPRG33iXu6Gb0m2ogbKVvnaeeWyGnuHDSJdszdg/48n61nS95
        +PLep6WeGh/Ns30fRx+ftT/X5cTvd/eZ1IM5z68+9zW7jKOcO6vIU37aYa+sl/+PRTvLz1gy
        28ovSfdP+OHyjj1ykd8lrs5ken/iR/Nl5hgHYWafLSv3lEQe5Fobvktdb96Eb+ZrhR6eFmUT
        PrhjxeyI3Xc+VJzOmaRcLbi7vauq99yVy7/zJuQfnbFgvl/fxIA6w3ORUrF/29zMm2L59LPT
        Ra/qiHWxR1+2+br7q8oWS569Eg/uuaW+4Z+hxFKckWioxVxUnAgAufY/jJMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnO4GkfNxBv+Pc1o8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujI9/tjEXbBetmNFylb2B8a5gFyMnh4SAicT3qfvYuxi5OIQEdjNK7G84wAKR
        kJa4vnECO4QtLLHy33OooiYmiZmTD4MVsQloS9ydvoUJxBYBKjryrY0RxGYWeMYkcephaRcj
        B4ewQKDEyV9cIGEWAVWJL/PmgM3kFbCRONZ8gg1ivrzE6g0HmEHKOQVsJfZOcAAJCwGVTFi1
        l3ECI98CRoZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBoayluYNx+6oPeocYmTgY
        DzFKcDArifA6nT0dJ8SbklhZlVqUH19UmpNafIhRmoNFSZz3RuHCOCGB9MSS1OzU1ILUIpgs
        EwenVANT+jElk+rcXNmMT1mSs67OFPC+P325iN/Sv//L/rgdv/jI7L6d9F6v/x6+13sjOeT8
        kuaJ2Lr8tdxeIrmZL2SO5rMLJa/vrZIX2q24WLaRi+3VwcgrD6vZptyR6s3kOv1Y3ypexeCs
        ytODL7bfTTKPfl6ftzn/JK9ak+OjxluvCpkcPr5bX7O2Kn8l77UvhcabcrfWhcy2ZFtwPP/Y
        rYrQ+SItruc0ji11ry/4tPbRwal3PxyImPzRansop9O9nXdnbP3zqM+KVeya5xYrlZhzEyIF
        Vsy08s3MD3v67t32eTe1q1nfHimy0XL7ZxXYPUvR61Td8rAvlbwMauGdPBnzvyRPm1LyTdC7
        5nR0wdN6JZbijERDLeai4kQAGrhjCdQCAAA=
X-CMS-MailID: 20200528013232epcas5p32fecbbebc06909ff1fa7136481891dc1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013232epcas5p32fecbbebc06909ff1fa7136481891dc1
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013232epcas5p32fecbbebc06909ff1fa7136481891dc1@epcas5p3.samsung.com>
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

