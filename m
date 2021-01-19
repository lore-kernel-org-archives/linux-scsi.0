Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C81C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 02:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF26822E00
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 02:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394494AbhASCla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 21:41:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:38059 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394337AbhASClV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 21:41:21 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210119024017epoutp02bf5320cba298a988f32ea32e9014d6eb~bgc7Tl1P31542315423epoutp028
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 02:40:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210119024017epoutp02bf5320cba298a988f32ea32e9014d6eb~bgc7Tl1P31542315423epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611024017;
        bh=YA1/e4TPOxL6MryBAuaA6i41XFxzfZMi+vkRoddHhbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=Jth2zuIpzfEALzNf1SqilOEWrqxjBqdeloTmyInElQgxpx3PA+dLWWHTt71kta2pE
         fJddbtY3jt8nsJ/bygTXQnjP87BSXPcpr0yqsLamKZd4j9GDzqgOEHfLYQgMm6Uf/K
         AjA4yMPhAEEIugaD7zFW3kdHfn/LRn4u/JTnu9/Q=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210119024016epcas2p388ca6f2e940da662337124102c2a013e~bgc6rNC9B1033910339epcas2p3Z;
        Tue, 19 Jan 2021 02:40:16 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DKXv14zT4z4x9Q7; Tue, 19 Jan
        2021 02:40:13 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.8A.56312.D8646006; Tue, 19 Jan 2021 11:40:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210119024012epcas2p2b99e5846e1e04d8a8fab76c75bf534a7~bgc3Vwq5w2850928509epcas2p2H;
        Tue, 19 Jan 2021 02:40:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210119024012epsmtrp1c31233e60bd8204d358de7d0d32dcf93~bgc3U1Aaa1474014740epsmtrp1a;
        Tue, 19 Jan 2021 02:40:12 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-38-6006468d39e1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.D6.13470.C8646006; Tue, 19 Jan 2021 11:40:12 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210119024012epsmtip2283fdba17de0d85d207cef1cafc49551~bgc3IXs5N0357703577epsmtip2d;
        Tue, 19 Jan 2021 02:40:12 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [ PATCH v6 1/2] ufs: introduce a quirk to allow only page-aligned
 sg entries
