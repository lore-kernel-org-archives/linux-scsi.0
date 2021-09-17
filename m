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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5946DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C726112E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 06:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbhIQG5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 02:57:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29088 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhIQG4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 02:56:52 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210917065527epoutp0413c2337dfad04ddeba72a5b62497cac0~liZhiFc_82962429624epoutp04U
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 06:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210917065527epoutp0413c2337dfad04ddeba72a5b62497cac0~liZhiFc_82962429624epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631861727;
        bh=rIuVrlrXUj9RtoTnjlPUt8vvubenE93aaUi0KVtqszU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfIvwRLUlyE/Uxq5+uYJylD1KvK6coYFfdAh/QJLZUbIEu71k0vU4iFE79Gm8g2Dz
         ULcTFuHI+9p/W2XwTXnWprgx/RDmlDtZnabvYr7n6iDDfOFHhcYzTWqAKlRPQcAiRd
         ett/Acg7MqlO8q72s31/zbR2TOCMj01V148NmEJA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210917065526epcas2p3d53320ff077a2978a38d7b1709463d00~liZgz6iRo0100601006epcas2p30;
        Fri, 17 Sep 2021 06:55:26 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4H9l8C40s1z4x9QG; Fri, 17 Sep
        2021 06:55:23 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.ED.09749.BDB34416; Fri, 17 Sep 2021 15:55:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epcas2p4ed13768faa6aa6d33116606e2601321e~liZdGtatW1927619276epcas2p44;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210917065522epsmtrp1616a98d9d65e6f684a126c4d1eaff3b0~liZdFoNmj1045910459epsmtrp1A;
        Fri, 17 Sep 2021 06:55:22 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-ab-61443bdb1441
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.10.09091.ADB34416; Fri, 17 Sep 2021 15:55:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210917065522epsmtip2de2aaebe6b4765056a69036c42d071da~liZc3AhfC2196221962epsmtip2b;
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
        jongmin jeong <jjmin.jeong@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v3 02/17] scsi: ufs: add quirk to enable host controller
 without ph configuration
