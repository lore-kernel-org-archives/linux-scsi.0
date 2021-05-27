Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6535C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8554161358
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 03:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhE0DN6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 23:13:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17647 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbhE0DN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 23:13:57 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210527031223epoutp01d15a2633715e55ac75ff4a925b800ad6~CzdgAd1I32072420724epoutp017
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 03:12:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210527031223epoutp01d15a2633715e55ac75ff4a925b800ad6~CzdgAd1I32072420724epoutp017
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622085143;
        bh=0hpKO5higzaZMXr6qB5GWGSB2TNiUI9oi3bZGjSi09c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbEpr7TY7chBY49FDTaBh+qYjnui/wBl9QBuZLM9HZ3J8fNrgxPLiwZd+xI/kLepI
         wewRzCSRQIuUnQb4zBWxPV/JH066eiPTpny/BnbZn+8Ortpzw0VMoHXivG7LXGqCTb
         H9yJAjRlZlyx7/E8vNq9R8l4iHaDeNz6Tql6H1A8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210527031222epcas2p212470e592ff66707c629c70f8cf6ed09~CzdfbDpeF2938829388epcas2p2G;
        Thu, 27 May 2021 03:12:22 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FrCY05rxtz4x9Q6; Thu, 27 May
        2021 03:12:20 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        D4.DC.09604.41E0FA06; Thu, 27 May 2021 12:12:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210527031220epcas2p269503cfa517d80af350c5344cdeb24c7~Czdc5w-h12938829388epcas2p2A;
        Thu, 27 May 2021 03:12:20 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210527031220epsmtrp1e3f89235528fa6a641153d8fca15764a~Czdc5BcvD0371003710epsmtrp1X;
        Thu, 27 May 2021 03:12:20 +0000 (GMT)
X-AuditID: b6c32a45-dc9ff70000002584-d7-60af0e1492b9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.B2.08163.31E0FA06; Thu, 27 May 2021 12:12:19 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.60]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210527031219epsmtip220642a9673769acd882ab79005a57228~CzdctaIoa2760027600epsmtip29;
        Thu, 27 May 2021 03:12:19 +0000 (GMT)
From:   jongmin jeong <jjmin.jeong@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        beanhuo@micron.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jjmin.jeong@samsung.com
Subject: [PATCH 2/3] scsi: ufs: add quirk to enable host controller without
 interface configuration
