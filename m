Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF2EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 09:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346878AbiCOJ6m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 05:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbiCOJ6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 05:58:35 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67962AF2
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 02:57:22 -0700 (PDT)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220315095721epoutp02c1dde5abdabe9cfd0f36a093d1fb4a88~chWcNW-iF1332113321epoutp02L
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 09:57:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220315095721epoutp02c1dde5abdabe9cfd0f36a093d1fb4a88~chWcNW-iF1332113321epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1647338241;
        bh=guf5a+UyXn8Tu3/RRFV+ifGaLBDshbdYgxhEy4V5WMs=;
        h=From:To:Cc:Subject:Date:References:From;
        b=HPfI4l0ICHLLyKOl/34UDxPWBAmBDigH63JqWyGazzMBQ2T2wrG7gq1mBWJ9TA3se
         WUuG7NJ23WSeHsZv6/tFUfjRpDoIkZ2tod2V9rVewIHCpGashqNCgILwLSh6czpynp
         WrZeQBzqkx3gtcAPpAHHHBLYNvCg7wrf79kDHEl8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20220315095720epcas2p3c0a87e40ad406b33cfdd7f432df9d4dd~chWbjNGDS0321003210epcas2p3X;
        Tue, 15 Mar 2022 09:57:20 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.102]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KHpjT2GXQz4x9Pv; Tue, 15 Mar
        2022 09:57:17 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.39.16040.DF260326; Tue, 15 Mar 2022 18:57:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220315095716epcas2p2ec52c66863b71180a6c2c45856058683~chWX7Bv550452404524epcas2p2F;
        Tue, 15 Mar 2022 09:57:16 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220315095716epsmtrp1e1fe9f4d9d85366daa36972679b7aad5~chWX6HqVa1158911589epsmtrp1T;
        Tue, 15 Mar 2022 09:57:16 +0000 (GMT)
X-AuditID: b6c32a46-bffff70000023ea8-38-623062fd68ae
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.9D.03370.CF260326; Tue, 15 Mar 2022 18:57:16 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220315095716epsmtip29d8bd28845a2e47d2552acf27faad352~chWXt7gJ01295012950epsmtip2k;
        Tue, 15 Mar 2022 09:57:16 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com, vkumar.1997@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v3] scsi: ufs: exclude UECxx from SFR dump list
