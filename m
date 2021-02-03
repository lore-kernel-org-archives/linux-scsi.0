Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8636CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 10:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A70664E38
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 10:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhBCK2v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 05:28:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48391 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbhBCK2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 05:28:37 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210203102754epoutp0415ee5725a274b159b32ec8f82d637133~gNggJf3a22799027990epoutp04H
        for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2021 10:27:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210203102754epoutp0415ee5725a274b159b32ec8f82d637133~gNggJf3a22799027990epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612348074;
        bh=Z9kNkZzAEeTBfD4O65pjiQmP4wonM7//9FIOKqztpco=;
        h=From:To:Cc:Subject:Date:References:From;
        b=hs9tIfRSsTRZBIGAQBggz/aY/C7Ta9jIgLTB4YCG00BUAvnc+s7ouw6fCpFa7rALg
         PLKVUnnBnHyKmWPhjDC5rT5HFOfmWW4IxFhHB8iI0sMdhqmJhsaKUTY2yrGtUzFGBf
         I8++0jPIWHnGuwZnAogz9sZyD2P3eMNapjCox6ok=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210203102753epcas1p2700257122fed645bfa89d07ad8d42ea9~gNgfRzdoI1166611666epcas1p28;
        Wed,  3 Feb 2021 10:27:53 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.165]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DVyYh6Gdyz4x9Q3; Wed,  3 Feb
        2021 10:27:52 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        90.9C.09577.8AA7A106; Wed,  3 Feb 2021 19:27:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210203102752epcas1p16713d977a1a679cf641894144d8f299d~gNgdsIcr21883018830epcas1p1H;
        Wed,  3 Feb 2021 10:27:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210203102752epsmtrp2a2bd67f385aed59c7b9b22aae4608378~gNgdq9i0J2703827038epsmtrp2A;
        Wed,  3 Feb 2021 10:27:52 +0000 (GMT)
X-AuditID: b6c32a39-bfdff70000002569-5f-601a7aa8336a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.D2.08745.7AA7A106; Wed,  3 Feb 2021 19:27:51 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210203102751epsmtip2e8885f16afef4054870103046f61f745~gNgdVrjAD3260932609epsmtip2F;
        Wed,  3 Feb 2021 10:27:51 +0000 (GMT)
From:   DooHyun Hwang <dh0421.hwang@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com,
        DooHyun Hwang <dh0421.hwang@samsung.com>
