Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86FBC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8024822B2B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLVCdd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:33:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48563 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVCdc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:33:32 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201222023250epoutp0152ef0d56db3458dc38818b07ffd91022~S6SbuNsBS3031530315epoutp01c
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:32:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201222023250epoutp0152ef0d56db3458dc38818b07ffd91022~S6SbuNsBS3031530315epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608604370;
        bh=2/CTmTPc5wn62J2yW6zlmKXNQvZr7UTGRwmPhSaBEJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Bpy3xjDSpo3W9OZjARjPJ2afyrxwLUJIcIDsqsHkJTTNlmWeXK0htdnmDuWdygogf
         yQY/EZNXeiVezpA27AmQ2mOqG22xDl/kizweWVi1fIyoz3F7nwwGZlsVo7WmCVrjOa
         mIoebqVWZwVVoMoodLdVrxHLY6vHbUPfAUQjq4rw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201222023246epcas2p35d277d31a27545dcd4d0fbaa0c86a879~S6SYnE6oa0622506225epcas2p3o;
        Tue, 22 Dec 2020 02:32:46 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D0L3K6Nymz4x9Pw; Tue, 22 Dec
        2020 02:32:45 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.47.10621.DCA51EF5; Tue, 22 Dec 2020 11:32:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c~S6SWfl44N1441014410epcas2p2o;
        Tue, 22 Dec 2020 02:32:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201222023244epsmtrp2b06d52b9305a81d31d22935e54319ba1~S6SWecU8j1587315873epsmtrp2M;
        Tue, 22 Dec 2020 02:32:44 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-68-5fe15acda81a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.55.08745.CCA51EF5; Tue, 22 Dec 2020 11:32:44 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201222023244epsmtip1c49f38f6b21b88f20eb2797f3ab6883d~S6SWMGZpN1490314903epsmtip1q;
        Tue, 22 Dec 2020 02:32:44 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Tue, 22 Dec 2020 11:21:47 +0900
Message-Id: <f79683fc5df0341047269fc73907e81109862abf.1608603608.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608603608.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608603608.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmhe7ZqIfxBo8WGFk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk7FlxxPWglaBinvXdrE2MLbzdjFyckgImEisXveMpYuRi0NIYAejxMpdfxghnE+M
        EjuP9DFBOJ8ZJWY828cM0zL5dRsrRGIXo0T30R3sEM4PRokzU16xglSxCWhKPL05FaxdROAM
        k8S11rNgCWYBdYldE04AJTg4hAWcJC60uICEWQRUJbZvW8ACYvMKREts+vuMEWKbnMTNc51g
        mzkFLCX2zbvGisrmAqqZyyFx6nYDE0SDi8SGP5ugmoUlXh3fwg5hS0l8freXDcKul9g3tQGq
        uYdR4um+f1ANxhKznrUzghzHDPTB+l36IKaEgLLEkVssEOfzSXQc/ssOEeaV6GgTgmhUlvg1
        aTLUEEmJmTfvQG31kDjcvBAavkCb9p48yzSBUX4WwoIFjIyrGMVSC4pz01OLjQoMkaNvEyM4
        qWq57mCc/PaD3iFGJg7GQ4wSHMxKIrxmUvfjhXhTEiurUovy44tKc1KLDzGaAgNyIrOUaHI+
        MK3nlcQbmhqZmRlYmlqYmhlZKInzFhs8iBcSSE8sSc1OTS1ILYLpY+LglGpgmqNl5Lxm/cq1
        Hy8ovdN9MD0s94HX9m3imlP0lNzjlivMZvES29B3hTOxfbep/wolmYZ4u8OaDFlH8t++iNDY
        b+EwcdKk3lY30a0FDVcfR54yzp60+HJKaAynkGlSm9vr+4r7Jh9I+/b24+Lv3NcP8gtd2H1U
        JqLMdOlKqaVmT0Rv6Dx/y3HJjl0yImxW3aKN37I+nddc+M+Zs5bzvgCrJt8WGUafWnfFbyoC
        T4KVws49l/7hZLxw6YHG8/u23l3Z/2jWa+uNKke22ylkPd4tci//BFNVxcRnh71Vzha727a3
        b7sx8cPT3Uu65ukpdTKtP5spaXR8mjH/ednG51U1IQ+uRWg9UZdeXZDNWH18uxJLcUaioRZz
        UXEiAMKnoPwzBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnO6ZqIfxBr1TlCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGVs2fGEtaBVoOLetV2sDYztvF2MnBwSAiYSk1+3sYLYQgI7
        GCX+tBlBxCUlTux8zghhC0vcbzkCVMMFVPONUeLVoYdMIAk2AU2JpzenMoEkRATuMUlcmjCX
        GSTBLKAusWvCCaAEB4ewgJPEhRYXkDCLgKrE9m0LWEBsXoFoiU1/n0EtkJO4ea4TrJVTwFJi
        37xrUAdZSPzZ+YkNl/gERoEFjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCI0JL
        awfjnlUf9A4xMnEwHmKU4GBWEuE1k7ofL8SbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB
        9MSS1OzU1ILUIpgsEwenVAOTvNzbdZIrKoXy5y1sOaM6Pbr8bPYl7wsSIZ8kJ1hzmGxVW2RV
        vVLB8svdg9yLVu/kEtWTq/ge8E6peMfutMNRDcesRTY/WCXNe717ot3hyIvvG15GXMuKfy2t
        fv3zqrfJJ9Mu3r3I9Svvo7o+Sxdbl8/slTtyr/oVnbL5wjun58LL+rknM2u65/ut/nD2QCLD
        POd86XP+96fs7pjcIPGp9fm76kWfUq9x82y8cKb5+f5XT79zC/NuyXafzea0QmLfiT8rNq46
        qvWz8eDJygf6cw8Lzv9ldvLMlpvLdukG/luQ9vna/URFl8tH527Lf7v/CtOGrE3/10UUZ9dc
        YVkr5mF2ozf996f9ms27/r0quRmpxFKckWioxVxUnAgA6PVAQPcCAAA=
X-CMS-MailID: 20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c
References: <cover.1608603608.git.kwmad.kim@samsung.com>
        <CGME20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Exynos requires one scatterlist entry for smaller than
page size, i.e. 4KB. For the cases of dispatching commands
with more than one scatterlist entry and under 4KB size,
Exynos behaves as follows:

Given that a command to read something
from device is dispatched with two scatterlist entries that
are named AAA and BBB. After dispatching, host builds two PRDT
entries and during transmission, device sends just one DATA IN
because device doesn't care on host dma. The host then tranfers
the whole data from start address of the area named AAA.
In consequebnce, the area that follows AAA would be corrupted.

    |<------------->|
    +-------+------------         +-------+
    +  AAA  + (corrupted)   ...   +  BBB  +
    +-------+------------         +-------+

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index a8770ff..8635d9d 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -14,6 +14,7 @@
 #include <linux/of_address.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/blkdev.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -1193,6 +1194,13 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_slave_configure(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+
+	blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1204,6 +1212,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.slave_configure		= exynos_ufs_slave_configure,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.7.4

