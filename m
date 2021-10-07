Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B66C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0801C6113E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbhJGIOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44160 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240657AbhJGIOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:14:10 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211007081216epoutp02e07eaebfb5df2ed78c0011ab57f781ef~rsWTg8e7m0613806138epoutp02C
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211007081216epoutp02e07eaebfb5df2ed78c0011ab57f781ef~rsWTg8e7m0613806138epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594336;
        bh=i8iBSSzmc23UmdmL1TAjsfjEgdPnpaOXk8MchnHpuXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpFinV2LJcOy4GfMPK2qHdMfFF3xHHns0f7JJnkE01Lqk/Jq5k6vcU6kQgbBNLBJr
         bF6et0/8nGZBksyaVZmD48jy72osVuzFxZnk9flZCvcGd81/61wK06//xwC2XnokQD
         S0N52PgQmSgY7O+P4wqUr2DJD7R4FIer07IXBl3U=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211007081200epcas2p46583614919b95d79e3014d1a43494b97~rsWEAFF9q2608526085epcas2p4f;
        Thu,  7 Oct 2021 08:12:00 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.91]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HQ3vC4109z4x9Ps; Thu,  7 Oct
        2021 08:11:51 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.D5.09749.4CBAE516; Thu,  7 Oct 2021 17:11:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p3cf933b0e8c52de665161fb978ec8e577~rsVsi7Z5H0718707187epcas2p3_;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp1b81c262d381733f52d94e71bc56d0a1c~rsVsiAz9T2164721647epsmtrp1h;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-6c-615eabc4fd17
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A2.63.09091.6BBAE516; Thu,  7 Oct 2021 17:11:34 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epsmtip296d1a0b9f7d58c2033454c2e6c25941f~rsVsUfCDX0802008020epsmtip2B;
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
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 09/16] scsi: ufs: ufs-exynos: add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
Date:   Thu,  7 Oct 2021 17:09:27 +0900
Message-Id: <20211007080934.108804-10-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxbZRT2vbe9LUi3u27CGxK2elEJIKzlo71DEAKb3GRLJMHMyBx4hRtK
        KG3T207nxwQnjI/BICxbqUgmxslgiED5GClYC4ygZl8MGaCMjSKCEIFOCyhoy626f88553ly
        znPO+wpR8UPMX5ij1jM6Na0iMG9eZ3+wPGygKZ2W1n8USQ7br2LkdF0nRs6vj2LkNw9KeOSF
        5XWUXG25zCdHvg4lz15LIr+rrEdIe4sJJevvdSLkvY0iPtm6tIaQ4+ZBHmm82YeQZWPdGPnF
        0BZC/rluQxLE1Mjdw5QpvxyjRirKEaq9IYT6zDKPUG2NJRhVWW8FlLOlGKNWZid4VIW5EVCO
        tr3UGWsZkuKTlhurZOgsRidh1JmarBx1dhxxODUjKSNaLpWFyQ6QCkKipvOYOOLgkZSwl3JU
        LnOE5AStMrhSKTTLEvtfjNVpDHpGotSw+jiC0WaptAptOEvnsQZ1dria0cfIpNKIaBfxjVyl
        /Y5UOyd6+3xDhSAfFPqUAi8hxKNg+4+b/FLgLRTj3QD2Lg6gXLAK4GDVqsDNEuN/ADg69kwp
        EG4r7H/hHKcXwK1LRo9gBcBH1tM8twDDw6B5bgG4C3vw3wC0z5wXuAMUn0Vh3Vo55mbtxmno
        rC7juzEPfxYOtV5H3FiEJ8C1sWY+N+A+OLBRgrqxlytv6WnGOM4uOFxj3+6GujinOz7eHgPi
        i0Jo+mXFIz4IjbV3BBzeDReGzB7sD+fPFQk4QRmAhQ//9hSaACwpOMLheLhx0cx3m0bxYNjS
        s5/zHwgHJjx9d8Di/k0BlxbB4iIxJwyC1q6LPA4HwLJah2caCjrHhnnctqoBbNy8jVUCiekx
        O6bH7Jj+b3wJoI3Al9GyedkMG6GN/O/CmZq8NrD92EOSu4FxaTncBhAhsAEoRIk9Ik38cVos
        yqJPvsPoNBk6g4phbSDatewq1P+pTI3rt6j1GbKoA9IouVymiIiWKgg/0SdbibQYz6b1TC7D
        aBndvzpE6OWfjzTvLV0z1i5VDYa3B/4st71gen8iMTTzrLANUKGvOqdVRzueq16o03wq+dzZ
        lfbuoZrUo1cWiZwpS6vPtbEbo6m6dIftXMip2MlbyoTVHzYNrzQ/+rLveS9j3Uzfm4mTkZFB
        3jPjjgeC1o2Y0F71zuSpjbf8fGKsO+UFpuCa97yQJwsCUL8+3wuB+2yYT8Vy5bg26XLaKau+
        9OVfS04espzgZ12ZZxvuzwZ99S3vp6nE4IG7+LKypjA14AOsH73Zk9c9f8YubzIN5T6xkvi7
        Q1F4vbvLYJFbj+u2xE+PfLjDN1tkPlZgmpyOmtp1I+1qx/fHbgdGrrxGOu7HJ8emv37LSc4R
        PFZJy0JQHUv/A11Pu4d1BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvO621XGJBq1fpCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8WNX22sFhvf
        /mCyuLnlKIvFjPP7mCy6r+9gs1h+/B+Txe+fh5gchDwuX/H2mNXQy+Zxua+XyWPzCi2PxXte
        MnlsWtXJ5jFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQJ4orhsUlJzMstSi/TtErgy
        nlwyKHjOWzFlRR97A2MrTxcjB4eEgInEkz8CXYxcHEICuxkl/s3aztjFyAkUl5V49m4HO4Qt
        LHG/5QgrRNF7RolFd9+CJdgEdCW2PH8F1iAi8JFRYs43LZAiZoGPzBJ3Vi5hAdkgLBAvMWG7
        DkgNi4CqxPGNx5hAbF4BB4kf19eyQiyQlzjyq5MZxOYEiu/ZtZYNpFVIwF6i628kRLmgxMmZ
        T1hAbGag8uats5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZG
        cPRpae5g3L7qg94hRiYOxkOMEhzMSiK8+faxiUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3Sd
        jBcSSE8sSc1OTS1ILYLJMnFwSjUwle91Ph4w7/y8qacX/S6L/njz17EJrNPmRmpEaV4+fjg1
        33frrPcC6iujC+cqXH7adEK1TdmjY++Vtwwyaz2ZuBZu4Wg13tfqOeds3KdZi86xHZsnu0b4
        eKrv9t9njzwRnfxh8s8n9pan+za27S4N/yOr9GN1G5/n14i1s3hFyqLiwjM7vXgqZbK/3O/Y
        XLIteFLCbtOfqzz4z8TIs60VmDeF98HpgzcSvsiqaLeHF305WbBUf1LSJKdZDaEKW6yfVL77
        dGum+D3DG0fXmc4oL74mx23Q2i4caLuiXuDNBPH9DsmS1cvP9+Z67TR7J8L8THTHjqbjr5Xe
        dXLdtOvNffxaMmpL0PwnLin6K7yOzFJiKc5INNRiLipOBAAr3AmiLQMAAA==
X-CMS-MailID: 20211007081134epcas2p3cf933b0e8c52de665161fb978ec8e577
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p3cf933b0e8c52de665161fb978ec8e577
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p3cf933b0e8c52de665161fb978ec8e577@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To skip exynos_ufs_config_phy_*_attr settings for exynos-ufs variant,
this patch provides EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR as an opts
flag. Regarding exynosauto v9 SoC's controller, M-Phy timinig setting is
not required and most of vendor specific configurations will be
configured on pre_link callback function.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 ++++--
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 8df792071a0a..72ab98d42dc8 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -830,8 +830,10 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
-	exynos_ufs_config_phy_time_attr(ufs);
-	exynos_ufs_config_phy_cap_attr(ufs);
+	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
+		exynos_ufs_config_phy_time_attr(ufs);
+		exynos_ufs_config_phy_cap_attr(ufs);
+	}
 
 	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 74f556d8a003..89955ae226dc 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -199,6 +199,7 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
 #define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+#define EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR	BIT(5)
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
-- 
2.33.0

