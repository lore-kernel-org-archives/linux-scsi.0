Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDAEC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 06:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3585123A82
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 06:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgLSGwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 01:52:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25633 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgLSGwO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 01:52:14 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201219065131epoutp012b035d0cd4f18d740e3a70afaa353693~SC4b00Ykc1136711367epoutp01U
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 06:51:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201219065131epoutp012b035d0cd4f18d740e3a70afaa353693~SC4b00Ykc1136711367epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608360691;
        bh=DRzyNi1cXsoZVufJ3NZHgeOShnsItcixOvadTME3d7c=;
        h=From:To:Cc:Subject:Date:References:From;
        b=PPPUN96Mpl2ZDD2QLyH32PHP/kEa/s6wUTpuh0AtCyOTlJDc/bcproOKr8SqxWYXs
         LYSwaEMV9QRPqDiFZ+2Y2Geh03I67n6A+poc58gpfLoABBdnj4phT5vksd2nAiyDIb
         5CejcltstipVTiGLmxga38m1L/i6XBPj1AjPndtg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201219065129epcas2p4b3502a3d92be80bca7fcbcf0e0b369ee~SC4akrsty0282702827epcas2p4k;
        Sat, 19 Dec 2020 06:51:29 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CybxD58nMzMqYkV; Sat, 19 Dec
        2020 06:51:28 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.08.05262.0F2ADDF5; Sat, 19 Dec 2020 15:51:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b~SC4YmWadz1465014650epcas2p46;
        Sat, 19 Dec 2020 06:51:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201219065127epsmtrp2a6fc247c05d10ede3ff0f83810cf1bee~SC4Ylj2G81039510395epsmtrp2E;
        Sat, 19 Dec 2020 06:51:27 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-2f-5fdda2f0b177
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.34.08745.FE2ADDF5; Sat, 19 Dec 2020 15:51:27 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201219065126epsmtip22fa3a4b07ae1ada03895dd50eb82a8f0~SC4XicF4F1141511415epsmtip2d;
        Sat, 19 Dec 2020 06:51:26 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1] ufs: relocate flush of exceptional event
Date:   Sat, 19 Dec 2020 15:40:39 +0900
Message-Id: <1608360039-16390-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdljTVPfDorvxBscPq1k8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFigV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk7Fv92Pmgv+cFU1XHjA2MPZydDFyckgImEhcX7GFsYuRi0NIYAejxMn2x0wQzidG
        iZuPr7BAOJ8ZJW50v2aBaTlwaAE7RGIXo0TrvalQLT8YJX5uOsoKUsUmoCnx9CZEQkTgDJPE
        tdazYAlmAXWJXRNOMIHYwgIOEpvWzAWzWQRUJQ62HGADsXkFXCX+P+5jglgnJ3HzXCczyCAJ
        gUYOibP9LewQCReJfQfvM0PYwhKvjm+BiktJfH63lw3CrpfYN7WBFaK5h1Hi6b5/jBAJY4lZ
        z9qBbA6gizQl1u/SBzElBJQljtxigbiTT6Lj8F92iDCvREebEESjssSvSZOhhkhKzLx5B2qr
        h8TBT1PB4kICsRLXb59jmcAoOwth/gJGxlWMYqkFxbnpqcVGBcbI0bSJEZwktdx3MM54+0Hv
        ECMTB+MhRgkOZiUR3tAHt+OFeFMSK6tSi/Lji0pzUosPMZoCw2sis5Rocj4wTeeVxBuaGpmZ
        GViaWpiaGVkoifOGruyLFxJITyxJzU5NLUgtgulj4uCUamDKdYoItze+cb5W4aarured8PY5
        csUdBYu5QgsSPny/8rduPW/rzTcSs9QFzh69qiD2cMIPu++vJszuf8x3ZuuPwsebfJ9vPvr4
        0Oe4ZplPVv+e8ks0Sme0W/fcLk1yOz3zfyxfdMYMraeGnxbd7NP8qSKzmS8wumGf3ea1P6W3
        6q82sGW0Zbm9f1bsigiji6cT0/v8/1+Su/86hS1hy8cp3xM3WXj96eLL5f2RsDW9749GXqM9
        RyDPZyPBw3/bnj445/pydYhtyMG56/feX/jmWPO8vV++90ezJcwUCmF8LvR2+QUpn/1TalhU
        Tef5ucdy8/vu9M2/uDHh8um8M0Z3nr2dvme3elm57rujS/TnKLEUZyQaajEXFScCACBULYkb
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSvO77RXfjDW60qlk8mLeNzWJv2wl2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zV4tff9ewWqxc/YLFYdGMbk8XNLUdZLLqv72Cz
        WH78H5NF190bjBZL/71lceD3uHzF2+NyXy+Tx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4MrYt/sxc8F/zoqmKw8YGxh7OboYOTkkBEwkDhxawN7FyMUh
        JLCDUWLN++lMEAlJiRM7nzNC2MIS91uOsEIUfWOUaH36kAUkwSagKfH05lQmkISIwD0miUsT
        5jKDJJgF1CV2TTgBNklYwEFi05q5YDaLgKrEwZYDbCA2r4CrxP/HfVDb5CRunutknsDIs4CR
        YRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnDQamntYNyz6oPeIUYmDsZDjBIczEoi
        vKEPbscL8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwJSy
        3/78ofmeNk6Fp1acy+j61riq7KRz3/+5TJllT8p/i/CwRddeTrj0YMtZo7Wl+1eUlCY9KdL+
        +iNohe6RWa5L1szt3fmZb/vqf3PbF5wV2v6LnZ/Z8Lr5e91tPAfMPm6tOn5DKexTtbHMbY4V
        tzK+KLT+7q78sij87LqCSs0bZwJbd5kJFmV73PVNCZ0s/Gv2wV9mIjKaG3jqWzKuzW79FPE6
        1vpe3I/AyDmJBxPln5nFlGRXpYtOzbsZ9/xu0tKqvHuzqtepzXS311WMDJiyY9H9nEzhRsEX
        FpsmbRYUtLk/kXtqNssEp4OiZTdTL+62efj+4UM9dtGdM3Z5xzk36F1mqOxc/Wjrm84pja5K
        LMUZiYZazEXFiQDSQij5yQIAAA==
X-CMS-MailID: 20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b
References: <CGME20201219065127epcas2p4ee350f78ba75619dfd502dbb2e694a9b@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I found one case as follows and the current flush
location doesn't guarantee disabling BKOPS in the
case of requsting device power off.
1) The exceptional event handler is queued.
2) ufs suspend starts with a request of device power off
3) BKOPS is disabled in ufs suspend
4) The queued work for the handler is done and BKOPS
is enabled again.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..414025c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8608,6 +8608,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			ufshcd_wb_need_flush(hba));
 	}
 
+	flush_work(&hba->eeh_work);
+
 	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
 		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
 		    !ufshcd_is_runtime_pm(pm_op)) {
@@ -8622,8 +8624,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		}
 	}
 
-	flush_work(&hba->eeh_work);
-
 	/*
 	 * In the case of DeepSleep, the device is expected to remain powered
 	 * with the link off, so do not check for bkops.
-- 
2.7.4

