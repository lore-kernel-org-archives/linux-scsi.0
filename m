Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5E7C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2CD961358
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbhE0DOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 23:14:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29328 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhE0DN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 23:13:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210527031224epoutp04aafcce3172a30ebb4dc7775a613886e2~CzdhLSqPA0906709067epoutp04_
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 03:12:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210527031224epoutp04aafcce3172a30ebb4dc7775a613886e2~CzdhLSqPA0906709067epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622085144;
        bh=cVkOyZXFci4e/LC+JGV+kk1apRazO3c51y6t6bo12bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFPsD0oThsb7QqSIouRArZpV8LvA+D2iTL8FCp4DOhO04LTzDmg1man/tkk3eIdJ3
         8gQMPy2eNjyUJ2TahMmHeOd3bVWjYi3Snrom7mVHHlTk2YMzGhZUXG0tSAB3Mqx0nt
         iPjknoI6fb5LuhqG2/SScjGEgw8dbjdimVFvpVyE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210527031223epcas2p2a4d153a87bbe9613dafc3a63bb587506~CzdgciFHj2939229392epcas2p2_;
        Thu, 27 May 2021 03:12:23 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FrCY10Z5cz4x9Q1; Thu, 27 May
        2021 03:12:21 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.78.09717.41E0FA06; Thu, 27 May 2021 12:12:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0~CzddXBTAw0832808328epcas2p4_;
        Thu, 27 May 2021 03:12:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210527031220epsmtrp1e96e025d35f0dc9691b6755c5d8bd083~CzddWEBJT0371003710epsmtrp1Z;
        Thu, 27 May 2021 03:12:20 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-85-60af0e14ca4f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.06.08637.41E0FA06; Thu, 27 May 2021 12:12:20 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.60]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210527031220epsmtip26cce362e4d9749c78ab753a66c307239~CzddL--yv1633016330epsmtip29;
        Thu, 27 May 2021 03:12:20 +0000 (GMT)
