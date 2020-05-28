Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BF4C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D14212CC
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 01:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uSGoa+ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgE1Bch (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 21:32:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63043 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgE1Bcc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 21:32:32 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200528013229epoutp01166d0c0dc7f4a2c2fa7ef5d6d4002318~TDSXq0eXV2174221742epoutp01k
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2020 01:32:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200528013229epoutp01166d0c0dc7f4a2c2fa7ef5d6d4002318~TDSXq0eXV2174221742epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590629549;
        bh=aZlGHc5xTiWwAyuHWOUJ6KyldBblFcw6DUpelUfBEa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSGoa+nsQtvqb05cVlCYGTrzqDjboaEtV01OjRnkITuRkWFZ1hdK76RVKldMD6XtL
         aL7rlHFk5kH67eWCeEI5CXZL/JHAZQSjdeGDDB1G9w78mzfmetiyizIOBHgosgLqpO
         waFOcsFwaOAeXZFQ9cbsJX2d5OWT2EdsLwhzroqg=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200528013228epcas5p2fcbdc5778b4f1156ff32c6bf6271aeac~TDSWf9m_A0582105821epcas5p2T;
        Thu, 28 May 2020 01:32:28 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.00.09467.CA41FCE5; Thu, 28 May 2020 10:32:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200528013228epcas5p4641c271e319aaefc78d7bbd22b23c30f~TDSV_NUZl2137121371epcas5p4e;
        Thu, 28 May 2020 01:32:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200528013228epsmtrp1f07aee0488fcd41cd71921d3645e1825~TDSV81IwD0638506385epsmtrp1i;
        Thu, 28 May 2020 01:32:28 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-16-5ecf14ac61e3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.E7.08382.BA41FCE5; Thu, 28 May 2020 10:32:27 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200528013226epsmtip1781cc4df5f4a1a48d05ee63fe450e2b8~TDSUIVqMU1669416694epsmtip1k;
        Thu, 28 May 2020 01:32:25 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v10 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Date:   Thu, 28 May 2020 06:46:50 +0530
Message-Id: <20200528011658.71590-3-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528011658.71590-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSeUwTURCHfbvb7VKt2ZRGR8CrBm8LiJrVIBI1uph4x1vRChtQoK0teEUj
        QQShFqtRIYhFDIiChFIrQbBa8agIigQ5SgIUkRiMEa1aJRqPujX+95uZ73vz8vIoXJIq8KP2
        KJM4jVKRICNFRNWDaVNn3ZA2RQVnlExinMYqkhkYaiUZV8VVAVPw8LmAaWoyCRmH5RHBmPva
        BExLTT7J5DbdxRhdezXJlNh/YsyvO9VCpviWA0WI2ZZsPcaaSzNJ9mbRMTat/h7BfuzvJNhs
        SyliP5nHsRk2HbaG2ioKi+ES9uznNEHhu0RxVbXvSXXniIMGeyeeglpEWciHAnoOXDuvJ7KQ
        iJLQtQhS3xRgfOFCYHVfJPnCjeCcdVD4T8kyuYX8wIqgI/Wi10/D4NGZQtxDkfQM6MqxYJ4s
        pX3hoTsdeTJOd2DgvL7Uk33p7fDK1P2HpyiCDoTWoo2etpgOg5wXRd5l46HMZPuL+NALwWqI
        8KwCOpOC7mufCZ5ZCmXlNgGffeGt3eJ1/WDgdLrQ4wIdD6dqQvn2ESg2Pvaqi8D2Mp/wIDg9
        DSpqgvhLjgT999cYb4rhZLqEpwPh+PtWr+kPZ3Q671IWes8+R/wjGBB0OYaQAY3N+3/qZYRK
        0RhOrU2M5bRz1SFK7oBcq0jUJitj5dGqRDP6+02mR1ajLucHeR3CKFSHgMJlUvHiZw1REnGM
        4tBhTqPaqUlO4LR1yJ8iZKPFsm+NURI6VpHExXOcmtP8m2KUj18Kxj3+0lOw4pg8dEdzZEDf
        BWu7yN6+97zGKW04eqlUqtq3MjSvcN3m+P7V206kfF6gX7utrs/UfKfidrQrd+KViVd+DGXu
        vmwvx3/sC2/e6zxXFXt6ru1tIwREBXyhI82VLmPglIGWUfeNFyonfNuOz8PIzXpi/tFhGTMr
        88NGipDfq/HdfRGpExw3N8p1aYavi1lgbWvjDtRf2m1wHN7/rkcgQwKlar3FEpOztWu4Vrcy
        t3qJu2FZOZn0ZMns4qfZzOjBe2clZYeWR6ypnWQJFSQHq9tKOm1DM/0DVrl6i8JV4372BA1i
        wZuSJm/JSxvbizYEcyGzG1cbMeebwv7vsg8yQhunCJmOa7SK39u2meqVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnO5qkfNxBnP2WFs8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujG2737EV3OKpmHD8FnMD42WuLkZODgkBE4muDd/Yuxi5OIQEdjNKPP/+nREi
        IS1xfeMEdghbWGLlv+dQRU1MEp3/17GCJNgEtCXuTt/CBGKLABUd+dYG1sws8IxJ4tTDUhBb
        WCBKouvaR6AaDg4WAVWJq0vCQMK8AjYS0y8sgZovL7F6wwFmkBJOAVuJvRMcQMJCQCUTVu1l
        nMDIt4CRYRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnAoa2nuYNy+6oPeIUYmDsZD
        jBIczEoivE5nT8cJ8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1OzW1ILUIJsvE
        wSnVwDT9uuTUHEMn/R5hlfL9vTvvSO7fpXNV/8fKvQY7ti9QZnXKLI7gPOT/8tTVT+lXYmfc
        mPYg70DdW80zZRWnWBTls/T0zrKkmXVc27tyoc/SNc33St4sqrgk8+eXevzTWXmzV7uzt0av
        WF8yh3Fz5oNvClolb/TyZlg+n7qj9VXCe/5dqes/uZ362nf8at654kka6tVxVwRjbW4dvdV6
        5pGEFZPUFxfJ56p6dgYZM0Qv1B7/+eb93q3zzmp+OpNsuSX6+4rtpzaUzgipt7N8FuSUL/Ww
        7JbMm/DTVUtlX8+6YpTmxSczYXul9tGww5WLGI17+BucjDO+1q9g846+zXo47BirenXVe0cV
        N/nGV9lKLMUZiYZazEXFiQCLL+Dq1AIAAA==
X-CMS-MailID: 20200528013228epcas5p4641c271e319aaefc78d7bbd22b23c30f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013228epcas5p4641c271e319aaefc78d7bbd22b23c30f
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013228epcas5p4641c271e319aaefc78d7bbd22b23c30f@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers support interrupt aggregation but don't allow
resetting counter and timer in software.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3655b88fc862..0e9704da58bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,7 +4884,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 071f0edf3f64..53096642f9a8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -523,6 +523,12 @@ enum ufshcd_quirks {
 	 * Clear handling for transfer/task request list is just opposite.
 	 */
 	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
+
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

