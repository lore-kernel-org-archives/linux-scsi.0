Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE4DC07E9C
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA2161221
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhGIHAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38129 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhGIHAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:37 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210709065752epoutp045b6a5ebe895b2b0f8d58f5570a95b14d~QDRpePQ4B1010810108epoutp04j
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210709065752epoutp045b6a5ebe895b2b0f8d58f5570a95b14d~QDRpePQ4B1010810108epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813872;
        bh=VaR7GsTXdfN/ttujUGssJkAQBO+Bmj7HAq8hMUH+6Fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cj3ajFoIBr4g8lKhm2nTs4mMEDKMbnuqgqjoElkeDl2fqv9LTXNtjyDlvd/NJ7J4t
         5L/9HLSL5ARzy5Hw2wI9R05OYLHpwgqJDmvST+aw5d2nMkgSkS5QxPiKG6qiUdvrF6
         fk4boK0jC0yqHqaDQJVHg041WGZ6hlwodHdzL474=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210709065749epcas2p28fbc4d11a23768cc65b6e8cff377839f~QDRnLXQy41001710017epcas2p2I;
        Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GLkWJ21KTz4x9Q2; Fri,  9 Jul
        2021 06:57:48 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.7D.09571.C63F7E06; Fri,  9 Jul 2021 15:57:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epcas2p284a0f5eac2e46bf03283b7a7363616c4~QDRkmWm_k2549725497epcas2p2J;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065747epsmtrp2be7bb33d29dd2c80f8e3d17cbf8b0b35~QDRkk1bTo0268602686epsmtrp28;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
X-AuditID: b6c32a48-1dfff70000002563-fd-60e7f36c2c9f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.C7.08289.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2ef429046a313456d150b51ce9421f077~QDRkZ-KhS3077030770epsmtip2Q;
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
Subject: [PATCH 12/15] scsi: ufs: ufs-exynos: add pre/post_hce_enable drv
 callbacks
