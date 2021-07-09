Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D45C11F69
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AA0061221
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhGIHAh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50405 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210709065749epoutp0376528b28e1168de148d34abd90090382~QDRnHAtQI2276222762epoutp03h
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210709065749epoutp0376528b28e1168de148d34abd90090382~QDRnHAtQI2276222762epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813869;
        bh=rjwJ4dRGZpPwc9QzXTmfR3F2iqx4i1w0LwG82FMYvV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzroLmuF6usJ0aiAEFnrWUlErphvV6CFUiqLj08TKV3cSiAdFRryxJPgn0jeDQlwH
         Kthwt9IwTfWIAZo+XECWD49amVY7aXEn55rQDaI4V929l4XghneuV/1CzItWJBkt8M
         waCnrASPRk1ULZMpFLx39+N5rGkbrg3Q6obWcwyQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210709065748epcas2p32a2505c79910b36884c7ebc1d4084291~QDRmKdDF_2002320023epcas2p3_;
        Fri,  9 Jul 2021 06:57:48 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GLkWH3Px3z4x9QQ; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C3.7D.09571.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epcas2p2e966883390d1e77a43a897eae9ef0ad3~QDRkd4yei2550225502epcas2p2L;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp284e9a23d2440a1c10d876bbeb73a0e9b~QDRkdBEcT0268602686epsmtrp27;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a48-1f5ff70000002563-fa-60e7f36b7cd9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.63.08394.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2ce1806bba2bd947c0cb936cc9503fde0~QDRkQUdZF3177431774epsmtip2g;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 10/15] scsi: ufs: ufs-exynos: add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
Date:   Fri,  9 Jul 2021 15:57:06 +0900
Message-Id: <20210709065711.25195-11-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmhW725+cJBudPiFucfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORn3Hx5gLljBXfH3y3m2Bsb3nF2MnBwSAiYS3xa9ZwexhQR2MErcW5PS
        xcgFZH9ilLi4fS0jhPONUWLf9nOMcB33T0Ml9jJKfOlpYoVwPjJKXFp8kgmkik1AV2LL81dg
        VSIC/YwSy/fPZQFxmAVOMkucXnAQbKOwQJzEy4d/wTpYBFQlbi3/BWbzCthLXHswkwlin7zE
        qWUHwWxOoPi8HxOgagQlTs58wgJiMwPVNG+dzQyyQELgAIdE07rz7BDNLhIrW++yQNjCEq+O
        b4GKS0l8freXDaKhm1Gi9dF/qMRqRonORh8I217i1/QtQM9xAG3QlFi/Sx/ElBBQljhyC2ov
        n0TH4b/sEGFeiY42IYhGdYkD26dDbZWV6J7zmRXC9pD41nmZCRJakxgl5q9czzqBUWEWkndm
        IXlnFsLiBYzMqxjFUguKc9NTi40KTJDjeBMjOFVreexgnP32g94hRiYOxkOMEhzMSiK8RjOe
        JQjxpiRWVqUW5ccXleakFh9iNAUG9kRmKdHkfGC2yCuJNzQ1MjMzsDS1MDUzslAS5+VgP5Qg
        JJCeWJKanZpakFoE08fEwSnVwHSw+ff0Dq7HV1iaz82z+LDMzpTHdGnLtFuRRWdtO35t+bxN
        4bblhOiiL0v7o+9qBfxk749fUPHuzP9YRbErpW9LGq79T6tS/uE+WcUumiE/ZSVn+3ruWgd1
        pfJXB2TPmQnL6Z5R4W88e7045LesqJis+JXLf53D17ze+e/WuTtv0mTcr8wOfR3GurCh1C/b
        1P2wbo2y2w6TOtnnp65cOJP0d39nvvM9O62J6Y42lV4J1jWPjl3kmsrvPi+WQdmDcZJfWKfb
        z5CdqXLHvQ0F/8v1VHNL1Ya9YJS5wpfq+jb8yJqAueFfV7mUdm6an3uov2TSFOWG7F2RXE1p
        nLNvLI385vqS6cTRzObk5dW5SizFGYmGWsxFxYkAiqMcRV4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg63vzSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfG/YcHmAtWcFf8/XKerYHxPWcXIyeHhICJxLf7
        pxm7GLk4hAR2M0p0zD7DDpGQlXj2bgeULSxxv+UIK0TRe0aJhR1/GEESbAK6EluevwKzRQQm
        MkosuScGUsQscJlZ4tu0K8wgCWGBGInle6exgtgsAqoSt5b/YgKxeQXsJa49mMkEsUFe4tSy
        g2A2J1B83o8JYLaQgJ3EvQ372CHqBSVOznzCAmIzA9U3b53NPIFRYBaS1CwkqQWMTKsYJVML
        inPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIjSktzB+P2VR/0DjEycTAeYpTgYFYS4TWa8SxB
        iDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqYrxTcuHM70
        OXOiiinaq3f5LuP3Jzru+z49EHZRcE+wR83rSQt/VX9Zk/Ul5pHW6QjHHUfWFtVzmF41m8wQ
        mncls6314W3XxY9jl+ZHLvzyrUROtf16zYT27fdaDYVXLXTeNI9hRc+L3K+Hpnrn1NjGMNT8
        t6vusVw0ub0lRo/nWLOXvS4ne0xBiiiPQa7TA/OK+FvOfnLhZ3Z47Py2ap/G4Y0Fbi+flruo
        WUbK2h3ombw99ubSz+u/P1haM2dy3iVT26jGJbfiZ/YLPvyVHTY9U/9/xCs7iU9/u65uLPmv
        umQy86R+1Z7k5cqB/jFzshRsmlhYaza2sV8V3KRZ1vSskK3msNuFOomXsc9iDJVYijMSDbWY
        i4oTAeyvC1cXAwAA
X-CMS-MailID: 20210709065747epcas2p2e966883390d1e77a43a897eae9ef0ad3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p2e966883390d1e77a43a897eae9ef0ad3
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p2e966883390d1e77a43a897eae9ef0ad3@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To skip exynos_ufs_config_phy_*_attr settings for exynos-ufs variant,
this patch provides EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR as an opts
flag.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 6 ++++--
 drivers/scsi/ufs/ufs-exynos.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 90c0d7c85a13..9a5a7a5ffc4b 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -831,8 +831,10 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
-	exynos_ufs_config_phy_time_attr(ufs);
-	exynos_ufs_config_phy_cap_attr(ufs);
+	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
+		exynos_ufs_config_phy_time_attr(ufs);
+		exynos_ufs_config_phy_cap_attr(ufs);
+	}
 
 	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 0938bd82763f..8695270d38d9 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -200,6 +200,7 @@ struct exynos_ufs {
 #define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
 #define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
 #define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
+#define EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR	BIT(5)
 };
 
 #define for_each_ufs_rx_lane(ufs, i) \
-- 
2.32.0

