Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1C0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA92C6103C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhJRMrj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64064 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhJRMr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:26 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211018124511epoutp0437408795d68590cfa13c4db338cc2c0c~vIKuY5Xyo0084700847epoutp04K
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211018124511epoutp0437408795d68590cfa13c4db338cc2c0c~vIKuY5Xyo0084700847epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561111;
        bh=DKThkSvqKVMDYX+GT+CR2cS4wZ2iAiNEfHZRkAbFJJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9uYn+g2fL8Mm45pBD9BTVmSnw/oXxAOeuZDCXiEasDyMZe3PKV3kjQJYGCvQlDCk
         ArCpdtpnH/FLJCH4x2Bj3OLbPCytjjk52yb5Sr9MXRA8NC8yVmPostO92RENygrMqS
         jA/FQCDu87FWcDU4KVbuJBQ0zYebSFMPsmWxS9jY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211018124510epcas2p434125e18b3d62f56e5c3cc853b79a876~vIKt4ZRi52241122411epcas2p4a;
        Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.98]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HXxRQ2P66z4x9Q2; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E5.14.09868.25C6D616; Mon, 18 Oct 2021 21:45:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p38f13fa432c4f6e5ca4898a8f41c2b041~vIKpeNGs40244402444epcas2p3I;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp1e30ad5e8a397357c983aaa86bce630bb~vIKpdYsSY1588315883epsmtrp1D;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a45-9b9ff7000000268c-7b-616d6c521b3a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.50.08902.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip2e452a784899401d2e92cee64096cc562~vIKpQcIIe0235802358epsmtip2t;
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
Subject: [PATCH v5 09/15] scsi: ufs: ufs-exynos: factor out priv data init
Date:   Mon, 18 Oct 2021 21:42:10 +0900
Message-Id: <20211018124216.153072-10-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJsWRmVeSWpSXmKPExsWy7bCmmW5QTm6iwall/BYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8Udk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDPKSmUJeaUAoUCEouLlfTtbIry
        S0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkusDA0MjEyBChOyMy5NamIr6OCt+DJjE0sD
        4xeuLkZODgkBE4lfSy+xdTFycQgJ7GCUuPKhD8r5xCix/H87M4TzjVFi45wjLDAtTw6shKra
        yyjxcstHdgjnI6NE149udpAqNgFdiS3PXzGCJEQE3jNKPHk8BayKWeAps8S8H71sIFXCAl4S
        d1bNYQKxWQRUJf6tv8AKYvMKOEj8+9XMBLFPXuLIr05mEJsTKN6z6AgTRI2gxMmZT8BuYgaq
        ad46G+xYCYEXHBLz7zSzQzS7SEz6/pIZwhaWeHV8C1RcSuJlfxs7REM3o0Tro/9QidWMEp2N
        PhC2vcSv6VuALuIA2qApsX6XPogpIaAsceQW1F4+iY7Df9khwrwSHW1CEI3qEge2T4cGl6xE
        95zPrBC2h8Sp29+gYToZGFob1rNOYFSYheSdWUjemYWweAEj8ypGsdSC4tz01GKjAkN4JCfn
        525iBKd3LdcdjJPfftA7xMjEwXiIUYKDWUmEN8k1N1GINyWxsiq1KD++qDQntfgQoykwsCcy
        S4km5wMzTF5JvKGJpYGJmZmhuZGpgbmSOK+laHaikEB6YklqdmpqQWoRTB8TB6dUA9P23Ddn
        7Jbnbi+3U6pXdpW9IN1o/i1T4BO3ZOBkb1bDK9miLzutTlw2zInZ2bAhl2Hlb2GPnz96Kw6c
        /7lT9rj2Tac89ctq/FPLTsRsW7iMs+lKxcOKkKjaZb+qvR/d7DysxyDOppZ39qb+0saqs0E2
        UjyPSp8firoi3y10MuL8wqAVuXYP9c81hMXqCJTaHLjL/unS1SstSumK1bd9gtw71hlvvLUm
        wf1R1Pr1/jfuNyotPLvdQ9Wd36Sxbv+WEj3r2QZ2W3Yv1DL4KFdQcfpxuorn2SMPvrywUJzq
        99TswtkPDzc4Ou6LVE8Tn1jB3pLZJ1Am+jN/+4rdjQvmbp0hd/We/sH51/bwfX88IUOJpTgj
        0VCLuag4EQBPJGOUeAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwbnlehYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        lyY1sRV08FZ8mbGJpYHxC1cXIyeHhICJxJMDK9m6GLk4hAR2M0rsOfGDESIhK/Hs3Q52CFtY
        4n7LEVaIoveMEu/utIIl2AR0JbY8fwXWICLwkVFizjctkCJmgY/MEndWLmEBSQgLeEncWTWH
        CcRmEVCV+Lf+AiuIzSvgIPHvVzMTxAZ5iSO/OplBbE6geM+iI2BxIQF7icUvZzND1AtKnJz5
        BGwmM1B989bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4
        CrU0dzBuX/VB7xAjEwfjIUYJDmYlEd4k19xEId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7G
        CwmkJ5akZqemFqQWwWSZODilGpi4zxx52Hp11/9jjxctXLws/sfmWIPdQXGcZ6TUW+v2n2Fq
        VlzcG5+/Z53k6yV3/02Tm7VymnHcVqlD1lr7H75/J3GiriZ5pfaBBSnnZ1ZVvzVW2qtofCX8
        zQyHpSemd1478NlmngxXLdeTP3u3uYQm8xt8SeyMy944Zc80dqvypMNJQcz6jxf/Erk/J/hg
        h57uj7/zcuTKZ8wL7Kn9GLzc4T5/wJdegQt2xrz9t7rz2SReXWcVOLHtx9EAS55sx9mzixcc
        cJ+Ve6iV/fQRltyUSfta9K7XrC5c+Vxy1yKPdSa3mnZyb6jYfMZWu1O97J5jrq+OpGN6lmf+
        72u7msL/it12lTvZYrSySWj3zt1rlViKMxINtZiLihMB6Vl9YzEDAAA=
X-CMS-MailID: 20211018124505epcas2p38f13fa432c4f6e5ca4898a8f41c2b041
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p38f13fa432c4f6e5ca4898a8f41c2b041
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p38f13fa432c4f6e5ca4898a8f41c2b041@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be used this assignment code for other variant exynos-ufs driver,
this patch factors out the codes as inline code.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index ce9ac3bf5e95..6bb4bbb2af21 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -946,6 +946,18 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 	return ret;
 }
 
+static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
+					struct exynos_ufs *ufs)
+{
+	ufs->hba = hba;
+	ufs->opts = ufs->drv_data->opts;
+	ufs->rx_sel_idx = PA_MAXDATALANES;
+	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
+		ufs->rx_sel_idx = 0;
+	hba->priv = (void *)ufs;
+	hba->quirks = ufs->drv_data->quirks;
+}
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
@@ -995,13 +1007,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	if (ret)
 		goto phy_off;
 
-	ufs->hba = hba;
-	ufs->opts = ufs->drv_data->opts;
-	ufs->rx_sel_idx = PA_MAXDATALANES;
-	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
-		ufs->rx_sel_idx = 0;
-	hba->priv = (void *)ufs;
-	hba->quirks = ufs->drv_data->quirks;
+	exynos_ufs_priv_init(hba, ufs);
+
 	if (ufs->drv_data->drv_init) {
 		ret = ufs->drv_data->drv_init(dev, ufs);
 		if (ret) {
-- 
2.33.0

