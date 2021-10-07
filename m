Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90239C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7567D611C3
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbhJGIOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:14:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45897 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240648AbhJGIN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:13:59 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211007081204epoutp04eae54d9aa1bf967feac38e438ecfa271~rsWIlp_Jo0086800868epoutp04d
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211007081204epoutp04eae54d9aa1bf967feac38e438ecfa271~rsWIlp_Jo0086800868epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594324;
        bh=7BL2AWr6+0k7oxNShoCpcCYD/b8/ltLEIlEjR8sYOls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1p3ny/ZzA5QGIqU1Z5abTaeCi2KBMg11bVHLIK8efxDxvQspZI2KNNFvAb8tU3oc
         pD4F24hwKu8kwgcUghz2aLzZLnvu7+tFH+R296DNRYSIosrtRg1anpOTZeDlmQa4UM
         nowBNb4y/oEbraPAOXYJ+ZryBARNh/DK7wA5fo5M=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081148epcas2p29f177c598ba8672fd13715101fe5962a~rsV5tz_2o3143931439epcas2p2r;
        Thu,  7 Oct 2021 08:11:48 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.90]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HQ3v543Djz4x9Qj; Thu,  7 Oct
        2021 08:11:45 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.6F.09717.CBBAE516; Thu,  7 Oct 2021 17:11:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081134epcas2p27513b5eed7fc78424709f70fa651a877~rsVr7ZO9p3103131031epcas2p2v;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211007081134epsmtrp11d9f56b897f493a35cb8e36275768df4~rsVr6b_wL2164721647epsmtrp1f;
        Thu,  7 Oct 2021 08:11:34 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-4b-615eabbca0f6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.A7.08750.5BBAE516; Thu,  7 Oct 2021 17:11:33 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epsmtip24dbe04206e3331917734346e8d214a59~rsVrmT0wC0776407764epsmtip2Q;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
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
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v4 03/16] scsi: ufs: ufs-exynos: change pclk available max
 value
