Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3CCC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC30F22ADC
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 02:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgLVCSZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 21:18:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38737 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgLVCSZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 21:18:25 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201222021742epoutp01109e01fe7346220c3a5982eb7f93b131~S6FN0M98g1752717527epoutp01H
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:17:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201222021742epoutp01109e01fe7346220c3a5982eb7f93b131~S6FN0M98g1752717527epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608603462;
        bh=Cvf+OC80gBYPC5u3wt1AfMt70HIPfTUiDHhhhgEAQSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=seWqdWx6ciDgl9YfiajTbXpkWcyVfYA5f7VH38qlGq+vaEd9LSxwnjLOw6WPvJLk4
         +gNEagq+dR0ZX9fxyy3PvU6NHLwFbq2SX1FanWFIHke/p3odn2xkcuKzkzFupn/9/v
         T1hpkUIn15kfOCIENqBBwFaJHDCqWJcrA1zuSrC8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201222021741epcas2p348dc9ea9d590bf0b74df3c7f2fd10784~S6FNLCcMV2886528865epcas2p37;
        Tue, 22 Dec 2020 02:17:41 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D0Kjw1Kwrz4x9Pw; Tue, 22 Dec
        2020 02:17:40 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.48.52511.34751EF5; Tue, 22 Dec 2020 11:17:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201222021739epcas2p306802e943b386815e819259681c9efd4~S6FLh-bQN2888128881epcas2p32;
        Tue, 22 Dec 2020 02:17:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201222021739epsmtrp237c805a36316345df67b6f9dae752fb4~S6FLgUQcA0835008350epsmtrp2N;
        Tue, 22 Dec 2020 02:17:39 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-00-5fe15743f6f3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.73.08745.34751EF5; Tue, 22 Dec 2020 11:17:39 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201222021739epsmtip11682bd4a14c30e72e0a1e78f77567a8a~S6FLPSWeR0722207222epsmtip1t;
        Tue, 22 Dec 2020 02:17:39 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Tue, 22 Dec 2020 11:06:47 +0900
Message-Id: <750d12f8707189b51d0f1befb5f264a247e05cef.1608602725.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608602725.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608602725.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmua5z+MN4g6sHLC0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyTjZ18tSMEWgYvnBu6wNjNN4uxg5OSQETCT6385k72Lk4hAS2MEo0bT5FxOE84lR
        4ur8vYwQzmdGiTurH7PCtLTe6oSq2sUo8fD9DBYI5wejxP7G6ywgVWwCmhJPb04FqxIROMMk
        ca31LFg7s4C6xK4JJ5hAbGEBJ4n3f18wg9gsAqoSbS+WMYLYvALREqsX3GKDWCcncfNcJ1gN
        p4ClxNX7a1hR2VxANTM5JGZcusgM0eAiceHFJKhmYYlXx7ewQ9hSEp/f7YWK10vsm9oA1dzD
        KPF03z9GiISxxKxn7UA2B9ClmhLrd+mDmBICyhJHbrFA3M8n0XH4LztEmFeio00IolFZ4tek
        yVBDJCVm3rwDtdVD4u6STayQAALaNHHidJYJjPKzEBYsYGRcxSiWWlCcm55abFRgghx/mxjB
        aVXLYwfj7Lcf9A4xMnEwHmKU4GBWEuE1k7ofL8SbklhZlVqUH19UmpNafIjRFBiQE5mlRJPz
        gYk9ryTe0NTIzMzA0tTC1MzIQkmct8jgQbyQQHpiSWp2ampBahFMHxMHp1QDU8QE16NTDq56
        6MsaaNG76CP74YVL39jvdputftbB8pOu61mBywcucx5r+Xg06NCaBZOlg8Xt79StNo6db+V9
        Tscl9zfvu79nDWZ4bOn8Nm0Rv7L7xR9LFqbNKtnG9ujk7BTu1Mmt4inPTtdxpX4QCnorscGx
        P9WrKbSoqub5qpedq2Uk3z8IK4lVevL34gPvdo23ri9b119wWWa1nOldg/PJxLdz7D3TCn88
        U7Eqz5ybJzzxzkXO7fHu/Fcm1C0zqzLZ+LZ7T0sAq9aTP7aavLUSnxdPSC68elhw4e6A/8sc
        ePfm7v4h/s9tucEq/waRC5/Ko30V3sUei5ohLlqyILNxc5wYq+lcnfDlbwz6WZVYijMSDbWY
        i4oTARQi2Xo0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnK5z+MN4g63nJS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGWc7OtlKZgiULH84F3WBsZpvF2MnBwSAiYSrbc6mboYuTiE
        BHYwSny9dJcNIiEpcWLnc0YIW1jifssRVoiib4wST76uZAVJsAloSjy9ORWsW0TgHpPEpQlz
        mUESzALqErsmnGACsYUFnCTe/30BFmcRUJVoe7EMbCqvQLTE6gW3oLbJSdw81wlWwylgKXH1
        /hqwBUICFhJrF01kwyU+gVFgASPDKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4KjQ
        0trBuGfVB71DjEwcjIcYJTiYlUR4zaTuxwvxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5I
        ID2xJDU7NbUgtQgmy8TBKdXAVOki8oq35MS2Yy48OUyHXjB3Jz9truM97XB62u8Je/Tnc02Y
        zbhJO89SbD536+LG6ek8Mz6GdpU/sxWQDThmPTc3rT/f9Rbbh6PyVRtXZydYro0+6lp1+Kjj
        5Ev3+dZ5FtqEG1mdKJ4VWfdmYdILlUUPomuOByeLLfyzcYLr1PW3L99Om/Jg/8F7h/jf5L9V
        Wl6THGjf+qsiUVRs2yXlpMJEaRmRL7+ecIX2nTroIxE5Pajg3wWe7msPv9yz/F11t88w8qW5
        Swqjr/ENj6UcjyKNP7GLmls3vT8ae6fJRXiN3MPbKeL/3rcFX+3etmK6wwY/nfRe87ZZP58f
        e/kr8+SqA4nvbzs6tSpe6ej3VGIpzkg01GIuKk4EAAKkaf35AgAA
X-CMS-MailID: 20201222021739epcas2p306802e943b386815e819259681c9efd4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222021739epcas2p306802e943b386815e819259681c9efd4
References: <cover.1608602725.git.kwmad.kim@samsung.com>
        <CGME20201222021739epcas2p306802e943b386815e819259681c9efd4@epcas2p3.samsung.com>
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
index a8770ff..1fd5265 100644
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
 
+static void exynos_ufs_config_request_queue(struct scsi_device *sdev)
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
+	.config_request_queue		= exynos_ufs_config_request_queue,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.7.4