Date:   Fri,  9 Jul 2021 15:57:08 +0900
Message-Id: <20210709065711.25195-13-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmqW7O5+cJBr82cFqcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORl7b/czFqzirXg+eyl7A+MM7i5GDg4JAROJ6y2iXYxcHEICOxglXi9Y
        wQrhfGKUuLF4AnsXIyeQ85lR4vmfTBAbpOHXzymMEEW7GCW+LrzAAuF8ZJS4/nQeI0gVm4Cu
        xJbnr8CqRAT6GSWW758LVsUscJJZ4vSCg2BzhQVCJZ5NhtjBIqAqcflbPwuIzStgL7Hx3T4W
        iH3yEqeWHWQCsTmB4vN+TGCCqBGUODnzCVgNM1BN89bZzCALJAROcEhs3f2SEaLZRWL3qVOs
        ELawxKvjW9ghbCmJz+/2skE0dDNKtD76D5VYzSjR2egDYdtL/Jq+hRUUTMwCmhLrd+lDQkxZ
        4sgtqL18Eh2H/7JDhHklOtqEIBrVJQ5snw51vqxE95zPUBd4SLw6ORsavpMYJbZsP8E6gVFh
        FpJ3ZiF5ZxbC4gWMzKsYxVILinPTU4uNCkyQo3gTIzhRa3nsYJz99oPeIUYmDsZDjBIczEoi
        vEYzniUI8aYkVlalFuXHF5XmpBYfYjQFBvZEZinR5HxgrsgriTc0NTIzM7A0tTA1M7JQEufl
        YD+UICSQnliSmp2aWpBaBNPHxMEp1cA0w2BFex9H+3QBlf3nF3A+bEg3/iY5VzJcr+J06Opb
        2gXH3j3ni7oZVvtT7+zGE8a5K1sSXfa1Zrsn3K73Oxnt3iboalLF483751BXm7qk+/fObeVq
        5gVBfC65Jy538TTez3sjqFR1/rTu7IMp646vnq50hdng2w5Wc430+pAXKq3PtlnuXSy4tXiK
        +8a1Z+dPfMD49en7KxNPWaznNeXT4nxiu7WZ1Sx7o/ty+fr3LK3KVltkVW3P3+7OC+pgXPt/
        jpFvk8w2O1+Wo1wmckUdcmbya2fNeNZ68rXHQj17HhfXLU9+Xto+h2Hx33KJGw9F/9RXOrY/
        C+w2yDmd6azPtO7E1ol9JsvW7Jp675oSS3FGoqEWc1FxIgBOCgoAXQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJXjf78/MEg3W3mS1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfG3tv9jAWreCuez17K3sA4g7uLkZNDQsBE4tfP
        KYxdjBwcQgI7GCW2BEOEZSWevdvBDmELS9xvOcLaxcgFVPKeUeJE13w2kASbgK7EluevGEFs
        EYGJjBJL7omBFDELXGaW+DbtCjNIQlggWGLy2xNgDSwCqhKXv/WzgNi8AvYSG9/tY4HYIC9x
        atlBJhCbEyg+78cEMFtIwE7i3oZ97BD1ghInZz4Bq2cGqm/eOpt5AqPALCSpWUhSCxiZVjFK
        phYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeTltYOxj2rPugdYmTiYDzEKMHBrCTCazTj
        WYIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTBv/HNlh
        vqHOYsKVhdczbtydzHri2Kmvh987Kxg2zvt0x3ihzMO0i4aawXbJ7s7bNhyda/bRu/r2A9O6
        61/rd9qd4j1teH/ltU/9lvtYtjFYlO3bt6DN9qX/u4M7bhpuUmW48G7L7LkVjEevvV25KVAs
        xN1gXtCOHPerFl8XOFz+3x5wKLnKYWPcMpW8dY+ORhXLLpx2XfzwjTwZi9mMkSJXq55r3jJR
        YuRkmHSk2jFqzXKvxLl3A+XWxazaJ2VoOcFjVYDoiQtnfU5vFC/Ytk2JddsC//v3GGPeS97w
        vKei3HnzaEV/wOZTU7/PMI1lOFXRquJtI/yqefXLV5rTHq3dsfnpTAHb02+1pUz/H2R4psRS
        nJFoqMVcVJwIALcck2IVAwAA
X-CMS-MailID: 20210709065747epcas2p284a0f5eac2e46bf03283b7a7363616c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p284a0f5eac2e46bf03283b7a7363616c4
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p284a0f5eac2e46bf03283b7a7363616c4@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds driver-specific pre/post_hce_enable callbacks to execute
extra initializations before and after hce_enable_notify callback.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 10 ++++++++++
 drivers/scsi/ufs/ufs-exynos.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 81b8b8d9915a..9669afe8f1f4 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1141,6 +1141,12 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 
 	switch (status) {
 	case PRE_CHANGE:
+		if (ufs->drv_data->pre_hce_enable) {
+			ret = ufs->drv_data->pre_hce_enable(ufs);
+			if (ret)
+				return ret;
+		}
+
 		ret = exynos_ufs_host_reset(hba);
 		if (ret)
 			return ret;
@@ -1150,6 +1156,10 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 		exynos_ufs_calc_pwm_clk_div(ufs);
 		if (!(ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+
+		if (ufs->drv_data->post_hce_enable)
+			ret = ufs->drv_data->post_hce_enable(ufs);
+
 		break;
 	}
 
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 8695270d38d9..9c44ca81020b 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -154,6 +154,8 @@ struct exynos_ufs_drv_data {
 				struct ufs_pa_layer_attr *pwr);
 	int (*post_pwr_change)(struct exynos_ufs *ufs,
 				struct ufs_pa_layer_attr *pwr);
+	int (*pre_hce_enable)(struct exynos_ufs *ufs);
+	int (*post_hce_enable)(struct exynos_ufs *ufs);
 };
 
 struct ufs_phy_time_cfg {
-- 
2.32.0