Date:   Fri, 17 Sep 2021 15:54:21 +0900
Message-Id: <20210917065436.145629-3-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210917065436.145629-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJJsWRmVeSWpSXmKPExsWy7bCmqe5ta5dEg2fdchYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyWLlNQuLjW9/
        MFnMOL+PyaL7+g42i+XH/zE5CHhcvuLtMauhl83jcl8vk8fmFVoei/e8ZPLYtKqTzWPCogOM
        Ht/Xd7B5fHx6i8Wjb8sqRo/Pm+Q82g90MwXwROXYZKQmpqQWKaTmJeenZOal2yp5B8c7x5ua
        GRjqGlpamCsp5CXmptoqufgE6Lpl5gB9pKRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUot
        SMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMlY3/qXseA5X0XP7gtsDYyreLoYOTgkBEwk
        3h5h7mLk4hAS2MEosXnxQxYI5xOjROfRz2wQzjdGiXfzdrJ3MXKCdRy/sI8RIrGXUWLDoktQ
        LR8ZJboeTwKrYhPQldjy/BVYlYjAe0aJJ4+nsIM4zALzmCVePGhhA6kSFkiW2L35AJjNIqAq
        cfXwWzCbV8Be4vOpxcwQ++QljvzqBLM5BRwkbu36zwhRIyhxcuYTFhCbGaimeetsqPobHBLf
        VmRA2C4SP2b2s0HYwhKvjm+B+kFK4mV/G9hBEgLdjBKtj/5DJVYDvd3oA2HbS/yavoUVFEzM
        ApoS63fpQ0JMWeLILai1fBIdh/+yQ4R5JTrahCAa1SUObJ/OAmHLSnTP+cwKYXtIHNw2Axpy
        kxklXv6fyTKBUWEWkm9mIflmFsLiBYzMqxjFUguKc9NTi40KjJGjeBMjOI1rue9gnPH2g94h
        RiYOxkOMEhzMSiK8F2ocE4V4UxIrq1KL8uOLSnNSiw8xmgLDeiKzlGhyPjCT5JXEG5oamZkZ
        WJpamJoZWSiJ887955QoJJCeWJKanZpakFoE08fEwSnVwCSkbfPhRDTD7fnm1TE7il5XLe8K
        4Y9m3BMRaVIR/tIytFKH4UkgO19voMac+G1XN4fcqlv1KDjxXDRDxFXGqyWPtu5KnW7glOv0
        8V6hRK1uvs+yX5Pq+SZfOZhgacufLlIt8mHFLblGyS1l5mZ3D1qVneDnkrwoMqP5p1sZz1KB
        3gVcZexqU5Ocwx8f3KlyR3vKobsHZh79Y3Fd2PxyTYqm3scNxxmWuEjPZX2S+XTJttANyrtn
        cn6dsf7lX5atv+/ob28NLvg1K+jZDYv9ghGnlj3XWtN41ijimN+kmq6fX/ZvNmhln/XAfsLP
        U+4FM35WbPaxuZNdcd/WP8zystA8ddbPyXPCHQUs3d+YfFNiKc5INNRiLipOBAD9a0K9bAQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSvO4ta5dEg5W3NCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWlzer23Rs9PZ4vSERUwWT9bPYrZYdGMbk8XKaxYWG9/+
        YLKYcX4fk0X39R1sFsuP/2NyEPC4fMXbY1ZDL5vH5b5eJo/NK7Q8Fu95yeSxaVUnm8eERQcY
        Pb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgieKySUnNySxLLdK3S+DKWN/6l7HgOV9Fz+4L
        bA2Mq3i6GDk5JARMJI5f2MfYxcjFISSwm1Hi89fpLBAJWYln73awQ9jCEvdbjrCC2EIC7xkl
        zk60ArHZBHQltjx/xQhiiwh8ZJSY800LZBCzwApmiaWXtoMNEhZIlPhy5jYbiM0ioCpx9fBb
        MJtXwF7i86nFzBAL5CWO/OoEszkFHCRu7frPCLHMXmLi5EWMEPWCEidnPgGbyQxU37x1NvME
        RoFZSFKzkKQWMDKtYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjjYtzR2M21d90DvE
        yMTBeIhRgoNZSYT3Qo1johBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtS
        i2CyTBycUg1Mu/OPRUjylT+ZrG8kxfY6csmy758Ws02YwaelFnqsanaSJPPfOctnudr38B7Y
        zHdiRp746a+2R/z19RW2ecvE7lV5ccAriMs8XfYQz9LZn3/O+33UukLwmcfno/3On3vMipaw
        N7DOf3JhmfUW5wuNfyONEvbocFwt0V6wMil97frlfU9b/2q8cWz+tGT9x4yKC0esJhyVtM9w
        tooIeK0tKxLy+5DMrfYbCh7GN/er6FVN2ar03rL7cRSbk6OqdMDULWoc9Wss1gnPyPRUEJA5
        /e/X8dCOtuNy69+uzjovVxy1dPOd75Lckdcjtwjs9PieZdq0pPGRyf8gW0fON9bS/d2v2Nfu
        EZvUuPC18p6FSizFGYmGWsxFxYkA7bdsaSUDAAA=
X-CMS-MailID: 20210917065522epcas2p4ed13768faa6aa6d33116606e2601321e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p4ed13768faa6aa6d33116606e2601321e
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p4ed13768faa6aa6d33116606e2601321e@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support like device management.
This patch skips the physical host interface configuration part that cannot
be performed in the virtual host.

Suggested-by: Alim Akhtar <alim.akhtar@samsung.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8a45e8c05965..628ef8e17531 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8066,6 +8066,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	if (ret)
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
+		goto out;
+
 	/* Debug counters initialization */
 	ufshcd_clear_dbg_ufs_stats(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e1d8fd432614..e547fbd19d49 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -594,6 +594,12 @@ enum ufshcd_quirks {
 	 * support UIC command
 	 */
 	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
+
+	/*
+	 * This quirk needs to be enabled if the host controller cannot
+	 * support physical host configuration.
+	 */
+	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		= 1 << 16,
 };
 
 enum ufshcd_caps {
-- 
2.33.0

