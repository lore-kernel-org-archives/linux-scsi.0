Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08502C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 16:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D86E520775
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 16:03:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="o6S9OlhI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403776AbgFYQD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 12:03:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13753 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390736AbgFYQD2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 12:03:28 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200625160325epoutp02a099bc26a6abb528fb2d2a595d22b0a2~b1OxoXwZb2863828638epoutp02L
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:03:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200625160325epoutp02a099bc26a6abb528fb2d2a595d22b0a2~b1OxoXwZb2863828638epoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593101005;
        bh=9ALuHxf5OBjHgU3MNpNNEuG4GURbQGPtK7QiyttU4Dg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=o6S9OlhIOdkwgyS4f+rNZzQQo+8UsGimsT5ZpiWrMOxu4tdGiU5oQp9DWt7c1mMR8
         cDxynylwn+UEafvYIr/XgluuYXwECRVxWbtS1HpwEXtl19YSHvy/Q9HSUVtWsOcJuP
         mCkJX+gp8gEGPHbskFmmIagvDM3DWXOY1fsTf6aQ=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200625160324epcas5p2918e42ecec14bf11563ed3c50d4c5b89~b1Ow1DsHv1896018960epcas5p2M;
        Thu, 25 Jun 2020 16:03:24 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.70.09475.CCAC4FE5; Fri, 26 Jun 2020 01:03:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200625160323epcas5p3f36a90efa2bf7bcbdd71bdccf2a20eb0~b1OwEhhf60412604126epcas5p3r;
        Thu, 25 Jun 2020 16:03:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200625160323epsmtrp2501f58aea64887ede6f5b7e9aeb2d109~b1OwD0vKo1518415184epsmtrp2z;
        Thu, 25 Jun 2020 16:03:23 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-1a-5ef4caccc5a4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.06.08382.BCAC4FE5; Fri, 26 Jun 2020 01:03:23 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200625160322epsmtip1d34613f5e8ae439fc1d363c8f8620326~b1Ou_eT8B1641616416epsmtip1v;
        Thu, 25 Jun 2020 16:03:22 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     linux-scsi@vger.kernel.org