Date:   Tue, 15 Mar 2022 18:56:02 +0900
Message-Id: <1647338162-75639-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdljTTPdvkkGSwZzf/BYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLm1uOslhc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFos79z+yOPB7XO7rZfJYvOclk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgiMq2yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAG6XkmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYF6gV5yYW1yal66Xl1piZWhg
        YGQKVJiQnTFp9kr2gjaeir835rE1MJ7h7GLk5JAQMJG4fvgHexcjF4eQwA5GiVNrP0I5nxgl
        vpx7zwrhfGaU2L6imw2m5cWF1ywQiV2MEtse/2GEcH4wSrQ1nGAGqWIT0JR4enMqE4gtInCd
        SWLe9gwQm1lAXWLXhBNgcWEBN4kNc5rBprIIqEocPzofaCoHB6+Aq0TT7CCIZXISN891MoPM
        lxBo5ZDYdH4LK0TCRWJP50FGCFtY4tXxLewQtpTEy/42dpA5EgLFEpv2yUP0NjBKLPm0mQWi
        xlhi1rN2RpAaZqA71+/ShyhXljhyiwXiSj6JjsN/oabwSnS0CUE0Kkv8mjQZaqmkxMybd6CW
        eki82/Mb7HEhgViJB2svME9glJ2FMH8BI+MqRrHUguLc9NRiowIjeBwl5+duYgSnRy23HYxT
        3n7QO8TIxMF4iFGCg1lJhPfMC/0kId6UxMqq1KL8+KLSnNTiQ4ymwNCayCwlmpwPTNB5JfGG
        JpYGJmZmhuZGpgbmSuK8XikbEoUE0hNLUrNTUwtSi2D6mDg4pRqYbmvMFLq9dfOjDSxHL558
        d/uvhf/TGRz+2qr3tLRfLhaYG3xS/u+zpplVkpcdj/ol3NwhYR1mG+J35nfv1KUn793ace9W
        EtPi+/Y/pJIrtgTfWK2SvJ79qdgS+R/HA6PWXOOalPNWaZlPffG9t3E1cbfOCEmnOefWrL9a
        slku9cUXTran9rZKph8Pn/1RdLLr3+8Z9/5/uK16TawgP3Yjf+af8Cf1Bz5MMmGqXpjzk2Gt
        tNv3N+tnBJ6SUP4073uU/E+Txq9b7TLzEzO4ZcQn9zXf0tkf2rwr4F65RnyVr1zgUr+zJk/F
        Ji2wkPnUIrc2ZI2xY1r5DrPi1lyR0xONC2t2Nf6JdEgwftjg9HpBkRJLcUaioRZzUXEiAAau
        x84YBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSvO6fJIMkg38rNCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWN7ccZbG4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LBZ37n9kceD3uNzXy+SxeM9LJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAEcVlk5Kak1mWWqRvl8CVMWn2SvaCNp6KvzfmsTUwnuHsYuTkkBAwkXhx4TULiC0k
        sINRonthOURcUuLEzueMELawxP2WI6xdjFxANd8YJdqf32QHSbAJaEo8vTmVCSQhIvCSSeLF
        nDVsIAlmAXWJXRNOMIHYwgJuEhvmNIPFWQRUJY4fnQ+0jYODV8BVoml2EMQCOYmb5zqZJzDy
        LGBkWMUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyyWlo7GPes+qB3iJGJg/EQowQH
        s5II75kX+klCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1
        MHEnJoYcFdnAvDb+2MMDyWHNBWwykxr2n1hVftZbPCxxgcui6X4zj2ue+3zrlMZj+7fZ36qO
        XYy2Ut32627Cbo7epO8Mt68KbBVpd084svbC2pmNnk333NO25pa/eaSbeSF0SQSzWJJVhnhs
        o+CPZXsS5Z65qB7b9L6ke2bvzJRw+XMTt602nvy0Uv3s9TsfivQ+eU5Yt/ZMEXNk95upUsEL
        1mbOCny4MD2Uxbr/Yo+u9SGO9X88fz/6+eTex1dbNu76FLCv/PBOuVX/X7uJrGU1TDRdtJFd
        8AjjGfOfjp9Uec543f48vzxH5+Pm5XKNk165rjQon7alOOBrscZu+TmyUz1TrXf6i8n3GDts
        3HtaiaU4I9FQi7moOBEAJSaXdMgCAAA=
X-CMS-MailID: 20220315095716epcas2p2ec52c66863b71180a6c2c45856058683
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220315095716epcas2p2ec52c66863b71180a6c2c45856058683
References: <CGME20220315095716epcas2p2ec52c66863b71180a6c2c45856058683@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v2 -> v3: add fixes
v1 -> v2: does skipping only for zero offset

These are ROC type things that means their values
are cleared when the SFRs are read.
They are usually read in ISR when an UIC error occur.
Thus, their values would be zero at many cases. And
there might be a little bit risky when they are read to
be cleared before the ISR reads them, e.g. the case that
a command is timed-out, ufshcd_dump_regs is called in
ufshcd_abort and an UIC error occurs at the nearly
same time. In this case, ISR will be called but UFS error handler
will not be scheduled.
This patch is to make UFS driver not read those SFRs in the
dump function, i.e. ufshcd_dump_regs.

Fixes: d67247566450 ("scsi: ufs: Use explicit access size in ufshcd_dump_regs")
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 460d2b4..7f2a1ed 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -115,8 +115,13 @@ int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 	if (!regs)
 		return -ENOMEM;
 
-	for (pos = 0; pos < len; pos += 4)
+	for (pos = 0; pos < len; pos += 4) {
+		if (offset == 0 &&
+		    pos >= REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER &&
+		    pos <= REG_UIC_ERROR_CODE_DME)
+			continue;
 		regs[pos / 4] = ufshcd_readl(hba, offset + pos);
+	}
 
 	ufshcd_hex_dump(prefix, regs, len);
 	kfree(regs);
-- 
2.7.4

