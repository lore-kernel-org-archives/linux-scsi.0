Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19190C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 035536112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhIQG5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41797 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbhIQG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:51 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210917065526epoutp03385f8450da09772329ca04055ac1bb39~liZgIWrfO0358003580epoutp03P
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210917065526epoutp03385f8450da09772329ca04055ac1bb39~liZgIWrfO0358003580epoutp03P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861726;
        bh=MRrBSUR634b5hu8flt9/LdYTIil76y865hidQqj1g+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaX8HUPd6Rik4vJegF/q5YzLvTLLst1MuA0tcsl3vFMeVrMZ2iOal8vRlF0gu988M
         mn2pJuOhbqhQkj6GNrMT5cDIPkiIOIL+3JL4KRZDIrmN69krlMQ51lLRPldYGE7IRt
         VgF5BnfSGrnpJ4DDbaFgwkzQp2TQ4oT4LnTxStmE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210917065524epcas2p21608d925d55bb057496511bac328072b~liZe_s3Ij3234832348epcas2p21;
        Fri, 17 Sep 2021 06:55:24 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8C3KhDz4x9Q7; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.ED.09749.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd~liZdM-BaD3235032350epcas2p2r;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210917065522epsmtrp28a91ede70cc2a52323d090439a977e56~liZdMERPU1371513715epsmtrp2P;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-a8-61443bdbce47
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.10.09091.ADB34416; Fri, 17 Sep 2021 15:55:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip21e25f3f16c26c5ae4f876f3b4e4fe8ac~liZc7v35w2196321963epsmtip2o;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
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
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v3 03/17] scsi: ufs: ufs-exynos: change pclk available max
 value
Date:   Fri, 17 Sep 2021 15:54:22 +0900
Message-Id: <20210917065436.145629-4-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJsWRmVeSWpSXmKPExsWy7bCmhe5ta5dEgw2d4hYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyWLj2x9MFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
        lhbmSgp5ibmptkouPgG6bpk5QN8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoM
        DQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMj7t3s1ecIS1YuGUX6wNjDdYuhg5OSQETCRmf+tm
        62Lk4hAS2MEoceFcK5TziVHixP59LBDON0aJS2dnM8K0vHy5nx0isZdR4t3so1BVHxkllt7d
        zA5SxSagK7Hl+StGkISIwHtGiSePp4C1MAt8ZZLYffA7G0iVsECQxLl9l8BsFgFViR+XlgB1
        cHDwCthLbD5WDLFOXuLIr05mEJtTwEHi1q7/YGfwCghKnJz5BOwLZqCa5q2zmUHmSwhc4ZBY
        u76HBWSOhICLxIcdThBzhCVeHd/CDmFLSXx+t5cNor6bUaL10X+oxGpGic5GHwjbXuLX9C2s
        IHOYBTQl1u/ShxipLHHkFtRaPomOw3/ZIcK8Eh1tQhCN6hIHtk+Hhq+sRPecz6wQtofEkbXT
        mSBhNZlRouHTD6YJjAqzkHwzC8k3sxAWL2BkXsUollpQnJueWmxUYIwcxZsYwelby30H44y3
        H/QOMTJxMB5ilOBgVhLhvVDjmCjEm5JYWZValB9fVJqTWnyI0RQY1BOZpUST84EZJK8k3tDU
        yMzMwNLUwtTMyEJJnHfuP6dEIYH0xJLU7NTUgtQimD4mDk6pBqbtE5dfeL1uFWd5X1PLdX5F
        u/Xps/In78tRZjrZFlct4TNpm8k0oxliliKNYeZVk/oYWqa2vZx73q+l+2vYShb/fWx9WkUa
        ++0uXj1ZeTqR2WvRqY212cab7N/UrX/90FdZyjLU+LFqjP7RZYVqb1n+/1F5Pi/qQuJirs19
        3vM/PJkT5dxy5E9tdPz9D58PrItrXswn+OuThnbZmcN7Xzt8T/Y316uaeP/HV/+QLV+WCE5q
        basvPjJl74/6ieaR75ewF9+RWJvQ6Tvd8XXc58pasWsf8w7+m8mldVrs7Y8OqZUe93/Khyxa
        47UkqvW3eOjr1yu4ixNEp3SlX97iqd7/6lxcaIf5xM4FD2/MZ7ugxFKckWioxVxUnAgAMCIR
        b2gEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42LZdlhJXveWtUuiwfxOA4uTT9awWTyYt43N
        4uXPq2wWBx92slhM+/CT2eLT+mWsFpf3a1v07HS2OD1hEZPFk/WzmC0W3djGZLHx7Q8mixnn
        9zFZdF/fwWax/Pg/Jgd+j8tXvD1mNfSyeVzu62Xy2LxCy2PxnpdMHptWdbJ5TFh0gNHj+/oO
        No+PT2+xePRtWcXo8XmTnEf7gW6mAJ4oLpuU1JzMstQifbsEroxPu3ezFxxhrVg45RdrA+MN
        li5GTg4JAROJly/3s3cxcnEICexmlHh3/gMzREJW4tm7HewQtrDE/ZYjrBBF7xkl7u5+A9bN
        JqArseX5K0YQW0TgI6PEnG9aIEXMAn+ZJFpbNzCBJIQFAiTmvOkGK2IRUJX4cWkJkM3BwStg
        L7H5WDHEAnmJI786wRZzCjhI3Nr1H6xcCKhk4uRFYDavgKDEyZlPwPYyA9U3b53NPIFRYBaS
        1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYKjTEtzB+P2VR/0DjEycTAe
        YpTgYFYS4b1Q45goxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwT
        B6dUA1OM2dnPda77Srf8MTr/8+dfXjs528surLobmJTTql+1vLZ/+njpSu5XaWFsNXIhb264
        JS16JWSq3S3gw1ypeaTd53G6qeQtJw0rC0e/XWHaaxwn1djumPooYv3LRBnuCq83AS9S3c/x
        WCx9+in4pt7v39tbnDs3TJnyKkYws+3FXP68P9c3hR4wr9vpsSw29XPV9daPt0KC1R5ovIh8
        dHL2XonlWzbPO6lZ1hT9cHHFganf9t7+3HL61O3EA7MzPBYYttRkfVi8m+F/bqmy/4rmM9kv
        Ikpul0ew7G0sPPkl7tsP5gsPv88TmulZddXcqLH4y8Tbnw98nvr3E//FqSH1Z/TeZWfulFIQ
        v1W5bt0CJZbijERDLeai4kQATCzopSEDAAA=
X-CMS-MailID: 20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support 167MHz PCLK, we need to adjust the maximum value.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index dadf4fd10dd8..0a31f77a5f48 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -99,7 +99,7 @@ struct exynos_ufs;
 #define PA_HIBERN8TIME_VAL	0x20
 
 #define PCLK_AVAIL_MIN	70000000
-#define PCLK_AVAIL_MAX	133000000
+#define PCLK_AVAIL_MAX	167000000
 
 struct exynos_ufs_uic_attr {
 	/* TX Attributes */
-- 
2.33.0

