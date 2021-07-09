Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0424C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A45861221
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 06:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhGIHAm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:00:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19251 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhGIHAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 03:00:36 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210709065751epoutp0168cfcbd787ee40ec75c841ea9e80c12f~QDRo5MUx62701027010epoutp01a
        for <linux-scsi@vger.kernel.org>; Fri,  9 Jul 2021 06:57:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210709065751epoutp0168cfcbd787ee40ec75c841ea9e80c12f~QDRo5MUx62701027010epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625813871;
        bh=VM8eDkYE7bjtqHXIrXSPWeAIT11uSoJEcd4YSofYT8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3UWL85Ckg682ToKVMjjeWndhN7sQPLqBABTJi5Z2DB2X/FYpYzzsMDWvqu3Ujv93
         GXk6p/EUQmLnDWz27XiJoOGbl5WImkTiout+Y5LKwHp6HB01g1VdlivkLNvG1Wu1ZS
         BEx2wDLWsoJZMqpw4ncM8eEKCT6hqELwMZ7TszoU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210709065750epcas2p30923f1260bd571cd4088fa03ed73a255~QDRoD4uQ62702827028epcas2p3x;
        Fri,  9 Jul 2021 06:57:50 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GLkWJ11DTz4x9QK; Fri,  9 Jul
        2021 06:57:48 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.CF.09541.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34~QDRjvxUwJ2549725497epcas2p2F;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210709065746epsmtrp20f302903b3cda5408056e03a142b1a8f~QDRjuy-q-0268602686epsmtrp24;
        Fri,  9 Jul 2021 06:57:46 +0000 (GMT)
X-AuditID: b6c32a47-5f3ff70000002545-12-60e7f36adaa1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.B7.08289.A63F7E06; Fri,  9 Jul 2021 15:57:46 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210709065746epsmtip2898de7ce897de0163d2f4ff6db8b003b~QDRjh5y223177431774epsmtip2e;
        Fri,  9 Jul 2021 06:57:45 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH 02/15] scsi: ufs: add quirk to enable host controller
 without interface configuration