Date:   Tue, 19 Jan 2021 11:28:48 +0900
Message-Id: <56dddef94f60bd9466fd77e69f64bbbd657ed2a1.1611023224.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1611023224.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1611023224.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmqW6vG1uCQd97KYsH87axWextO8Fu
        8fLnVTaLgw87WSy+Ln3GajHtw09mi0/rl7Fa/Pq7nt1i9eIHLBaLbmxjsri55SiLRff1HWwW
        y4//Y7LounuD0WLpv7csDvwel694e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2
        A91MARxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
        QMcrKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0M
        jEyBKhNyMs50/mMt+MZf8fjvV9YGxu88XYycHBICJhL9ja2MXYxcHEICOxglDp86wwThfGKU
        WPhqCVTmG6PEkpdHmWBa2l88Z4FI7GWUODd/KTuE84NR4u7nO+wgVWwCmhJPb04FmyUicIZJ
        4lrrWVaQBLOAusSuCSeAEhwcwgLhEjt+uYCEWQRUJc58XccCYvMKREvMbNoDtU1O4ua5TmYQ
        m1PAUmL24jOMqGwuoJq5HBJXni1ng2hwkZjzfA47hC0s8er4FihbSuJlfxuUXS+xb2oDK0Rz
        D6PE033/GCESxhKznrUzghzHDPTB+l36IKaEgLLEkVssEOfzSXQc/ssOEeaV6GgTgmhUlvg1
        aTLUEEmJmTfvQG3ykPi87TwbJHyANp1acoF9AqP8LIQFCxgZVzGKpRYU56anFhsVGCFH3yZG
        cFLVctvBOOXtB71DjEwcjIcYJTiYlUR4S9cxJQjxpiRWVqUW5ccXleakFh9iNAUG5ERmKdHk
        fGBazyuJNzQ1MjMzsDS1MDUzslAS5y02eBAvJJCeWJKanZpakFoE08fEwSnVwHSgVVrA8UiT
        Re6JaLU9NyLqlsjqHgnIZ0rexfpuC2PzjJQTOTv5YtfLZlnuEXjOfdOgqv2c5KyGjA2vrKbu
        YAzK7zjLIVbyOkV1Z/kztk6djmkKuRt1GAq6WJuVX64WUa+68fxSdKQKc1XEUdse8Y+fs/SY
        NVess86T1uG8HbDmUtpxg2ve3bv3f5KpZWv+8W8/X7PvrCYJ33CvfWKHr2s8ZxN5Yxy1nVst
        rqDq5eqC56q37F++cMwuebj7W8nLb7ML9LxyZjjzqrn7ClgXX1H68czq5p67a66xz74w/Sj7
        gW7/O0+uWk4LWbrvn9+sNvnKtscczO6VK6NY1xbMvLGYhytF4InFzZq3x7orlFiKMxINtZiL
        ihMBlIPm6TMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvG6PG1uCwZ8JmhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiiuGxSUnMyy1KL9O0SuDLOdP5jLfjGX/H471fWBsbvPF2MnBwSAiYS7S+es3QxcnEI
        CexmlNj89hYLREJS4sTO54wQtrDE/ZYjrCC2kMA3RonXR71AbDYBTYmnN6cygTSLCNxjkrg0
        YS4zSIJZQF1i14QTTCC2sECoRMvp5WwgNouAqsSZr+vAFvAKREvMbNrDBLFATuLmuU6wXk4B
        S4nZi88wQiyzkLj15R07LvEJjAILGBlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIE
        x4SW5g7G7as+6B1iZOJgPMQowcGsJMJbuo4pQYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T
        8UIC6YklqdmpqQWpRTBZJg5OqQYmG76THinFlen5v07/fHZvw253wzeOdn28m43TLVKvKdYX
        J1/56DM5vPKoTZZTt7TBe2FP21CtdtWQVZ2B2y9tOhj6ZOU5tqvWLA7nFpms3Cq5br+As8DR
        b3nNv6wfms3d9sk1Kfh8q96y7PNXJJc7vPE9UGVivOp9nVitfcdFFperc+6m2B5bdCVp05aj
        wssZpRyubJWt7/I86/Ba51Wh/5XS9vX9v4KiTM8V2RdLyeSKLYi2jdt+dr8Of/BdlkPeWU9P
        ph2skGbYm7c6bdmhtaYSDO2THddL1PnO0vZaZbwuU7ogYZ30VOubG322MmZl+n9QytSv9rv4
        Qtc8rnFdwypHl6nuD6d/OfX5krsSS3FGoqEWc1FxIgDt41pV+AIAAA==
X-CMS-MailID: 20210119024012epcas2p2b99e5846e1e04d8a8fab76c75bf534a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119024012epcas2p2b99e5846e1e04d8a8fab76c75bf534a7
References: <cover.1611023224.git.kwmad.kim@samsung.com>
        <CGME20210119024012epcas2p2b99e5846e1e04d8a8fab76c75bf534a7@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoCs could require one scatterlist entry for smaller than
page size, i.e. 4KB. For the cases of dispatching commands
with more than one scatterlist entry and under 4KB size,
They could behave as follows:

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

In this case, you need to force an aligment with page size for
sg entries.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e221add..847eb02 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4792,6 +4792,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
+		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9bb5f0e..9e7223f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -549,6 +549,10 @@ enum ufshcd_quirks {
 	 */
 	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
 
+	/*
+	 * This quirk allows only sg entries aligned with page size.
+	 */
+	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 13,
 };
 
 enum ufshcd_caps {
-- 
2.7.4