Date:   Thu,  7 Oct 2021 17:09:21 +0900
Message-Id: <20211007080934.108804-4-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwbZRjPe9ceBVZzlOHesA26MxOHAVpC6Q35kk13EdwYRGPIFE+4FEJp
        a68QJVkGIh0MBkwYzOIHoGVIYYxSWSFk8hUI4D4YQ2DGsE5wwNwE6qLAQFuO6f77Pc/z+z2f
        7ytARTbMW5Cu0jFaFa0kMDdeR/8BWUC36T1acqHRnRyebcbIu191YOTC6gRG9tqKeGTV0ipK
        rrQ28MnxH14mSzoPkaPl9Qj52Uw5j5xtNaBk/VQHQk6t6flk28O/EfLCjasIWTxpxciLQ5sI
        ub7ah0SLqPHbsZQh9yxGjZeeRaj2Rn/qm+4FhDI3FWFUeX0PoP5qLcSo5bk7PKrU0gQou9mH
        Ot1TjMTvSMoIT2PoVEYrZlQp6tR0lSKCiE1MPpQsC5VIA6QHSTkhVtGZTARxOC4+4PV0pWM4
        QpxNK7McrniaZYmgyHCtOkvHiNPUrC6CYDSpSo1cE8jSmWyWShGoYnRhUokkWOYgvp+Rdmuh
        DNWs8D8yTv3JzwV5/DPAVQDxEGgcuYadAW4CEW4FcLTasG2sAHh+3cTnDDuALSuPsaeSafPg
        llyEdwF4yXqcIy0D2H7LsBXA8ABoub8InIGd+B8Azv5a6eI0UNyGwoLLesTJ8sQT4Px0nQML
        BDx8P7Q+8nS6hXgUNNlqXbhqvnBgrQh1Ylc8GnZ3tWAcxwMOfz7Lc2LUwcn/vgZ15of4rABu
        GCsAJz4M1+9Nb7ftCReHLNtJveFCmd6FExQDWHDvn+2ACcCivDgOR8G1agvf2RyKH4CtXUFO
        CPEX4MCd7brPwcL+DRfOLYSFehEn9IM9V6p5HN4Li7+w8zkKBb+7m8jtrcKx6uKkciA2PDOM
        4ZlhDP+XrQVoE3ie0bCZCoYN1kj/O3CKOtMMtt66/2tWUPFwKbAPIALQB6AAJXYK1VHv0iJh
        Kv1xDqNVJ2uzlAzbB2SOTZ9Dvb1S1I7PotIlS0MOSkJCQ6XyYJlETuwSfrkZQ4twBa1jMhhG
        w2if6hCBq3cu4p+zL75mBN+zfvTRiaBANrp5TpH1gY+HUJ8YO3HEPDdTpGyz6pWVp5RRiX6T
        5buvZNdNN+X+VCI/PQzF7o2dn7TPu3ck5KgePBENP44ZnH8wkpZf9WN+ycU3jL57I65HVp2P
        xj+09I963Xzp+tC4z6LwVFyMKPjrF6dPdprGfhbt2X8DQ38PMynq8uGbKru94/6rSzZ52KXF
        Jw2+Qb3NY5Jv54971laWZdcN/Pb27bGxlqOXl3ctv1LTt28h+aZHp5G/Muj5i9Ut0stnt3Hm
        ndhVGSNt67WvXitYLtD5H9EvfrpxtZR461h2f15wfZXdYzPpRMMOv4TWY5WTSNnJCFv4xAjB
        Y9NoqT+qZel/AYVUBpB0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvO7W1XGJBi8v21icfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsJt2fwGLxZP0sZotFN7YxWdz4
        1cZqsfHtDyaLGef3MVl0X9/BZrH8+D8mi98/DzE5CHlcvuLtMauhl83jcl8vk8fmFVoei/e8
        ZPLYtKqTzWPCogOMHt/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwRHHZpKTmZJalFunbJXBl
        XHrZz1zwibVi6Y0vrA2MjaxdjJwcEgImEjc3HQOyuTiEBHYwSpxesoAJIiEr8ezdDnYIW1ji
        fssRqKL3jBIvfuxiA0mwCehKbHn+ihHEFhH4yCgx55sWSBGzwFtmifMH34AlhAUCJJZ/vAs0
        iYODRUBVYsc7YZAwr4C9xOqHC6AWyEsc+dXJDGJzCjhI7Nm1lg2kXAioputvJES5oMTJmU9Y
        QGxmoPLmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnAE
        amntYNyz6oPeIUYmDsZDjBIczEoivPn2sYlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwX
        EkhPLEnNTk0tSC2CyTJxcEo1MK1XnFzllcmu1rZgyfbDHo9DCmJNaqu6PxWL3pW7ruVkp/qu
        +OaOuFLGoGjdaV4uu5Y9vLnbKeW5sV/MqQUB7K43HykoTt60znaWWP2fFJGY0APPr5kbrzu6
        430j++VDN/kv/xH+Zni62Crj7bxVM3bKKesamLVOsZbsrFpraegvU5byetUlJT/2gzcPaX+4
        28RZMptjuTyvxZnWypOd8k5cC70XxMqzSF/nUF/7Yf70IMeHJ32aBUKXcK42NZhmxpRcYfn3
        Ss8XFzOjG0K7j4deenX4weV5nO79/QmOgld0RZcu+XyJwUnhkdTiFodg7ieLYs3DHtvLHNad
        5V93YP9vubRZ+qWFez4m7Z26Q4mlOCPRUIu5qDgRAOrOwFIvAwAA
X-CMS-MailID: 20211007081134epcas2p27513b5eed7fc78424709f70fa651a877
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p27513b5eed7fc78424709f70fa651a877
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p27513b5eed7fc78424709f70fa651a877@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To support 167MHz PCLK, we need to adjust the maximum value.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Inki Dae <inki.dae@samsung.com>
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

