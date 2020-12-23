Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52C6C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BF352313C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 02:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgLWCQy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 21:16:54 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34769 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgLWCQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 21:16:53 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201223021609epoutp049cd624255aa55b01c6a9186fc93cdaa4~TNtKBA4fr1311813118epoutp04f
        for <linux-scsi@vger.kernel.org>; Wed, 23 Dec 2020 02:16:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201223021609epoutp049cd624255aa55b01c6a9186fc93cdaa4~TNtKBA4fr1311813118epoutp04f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608689769;
        bh=lwAQ1PzW0VMl9CBiHdgxELLV18mjj2JnxwNzqNXeoZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=iZkFP7Jxe/D09n9FICgWYqXDekm9N5cil4owHC4d8kb7t0vX9jr8bvVy3MkrTf4zm
         zWz6DAElrIodX4uLriYU142OhjWUKfcpSyEM3/l1B3Cn34ZTunDrfR7Y5FwSj1BZdL
         S6qLzwa3KTIG2EtH0t97xe5NYIHmfTrwM8fMzT0k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201223021608epcas2p356fb0a890bc5066b9b5ccbff0d856549~TNtJSQAP11049510495epcas2p3z;
        Wed, 23 Dec 2020 02:16:08 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4D0xdg4kMxzMqYks; Wed, 23 Dec
        2020 02:16:07 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.C9.05262.368A2EF5; Wed, 23 Dec 2020 11:16:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201223021602epcas2p343141ccef708e29f424d390da5324177~TNtDWEdZL1049510495epcas2p3f;
        Wed, 23 Dec 2020 02:16:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201223021602epsmtrp10b01c0b16a52b62401b49e987f1e64de~TNtDVNduy0837708377epsmtrp1f;
        Wed, 23 Dec 2020 02:16:02 +0000 (GMT)
X-AuditID: b6c32a47-b81ff7000000148e-14-5fe2a8634968
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.56.13470.268A2EF5; Wed, 23 Dec 2020 11:16:02 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201223021602epsmtip12a897e3937a6464b1669d71d0593fc9f~TNtDCLhwR1422114221epsmtip1q;
        Wed, 23 Dec 2020 02:16:02 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v4 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Wed, 23 Dec 2020 11:05:08 +0900
Message-Id: <6fd23159db1254b1a5076d0aec9567e71e1aae27.1608689016.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608689016.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608689016.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmmW7yikfxBod6eSwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyfh78CZjQYtAxcbzTawNjG28XYycHBICJhIrL95i6mLk4hAS2MEoMeHpXijnE6PE
        4TdPWCGcb4wSxw+vYodpWXXkGFRiL6NEf9sOZgjnB6PE3tWrWUCq2AQ0JZ7enAo2S0TgDJPE
        tdazrCAJZgF1iV0TTjCB2MICThLfVi1lBLFZBFQldmyfCxbnFYiWOHVtLgvEOjmJm+c6mUFs
        TgFLiV2Lm5lQ2VxANTM5JM7/+MoM0eAiceL5NCYIW1ji1fEtUHdLSbzsb4Oy6yX2TW1ghWju
        YZR4uu8fI0TCWGLWs3YgmwPoUk2J9bv0QUwJAWWJI7dYIO7nk+g4/JcdIswr0dEmBNGoLPFr
        0mSoIZISM2/egdrkIfH51ypoaAFtmvp6DesERvlZCAsWMDKuYhRLLSjOTU8tNiowRo6/TYzg
        tKrlvoNxxtsPeocYmTgYDzFKcDArifCaSd2PF+JNSaysSi3Kjy8qzUktPsRoCgzIicxSosn5
        wMSeVxJvaGpkZmZgaWphamZkoSTOW2zwIF5IID2xJDU7NbUgtQimj4mDU6qBKfGPhdANP43X
        hb8eRXlZTM3LKChc8XFl3qHAV3+lhQ58MlE5/Wtd/tFUvbVvlC3Ydy0IP+1g9LMwLfXXumVn
        MmpvB1xgfHPctsXoWNOxF3MD81WnsckqqhnPm312Rzuf2WXbYIF7PLwucuulebgLVZnO3vRd
        t3mfSaiVV4KLskZ0xCel00Ei9uETX6ts/cv0bs6kBN7u0MlWU0NiFxW/vLInYdkE83IO0W8H
        j9yaO+N0jelqxxn3+E1mTbwtt/np1Jn51TKxfYenfFx6ktfHYN9Mw/yJ9dtq5NPL7y5NZdxn
        ffbPUSEb9yDlDRe+KSzawCnRG7kkaIN89Hne/gcS9RMXaM54eUTx0vrt635vTlViKc5INNRi
        LipOBACN/zmtNAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnG7SikfxBj8nCVs8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4Mr4e/AmY0GLQMXG802sDYxtvF2MnBwSAiYSq44cY+1i5OIQ
        EtjNKHFi9Rd2iISkxImdzxkhbGGJ+y1HoIq+MUrsu3IRrIhNQFPi6c2pTCAJEYF7TBKXJsxl
        BkkwC6hL7JpwggnEFhZwkvi2ainYJBYBVYkd2+eCxXkFoiVOXZvLArFBTuLmuU6wXk4BS4ld
        i5uBajiAtllIPP7AikN4AqPAAkaGVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwRGh
        pbmDcfuqD3qHGJk4GA8xSnAwK4nwmkndjxfiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQ
        QHpiSWp2ampBahFMlomDU6qB6fy2b/OWHWJcHM6fvaVgn6PwvY1/+t9vZ54Y9dTLM15/ifX3
        N0ffy/bW/ugM11rydq1vY/7JmyfvtOi3BTouzPzH/aXueCKD+sSDcrMLZx/t4GXTVl9zUjhK
        IKJUwsT6/5Mz/kvljI5WmrEe2+T2sT+L+cofLgeWv2zBJkoG01WlX+15q3R1us3cnGlL/zHx
        dXaeaXwkcUt7RuG5qtLjaTbTAlMEpoWcnDarXHu2+clO554rvcl1XBVF7N9Nc4zlrW5lLTzv
        dJOJaUlObAM/YzOjdcz2bPs7p6PXvJ54dn/zgy5Z/VUZnlFNHiltjXXJsROn+f+2DAxWzJt8
        V0raYPmnU2v+7Ds2xdiR1S9TiaU4I9FQi7moOBEAiI7opvcCAAA=
X-CMS-MailID: 20201223021602epcas2p343141ccef708e29f424d390da5324177
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201223021602epcas2p343141ccef708e29f424d390da5324177
References: <cover.1608689016.git.kwmad.kim@samsung.com>
        <CGME20201223021602epcas2p343141ccef708e29f424d390da5324177@epcas2p3.samsung.com>
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
In consequence, the area that follows AAA would be corrupted.

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