Subject: [PATCH] scsi: ufs: print the counter of each event history
Date:   Wed,  3 Feb 2021 19:14:43 +0900
Message-Id: <20210203101443.28934-1-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxjfube9LZrKtTJ2IAzxDrdIBFpr6XEKM0LI3ZSFZNmSubFSy+XZ
        11rKkIyMx0SwBaozmcI0DJjKwzQpjxSkvHRCCTImg00YmQhomI4MkKE83Fou2/jv+37f73e+
        3/edc/i48BHhy0/RpDN6jUJFEVs4zTf3hAZfy/KNF1kfhiDnVD2B7l9uJpCjoJeHZp4PE6hr
        ooiD5q1XuOhCXwEXtY84eWh5zcpDU9YyHBU2fYWhyl+aMWR/1M9DrWv5GBpq/YZApp/tBLra
        8wJDpXXjBMpbbeegkf5eLvqu6R5ADXf/4hz2podKijG6wmakq9pmMNpWW0TQlspOQH/p7ODQ
        S9ZCgp6bHuXQJY21gF6w+dOnO01Y7NbjqkPJjCKB0QcwGqU2IUWTFE4dfU8eKZeGicTB4gNI
        RgVoFGomnIo6FhscnaJyjUsFZChURhcUqzAYqNCIQ3qtMZ0JSNYa0sMpRpeg0olFuhCDQm0w
        apJClFr1m2KRaJ/UxYxXJT+1jHF1LdzMpnwbLwfc4pwBHnxI7ocD+Q+5Z8AWvpC0A1hwpghn
        k3kAK67XbVQWAHRWT7kk/HVJhyPSrRaSrQDm9L7/H8fRvoK7CwQZAtuKa9fFXmQ7Bn+t6cDc
        CU7OAfjt6GPCzdpBRsKp8xaeO+aQu+Httv51tYAMh1Wd97iswZ1w9TfzBr4dOi9OrRvHXXh+
        U/m6V0g+4cPF8rM4ay8Klo5ns9od8PeeRh4b+8KFWQfBxiYAS7sjWK0FwKEe80ZBAucXFoD7
        HJzcA62toSy8C7asXAJs321wdtHMZVsJYGGBkKW8DqteLLkoPFfsB3O3sigNJwfNHHZXcbDk
        9gxhATvLNs1StmmWsv/bVgC8FngzOoM6iTGIddLNd2oD6y8+6IAdfP3HnyHdAOODbgD5OOUl
        6DvnHS8UJChOZjF6rVxvVDGGbiB1bfcs7vuyUuv6Mpp0uVi6TyKRoP1hsjCphHpFcEJ0Xy4k
        kxTpTBrD6Bj9vzqM7+Gbg6VGtsyn3bXXN5e/qiIlsknVYJfo1NCz2cTJK4Mxb58YOyLMANdB
        bYCg2uzz1mcdhNoS5+2MNN24Mxjx8Xnz7JPUSkejmr7E1HCNK9ZTWRem9yqv+TvnsN2BPh4P
        Wo6kKs3bZCdrpKY8+UR8qbffdHjX0aiXvP6+E7iWU9Ecdbz4I2op0zPL/O5N06c2P7r6R27a
        0E/QHhMa5nmMn5iXXRSNyYY/WPHkUj1xj6mRg5/vHb1R/0ZxbuaHDUVR5/KWC4djcp8v99kc
        zDOfhvHssYNZNadf+8RvNTaosqxuQvrOrcNS0CNStvv/0NkVvThgzgiUJT79vn/75S8GrlbV
        XHwwTHEMyQpxEK43KP4Bhs/uOHoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsWy7bCSvO7yKqkEg2lLLSxOPlnDZvFg3jY2
        i71tJ9gtXv68ymZx8GEni8Wn9ctYLWacamO12HftJLvFr7/r2S2erJ/FbNGxdTKTxaIb25gs
        djw/w26x628zk8XlXXPYLLqv72CzWH78H5NF/+q7bBZNf/axWFw7c4LVYunWm4wWmy99Y3EQ
        87jc18vksWBTqcfiPS+ZPDat6mTzmLDoAKNHy8n9LB7f13eweXx8eovFo2/LKkaPz5vkPNoP
        dDMFcEdx2aSk5mSWpRbp2yVwZXyZcJu1YCdrxdbmTewNjEdYuhg5OCQETCT273XuYuTiEBLY
        wSix+fY79i5GTqC4jET3/b3sEDXCEocPF0PUfGSU+HJjPTNIDZuAnsSe3lWsIAkRgXNMErfn
        LWEEcZgFfjNKTPrRDDZJWMBZ4smUCWA2i4CqxLE9Z8C6eQVsJRYfuMkKsU1e4s/9Hqi4oMTJ
        mU9YQGxmoHjz1tnMExj5ZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cT
        IzjutLR2MO5Z9UHvECMTB+MhRgkOZiUR3lOTxBKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817o
        OhkvJJCeWJKanZpakFoEk2Xi4JRqYLow8QJnaHttwvWfdsGbLQM/T//QeO/Qg2Mx3QEmHdlS
        Lv3pRUlJ2znnn5vhYv5ig6Sy4pzYWdlHfJtPKkcvWL4pbN/DE48fPVh2/pfMvnOdc49MOL12
        tl3IXfNpS2cu27TGSLbutsw65aPvPZLOV7icfOz1566nvqr4tx0Cl8U7w9c0ZD29ZDY5a1Uy
        05XS2uXXTNfNNzAKDH8gff7Xn4Z9DWqd7RJRp2/H6QlPDX+p+OoSz6Kky3ExSXXhzr+XhUuU
        LSmfGLK7tMTiU6DSzIOBIvUrEye2RrkdzZKWXGDJ8ShmvmnQk1Np7ZuXi0XXXbvne7TUNVLh
        uVtvU7txQ8CRvpnW8VVsHI2pzSY7/yixFGckGmoxFxUnAgAGQP0SKgMAAA==
X-CMS-MailID: 20210203102752epcas1p16713d977a1a679cf641894144d8f299d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210203102752epcas1p16713d977a1a679cf641894144d8f299d
References: <CGME20210203102752epcas1p16713d977a1a679cf641894144d8f299d@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since only print the recorded event history list,
add to print the counter value.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 721f55db181f..1ea920aeb701 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -451,6 +451,8 @@ static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
 
 	if (!found)
 		dev_err(hba->dev, "No record of %s\n", err_name);
+	else
+		dev_err(hba->dev, "%s: total cnt=%llu\n", err_name, e->cnt);
 }
 
 static void ufshcd_print_evt_hist(struct ufs_hba *hba)
-- 
2.29.0

