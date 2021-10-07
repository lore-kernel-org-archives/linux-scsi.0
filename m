Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301B4C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE7961163
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240662AbhJGIOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43009 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240664AbhJGIOD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:03 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211007081209epoutp0146cbff0dbe3987cbbeac055c13391c2d~rsWMjR-aW1645416454epoutp01Q
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211007081209epoutp0146cbff0dbe3987cbbeac055c13391c2d~rsWMjR-aW1645416454epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594329;
        bh=TW2/nk4jDuiLFCFTmrOnDly8/DaBMFmAg3aO8wQGITs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWJhRVB5T+6viBhm503B1MQncJUtql5nB+eQ86MIkT54Q0OSGFRBSfv2cVeH+sMhI
         LVLYE9EHw4sl8D3f4h/Gc2dWRxkMODE+xNbNRJjWTlf6Qmc21XlQucy4YU5+qNqHUj
         3nxEUvD888UcOtV4yVXn6MI8W+Tn5jYyDw7odbHg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211007081155epcas2p1596f2245df2d613f2bdb02a952248d3d~rsV-ptJUI2609026090epcas2p1b;
        Thu,  7 Oct 2021 08:11:55 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.98]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HQ3v851HNz4x9QC; Thu,  7 Oct
        2021 08:11:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.6F.09717.1CBAE516; Thu,  7 Oct 2021 17:11:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p4121be716aafc8900713e331026eceaa8~rsVsKNgNA3097130971epcas2p4Z;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp158f4392ba08145d112fdac60cb7b47f4~rsVsEvtvg2164721647epsmtrp1g;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-5d-615eabc12bbb
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.A7.08750.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip2460fedc3f55de32c264d267ed2499eaf~rsVr2JGKN0566205662epsmtip29;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v4 05/16] scsi: ufs: ufs-exynos: add refclkout_stop control
Date:   Thu,  7 Oct 2021 17:09:23 +0900
Message-Id: <20211007080934.108804-6-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmme6h1XGJBrddLE4+WcNm8WDeNjaL
        lz+vslkcfNjJYjHtw09mi0/rl7FaXN6vbdGz09ni9IRFTBZP1s9itlh0YxuTxY1fbawWG9/+
        YLKYcX4fk0X39R1sFsuP/2Oy+P3zEJODoMflK94esxp62Twu9/UyeWxeoeWxeM9LJo9NqzrZ
        PCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBPVLZNRmpiSmqRQmpecn5KZl66rZJ3
        cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBbSgpliTmlQKGAxOJiJX07m6L80pJUhYz8
        4hJbpdSClJwC8wK94sTc4tK8dL281BIrQwMDI1OgwoTsjIeT17MVHGav6Fuzl7WBcS1bFyMn
        h4SAiUTn2gbWLkYuDiGBHYwSN3paWCCcT4wS9xsWQ2U+M0o8ODSTFaZl1rb9zBCJXYwSs+6e
        Y4dwPjJK7Hr/G2wwm4CuxJbnrxhBEiIC7xklnjyeAlbFLHCAWeLxzp9Aszg4hAW8JU59rgFp
        YBFQlVhx5h7YCl4Be4mDq7rYIdbJSxz51ckMYnMKOEjs2QVxOa+AoMTJmU9YQGxmoJrmrbPB
        TpIQeMAhcWDifRaIZheJ41+vQ9nCEq+Ob4EaKiXxsr+NHaKhm1Gi9dF/qMRqRonORh8I217i
        1/QtYIcyC2hKrN+lD2JKCChLHLkFtZdPouPwX3aIMK9ER5sQRKO6xIHt06G2ykp0z/kMDTkP
        ie2bNzJBAmsyo8SK2x+ZJzAqzELyziwk78xCWLyAkXkVo1hqQXFuemqxUYEhPI6T83M3MYIT
        upbrDsbJbz/oHWJk4mA8xCjBwawkwptvH5soxJuSWFmVWpQfX1Sak1p8iNEUGNgTmaVEk/OB
        OSWvJN7QxNLAxMzM0NzI1MBcSZx37j+nRCGB9MSS1OzU1ILUIpg+Jg5OqQYmi+qzG7gnpP++
        WyvwSmmTKrdC4vU53KVN0V6tF5QT5nLNk//I/mZVQcL1Tu6nNa2fHH/ty9y1zrRi7cmiXodv
        7Ds7ra+Z8+aeea14wPqKbPWhziWiF0qv17w/0TW399DOf7+0JAvLrut8dn7C3V1h+uq7k8Hq
        XzIJL7k2ViWdkrvUtag+aWfj2sqwV+t+9ZTPZxUyMS2NPF+79/fiiYZ/F99qMPE3VlaeEPTw
        WPn6zqc6Wn8E9BMCbz1k3OOUmaL2dZ41v9L5qCmX99iJKWmUyrm2LNXJteJM/+lnqTo9WdZs
        37mSrn1Okexv139WidA7KOxyWVZBUDU6aP3dG7b9mw7P2C1te95J/1780etKLMUZiYZazEXF
        iQDN//jpcQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBrN7eC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCymHF+H5NF9/UdbBbLj/9jsvj98xCTg6DH5SveHrMaetk8Lvf1MnlsXqHlsXjPSyaPTas6
        2TwmLDrA6PF9fQebx8ent1g8+rasYvT4vEnOo/1AN1MATxSXTUpqTmZZapG+XQJXxsPJ69kK
        DrNX9K3Zy9rAuJati5GTQ0LARGLWtv3MXYxcHEICOxglVq/+zQKRkJV49m4HO4QtLHG/5Qgr
        RNF7Rokb/96wgiTYBHQltjx/xQhiiwh8ZJSY800LpIhZ4BSzxNp1m4AmcXAIC3hLnPpcA1LD
        IqAqseLMPbBeXgF7iYOruqAWyEsc+dXJDGJzCjhI7NkFch0H0DJ7ia6/kRDlghInZz4Bu40Z
        qLx562zmCYwCs5CkZiFJLWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERx3Wlo7
        GPes+qB3iJGJg/EQowQHs5IIb759bKIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNIT
        S1KzU1MLUotgskwcnFINTPvmiLt4FFld0Hh0Z8fxzmua4gJVKp9iJfkdhU8+MNml6LHdvvlR
        yLSOSvkTN++EKyvpnX205bS0m+Ei3nKVc/rFp1duMvwiHZa8yX3Fnqfro/6fely0waFtkvLT
        yLV8nQaZBdEtmQedDvx26I6QmFhcH7nDV+x8evbStB7z7sba/Pf/ZL/3BK1iun/IJHTBAnuG
        HZmfnQtkzMOvJxj45++0VFsuwSy0+lz2wWUnbmS/++T2PG1CyLTD74PtE40S3xz48uaDXYVW
        ZNFiRZPSE388GO7Nj5Of0xHhzBxb4jH3x9XXLCLHPzjOkFtpkHnraJx7T/arqmVT3nyyatvb
        IfiD3/GN9Luu9cErkye7KrEUZyQaajEXFScCAI6UjVMqAwAA
X-CMS-MailID: 20211007081134epcas2p4121be716aafc8900713e331026eceaa8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p4121be716aafc8900713e331026eceaa8
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p4121be716aafc8900713e331026eceaa8@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds REFCLKOUT_STOP control to CLK_STOP_MASK. It can
en/disable reference clock out control for UFS device.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 8a17ba32a721..37a4ab4cc662 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -48,10 +48,11 @@
 #define HCI_ERR_EN_T_LAYER	0x84
 #define HCI_ERR_EN_DME_LAYER	0x88
 #define HCI_CLKSTOP_CTRL	0xB0
+#define REFCLKOUT_STOP		BIT(4)
 #define REFCLK_STOP		BIT(2)
 #define UNIPRO_MCLK_STOP	BIT(1)
 #define UNIPRO_PCLK_STOP	BIT(0)
-#define CLK_STOP_MASK		(REFCLK_STOP |\
+#define CLK_STOP_MASK		(REFCLKOUT_STOP | REFCLK_STOP |\
 				 UNIPRO_MCLK_STOP |\
 				 UNIPRO_PCLK_STOP)
 #define HCI_MISC		0xB4
-- 
2.33.0

