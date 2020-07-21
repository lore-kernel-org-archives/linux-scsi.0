Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107D4C433F1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF63A2073A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tQGBgYgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgGUJ5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:57:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48820 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729076AbgGUJ5A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 05:57:00 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200721095657epoutp0107f18447036c9ca6b78e1fcb53a4847d~jvAPcLrxU0852408524epoutp01_
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:56:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200721095657epoutp0107f18447036c9ca6b78e1fcb53a4847d~jvAPcLrxU0852408524epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595325417;
        bh=nV+/lhhcAFWEs1ILcJtcCffr5DJSS0l9nkMRSjne5lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQGBgYgQsDw/w5wU5QnHUzIc2y1TyHrBB7UKUFyD7/O6PnWt2JMECh4/StQ9MZjih
         KJVAv3h/zPLYGEmo76To/OEwq4jyGe1wYOYv+3Sjc6r1gP0XkeYoO5ZMkvE7QQPK0h
         ivc6AXC9r3G+gSpDSTb1nWAKzCsxtZweFLpVp8Lo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200721095657epcas2p19019454aaaa68055e9386c3cdaace00f~jvAO4AkiE0338903389epcas2p1Q;
        Tue, 21 Jul 2020 09:56:57 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4B9vBt1PvHzMqYkb; Tue, 21 Jul
        2020 09:56:54 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.CB.18874.6EBB61F5; Tue, 21 Jul 2020 18:56:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200721095653epcas2p4575db5cbcd8897662ad19465339128b2~jvALxJLYA2747427474epcas2p4c;
        Tue, 21 Jul 2020 09:56:53 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721095653epsmtrp2932fff629bbbc7564e7d42f14bb14b5e~jvALwUcnl0200302003epsmtrp2J;
        Tue, 21 Jul 2020 09:56:53 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-45-5f16bbe6dbf7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.3A.08303.5EBB61F5; Tue, 21 Jul 2020 18:56:53 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200721095653epsmtip20aa41f42de567561ab82dbcf873fabf9~jvALiXNnD0445804458epsmtip2l;
        Tue, 21 Jul 2020 09:56:53 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v3 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Date:   Tue, 21 Jul 2020 18:57:11 +0900