Cc:     avri.altman@wdc.com, martin.petersen@oracle.com,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH -next] scsi: ufs: ufs-exynos: Fix build warning
Date:   Thu, 25 Jun 2020 21:14:05 +0530
Message-Id: <20200625154405.60448-1-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWy7bCmlu6ZU1/iDLbMY7F4MG8bm8XLn1fZ
        LBbd2MZkcXnXHDaL7us72CyWH//HZLF171V2B3aPxhs32DwmLDrA6PHx6S0Wj74tqxg9Pm+S
        82g/0M0UwBbFZZOSmpNZllqkb5fAlTGl4S1zwWKOin/v/BsY57B3MXJySAiYSPyZeZ21i5GL
        Q0hgN6PEs2OfwRJCAp8YJTYs8oFIfGOU2PzqNCtMx/cPH5kgEnsZJWZvOQ3ltDBJTLz4FqyK
        TUBb4u70LUwgtoiAnMTm5V9ZQIqYBZYxShz69AIsISxgL3G/dQ1jFyMHB4uAqsTqz7kgYV4B
        G4kDm29CbZOXWL3hADNIr4TALnaJXbsWMEIkXCQerZzMAmELS7w6vgXqISmJz+/2soHMlBDI
        lujZZQwRrpFYOu8YVLm9xIErc1hASpgFNCXW79IHCTML8En0/n7CBNHJK9HRJgRRrSrR/O4q
        VKe0xMTubqjLPCQePTwCDaxYifMvl7NPYJSZhTB0ASPjKkbJ1ILi3PTUYtMC47zUcr3ixNzi
        0rx0veT83E2M4CjX8t7B+OjBB71DjEwcjIcYJTiYlUR4Q9w+xQnxpiRWVqUW5ccXleakFh9i
        lOZgURLnVfpxJk5IID2xJDU7NbUgtQgmy8TBKdXA9NCMv1Q6XyDwlVGWvtYb09WTrCUiEp7L
        MK0MCT8l/sR1Z3JfRtIuhuaGQ+fTbm23Pu9Z5lv66Fraa6lljVo+4hG3fz7hvPro1s8fG5d5
        nG04Yrz4fnJF1vWEzlkvtz1znaxnY7rk8oVvzAIpU+9kBsv27n29ca/I8n22ZWZ3HN/otUye
        NvdqVNi1GvaG35fMt1hWcuUdnz316Z67ou/3pk959OTSp7X/BDxPF53cuPEg56HOd9lKl76x
        zW65/jduTUDrnoudnseSXN8sndzy9KvTusXeOc0sS/gThWcHak++lTmj/+nxe20xK181fi/Q
        N5S5NWnx5lStxTrG/h4VR08yF+2bwjfz8iKjXe/nntZUYinOSDTUYi4qTgQAMkhA/2EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42LZdlhJTvf0qS9xBr2v+C0ezNvGZvHy51U2
        i0U3tjFZXN41h82i+/oONovlx/8xWWzde5Xdgd2j8cYNNo8Jiw4wenx8eovFo2/LKkaPz5vk
        PNoPdDMFsEVx2aSk5mSWpRbp2yVwZUxpeMtcsJij4t87/wbGOexdjJwcEgImEt8/fGTqYuTi
        EBLYzSjx58J1JoiEtMT1jROgioQlVv57DmYLCTQxSTz65wRiswloS9ydvgWsXkRATmLz8q8s
        IIOYBdYwSky984wFJCEsYC9xv3UNYxcjBweLgKrE6s+5IGFeARuJA5tvskLMl5dYveEA8wRG
        ngWMDKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYKDSUtzB+P2VR/0DjEycTAeYpTg
        YFYS4Q1x+xQnxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQimCwTB6dU
        A1PEj7oNRd5VC47NSxBa/P2m3dNbUkUOCSd7Ijv4qj3uXuW0F7n/Up7j8s/N+8yfhp9f2L5g
        XUy+go+hXo3+rzp3iSfzjhubCmxon5D5Uu+FuLHehXUP1ynGyvWWzfXynR2x57lEZciyCwbh
        xefc37S3r07vSZFdMHd+ya5nl4/78J88ELH97D/b7jfvDd94hrOHMBZmT9fJXaqWmrZu8yyf
        eseU5auuH+3uctQTeBfZ0lov8z/x4WeWw4LNpXOD3vzdu2zx+46fhR/dGi1jE65PnPX1iYtn
        iLxe3JzW2fOv3psh8urbn7Wye3cp2G/yCl0dYFyz4KBG8KRGRqZaj727teXVJrn6zdhfdD/x
        pocSS3FGoqEWc1FxIgA4haG4lQIAAA==
X-CMS-MailID: 20200625160323epcas5p3f36a90efa2bf7bcbdd71bdccf2a20eb0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200625160323epcas5p3f36a90efa2bf7bcbdd71bdccf2a20eb0
References: <CGME20200625160323epcas5p3f36a90efa2bf7bcbdd71bdccf2a20eb0@epcas5p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While building for x86_64 allmodconfig, below warning reported

WARNING: modpost: missing MODULE_LICENSE() in drivers/scsi/ufs/ufs-exynos.o

Add the missing license/author/description tags.

Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 16544b3dad47..b0796066a449 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1290,3 +1290,8 @@ static struct platform_driver exynos_ufs_pltform = {
 	},
 };
 module_platform_driver(exynos_ufs_pltform);
+
+MODULE_AUTHOR("Alim Akhtar <alim.akhtar@samsung.com>");
+MODULE_AUTHOR("Seungwon Jeon  <essuuj@gmail.com>");
+MODULE_DESCRIPTION("Exynos UFS HCI Driver");
+MODULE_LICENSE("GPL v2");

base-commit: 3f9437c6234d95d96967f1b438a4fb71b6be254d
-- 
2.17.1

