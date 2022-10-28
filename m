Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D52AECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Oct 2022 07:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJ1HgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Oct 2022 03:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJ1HgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2022 03:36:00 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB10A2AAE
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 00:35:56 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221028073554epoutp0253e243cb26781eb06ad27af0c4550f68~iK2viw5vZ1259512595epoutp02N
        for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2022 07:35:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221028073554epoutp0253e243cb26781eb06ad27af0c4550f68~iK2viw5vZ1259512595epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666942554;
        bh=CWUfsC0Pi4NZOcVC8baMUqkw1IwSaT37tR2xo1u6jBM=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=ROu4yN+SrVmhgT+wfkPTrFaPkiAgrHEAOfuLzbYZOo8BpbeThnt39iFt8XCfWGDXR
         CXnivc9mMIZ0IY96tPFWbAr3ARumdKAbd1yV4QyK13sMFUApnedd6auoXQZeTVql5Z
         l/Py/Xz+RlUI8poVrEDWVy9ow+apKwjsryXpKcNs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20221028073554epcas2p36b80a5b9458e40611ac2596e43b5e1b5~iK2vIsDKS2879428794epcas2p3E;
        Fri, 28 Oct 2022 07:35:54 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.98]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4MzDqY4lXLz4x9Px; Fri, 28 Oct
        2022 07:35:53 +0000 (GMT)
X-AuditID: b6c32a46-85fff70000012ff6-a5-635b86597485
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.53.12278.9568B536; Fri, 28 Oct 2022 16:35:53 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Refactor ufshcd_hba_enable()
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221028073553epcms2p6dc4f8bdbebdc8f96f43fc4197b3edd0c@epcms2p6>
Date:   Fri, 28 Oct 2022 16:35:53 +0900
X-CMS-MailID: 20221028073553epcms2p6dc4f8bdbebdc8f96f43fc4197b3edd0c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmqW5kW3Sywaq/KhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8XLQ5oWj24/Y7To7d/KZrHoxjYmi8u75rBZdF/fwWax/Pg/Jgce
        j8tXvD0W73nJ5DFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQI4orJtMlITU1KLFFLz
        kvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4COVVIoS8wpBQoFJBYXK+nb
        2RTll5akKmTkF5fYKqUWpOQUmBfoFSfmFpfmpevlpZZYGRoYGJkCFSZkZyy62MFYcIuzYkr/
        U+YGxo/sXYycHBICJhJ75/eydDFycQgJ7GCUePplB1CCg4NXQFDi7w5hkBphATuJozub2EBs
        IQElia6FW5kh4gYS66bvAbPZBPQkpvy+wwgyR0TgJ7PEpfez2SAW8ErMaH/KAmFLS2xfvpUR
        wtaQ+LGslxnCFpW4ufotO4z9/th8qBoRidZ7Z6FqBCUe/NwNFZeUaD2zFWp+vsSTm/1Q82sk
        Fmz/DBXXl7jWsREszivgK9H8ZQrYfBYBVYnlWz5B1btI3J7WBRZnFpCX2P52DjPI78wCmhLr
        d+mDmBICyhJHbrHAfNKw8Tc7OptZgE+i4/BfuPiOeU+YIGw1iUcLtrBC2DISF+ecg/rEQ+La
        hCtsExgVZyECehaSG2Yh3LCAkXkVo1hqQXFuemqxUYERPG6T83M3MYKTrZbbDsYpbz/oHWJk
        4mA8xCjBwawkwnv2RniyEG9KYmVValF+fFFpTmrxIUZToO8nMkuJJucD031eSbyhiaWBiZmZ
        obmRqYG5kjhv1wytZCGB9MSS1OzU1ILUIpg+Jg5OqQam/BlPA65OEpiSM/9x9UN9fia/kqDy
        6R+6v1w5q/fQ3C7Iz2G97sHfT4Sed76/PFUg597Rf1lS1fmvQiS2FNpUzfQS3L51a1R+ZPnK
        onRBk1jmDRzR13h/Oq/xMWwNvHbQc+LEXzLPci7tWSTEyXzIv95gun3JkrSp5ftPV6vFznw7
        c681gy7j9atXKtqsfm/qEfnA+j4n8taXe1IXJ1qLORUuDBFZo6Bt0L5gibvUm257nYv5ETo7
        O6W0N2mJcy26FODGdsb884LFmyv/T1/ZbXE987+IZQ/v3dUvX/M4xG7fM+ufw9rE3vVzPB+n
        Xfi39/rKN99qw0++WsXb3poiNPfeiva7vCfPVhxS7/zYrMRSnJFoqMVcVJwIALOnOBU/BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221028073553epcms2p6dc4f8bdbebdc8f96f43fc4197b3edd0c
References: <CGME20221028073553epcms2p6dc4f8bdbebdc8f96f43fc4197b3edd0c@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use "if error return" style in ufshcd_hba_enable().
No functional change.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b2203dd79e8c..4288241040db 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4665,14 +4665,18 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
 		/* enable UIC related interrupts */
 		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
 		ret = ufshcd_dme_reset(hba);
-		if (!ret) {
-			ret = ufshcd_dme_enable(hba);
-			if (!ret)
-				ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
-			if (ret)
-				dev_err(hba->dev,
-					"Host controller enable failed with non-hce\n");
+		if (ret) {
+			dev_err(hba->dev, "DME_RESET failed\n");
+			return ret;
 		}
+
+		ret = ufshcd_dme_enable(hba);
+		if (ret) {
+			dev_err(hba->dev, "Enabling DME failed\n");
+			return ret;
+		}
+
+		ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
 	} else {
 		ret = ufshcd_hba_execute_hce(hba);
 	}
-- 
2.17.1

