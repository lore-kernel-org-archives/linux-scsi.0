Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE18C4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E75610C7
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 08:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbhJGIN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 04:13:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43922 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240554AbhJGINz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 04:13:55 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211007081200epoutp02514eb802f2e425dce2b6d05f1bb0cccb~rsWEoMnfB0453504535epoutp02w
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 08:12:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211007081200epoutp02514eb802f2e425dce2b6d05f1bb0cccb~rsWEoMnfB0453504535epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633594320;
        bh=1sGqwx8KngIfZGMF93W3ec2Pl/8FNMcx9mooOsJttB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWoR439/hplp/88zSuI9zZ8MFNsR3932eHXOQD78jAmNMGg13+KVoTgSg8pTDRBhX
         K6bYIdDFpY41BbU6hQSzL89+2Vamo18QSjx1TCccAmlTc2MiK1SBMbcaD7bEbzhRc3
         o9GKwBv4Gxa6wTeqe65/XlqY2gP3VODVa6GIPsGU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20211007081147epcas2p2c008aa0df7d5589014f38db5bfe61f0a~rsV4hs6v13110131101epcas2p2b;
        Thu,  7 Oct 2021 08:11:47 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.91]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HQ3v22R2mz4x9Qc; Thu,  7 Oct
        2021 08:11:42 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DF.98.09816.BBBAE516; Thu,  7 Oct 2021 17:11:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epcas2p3ca173361432aabe2ce9b923465a08570~rsVrsb2lo2615326153epcas2p3L;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211007081133epsmtrp23c76dc83ee77a187d349212d2733fb5d~rsVrobjOG2686726867epsmtrp23;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-0d-615eabbbab42
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.A7.08750.5BBAE516; Thu,  7 Oct 2021 17:11:33 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211007081133epsmtip2ec9be9a83825380bc6c5134756b318a3~rsVrYzsp50776407764epsmtip2P;
        Thu,  7 Oct 2021 08:11:33 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH v4 01/16] scsi: ufs: add quirk to handle broken UIC command