Date:   Thu, 27 May 2021 12:09:00 +0900
Message-Id: <20210527030901.88403-3-jjmin.jeong@samsung.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527030901.88403-1-jjmin.jeong@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJJsWRmVeSWpSXmKPExsWy7bCmua4I3/oEgw1N8hYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4tH4Zq8WiG9uYLFZes7C4vGsOm0X39R1sFsuP/2Ny4PK43NfL5LF4z0sm
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ2N55zvGgkc8FddaFzI3MJ7k6mLk
        5JAQMJGY83AnC4gtJLCDUWLv2rAuRi4g+xOjxMoHB1kgnM+MEkveXGKE6Xh99DAbRGIXo8TX
        f7OgnI+MEr2vvzCDVLEJ6Eqc2fwSyObgEBEwkri2yhOkhlngJFDN2RdgNcICqRK/G24xgdgs
        AqoSC27sAruDV8BG4vacqUwQ2+QlTp+4xggyh1PAVmLNlUyIEkGJkzOfgJUzA5U0b53NDDJf
        QmAih8SRGVfYIHpdJNZOm8AMYQtLvDq+hR3ClpJ42d8GZddL7G7YA9U8gVGiu/MqC0TCXuLX
        9C2sIIuZBTQl1u/SBzElBJQljtyC2ssn0XH4LztEmFeio00IolFVYsvijdCwkpZYuvY41EAP
        iaOnlzBBggpo08qZt1knMCrMQvLOLCTvzEJYvICReRWjWGpBcW56arFRgSFyBG9iBKdZLdcd
        jJPfftA7xMjEwXiIUYKDWUmE92Dz2gQh3pTEyqrUovz4otKc1OJDjKbAsJ7ILCWanA9M9Hkl
        8YamRmZmBpamFqZmRhZK4rw/U+sShATSE0tSs1NTC1KLYPqYODilGphqo0wPV6Vdvp//UOD0
        sv6Hi6deK3b++T/4xcybEbmr9D8sOBZU2bLh+oS52xdFxb9Xqg7t2nhl3swrogLtSlsC/5/m
        8kthFz0WwGhpe/vvJAbh/qxj5w+7Tdt/P+LRvdKY9i4mo7y5U2b9ua/fkrFtS+6xyRoLUvLV
        b3F+fDxZ4lZ3esXppQaXXhq0LJOaVTR/0smMiUfqYpv0p0tkxnqILNjHmDxV6+wpBz+eQ4Vd
        n1inRvM7bfF6EVV74vPW44smzYpY2F6202PmU53Q0KvMGzkkrmct+D/54vGAM1FbBDvvnhdM
        2Gc4oTzRTKRoEteJyWJVfioLvARjGT/scLpsvah6Y0r8aWaRymmWb0tPKbEUZyQaajEXFScC
        AJGBS/Q8BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSvK4w3/oEgwkbrS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxaf0yVotFN7YxWay8ZmFxedccNovu6zvYLJYf/8fkwOVxua+XyWPxnpdM
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugStjeec7xoJH
        PBXXWhcyNzCe5Opi5OSQEDCReH30MFsXIxeHkMAORokdJ/YydTFyACWkJdbskYaoEZa433KE
        FaLmPaPEt9f/GEESbAK6Emc2v2QGsUWABs249Y4VxGYWuMwoMf1cNIgtLJAsMevrArAaFgFV
        iQU3drGA2LwCNhK350xlglggL3H6xDVGkL2cArYSa65kgphCQCUvlqVAVAtKnJz5hAViurxE
        89bZzBMYBWYhSc1CklrAyLSKUTK1oDg3PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4FrS0djDu
        WfVB7xAjEwfjIUYJDmYlEd6DzWsThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliS
        mp2aWpBaBJNl4uCUamC63LQ3SOZAh+Z/Bi5WyQJH/8tlOqWVuR0bPzRrSy59IlJ1bxYTu5iL
        hZrcluvb/sl917uu/W3xfYETpTfFTxy4m/R4p2/YSbecBGvXp89mqUa4rdLNz+CM3J59bvIO
        58WPE5uzq9V3pDUoWef+7t1g3avyutMg6ZCs0BbTu8zbGBYb3ma70dn3quP9w4n20WtNlRj2
        q31/l/CgVJ1nvVP9slXW9vd25UZe9K97dWz12mdBrKr/NiSk1ekfEqpMkO0++K1bRU3i/zxL
        d1/ztTdOnvnLWycQG/chyOly0bRmBuUYbmsbDck83cUzOBf8VdQs+j17x4KaLp4Wjo0NnE72
        Wzd/7MkW9TLhjPscpMRSnJFoqMVcVJwIAHGU/LX0AgAA
X-CMS-MailID: 20210527031220epcas2p269503cfa517d80af350c5344cdeb24c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210527031220epcas2p269503cfa517d80af350c5344cdeb24c7
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
        <CGME20210527031220epcas2p269503cfa517d80af350c5344cdeb24c7@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

samsung ExynosAuto SoC has two types of host controller interface to
support the virtualization of UFS Device.
One is the physical host(PH) that the same as conventaional UFSHCI,
and the other is the virtual host(VH) that support data transfer function only.

In this structure, the virtual host does not support like device management.
This patch skips the interface configuration part that cannot be performed
in the virtual host.

Change-Id: I65b56f898da9d57c627b5752535dd563e4fd3e8d
Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ec663cb58233..4787e40c6a2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7975,6 +7975,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	if (ret)
 		goto out;
 
+	if (hba->quirks & UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION)
+		goto out;
+
 	/* Debug counters initialization */
 	ufshcd_clear_dbg_ufs_stats(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4a929bf7cf8e..0ab4c296be32 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -575,6 +575,12 @@ enum ufshcd_quirks {
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
2.31.1

