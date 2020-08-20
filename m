Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73ABC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 13:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DBEA208DB
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 13:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="L4BQ8up9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgHTNUZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 09:20:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13901 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgHTJej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 05:34:39 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200820093435epoutp03b38c248dc3e425ae7ae41cd9d1db51a5~s8DRdUPQC1019310193epoutp03J
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2020 09:34:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200820093435epoutp03b38c248dc3e425ae7ae41cd9d1db51a5~s8DRdUPQC1019310193epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597916075;
        bh=S8AFufUusFGYosU+s/AZzZx5BuLS4nnRkMixFZZzsX0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=L4BQ8up950F4ohXeusJVgsUw5FauEIhCAMDAVCgGRsDnoDuQajilhjQ/YenuQ0/KP
         EE4aciUPlZ309RNocZKUy4InhWTsau2XGxo15xs3r2s1Yglz67/ZE72ahcb8naSeQA
         178IWzuEPv/D4hEBFRofvpaOnNUrRec7xlqpLGWA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200820093434epcas2p415e36356fd06f0d019ffd687ae5b1683~s8DQtytSn0377903779epcas2p4u;
        Thu, 20 Aug 2020 09:34:34 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BXKHD39dLzMqYlp; Thu, 20 Aug
        2020 09:34:32 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.C8.27013.7A34E3F5; Thu, 20 Aug 2020 18:34:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200820093430epcas2p1b78325cbc1ee6ff0f6ee1727e2a4de49~s8DNFnQdq2005220052epcas2p1M;
        Thu, 20 Aug 2020 09:34:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200820093430epsmtrp2cb9e08e0020e1147975e363b62f63500~s8DNEpThh0074700747epsmtrp2W;
        Thu, 20 Aug 2020 09:34:30 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-e1-5f3e43a7701f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BD.4F.08303.6A34E3F5; Thu, 20 Aug 2020 18:34:30 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200820093430epsmtip20ee498c18e8fec4a024d5f99baf2cd13~s8DM5VFXs2246522465epsmtip2J;
        Thu, 20 Aug 2020 09:34:30 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: skip manual flush for write booster
Date:   Thu, 20 Aug 2020 18:25:50 +0900
Message-Id: <1597915550-167609-1-git-send-email-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmme5yZ7t4gy17hCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORkbuzeyFCzmqZjzqIu1gXEuVxcjB4eEgInE0lbLLkYuDiGBHYwSm6feZIJwPjFKrL/3nRnC
        +cwoMXX7PrYuRk6wjuONm1hAbCGBXYwS1yYkQBT9YJRYvngCWBGbgKbE05tTwUaJCGxmkni1
        4D4zSIJZQF1i14QTTCC2sICNxNQZ/WANLAKqEpfv/WMBuYlXwE2i8xgjxDI5iZvnOsGukBD4
        yS7xeNVGRoi7XSRm/8+EqBGWeHV8CzuELSXx+d1eqEPrJfZNbWCF6O1hlHi67x/UUGOJWc/a
        weYwAx26fpc+xEhliSO3WCCu5JPoOPyXHSLMK9HRJgTRqCzxa9JkqCGSEjNv3oHa6iHx9tZ6
        dkiQxEocb1jAPoFRdhbC/AWMjKsYxVILinPTU4uNCkyQo2gTIzglannsYJz99oPeIUYmDsZD
        jBIczEoivL17reOFeFMSK6tSi/Lji0pzUosPMZoCQ2sis5Rocj4wKeeVxBuaGpmZGViaWpia
        GVkoifO+s7oQJySQnliSmp2aWpBaBNPHxMEp1cC0sav67q8fDB9+xwfMDWj7G/Lp782N7sz6
        Uy/d2Vv1Ljn18ZEtLbfWG57v9y54+DRIKedGmyX7HH8RtY9GD79ciNj9s+KqiLWA+8ldSazl
        rBP7NOJ+b6pI3D1dOVn05Rvv9PDAPatk9D3/VuXVKd+efy97Ba/OMb29J16I5B9dsCFFmvmd
        wSzem3d8daduv3Z3lZtm671pXfPcdpTvuW34TKrBxNUk5EnCi+7vm0zSMnYxL2iRMWDaHGbg
        8S+7duKkmbzJPFud/u1NN3m+74WPuO2uB8lO2+KiPetmhP+qC4nzPRvwIkzfm7PLJtBKMkl3
        lTjjmYnecbs2n/26IePLxSN/PTR8HCZx+am8iYxTYinOSDTUYi4qTgQAYbf0NxIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvO4yZ7t4g2mXdCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6Mjd0bWQoW81TMedTF2sA4l6uLkZNDQsBE4njjJhYQW0hgB6PEkr9R
        EHFJiRM7nzNC2MIS91uOsHYxcgHVfGOU+HVwJztIgk1AU+LpzalMIAkRgcNMEv+3PgdLMAuo
        S+yacIIJxBYWsJGYOqOfDcRmEVCVuHzvH9A2Dg5eATeJzmNQC+Qkbp7rZJ7AyLOAkWEVo2Rq
        QXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwmGpp7WDcs+qD3iFGJg7GQ4wSHMxKIry9e63j
        hXhTEiurUovy44tKc1KLDzFKc7AoifN+nbUwTkggPbEkNTs1tSC1CCbLxMEp1cAk2qhscsb0
        xoIPk9zftpV5TfqdF/elnfVEYVBZ0bdZixn7J6scjjui83qqWfhdb5+qiFlffhqJ7F70/01s
        xcoES0l+9wVPc1avXXh+8fO0xeYik17F9Or39U19kTH507KsDQUfs/03HTzGkHJBnFlU+cBy
        hly+YpOkQLf3nzVvn9N5+YexwaR9LauSbFfYKl22hX/Xb49ZwrAtf2OSqdb0QyvS7q1Nqvna
        1x9XNden7IjkVj/mmUJZbxnf9vWl/n2hJp5x8X/Nnu1JnSlfuQQ07dt/7w18xyPyLSjD8mSu
        10GRcqn6voP+dsf69T6d/WS4mLO8oDj7C18al62XqqL9j+rwK32/IvP3WDEaCiqxFGckGmox
        FxUnAgCpNW1UwgIAAA==
X-CMS-MailID: 20200820093430epcas2p1b78325cbc1ee6ff0f6ee1727e2a4de49
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200820093430epcas2p1b78325cbc1ee6ff0f6ee1727e2a4de49
References: <CGME20200820093430epcas2p1b78325cbc1ee6ff0f6ee1727e2a4de49@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have two knobs to flush for write booster, i.e.
fWriteBoosterEn, fWriteBoosterBufferFlushEn.
However, many product makers uses only fWriteBoosterBufferFlushEn,
because this can reportedly cover most scenarios and
there have been some reports that flush by fWriteBoosterEn could
lead raise power consumption thanks to unexpected internal
operations. So we need a way to enable or disable fWriteBoosterEn.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3076222..5392877 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5296,6 +5296,9 @@ static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
 
 static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
 {
+	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
+		return;
+
 	if (enable)
 		ufshcd_wb_buf_flush_enable(hba);
 	else
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b2ef18f..21d5741 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -520,6 +520,11 @@ enum ufshcd_quirks {
 	 * OCS FATAL ERROR with device error through sense data
 	 */
 	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
+
+	/*
+	 * This quirk needs to disable manual flush for write booster
+	 */
+	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 11,
 };
 
 enum ufshcd_caps {
-- 
2.7.4