From:   jongmin jeong <jjmin.jeong@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        beanhuo@micron.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjmin.jeong@samsung.com
Subject: [PATCH 3/3] scsi: ufs: add quirk to support host reset only
Date:   Thu, 27 May 2021 12:09:01 +0900
Message-Id: <20210527030901.88403-4-jjmin.jeong@samsung.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527030901.88403-1-jjmin.jeong@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmha4I3/oEg3/frSxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxaf0yVotFN7YxWay8ZmFxedccNovu6zvYLJYf/8fkwOVxua+XyWPxnpdM
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjKscmIzUxJbVIITUvOT8lMy/dVsk7
        ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hGJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+
        cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEpUGVCTsal3n1MBd/4K7Z03WFsYJzN28XI
        ySEhYCLR2v+ErYuRi0NIYAejxL2e08wQzidGiavdt6Ccb4wS6zr/sMK0nP//kgkisZdRYmb3
        WkYI5yOjRMuuGUwgVWwCuhJnNr8EaufgEBEwkri2yhOkhlngJKNE79kXzCA1wgIuEs8+TWYE
        sVkEVCX2d11mB7F5BWwk7jTdYIHYJi9x+sQ1RpA5nAK2EmuuZEKUCEqcnPkErIQZqKR562yw
        SyUEpnJInLh2gRGi10Xibs8uNghbWOLV8S3sELaUxMv+Nii7XmJ3wx6o5gmMEt2dV6EW20v8
        mr6FFWQxs4CmxPpd+iCmhICyxJFbUHv5JDoO/2WHCPNKdLQJQTSqSmxZvBHqAmmJpWuPQw30
        kJjw6B0LJKiANj343sQ2gVFhFpJ3ZiF5ZxbC4gWMzKsYxVILinPTU4uNCkyQY3gTIzjRanns
        YJz99oPeIUYmDsZDjBIczEoivAeb1yYI8aYkVlalFuXHF5XmpBYfYjQFhvVEZinR5Hxgqs8r
        iTc0NTIzM7A0tTA1M7JQEuf9mVqXICSQnliSmp2aWpBaBNPHxMEp1cC05LzlZ7POm2s3Hvxj
        0MK9YvrlyffDP7f+3Hwzp+ObWMSdO9uMaorXfve4YeeceDtMJXA9V6nuPg/+M4aJi2puFvRd
        NHdOvHz+s6jNU0Ge3W4XWz3OMBn6X544JfWKw835x6xPTOyO4opMdONgZn60g8F6ZtTc1fdk
        31mq+f/awHBj4/HvE802b340R+lD20Wp4lgN20u2nklVrg88puspzr3j/LjGaN/L5MpL857x
        royb0hC1sEBdQWLOMavbxue8heY9rOWYcXJBpBSX7Ox9VasXNmTnslw42R/wfsOUXeuf7fy4
        cmLWe6vYtJaMXXPOMQfOvBZcfyHWoXTrzwYZ9sbNjKcPPYi4YbZTZ4LoRyWW4oxEQy3mouJE
        AIfLeBQ9BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvK4I3/oEg5f3ZC1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxaf0yVotFN7YxWay8ZmFxedccNovu6zvYLJYf/8fkwOVxua+XyWPxnpdM
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugSvjUu8+poJv
        /BVbuu4wNjDO5u1i5OSQEDCROP//JVMXIxeHkMBuRondy6axdDFyACWkJdbskYaoEZa433KE
        FaLmPaPE0udX2UASbAK6Emc2v2QGsUWABs249Y4VxGYWuMwoMf1cNIgtLOAi8ezTZEYQm0VA
        VWJ/12V2EJtXwEbiTtMNFogF8hKnT1xjBNnLKWArseZKJogpBFTyYlkKRLWgxMmZT1ggpstL
        NG+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCY0FLcwfj
        9lUf9A4xMnEwHmKU4GBWEuE92Lw2QYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6Ykl
        qdmpqQWpRTBZJg5OqQYmgRuvHH5tmfCgNmvVb7MlAk84LVbMCNghqfTdQm5yaMvWqqyDB48b
        cBbm/HyuZ/QqZvW1Ga7WEim7rctEVIxUtzxeXXY07UD4q5nKkSkbrrq2qT4wsuL8P2Hxe+U9
        W3ZO1wgq8w3rWxUiETXRQcfdtc1sV2BezY/I/c8UDrJEfai5mHIgfsLJjG+8Z1gPOc00uC89
        XdJisudH3/KEnRrWMpc+tE7jra2/eWrLwZNHn5pbiXulX/y2WLz9zRLRK7sCHZI8Uj1ehE5i
        Sq/fvstL7GCbekaciNzlC91HJKeeqvl9SyblSr9W7LSdH5Q5a1/1pQXEvn1oZVr5+oXNlr98
        HxNdH5tsX/XVaYMSb8gNJZbijERDLeai4kQAoDKvRvQCAAA=
X-CMS-MailID: 20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
        <CGME20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does support host reset handler only.
This patch calls the host reset handler when abort or device reset handler
has occured in the virtual host.

Change-Id: I3f07e772415a35fe1e7374e02b3c37ef0bf5660d
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++++++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4787e40c6a2d..9d1912290f87 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6826,6 +6826,9 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	u8 resp = 0xF, lun;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_RESET_HANDLER)
+		return ufshcd_eh_host_reset_handler(cmd);
+
 	host = cmd->device->host;
 	hba = shost_priv(host);
 
@@ -6972,6 +6975,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	host = cmd->device->host;
 	hba = shost_priv(host);
 	tag = cmd->request->tag;
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_RESET_HANDLER)
+		return ufshcd_eh_host_reset_handler(cmd);
+
 	lrbp = &hba->lrb[tag];
 	if (!ufshcd_valid_tag(hba, tag)) {
 		dev_err(hba->dev,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0ab4c296be32..82a9c6889978 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -581,6 +581,12 @@ enum ufshcd_quirks {
 	 * support interface configuration.
 	 */
 	UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION	= 1 << 16,
+
+	/*
+	 * This quirk needs to be enabled if the host controller support
+	 * host reset handler only.
+	 */
+	UFSHCD_QUIRK_BROKEN_RESET_HANDLER		= 1 << 17,
 };
 
 enum ufshcd_caps {
-- 
2.31.1