Date:   Fri,  9 Jul 2021 15:56:58 +0900
Message-Id: <20210709065711.25195-3-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709065711.25195-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJsWRmVeSWpSXmKPExsWy7bCmuW7W5+cJBoee21icfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC0u79e26NnpbHF6wiImiyfrZzFbLLqxjcli5TULi5tbjrJYzDi/
        j8mi+/oONovlx/8xOfB7XL7i7XG5r5fJY/MKLY/Fe14yeWxa1cnmMWHRAUaPj09vsXj0bVnF
        6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
        F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6
        yfm5VoYGBkamQJUJORn9V86wFEzlrTi68jtjA+Nnri5GTg4JAROJTTu/sXcxcnEICexglDjw
        /S0ThPOJUeLHv+mMIFVCAp8ZJZ7e9uhi5ADr6D7BDRHexSjxap0tRP1HRomrmyawgCTYBHQl
        tjx/xQiSEBHoZ5RYvn8uC4jDLHCSWeL0goPsIFXCAukSLx9tAOtgEVCV+Ny4mRnE5hWwk9j/
        6BcLxH3yEqeWHWQCsTkF7CXm/ZjABFEjKHFy5hOwGmagmuats5lBFkgIHOGQ2PuhjxWi2UVi
        3c9F7BC2sMSr41ugbCmJz+/2skE0dDNKtD76D5VYzSjR2egDYdtL/Jq+hRXkZ2YBTYn1u/Qh
        3leWOHILai+fRMfhv+wQYV6JjjYhiEZ1iQPbp0OdLyvRPecz1DUeEkc/HWGDhNYkRolvT88z
        TWBUmIXknVlI3pmFsHgBI/MqRrHUguLc9NRiowJj5BjexAhO01ruOxhnvP2gd4iRiYPxEKME
        B7OSCK/RjGcJQrwpiZVVqUX58UWlOanFhxhNgYE9kVlKNDkfmCnySuINTY3MzAwsTS1MzYws
        lMR5OdgPJQgJpCeWpGanphakFsH0MXFwSjUwFQrwnn9zok7KkjdoksGtwoV97jNFpl8V490X
        USmrff/XwfMvFBQT7x9W7E4qDLp4IfJ3+PreuOw3yW5Cb8u8jxi6GB56nR+VaqoYrb45QaJF
        M/bADF1x/9vFKZdYE2b/6I/jndZd82Lfco0u9Y2afcof89imOyle017rfXAST93tBFHPkIgz
        D2IKzZY0HZYs/9h++h/bvjTh8IWVTFYHC0vvCLRKVtnPPPZx7/FF/1JDDX4UVXN+mefUsb6e
        d9baNRym0We5Li+zc7/59cKvTq0rngKx5S3XQkQ3fZz07vNGnfmPruZOtF3p2/paLWP+ilty
        /5SeSbDsTL0fcjtA+c8ug4wIbS+ri+lnGw8osRRnJBpqMRcVJwIAb6OuaFwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXjfr8/MEg2+X2C1OPlnDZvFg3jY2
        i5c/r7JZTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8pqFxc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YHPg9Ll/x9rjc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPHx6e3WDz6tqxi
        9Pi8Sc6j/UA3UwBXFJdNSmpOZllqkb5dAldG/5UzLAVTeSuOrvzO2MD4mauLkYNDQsBEovsE
        dxcjF4eQwA5GifebZrJ2MXICxWUlnr3bwQ5hC0vcbznCClH0nlFidt9ysASbgK7EluevGEFs
        EYGJjBJL7omBFDELXGaW+DbtCjNIQlggVWL+jn9gU1kEVCU+N24Gi/MK2Ensf/SLBWKDvMSp
        ZQeZQGxOAXuJeT8mgNlCQDX3Nuxjh6gXlDg58wlYPTNQffPW2cwTGAVmIUnNQpJawMi0ilEy
        taA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOJ60tHYw7ln1Qe8QIxMH4yFGCQ5mJRFeoxnP
        EoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgWpPC0d54
        43MmG+sLZv4IJgVhg9PshX6STEfKLvB9V/6u3ug6w/Mdb9Cx/gK5Se7876JvnPjKvt/zruQJ
        7mWKJjGpa3JZG/MXJIq53X66Ydv6Y/lZvu9qZ4Rab9h2t/HDxEbp1zd+7TpZkzrN7fWvHndr
        a+eCtMJsm8divq5ZtusaZkU9abnDFmm1M+PrB8Osqy1Va73//Ziy7tv1oEC2uxuD1JeaFjzf
        /PDVay1hwRkHwnulVut1HV178QtTUn3Xe82za9sXa/DO6b8kMzN7Z2CpOneAklW1V9qsC7Hb
        ihrmvd8uP/9jy/SoraYhXf/tG3ct/O/8QOO3TWbA3Mfelh/uizMJ98sqZ91gYbmkxFKckWio
        xVxUnAgA+rKjKRYDAAA=
X-CMS-MailID: 20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p2f353983bbc64c1a21571fda2be59df34@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support like device management.
This patch skips the interface configuration part that cannot be performed
in the virtual host.

Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9702086e9860..3451b335f2b4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7988,6 +7988,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	if (ret)
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION)
+		goto out;
+
 	/* Debug counters initialization */
 	ufshcd_clear_dbg_ufs_stats(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e67b1fcfe1a2..fe523cbd68dd 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -573,6 +573,12 @@ enum ufshcd_quirks {
 	 * support UIC command
 	 */
 	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
+
+	/*
+	 * This quirk needs to be enabled if the host controller cannot
+	 * support interface configuration.
+	 */
+	UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION	= 1 << 16,
 };
 
 enum ufshcd_caps {
-- 
2.32.0