Message-Id: <52e4453499a65ad276df5af9a0f057e960704f93.1595325064.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595325064.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmme6z3WLxBrs72S0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mB26Py1e8
        PS739TJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAI6oHJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoEOVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GZMXqBc85ah4OTOugXE3
        excjJ4eEgInEviMHWLoYuTiEBHYwSizZvpURwvnEKNH9YBkzhPOZUWLBwYdsMC3H5x+CatnF
        KPH2y3pWCOcHo8Sp1p9gg9kENCTWHDvEBJIQEfjAKHF0xWxWkASzgJrE57vLWEBsYYEaiTNr
        dgEVcXCwCKhK9PXLg4R5BaIkprUthjpQXmJRw28mEJtTwELi7Ozz7BA1ghInZz5hgRgpL9G8
        dTbYqRICUzkkmo7sZASZKSHgIrF5oz7EHGGJV8e3QM2Ukvj8bi/UN/USU+6tYoHo7WGU2LPi
        BBNEwlhi1rN2sDnMApoS63fpQ4xUljhyC2otn0TH4b/sEGFeiY42IYhGJYkzc29DhSUkDs7O
        gQh7SPxf9hoabN2MEtfXN7JPYFSYheSZWUiemYWwdwEj8ypGsdSC4tz01GKjAiPk6N3ECE62
        Wm47GKe8/aB3iJGJg/EQowQHs5II70Qe4Xgh3pTEyqrUovz4otKc1OJDjKbAkJ7ILCWanA9M
        93kl8YamRmZmBpamFqZmRhZK4rz1ihfihATSE0tSs1NTC1KLYPqYODilGpjWzfPS6Tslf3qB
        p+0k/w9f7rC4FM3riX26vsW3m+/0Kz5tpqkqvRF3OSvuzk27+yAj+t8knunXc07yqwQlZtr6
        dxok+TxWvP39hcW3SJm1UmLeVtG9ob8Nvhv91ui3mKP8zuTUAjd9rXtFL2ZE1N9b5cH2b1kQ
        55yumWIfFkV+4soPqyqrbN/sXt52KCdGL3JawyuetoV3Ek42FedMYUsKPr0mLm3/pJPnFzMd
        2nVaqFU99eetvCMXJ5gKtcipGceZ7d8hPS958QfPdobvF9TOrH/v+5lDbHr9hy3bL8wrT9jv
        2r15flbxRY2zf8NnZS2q4fhmP/fUWgmv9UJyb2/+ENpXu/Rxew+fq8sR8RYlluKMREMt5qLi
        RABue7dFPwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvO7T3WLxBm87dS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mB26Py1e8
        PS739TJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAI4oLpuU1JzMstQifbsErozJ
        C9QLnnJUvJwZ18C4m72LkZNDQsBE4vj8QyxdjFwcQgI7GCW2nXjJCpGQkPi/uIkJwhaWuN9y
        hBWi6BujRPvVe8wgCTYBDYk1xw6BFYkI/GGUmHQ6DsRmFlCT+Hx3GdBUDg5hgSqJLecDQEwW
        AVWJvn55kApegSiJaW2LoW6Ql1jU8BtsCqeAhcTZ2efZQcqFBMwlZl8thCgXlDg58wkLxHB5
        ieats5knMArMQpKahSS1gJFpFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcERoae1g
        3LPqg94hRiYOxkOMEhzMSiK8E3mE44V4UxIrq1KL8uOLSnNSiw8xSnOwKInzfp21ME5IID2x
        JDU7NbUgtQgmy8TBKdXAtGRNaE68QmAC05mpjSqfLWPL8vYvb9RmD+5RamSdJ1QssdzHO0SX
        4dWU/d5bJprsKr+XPzV+pd/8HtPjR5hcJQ8IPEp778ORWByiqtv9yGGG4Lq5XT9sP5WXrjun
        y3qz582vQv5i55IXhbmBsZazKmM+7NUXT/2WIulwVP7kia2MlisPL6/lt5MpN+Sv39y8sVJz
        mdYOZbV7Gh9u39SbML31YrvKQY8j/156dF1UKW2YLcx756Xi5OIp1Y4dkb2PNHnUjga4sy+d
        rPTUtWnn64mL2vxOZ062nlL4WyJ0nS5ny6TmqVX+W9lZN5lFXOre3HeZ/fbv6UvPFx6s27Dr
        yudl6/8tcFfz1RHeYBipxFKckWioxVxUnAgAq0CyMPcCAAA=
X-CMS-MailID: 20200721095653epcas2p4575db5cbcd8897662ad19465339128b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095653epcas2p4575db5cbcd8897662ad19465339128b2
References: <cover.1595325064.git.hy50.seo@samsung.com>
        <CGME20200721095653epcas2p4575db5cbcd8897662ad19465339128b2@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9261519e7e9a..3eb139406a7c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6615,7 +6615,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	int err = 0;
 	int retries = MAX_HOST_RESET_RETRIES;
 
-	ufshcd_reset_vendor(hba);
+	ufshcd_wb_reset_vendor(hba);
 
 	do {
 		/* Reset the attached device */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index deb9577e0eaa..61ae5259c62a 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1217,7 +1217,7 @@ static int ufshcd_wb_ctrl_vendor(struct ufs_hba *hba, bool enable)
 	return hba->wb_ops->wb_ctrl_vendor(hba, enable);
 }
 
-static int ufshcd_reset_vendor(struct ufs_hba *hba)
+static int ufshcd_wb_reset_vendor(struct ufs_hba *hba)
 {
 	if (!hba->wb_ops || !hba->wb_ops->wb_reset_vendor)
 		return -1;
-- 
2.26.0

