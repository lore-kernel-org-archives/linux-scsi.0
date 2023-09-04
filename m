Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9613C83F2D
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Sep 2023 01:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350357AbjIDBmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Sep 2023 21:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350282AbjIDBmB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Sep 2023 21:42:01 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807D8FE
        for <linux-scsi@vger.kernel.org>; Sun,  3 Sep 2023 18:41:54 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230904014150epoutp04f3c178a34bf702f5b9a692e38a8e02dd~BjpYx5hVt2370123701epoutp047
        for <linux-scsi@vger.kernel.org>; Mon,  4 Sep 2023 01:41:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230904014150epoutp04f3c178a34bf702f5b9a692e38a8e02dd~BjpYx5hVt2370123701epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1693791710;
        bh=UpLDeUFH71BALzHr+pVoGyqIUenCPnb/EuSkSo/gxIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=UFTI4BKpqChkfr+DwGZArS63JOhPtQu1a/2Qksnn9bQQl3y4PcjRMzs6TZjkfEvv1
         0ynIwycbrxQJig4gaGUtHFdNVH7tz6MugxnTQLJfuiTfO7cU+O2Io0HElKWvAW8ctp
         TDP53yWx3E4jyMAWA46qzsrarmddXtP0tjIl3azY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20230904014150epcas2p4c8ecae68e589f5b674a4ef01a7125a29~BjpYeOMUS1199211992epcas2p4q;
        Mon,  4 Sep 2023 01:41:50 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.92]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RfBFT3LrHz4x9Px; Mon,  4 Sep
        2023 01:41:49 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.43.09693.DD535F46; Mon,  4 Sep 2023 10:41:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20230904014148epcas2p1c49a727b427f2e6cc3d3933b1885776f~BjpXJqPRa2921929219epcas2p1G;
        Mon,  4 Sep 2023 01:41:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230904014148epsmtrp271828b8ff2ec93ae720bfd82a4b1815b~BjpXIlbJB0621306213epsmtrp2e;
        Mon,  4 Sep 2023 01:41:48 +0000 (GMT)
X-AuditID: b6c32a45-abbfd700000025dd-26-64f535dd2a6b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        38.E0.18916.CD535F46; Mon,  4 Sep 2023 10:41:48 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230904014148epsmtip1dc16ae67ebdf62493a8cb40cdf399c55~BjpW3a5Cu1092710927epsmtip1P;
        Mon,  4 Sep 2023 01:41:48 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, kwangwon.min@samsung.com,
        junwoo80.lee@samsung.com, wkon.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v3 1/2] ufs: make __ufshcd_send_uic_cmd not wrapped
 by host_lock
