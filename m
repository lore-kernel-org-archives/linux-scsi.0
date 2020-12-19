Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C504C3526D
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 04:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7190C23C15
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 04:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgLSEuD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 23:50:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46518 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgLSEuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 23:50:02 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201219044919epoutp04d85de445407d1696372550548f7444e1~SBNwAtZM82727827278epoutp04j
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 04:49:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201219044919epoutp04d85de445407d1696372550548f7444e1~SBNwAtZM82727827278epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608353359;
        bh=Cvf+OC80gBYPC5u3wt1AfMt70HIPfTUiDHhhhgEAQSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=WaZQbgnzS0FDTjhCFGH4sK4Y3qg8lFCJ0nGuynOx9wm67t7NnjV49nsSN8605lzK4
         kSTNtpdQFnWizR9wL+NTzXxONf1vxJnu/ze8U+lzDPdWPQrumhq61GUCc1arKcreTp
         p+vsKa8Ksa9EGVgyxBR5WR33CavJyrgQJ6UTvcj4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201219044918epcas2p4fbbe08dee83de3ad97a9dd88dff9599e~SBNvGail40713407134epcas2p4C;
        Sat, 19 Dec 2020 04:49:18 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CyYDF60Q8zMqYkc; Sat, 19 Dec
        2020 04:49:17 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.9B.52511.D468DDF5; Sat, 19 Dec 2020 13:49:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201219044917epcas2p271c5a6dbbab952f8f1ba1e6a56f91bca~SBNtajUgO1118811188epcas2p2s;
        Sat, 19 Dec 2020 04:49:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201219044917epsmtrp268c06ff5235ae188213f1c29843a0e7f~SBNtZgV-Z1908619086epsmtrp2F;
        Sat, 19 Dec 2020 04:49:17 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-75-5fdd864dc234
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.81.08745.C468DDF5; Sat, 19 Dec 2020 13:49:16 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201219044916epsmtip18ba484bbd00764ccaabbd074a74bc8cb~SBNtKHeVp0674406744epsmtip1R;
        Sat, 19 Dec 2020 04:49:16 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Sat, 19 Dec 2020 13:38:26 +0900
Message-Id: <5554c8bc72d94a2c679b03ee9252ec54b8561199.1608352548.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608352548.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608352548.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmha5v2914g8+PNS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyTjZ18tSMEWgYvnBu6wNjNN4uxg5OSQETCQa955j7GLk4hAS2MEosfTkfnYI5xOj
        xK3lLVCZz4wS09r2MsK07D91F6pqF6PEr/cLWSGcH4wSG7rnsoBUsQloSjy9OZUJJCEicIZJ
        4lrrWVaQBLOAusSuCSeYQGxhATeJk4+/gY1lEVCVmHnhCFgNr0C0xL5fV5kh1slJ3DzXCWZz
        ClhKLP6/nB2VzQVUM5VD4te7RqgGF4mvt/8xQdjCEq+Ob2GHsKUkPr/bywZh10vsm9rACtHc
        wyjxdN8/qOeMJWY9aweyOYAu1ZRYv0sfxJQQUJY4cosF4n4+iY7Df9khwrwSHW1CEI3KEr8m
        TYYaIikx8+YdqK0eEl/+rGeDBBDQpjebbrFMYJSfhbBgASPjKkax1ILi3PTUYqMCE+T428QI
        TqtaHjsYZ7/9oHeIkYmD8RCjBAezkghv6IPb8UK8KYmVValF+fFFpTmpxYcYTYEBOZFZSjQ5
        H5jY80riDU2NzMwMLE0tTM2MLJTEeUNX9sULCaQnlqRmp6YWpBbB9DFxcEo1MDE93af+7ekb
        fYebO5+/kW3jnCaaPvfU3dWHa3a0u9ws+lnGZfKOv/mR9/RHsRkL3GyvLu5n/us3+brjo1c2
        LnNCGhOcGZ21jmX1mM4q21qyXmdTYyDfi3a2RHvVt0anFq5+/y3f6bvQo44eCy/jx1ZV7tmz
        15aa7uI/4pfieXSrZTR3yP5JYmn983jWmUqGTrZNOiv43KI+LIdvwuu1BlIuE55rz/t90kh5
        0qWjfTa5aduPndAWULHeLmh07G3/ycWbu2Jf/b3P3et4NGprt4TOS7n52257xXmwfF1zvPmr
        1S7XDa1383a2G6UbfG1RKj/j9NloL+u75uS6fReev7hTvjUxVIyVVVtHVU3gsRJLcUaioRZz
        UXEiALHPUzk0BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnK5P2914gxkfLCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGWc7OtlKZgiULH84F3WBsZpvF2MnBwSAiYS+0/dZe9i5OIQ
        EtjBKPHo8wEmiISkxImdzxkhbGGJ+y1HWEFsIYFvjBKnl6uD2GwCmhJPb05lAmkWEbjHJHFp
        wlxmkASzgLrErgknwAYJC7hJnHz8DWwQi4CqxMwLEIN4BaIl9v26ygyxQE7i5rlOMJtTwFJi
        8f/l7BDLLCQeXvvAjkt8AqPAAkaGVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwTGh
        pbWDcc+qD3qHGJk4GA8xSnAwK4nwhj64HS/Em5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXgh
        gfTEktTs1NSC1CKYLBMHp1QDk17dvechzgy365c0Sd2Vcbsd8dHCpO3PIq3SXVumvDNQz17C
        XtNlfpt5q9uLb4UzrbN4NDY486cGR6zSjYtTvDpt6U3Pudmcwu3Wcx9NO8Mw10X/1Oe6n0tZ
        A2d3iT2a2aW4tCbZRnFrDH/9sog9Qi6TjvaGVfTJHlwTKyrCdq+0oe1qk53Xt5Pv49qbxW12
        63IGeanet19nI8Aoq2Fj6h943ZX96Eu1gg+uTzadixSKlnt9ZH6XUZT5n35VqZeLFOQsk/+v
        OWfMLxzZKdVfJc85wfgjj+BMPk0VmQnuBtwN7wVPiQu8vDmj//ixwPWPKw7ZxAcllGZOFxZ/
        ZRCxbGOXalLo1bKPrszsO5VYijMSDbWYi4oTAbPQdUv4AgAA
X-CMS-MailID: 20201219044917epcas2p271c5a6dbbab952f8f1ba1e6a56f91bca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219044917epcas2p271c5a6dbbab952f8f1ba1e6a56f91bca
References: <cover.1608352548.git.kwmad.kim@samsung.com>
        <CGME20201219044917epcas2p271c5a6dbbab952f8f1ba1e6a56f91bca@epcas2p2.samsung.com>
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

