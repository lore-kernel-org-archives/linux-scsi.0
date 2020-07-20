Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F59C433E4
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A3622BF3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:39:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Tl+zao0b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgGTKj6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:39:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41878 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbgGTKj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 06:39:57 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200720103955epoutp04fc68890e5c00557b71c36dfd7fdd394f~jb8dknWGD0078500785epoutp04R
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 10:39:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200720103955epoutp04fc68890e5c00557b71c36dfd7fdd394f~jb8dknWGD0078500785epoutp04R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595241595;
        bh=XuMxHD/Gxlj+yR3CegW2oYFQ5WE9UqL8Bp0Wv+112Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tl+zao0bgB0I4DlL5Yh2zFgCNc+SVXUFimiP9ZWDKzWgT76G2MYk4MCqCGprPJhS1
         uOXU+Oa4iHNoDu+nhSrrD36TyleQQeL6qG5ubOSIs8skNy3GRsM1KfPlft+59v5H9+
         iMTy2pKjFlLoeiDHW3CqK0vA8DRPlEguQIq1bE08=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200720103953epcas2p4aca088be9c1f8b73fe5e247fa5be3d81~jb8cZiNsB3088630886epcas2p4Y;
        Mon, 20 Jul 2020 10:39:53 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B9JBv0RBvzMqYlv; Mon, 20 Jul
        2020 10:39:51 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.A0.27441.674751F5; Mon, 20 Jul 2020 19:39:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200720103950epcas2p16278643a6f62b446b653c834de448543~jb8ZVfQ3b1933419334epcas2p14;
        Mon, 20 Jul 2020 10:39:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200720103950epsmtrp1e9ebd6ea6e39829ee7461fd09a045c6b~jb8ZUzNc_1624116241epsmtrp1i;
        Mon, 20 Jul 2020 10:39:50 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-0c-5f157476fa62
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7B.45.08382.674751F5; Mon, 20 Jul 2020 19:39:50 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200720103950epsmtip26b3b661f438aef171a3bae57d94ca6fe~jb8ZIFvb90949409494epsmtip2n;
        Mon, 20 Jul 2020 10:39:50 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v2 2/3] scsi: ufs: modify function call name When ufs
 reset and restore, need to disable write booster
Date:   Mon, 20 Jul 2020 19:40:12 +0900
Message-Id: <98b5339dc9c5dc57ed72e83bc7c39c4211d20b6a.1595240433.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595240433.git.hy50.seo@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmqW5ZiWi8wb4ZlhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEdUjk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KFKCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjL1X5jMWPOWoeLr9FmsD
        4272LkYODgkBE4knzVFdjFwcQgI7GCUeL3vPCuF8YpQ4u+sAE4TzjVFi18WjLF2MnGAdv398
        ZYRI7GWU+L7oKFTVD0aJVT+mMYJUsQloSKw5dggsISLwgVHi6IrZrCAJZgE1ic93l4GNEhao
        kbjy6w0TiM0ioCqxccoPsDivQJREx9dJTBDr5CUWNfwGszkFLCTmbHzEBlEjKHFy5hMWiJny
        Es1bZzODLJMQmMkhMe//ZHaIZheJc33r2SBsYYlXx7dAxaUkXva3Qdn1ElPurWKBaO5hlNiz
        4gTUZmOJWc/aGUHBxCygKbF+lz4kxJQljtyC2ssn0XH4LzQgeSU62oQgGpUkzsy9DRWWkDg4
        Owci7CHxes8ZZkhYdTNKLPt8jW0Co8IsJN/MQvLNLIS9CxiZVzGKpRYU56anFhsVGCPH8CZG
        cMrVct/BOOPtB71DjEwcjIcYJTiYlUR4J/IIxwvxpiRWVqUW5ccXleakFh9iNAWG9URmKdHk
        fGDSzyuJNzQ1MjMzsDS1MDUzslAS5y22uhAnJJCeWJKanZpakFoE08fEwSnVwBS2Kv1dBOPT
        vY17pl45/VPkA+/DdAuRKYbHZobIr08KYA7R/nFr2YGrWje9n7w8MeOV3p8S/9KH7uIlzWdk
        5T+8kJyTnql551+r6PXI40fip2/L8rjA4ZbuF3G4K2gOR3qZ+BKLYw5TjiW8km1XcWPdaRqd
        LX5Dqu2D9r3zhk1hvfPcw1+JsEYalDDe+frEVXlv8Ok43t+tscrdZ5NiJrFszg36sig4/M2v
        txln/u1Zc7UvY3vnvxcGfo31ku2cqW8/i3DPyhHP2b/3fE/MognuSm7bX5hOY/m1QPzSHiFW
        92t/jJl1Lnzrmvspu2NtpoJpcZkPP7OF9qVpTFbBrMsfb9rT6COl6nxvD3/9RCWW4oxEQy3m
        ouJEALiQ15FCBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsWy7bCSvG5ZiWi8wbUNShYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TA7fH5Sve
        Hpf7epk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEcUl01Kak5mWWqRvl0CV8be
        K/MZC55yVDzdfou1gXE3excjJ4eEgInE7x9fGbsYuTiEBHYzSszdcw8qISHxf3ETE4QtLHG/
        5QgrRNE3RonbExaxgSTYBDQk1hw7BFYkIvCHUWLS6TgQm1lATeLz3WUsILawQJXE7vOTwYay
        CKhKbJzyAyzOKxAl0fF1EtQCeYlFDb/BbE4BC4k5Gx+BzRcSMJc4v6uRGaJeUOLkzCcsEPPl
        JZq3zmaewCgwC0lqFpLUAkamVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwbGhpbmD
        cfuqD3qHGJk4GA8xSnAwK4nwTuQRjhfiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6NwYZyQQHpi
        SWp2ampBahFMlomDU6qBabeqPu+91Os/cjtke5P6Z71Vyvt1I3+dgnblnhm8Ya5uwpPb7y5J
        6LaZd3OTVUY6uzv3v/dbbvpv4pW/ablq/UJ9Nv1FR6d0ni+Vm1watD9V8Of9pu9Or4wnxii9
        u15y/m5e1L7v9x5brXxytmH71wih4vrPjssEi0N16uwvOK1+cL8ooUXmiYHQA2Z51tlyyXun
        XT1y2zCVl+mB2c7HqUoJG95ND5n6UFv5wted37czmB1bu/qFFsuPCulA8YLt9VHBBS+c7S5f
        Pyu6VCa06NnHRu/NvxcI7azapGH1la/hUf+5kwodRrf1ZQxP/mef02wUvjT7zrd3N/j+n32Y
        /NFMcla67+7gfdbR19iuJCmxFGckGmoxFxUnAgAbiohy/AIAAA==
X-CMS-MailID: 20200720103950epcas2p16278643a6f62b446b653c834de448543
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103950epcas2p16278643a6f62b446b653c834de448543
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103950epcas2p16278643a6f62b446b653c834de448543@epcas2p1.samsung.com>
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
index efa16bf4fd76..419d3dd7e183 100644
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

