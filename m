Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A940C07E9B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 103C861245
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhGIHAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19183 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhGIHAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:34 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210709065749epoutp01c2fb9793882775508035f88c97c8cbdf~QDRnNffUn2699726997epoutp01k
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210709065749epoutp01c2fb9793882775508035f88c97c8cbdf~QDRnNffUn2699726997epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813869;
        bh=nvto6MAUXII++5Qoedhxm85Le+YYY4cABecM5BXJJzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y61S0fcfJb2Hn2UQyCKNkrCo0S/1EkmFS9SIYrqJopBtJcBVKN7UjZRaXue8NwE1f
         H1aeHde/jMjgdFO4ZhldSCtUPLHopzx8AiWCY84xs8c/ZTefCBIIj91nq6c5ckXCUO
         /Zl7SzWDWWdKZEnwEtHfFmv+IcLy2nUiMKltC/Vw=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210709065749epcas2p281cf75d82d3cdd1befe8980bbed51be3~QDRmY1GtF1003510035epcas2p2E;
        Fri,  9 Jul 2021 06:57:49 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GLkWH48Y3z4x9Q7; Fri,  9 Jul
        2021 06:57:47 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.7D.09571.B63F7E06; Fri,  9 Jul 2021 15:57:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210709065747epcas2p11576f5bd85eb2d99ae24a7241869a2f9~QDRkiRok60581505815epcas2p1u;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210709065747epsmtrp19957d387937ec01c8f70366a45aa2b10~QDRkhaR7V3179431794epsmtrp1R;
        Fri,  9 Jul 2021 06:57:47 +0000 (GMT)
X-AuditID: b6c32a48-1dfff70000002563-fb-60e7f36bd270
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FF.B7.08289.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2a02c337458139268508eaef73a0ae524~QDRkVX34F3134631346epsmtip2z;
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
Subject: [PATCH 11/15] scsi: ufs: ufs-exynos: factor out priv data init
Date:   Fri,  9 Jul 2021 15:57:07 +0900
Message-Id: <20210709065711.25195-12-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmmW725+cJBv+/y1mcfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORk7LrAX/OCuuLVyK2MD42fOLkYODgkBE4lHS/27GLk4hAR2MEp0LVvD
        CuF8YpTYeuQMG4TzmVHiTXMXkMMJ1rHxwB2oql2MEjc6V0I5Hxkl5mybwA5SxSagK7Hl+StG
        kISIQD+jxPL9c1lAHGaBk8wSpxccBKsSFnCXeLn7MSuIzSKgKrH9ejsjiM0rYC/xbcMJJoh9
        8hKnlh0EszmB4vN+TGCCqBGUODnzCQuIzQxU07x1NjNE/R4OiQU7oG51kXjRsYIFwhaWeHV8
        CzuELSXxsr+NHeQgCYFuRonWR/+hEqsZJTobfSBse4lf07ewgoKJWUBTYv0ufUiIKUscuQW1
        lk+i4/Bfdogwr0RHmxBEo7rEge3TobbKSnTP+cwKYXtILNj0hh0SWJMYJT7/Xc0+gVFhFpJv
        ZiH5ZhbC4gWMzKsYxVILinPTU4uNCkyQY3gTIzhNa3nsYJz99oPeIUYmDsZDjBIczEoivEYz
        niUI8aYkVlalFuXHF5XmpBYfYjQFhvVEZinR5HxgpsgriTc0NTIzM7A0tTA1M7JQEuflYD+U
        ICSQnliSmp2aWpBaBNPHxMEp1cB0LLpfOP3rxolnw255ycSuUIj7rPHhyJL0KcdXHtZVY18+
        Ybrw08//LN5+PPdFIHRm76zFAoffyur9X/jjleaKPSr9Ew4zK618vNX66BVVlmWrX3n5Llwg
        P7fioMVcnaRHM0zXuzNXLt4Xv+Tco7Od83TXLEpx5+ms3NVb3hjL+bT4q5P3zriCXwv67e1O
        MPROayo/4jF/vVTBma7sCEfn/3obBAImMB90f77mirjW+ZAd76POp0i0Ke2K4zrhnrRCTNPc
        /fD08ze2x7+OPHCwa4anr/qFEGfPxWusrQLbWjOm2V8Vfre9pulD2JTwN2k/Wz9cT5LgU5vp
        cm7Npn5noW835eI9wphNnH6e2J2rq8RSnJFoqMVcVJwIAFkBM91cBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg3WTbSxOPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAlfGjgvsBT+4K26t3MrYwPiZs4uRk0NCwERi44E7
        rF2MXBxCAjsYJVbcvM4OkZCVePZuB5QtLHG/5QhU0XtGiSs7m5lBEmwCuhJbnr9iBLFFBCYy
        Siy5JwZSxCxwmVni27QrYEXCAu4SL3c/ZgWxWQRUJbZfbwdr4BWwl/i24QQTxAZ5iVPLDoLZ
        nEDxeT8mgNlCAnYS9zbsY4eoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYwMq1ilEwtKM5N
        zy02LDDKSy3XK07MLS7NS9dLzs/dxAiOJy2tHYx7Vn3QO8TIxMF4iFGCg1lJhNdoxrMEId6U
        xMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpgsiqRWxlrKrbuU
        F3msKlDj90QuNkWVZqmybq68/j3beIsKu75MM9DxK1+tzGcw89fHde2PHuoXfa7KEu5O3rs/
        d391mpvMCxbul5wvEr5xXlvp9/d2946DscfNnYONxWZt5Jyafe7TSXX+RlFn0bVmHzvZvsh2
        rU41l6y7Ufro2HKVQ7LbzodebMoSMouLYkrdd+zR7PnC18Vi41KMLY4GqDLUfHIrfWTDe591
        dtHFLazfOWsYc3sCPu43U92z59eBpA0Z+2Tev+rcz7WiweGBqjpT+bVrnOvfck6ZLNwVIHvj
        QPGiv4svTdjR7s+sJyfN1hRsfX7p4ero5zUxfVaPJ8YceLXdXnx25gyOV0osxRmJhlrMRcWJ
        AKrgR04WAwAA
X-CMS-MailID: 20210709065747epcas2p11576f5bd85eb2d99ae24a7241869a2f9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p11576f5bd85eb2d99ae24a7241869a2f9
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065747epcas2p11576f5bd85eb2d99ae24a7241869a2f9@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To be used this assignment code for other variant exynos-ufs driver,
this patch factors out the codes as inline code.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 9a5a7a5ffc4b..81b8b8d9915a 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -951,6 +951,18 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
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
@@ -1000,13 +1012,8 @@ static int exynos_ufs_init(struct ufs_hba *hba)
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
2.32.0