Date:   Mon,  4 Sep 2023 10:30:44 +0900
Message-Id: <782ba5f26f0a96e58d85dff50751787d2d2a6b2b.1693790060.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1693790060.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1693790060.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmqe5d068pBsfWilmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBarFz9gsVh0YxuTxa6/zUwWW2/sZLG4ueUoi8XlXXPYLLqv72Cz
        WH78H5NF190bjBZL/71lsdh86RuLg4DH5SveHov3vGTymLDoAKPH9/UdbB4fn95i8ejbsorR
        4/MmOY/2A91MARxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
        PgG6bpk5QB8oKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMC/SKE3OLS/PS9fJS
        S6wMDQyMTIEKE7IzLt1ezlbwma9iwZTdTA2Mh3i6GDk5JARMJH7+fMrWxcjFISSwg1HiyM1l
        UM4nRokPTSsRnPX7lzPCtLSd3sEKkdjJKLH48GYo5wejxLwlncwgVWwCmhJPb05lAkmICHxg
        kvi/fBtYO7OAusSuCSeYQGxhgUiJy1NPgtksAqoSV9f9YAWxeQWiJdbMmsgEsU5O4uY5iKGc
        ApYSHz7dYUFlcwHVzOWQaJ2xnBWiwUXi0OfZzBC2sMSr41vYIWwpic/v9gI9xAFkZ0vsWSgG
        Ea6QWDztLQuEbSwx61k7I0gJM9AD63fpQ1QrSxy5xQJxPZ9Ex+G/7BBhXomONiGIRmWJX5Mm
        Q8NHUmLmzTtQOz0kLv+5xQQJnh5GiUnLelknMMrPQliwgJFxFaNYakFxbnpqsVGBITz2kvNz
        NzGCU6uW6w7GyW8/6B1iZOJgPMQowcGsJMIrp/0pRYg3JbGyKrUoP76oNCe1+BCjKTAYJzJL
        iSbnA5N7Xkm8oYmlgYmZmaG5kamBuZI4773WuSlCAumJJanZqakFqUUwfUwcnFINTOpidrfX
        ZJ3czz1/2+/Ef2+evmKptpJb/rn6fWjG0jVrV4V47ak6InOPrz94V7Nc+TPLHv6Ud5e6v7Iv
        zJ66u6NO8UPfPJ8n85unOiiFfTsusmrx3PBPWoYLF63IFLN99MyqV+bgnIRY9fJV1QE31tnx
        +RwNmfCx+Vva2v6AabcV1mfq1Ued/CjoM4UnIMH5/CmX35vycw0ur9mzrPyi5tytthIWq3uu
        fnObZddocSa/dqPJO1WxRZmy+3K8+n98eHDk81XZmaJHDn3TfuHIEr/m4tJiaS6Op1OPLAgs
        mZx9qzq1RNlgXR7zrzkvnE3mRj79s15IYrbpkoZVu9QEC6UdnZ07Zwae8898Py/25FIlluKM
        REMt5qLiRAA7hT/SNgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnO4d068pBs2rtCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZovVix+wWCy6sY3JYtffZiaLrTd2sljc3HKUxeLyrjlsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yWGy+9I3FQcDj8hVvj8V7XjJ5TFh0gNHj+/oONo+PT2+xePRtWcXo
        8XmTnEf7gW6mAI4oLpuU1JzMstQifbsEroxLt5ezFXzmq1gwZTdTA+Mhni5GTg4JAROJttM7
        WEFsIYHtjBKLv5ZDxCUlTux8zghhC0vcbzkCVMMFVPONUeLG+nVgCTYBTYmnN6cygSREBJqY
        JS7Nns4CkmAWUJfYNeEEUIKDQ1ggXOLwK22QMIuAqsTVdT/AlvEKREusmTWRCWKBnMTNc53M
        IDangKXEh093WCAOspBYs+Y7Cy7xCYwCCxgZVjGKphYU56bnJhcY6hUn5haX5qXrJefnbmIE
        x4RW0A7GZev/6h1iZOJgPMQowcGsJMIrp/0pRYg3JbGyKrUoP76oNCe1+BCjNAeLkjivck5n
        ipBAemJJanZqakFqEUyWiYNTqoEplO+ezbxS7wSuvGk3HJva9t8095nHti1s2xrOuLCn88OW
        Tolo+RG4++T1L0cO9DocOmyz9Mwv/50JPVM/vuKyjszaLCxjU/2aZ75Uwr7CR6JvfYs+vc2d
        camnQt1xBvtqne+Wrh8mP2tRb3v5U09v9bnlDlOyU77+6zBbMK/o0IWyi8dUk2u9dyvurKjJ
        V0lQmuK1zLrslVtD8mbuRakFMz74Hsx/UtT76/7uZ50v9B3WLw+XTPfQCUh/rj9HKzLmhLra
        R75lPz421xxusdpim3TA/Pm+mdUCNvMmqfaJ97zlv/mqQHRC5+rAk1x3v3K+tYzyE/UJ/3Zz
        6Q4VJ6aYheoTH/1p/xWb8NtSt8BYiaU4I9FQi7moOBEAjFrxZvgCAAA=
X-CMS-MailID: 20230904014148epcas2p1c49a727b427f2e6cc3d3933b1885776f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230904014148epcas2p1c49a727b427f2e6cc3d3933b1885776f
References: <cover.1693790060.git.kwmad.kim@samsung.com>
        <CGME20230904014148epcas2p1c49a727b427f2e6cc3d3933b1885776f@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__ufshcd_send_uic_cmd is wrapped uic_cmd_mutex and
its related contexts are accessed within the period wrappted
by uic_cmd_mutex. Thus, wrapping with host_lock is
redundant.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 27e1a49..6300ed6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2414,7 +2414,6 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 		      bool completion)
 {
 	lockdep_assert_held(&hba->uic_cmd_mutex);
-	lockdep_assert_held(hba->host->host_lock);
 
 	if (!ufshcd_ready_for_uic_cmd(hba)) {
 		dev_err(hba->dev,
@@ -2441,7 +2440,6 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
 	int ret;
-	unsigned long flags;
 
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
 		return 0;
@@ -2450,9 +2448,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
 
@@ -4161,8 +4157,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		wmb();
 		reenable_intr = true;
 	}
-	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
 	if (ret) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
-- 
2.7.4