Date:   Thu,  7 Oct 2021 17:09:19 +0900
Message-Id: <20211007080934.108804-2-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211007080934.108804-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd2+5FGK3u+L0SzMnlJFNFqDteHyABRmE3Q03mcZ/GMpuyh0Q
        Stv0oYAx4uYcUMEWCSCicTCHK04GdMh4ycMM2QPYGCDGyasGYSuvmiggsLYXN//7nXN+5/zO
        4/u4OH+CEHDTFFpGraDlQsKd09i9C/m11BymRdO2QNRruUag8UuNBJpZHiJQ50QeB5UsLONo
        qfYbFzR48y105sdo9IuhEkOW2nIcVd5pxNCdldMu6NthhOqsTzBU1t+OIf1IE4Gqe9YxtLrc
        he3hU4N/xlHlOQUENVhYgFENV32pqtYZjKo35RGUobIDUI9rcwlq8cFdDlVoNgHKVv8a9WWH
        HovfkpC+O5Whkxm1J6OQKZPTFClSYdyBpOikoGCR2E8cikKEngo6g5EKY/bG+8Wmye2zCT2P
        0HKd3RVPazTCgIjdaqVOy3imKjVaqZBRJctVISp/DZ2h0SlS/BWMNkwsEkmC7MRP0lNX+yc4
        qrqXMnMNV1xzwMyWfODGhWQgHDFeJxyYTzYBmF/qkw/c7XgJwBbD766sYQPw4oDV5VmG0XjD
        hQ00A/j38iqHNRYBnGsYd9YiSD9onp4FjsBWch5Ay1SxsxZOzuBwqNfm6mB5kHFwbagGd2AO
        6QNvWvRODR4ZCX8aW+KwejvhrZU8J8eN3ANbm78jWM7LsPe8xcnB7ZzPf7iAs/yHXLhoBSyO
        gdaa8U2/B5ztMbuyWABtc22EoyFI6gH8YnJjM1ADYN7JvSyOhCulZntDXLvALljbHOCAkPSG
        t+5uyr4Ic7vXXFk3D+ae5rOJb8COG6Wb3e+A+grb5uYo2FlbiLO7Pgfg45IEA/Asf26Y8ueG
        Kf9f9zLATWAbo9JkpDAaiUry34Vlyox64HzrvrFNoNi64N8FMC7oApCLC7fylJGHaD4vmc7K
        ZtTKJLVOzmi6QJB91UZc8IpMaf8sCm2SODBUFBgcLA6RBIlChNt5F9ffoflkCq1l0hlGxaif
        5WFcN0EOJhe4J9ZLvY8Wvhku2HdifvbE+CVewM4nnGxDg7dZWbGtqiW20WI6/rbk/fNTaYsj
        BYfai7wS7n//1/V3e+9XccIl1/a3fJAoPqjcKOupu3qPB3/+Z+pUc9WHvkGWGZ99o1RWdVvD
        0YT1qbYXJq/ENx0bzg45e1LWdi5gaHohMeLA/rDxM+sfj716uTW6Qv8R6Ct4T7cx/HWft6qa
        L3pa1P+p7Nhv917PjnIJEG+nzJk7bj8aLY4h2s62HxktYY7fflT3Wc1QWFRF4+BAJsr0iivL
        MnGlfb/quAMec14PBmJExrz2g6Gy6Atj0xHJh6P+8J7/quhpZ/jcZH3OQ9+MU8a1bqtJKuRo
        UmmxL67W0P8Ce+p9InQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvO7W1XGJBgsma1mcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtbi8X9uiZ6ezxekJi5gsnqyfxWyx6MY2Josbv9pYLVZe
        s7DY+PYHk8WM8/uYLLqv72CzWH78H5PF75+HmByEPC5f8faY1dDL5nG5r5fJY/MKLY/Fe14y
        eWxa1cnmMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJ+
        n3/IUrCRv6JjwlL2BsaXPF2MnBwSAiYSEyduZ+1i5OIQEtjBKLH+0UVGiISsxLN3O9ghbGGJ
        +y1HoIreM0ocnPwcLMEmoCux5fkrsAYRgY+MEnO+aYEUMQt8ZZbYdHQaE0hCWMBb4u/V1cwg
        NouAqsT+J92sIDavgL3EsfufWCA2yEsc+dUJVsMp4CCxZ9dati5GDqBt9hJdfyMhygUlTs58
        AlbODFTevHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiO
        QC2tHYx7Vn3QO8TIxMF4iFGCg1lJhDffPjZRiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPx
        QgLpiSWp2ampBalFMFkmDk6pBibxI7tOHfBh7mJZfXu5MNOiu41eFUrSnjsXXdvR78y3Mvjb
        XbuyL9+nzT3yoPTddNZXm25YrWaa8jJEPPX/4hUbGFjtPyyOrJ29Uidh1xM5fYXFncrXA688
        6HgkUN3DbHla7d2JVcc4+bbuMeXj2tZ4rLN6096jP66yh03PvnRO5/JGnxDFFX99ZlWktiZs
        6zm1L7fOb5Kxc2WclRGXTdOXpXd3n+VkYZW4/y7MSmEJ2y1LyYUvBUoX/pYVi/wz00riKEPR
        zPNXEkPtjvM+2jVN59yqyIKCbS1WhRwX3m3dN8OIPXWt7Ld/LC3iotNPyC71/nI75LhygVn+
        FQ9b8dCzImnL/9hJvuHXVRVntjBXYinOSDTUYi4qTgQAgGALGS8DAAA=
X-CMS-MailID: 20211007081133epcas2p3ca173361432aabe2ce9b923465a08570
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081133epcas2p3ca173361432aabe2ce9b923465a08570
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081133epcas2p3ca173361432aabe2ce9b923465a08570@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jongmin jeong <jjmin.jeong@samsung.com>

samsung ExynosAuto9 SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function
only.

In this structure, the virtual host does not support UIC command.
To support this, we add the quirk and return 0 when the UIC command
send function is called.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 188de6f91050..7cf8e688aec8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2322,6 +2322,9 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	int ret;
 	unsigned long flags;
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UIC_CMD)
+		return 0;
+
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f0da5d3db1fa..5d485d65591f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -588,6 +588,12 @@ enum ufshcd_quirks {
 	 * This quirk allows only sg entries aligned with page size.
 	 */
 	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+
+	/*
+	 * This quirk needs to be enabled if the host controller does not
+	 * support UIC command
+	 */
+	UFSHCD_QUIRK_BROKEN_UIC_CMD			= 1 << 15,
 };
 
 enum ufshcd_caps {
-- 
2.33.0

