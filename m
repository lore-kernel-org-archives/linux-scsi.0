Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057B0C43219
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 04:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiKRExs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 23:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiKRExf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 23:53:35 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E28E80
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 20:53:31 -0800 (PST)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221118045328epoutp02d36714be5090ef36f8d2869ca965b43f~olL6rOaKT0197301973epoutp02I
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 04:53:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221118045328epoutp02d36714be5090ef36f8d2869ca965b43f~olL6rOaKT0197301973epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668747208;
        bh=6Mq4Ye3ZC3MbTWf/UK6IaMcJY/o4/4AUd/BfQzoMcgk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=avDJZAGov+3hjgR7IixLWfxO4Qw6B9TEWhh9uLnjmw70FoxuBRx6LkpQ6qPwI5nju
         Iy/jullQvUuACxWW7WnS8agtLAulzuyWZKbP59xg5T4RCRnY1SS0ig5YH6e6zLBDtH
         tM0BEmrdiLnCth5yQn61C6SdRgzLqxHVYDgPlJqY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221118045328epcas1p101526969b9455db2e3e8b0a9b7c0169e~olL6PyUVr2370723707epcas1p1Z;
        Fri, 18 Nov 2022 04:53:28 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.38.248]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4ND4DR3L6jz4x9Ps; Fri, 18 Nov
        2022 04:53:27 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        96.26.07146.7CF07736; Fri, 18 Nov 2022 13:53:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c~olL5AJ2eu0594605946epcas1p42;
        Fri, 18 Nov 2022 04:53:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221118045326epsmtrp1e6154f2d8ae0dda8a4c84145ae4f763c~olL4-gVMM0968609686epsmtrp1W;
        Fri, 18 Nov 2022 04:53:26 +0000 (GMT)
X-AuditID: b6c32a35-a091fa8000021bea-f3-63770fc7d6d2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.47.14392.6CF07736; Fri, 18 Nov 2022 13:53:26 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.100.232]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221118045326epsmtip174c10cae4d2b5dd29c824fb9e263ca25~olL4w8_GW0075400754epsmtip1s;
        Fri, 18 Nov 2022 04:53:26 +0000 (GMT)
From:   Chanwoo Lee <cw9316.lee@samsung.com>
To:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc:     ChanWoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
Date:   Fri, 18 Nov 2022 13:52:42 +0900
Message-Id: <20221118045242.2770-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTQPc4f3mywd65YhYzTrWxWiy6sY3J
        4nLzRUaL7us72CyWH//HZNHUYmyxdOtNRgd2j52z7rJ7TFh0gNFj85J6j5aT+1k8Pj69xeLR
        t2UVo8fnTXIB7FHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+
        AbpumTlA5ygplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswK9IoTc4tL89L18lJL
        rAwNDIxMgQoTsjPmbZvBUnCFveLRqsPsDYxH2LoYOTkkBEwkXrx+C2RzcQgJ7GCUeNPWzA7h
        fGKUOLz4NFTmG6PEtU/LGbsYOcBarn3XgYjvZZR48GwSK4TzhVHi1twHrCBFbAJaErePeYPE
        RQRWMEpcPfyMBWQfs4CGxMlZT9hBbGEBR4nOCb2MIDaLgKrE9qarrCA2r4CVxOlTV6Huk5f4
        c7+HGSIuKHFy5hOoOfISzVtnM4MskBC4xS6xadNWZojrXCR2dEZC9ApLvDq+hR3ClpJ42d/G
        DlHfzCix7eslJging1FiY+sLRogqY4lPnz+DvcksoCmxfpc+RFhRYufvuYwQi/kk3n3tYYXY
        xSvR0SYEUaIiMafrHBvMro83HrNC2B4S99YtBIsLCcRK/H3dzzKBUX4WkndmIXlnFsLiBYzM
        qxjFUguKc9NTiw0LDOGxmpyfu4kRnCS1THcwTnz7Qe8QIxMH4yFGCQ5mJRHe3IulyUK8KYmV
        ValF+fFFpTmpxYcYTYEBPJFZSjQ5H5im80riDU0sDUzMjEwsjC2NzZTEeRtmaCULCaQnlqRm
        p6YWpBbB9DFxcEo1MDkXumWkTF5Qubhs2UuHnOx4rV3G53Qs1eaFHPm+VI2xZimj4YorPuL8
        u5j5rxu2yGxuMH51Zvehn3xmJRtCA437OE/HNNx4tbFyys0Z28OX8rKn/72ydm5+28Vt170L
        nz7kUb0yMe9LwOvlr0/IrxbZkuG/gd39avO2JwmJvRYvfQIm/gpbbmlxLZ7zfszFBzr7uQ0Y
        7yt0FhyfH8e0IfCDzo9JaxYEnb20NLJLxuLn/bSN23cH68hyl3T7Peb6dsArcWrIuRWbp5/J
        8G8qTjC0MZectzzvb7fpzvPcZ9QKP6gw73iT+la0JfrQ+6V+0VUlim31/4UO+rN8DV/99NsM
        SZvjS9U/qLpfX5ZyrEaJpTgj0VCLuag4EQDYti1bGwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsWy7bCSnO4x/vJkg5dHNSxmnGpjtVh0YxuT
        xeXmi4wW3dd3sFksP/6PyaKpxdhi6dabjA7sHjtn3WX3mLDoAKPH5iX1Hi0n97N4fHx6i8Wj
        b8sqRo/Pm+QC2KO4bFJSczLLUov07RK4MuZtm8FScIW94tGqw+wNjEfYuhg5OCQETCSufdfp
        YuTiEBLYzShx6cke5i5GTqC4lMTu/eehaoQlDh8uhqj5xCixe+UyJpA4m4CWxO1j3iBxEYF1
        jBJntv1mBOllFtCQODnrCTuILSzgKNE5oRcsziKgKrG96SoriM0rYCVx+tRVNohd8hJ/7vcw
        Q8QFJU7OfMICMUdeonnrbOYJjHyzkKRmIUktYGRaxSiZWlCcm55bbFhgmJdarlecmFtcmpeu
        l5yfu4kRHLJamjsYt6/6oHeIkYmD8RCjBAezkghv7sXSZCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYVr9d8oDl4pEcXR31tN/ZPapC/46sNa+Z/mir
        Q+zB//cWVvIf4Xi8uqx5+fQJbLbmdo7L4yp0Juj6te9Y/vhNeULhyv2Jbn1hXecMOPd83NDx
        5yh/mdin0PMdl5w1+3K2BQRlTGbccOjgi8OOfOWcW/zn5jRsLTa7deCOeAu33sFZSSmuKf+E
        DIvnfT87fZtNnmOi+gmPkO8XVuYorz0wa0H91IL9SnOVrXUrXouL6KZMnG/P9FNg2b4nfD9+
        5vToz/k287jDosNRK/byteXcj7nDFrfQtNX+gc4a5y1+DUUPWN8v6k1zZnwyUfbW3xPzlgoI
        TxEx5Vx27coJqRvdYkuK99zvLf4z3SYjvddkkxJLcUaioRZzUXEiAGnNv57IAgAA
X-CMS-MailID: 20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ChanWoo Lee <cw9316.lee@samsung.com>

Change the same as the other code to return bool type.
  91: 	return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
  98: 	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
  105:	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 7d13878dff47..ef5816d82326 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -109,7 +109,7 @@ static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return (host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
+	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
 }
 
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
-- 
2.29.0

