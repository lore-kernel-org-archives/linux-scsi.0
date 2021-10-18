Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F20BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 079FE60F8F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhJRMri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52850 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbhJRMr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:26 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211018124513epoutp020f60e28c82fa42c57a436421419b58fb~vIKwkqfsD0052800528epoutp02c
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211018124513epoutp020f60e28c82fa42c57a436421419b58fb~vIKwkqfsD0052800528epoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561113;
        bh=agDro/M9PB2uWYnwuEqRorzZb9+HXTTGf7awNrCY/qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4Ci52C3Yg9FBiwr/BozQed4YF7lkZlViekrcqnqodfH0djvLVH2z7qIRbycODKZ4
         4NkGq8VwRcZC6+FA+1HxXNQ/47plCh7WpCnSa2Z8berWXAEHNTsrXAX9IMLAIXRde+
         IkIHYcpbg8zHTLM9kz8/WnU0oPzOdRcXAs0jsumE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20211018124509epcas2p39b96fea38c86f88da19d863c899409dc~vIKtLiodu2766327663epcas2p3O;
        Mon, 18 Oct 2021 12:45:09 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HXxRQ2QBKz4x9Q7; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        EB.2C.10014.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p4bf7f7fe8419a03d5510c9adf67aee5ab~vIKpZQWTr2531925319epcas2p4K;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp190a863575a5ba20f8e01545cdda4bea3~vIKpYGSwB1580315803epsmtrp1O;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a47-489ff7000000271e-8d-616d6c525975
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.40.08738.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip28cda2c0f96ce3d2be7c87f35a433f377~vIKpJYCkG0378903789epsmtip2d;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
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
Subject: [PATCH v5 08/15] scsi: ufs: ufs-exynos: add
 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
Date:   Mon, 18 Oct 2021 21:42:09 +0900
Message-Id: <20211018124216.153072-9-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmqW5QTm6iwYw+HouTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFpf3a1v07HS2OD1hEZPFk/WzmC0W3djGZHHjVxurxca3
        P5gsbm45ymIx4/w+Jovu6zvYLJYf/8dk8fvnISYHIY/LV7w9ZjX0snlc7utl8ti8Qstj8Z6X
        TB6bVnWyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCeqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDnlBTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkF5gV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGR+mPGMteM5bse5GH0sD
        YytPFyMnh4SAicTmb4fYuxi5OIQEdjBKrHp3gAXC+cQo0bTlGRuE85lR4ve3O4xdjBxgLS9n
        GkDEdzFK7F6zGKrjI6PE9APTWEHmsgnoSmx5/ooRJCEi8J5R4snjKWBLmAWeMkvM+9HLBlIl
        LJAo8fTtbnYQm0VAVeLx6x4mEJtXwF5iw6yVLBAXyksc+dXJDGJzCjhI9Cw6AlUjKHFy5hOw
        Gmagmuats5lBFkgIvOGQaNrVyA7R7CLxcWMTE4QtLPHq+BaouJTEy/42doiGbkaJ1kf/oRKr
        GSU6G30gbHuJX9O3sII8zSygKbF+lz7E/8oSR25B7eWT6Dj8lx0izCvR0SYE0agucWD7dKjz
        ZSW653xmhbA9JNZu3gQN7MmMEs0ftzJOYFSYheSdWUjemYWweAEj8ypGsdSC4tz01GKjAmN4
        HCfn525iBCd3LfcdjDPeftA7xMjEwXiIUYKDWUmEN8k1N1GINyWxsiq1KD++qDQntfgQoykw
        sCcyS4km5wPzS15JvKGJpYGJmZmhuZGpgbmSOK+laHaikEB6YklqdmpqQWoRTB8TB6dUA5NQ
        5nsWD9mrKrwqvBo6K7mlv9xT0H972mjtpd16Sfd32R7fuHKh4Dyb+WLdldu+Oy2Onb3gL6PP
        9D8fNBNEplVoaOzv23FocoTzAVMZW/+m+TJ1STvWcTfbs3wJXPZ85/51z0p+ZYRJ7TRP27bu
        wRmFx4tvbnOo29L5WirmQrzr8oi0MvG3+1uWGWSc7pW0yirUPjX7drfLbKva01+/Ktemq6T9
        KNiTKPnJ9KnP9vY1v+XO3WqPf3vfkFO6Vumgg6+mT+CazHCllqa0rwKspgkvz+woFIlOzZWY
        5TZtYsh1b9eDFXpxm1QuM/Mr+xkdV1n2oklCMYvr5s9z2o+7XgvNfJ0+e9d71Yz7vn5cR5RY
        ijMSDbWYi4oTAejwFdN3BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwYH3GhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        H6Y8Yy14zlux7kYfSwNjK08XIweHhICJxMuZBl2MXBxCAjsYJRZencHcxcgJFJeVePZuBzuE
        LSxxv+UIK4gtJPCeUWJFRzqIzSagK7Hl+StGEFtE4COjxJxvWiCDmAU+MkvcWbmEBSQhLBAv
        cX3qYTYQm0VAVeLx6x4mEJtXwF5iw6yVLBAL5CWO/OoEW8wp4CDRs+gIE8Qye4nFL2czQ9QL
        Spyc+QSsnhmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yf
        u4kRHIFaWjsY96z6oHeIkYmD8RCjBAezkghvkmtuohBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
        C10n44UE0hNLUrNTUwtSi2CyTBycUg1ME8WZ1dQSvjlN6uaZF8tgU/lkx+Ty0+e///iuuES1
        eTHjbG1GqVxGs4bJv8+8+fgrqPGogPbOj9FGeTVZVk4/LRTfOLeZ9sZOnWXVMnW7VvS1WjOe
        6e2Ntg4HbqjVMHe8Snoz95+1jE+evsSTZwEHJZYveHojmrnrjaO8uqjIDLcVQYZdWcHPwiyL
        //3+e9Sk97D+H6Y1Ngse6Usemhu+O2zlh7bH7zVf/7F/6Pb22VyL/iDn/D0JUZu/bH2a6OQU
        pjzDVejWRdGX/Dydc3im2xraM3xXCpqz6vSsOC8Tzc+7fogH8/068oR1wsT42ijnhBOaBoe+
        P3n87yGLyOxjXab9+cHPlvBL3Z49V09XiaU4I9FQi7moOBEABDO+Ty8DAAA=
X-CMS-MailID: 20211018124505epcas2p4bf7f7fe8419a03d5510c9adf67aee5ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p4bf7f7fe8419a03d5510c9adf67aee5ab
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p4bf7f7fe8419a03d5510c9adf67aee5ab@epcas2p4.samsung.com>
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
index 5536b104794a..ce9ac3bf5e95 100644
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

