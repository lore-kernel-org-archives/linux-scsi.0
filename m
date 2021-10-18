Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E655AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C746E60FD9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 12:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhJRMrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 08:47:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:18659 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhJRMr0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 08:47:26 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211018124513epoutp017d3c10b2388ca0406af6c08349c8fac5~vIKwzHRue3215032150epoutp01X
        for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2021 12:45:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211018124513epoutp017d3c10b2388ca0406af6c08349c8fac5~vIKwzHRue3215032150epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634561113;
        bh=tdeOsJeU18tI1xI0ByYe46k7jWZars9aiwNI9U4KsHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRAb0rNbeUmW3XZDQexG0QZP1VVna0L4/rN+r5EPlD7/Der0Ykdu4gAM4dzo9toEX
         U1VqgOOevsdaB26TQ1XWW1YW9gqApqQsqNyImI68iUcSvK3ripx7b632G7cqOyAdHj
         IP4xOru6VIffGdVCZXwPn5A/g9N/ZeXYOYgTbZtk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211018124510epcas2p4ccc05de779b2815f472c4577dd10f37f~vIKtoUq9M2241122411epcas2p4Y;
        Mon, 18 Oct 2021 12:45:10 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.98]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HXxRQ0MtQz4x9Q1; Mon, 18 Oct
        2021 12:45:06 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.2C.10014.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epcas2p1d58eebe57563823e4768962342477a35~vIKpMVN2b2115521155epcas2p1I;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211018124505epsmtrp110595e3ea1198db90de7ec4d6f80780d~vIKpLWZnd1588315883epsmtrp1B;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
X-AuditID: b6c32a47-489ff7000000271e-8b-616d6c510ac8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C4.50.08902.15C6D616; Mon, 18 Oct 2021 21:45:05 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211018124505epsmtip292b31d03d241897fee3ef9a900a255b6~vIKo_16CO0439304393epsmtip2H;
        Mon, 18 Oct 2021 12:45:05 +0000 (GMT)
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
        Chanho Park <chanho61.park@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v5 06/15] scsi: ufs: ufs-exynos: add setup_clocks callback
Date:   Mon, 18 Oct 2021 21:42:07 +0900
Message-Id: <20211018124216.153072-7-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf0xTVxTefa+8FrXmUbHeEWXNW+YGG9AipY8pgwxwb4oJju0PZYO9wePH
        6C/6CnHLTDA6pPxm4BQkiHXowtg6scUOYUJFGbLFBJAh3diQFgQDIiSuQNS1fbj533fO+b77
        nXPuvQJUNIkFCHLUekanppUEto7Xfi1IEbJfqaKlDZadZL+jFSP/bmzHyJnl2xjZM2HgkV8v
        LKPkoum8Dzl09XWy7Kc4cqDKiJAOUz1KGkfbEXJ0pciHvDjnQsg75us88tStnxGy9HcrRl7o
        e4KQq8s2JFZEDQ3vpeoLyzFqqKIcoS59G0yd65xBqLYWA0ZVGbsB9Y+pGKMeOsd4VIW5BVBL
        bYHU8e5SJGnDwdxd2QydwegkjDpdk5Gjzoom9ianxaXJI6WyEFkUqSAkalrFRBPxiUkhu3OU
        7uEISQGtzHenkmiWJcLe2qXT5OsZSbaG1UcTjDZDqVVoQ1laxears0LVjP5NmVQaLncTP87N
        ruhrBdoxv0N/GkbQQvB0YwnwFUA8AhotPfwSsE4gwq0A2q3dGBcsAmgZrEY9LBH+CMA7NXnP
        FM7JcyhH6gKwu8MKuOAhgAMn6hAPC8NDoHl61lvwxx8A6Jis9ZqguBOFja5yzMPahO+BzrIe
        r4KHvwLr7k4DDxbiMXBhvoXP+b0Ee1cM3j588VhYZuxFOI4f7K9z8DwYdXOOWk6jHP+eADqb
        v+BwPJx2DgAOb4Kzfea1MwPgTGWRtyGIlwL45d2na4XvADQcSeRwDFw5afYpAQK3QRA0dYR5
        IMRfhr1ja7YbYfG1x3wuLYTFRSJO+CrsvnySx+FtsLRhyYfDFHQMT63tugbAI65qfhWQ1D83
        Tf1z09T/b9wE0BYgZrSsKothw7U7/rvidI2qDXhfe/A7VnBqbiHUBhABsAEoQAl/4ScJKlok
        zKA/+5zRadJ0+UqGtQG5e9fVaMDmdI37u6j1abKIKGlEZKRMES6XKogtwqjNubQIz6L1TC7D
        aBndMx0i8A0oRKSVmfT3RvpDV5rkBPzm1+T1/IJi8w/RaNJyuOjFgYZZInG+q/+r/fOawKWE
        ie324+P3j3YW+IAz/gnFmG2JuNVTO6keD33hbA7RcWPw/OOy3o/0G1JTBw9PvZa5Pvz9y84I
        8WTzVfmxDt8OcrXQcUVYcAOEZXSNpIjf1rVmppQ+sfWEGpoC74uT48CBZnSH5ReXMjZly3Bb
        k0nxoOjYVtV7n+654jqYPbKdSQWP7Kq8P6Imborf1QT6fSBsbHxDtk9+5nZ854TzIi/ux7yp
        ZsvNcf74anCr/fpvteXqUeHOw3OOmqL+2a7Kv+zxiwfSYw5duATsfmxQ5L2G3dtOT23NJ3hs
        Ni0LRnUs/S9iNLKldgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWy7bCSvG5gTm6iwbUX0hYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLS7v17bo2elscXrCIiaLJ+tnMVssurGNyeLGrzZWi41v
        fzBZ3NxylMVixvl9TBbd13ewWSw//o/J4vfPQ0wOQh6Xr3h7zGroZfO43NfL5LF5hZbH4j0v
        mTw2repk85iw6ACjx/f1HWweH5/eYvHo27KK0ePzJjmP9gPdTAE8UVw2Kak5mWWpRfp2CVwZ
        fcfXMBbcEqy423mNuYHxP18XIyeHhICJxNPHi5m7GLk4hAR2M0q0H/jFDpGQlXj2bgeULSxx
        v+UIK0TRe0aJztMvWUESbAK6Eluev2IEsUUEPjJKzPmmBVLELPCRWeLOyiUsIAlhAS+Jpz0H
        mUBsFgFViZmPnoM18ArYS3x4twpqg7zEkV+dzCA2p4CDRM+iI2D1QkA1i1/OZoaoF5Q4OfMJ
        2ExmoPrmrbOZJzAKzEKSmoUktYCRaRWjZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnAU
        amnuYNy+6oPeIUYmDsZDjBIczEoivEmuuYlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwX
        EkhPLEnNTk0tSC2CyTJxcEo1MCW7sNcdC8s1cZB9q3jPeJ5BYbT9xYtrzSM1zSVtYmIVvzRp
        rA3qi3FKtrv/7cpp8xeq0qvLft98L27xJU9oSqlZ8geOE/O5Z/57PqHlq9Klg6cVT0wtFdk3
        38Xn4+cVV16uPL9IyThsruv5LNe0r9+/Z/tIFJv/ef+3fMHVDZqcroZzXN/M0zq5/YLF2q8u
        VzumhrlIOD74lrjEcNH/J6cud8U27g6+x9Y9O/b0L6afMz//PXNr2UoxsaaGRrXwiqJqdc15
        dxqeH35ce1Hw08QShieGHjcXPuqa2lLo1W0X8y3F2GO11jrRl/8/+ac3Sez8aMZ/XmT73Ou1
        m3IXuWz74r04pp594sLa1RK+xUxKLMUZiYZazEXFiQCP89wIMQMAAA==
X-CMS-MailID: 20211018124505epcas2p1d58eebe57563823e4768962342477a35
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211018124505epcas2p1d58eebe57563823e4768962342477a35
References: <20211018124216.153072-1-chanho61.park@samsung.com>
        <CGME20211018124505epcas2p1d58eebe57563823e4768962342477a35@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds setup_clocks callback to control/gate clocks by ufshcd.
To avoid calling before initialization, it needs to check whether ufs is
null or not and call it initially from pre_link callback.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index e75736ce1534..226e7e64fad4 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -794,6 +794,27 @@ static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 errs, u8 index)
 	}
 }
 
+static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
+				   enum ufs_notify_change_status status)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+
+	if (!ufs)
+		return 0;
+
+	if (on && status == PRE_CHANGE) {
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_disable_auto_ctrl_hcc(ufs);
+		exynos_ufs_ungate_clks(ufs);
+	} else if (!on && status == POST_CHANGE) {
+		exynos_ufs_gate_clks(ufs);
+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
+	}
+
+	return 0;
+}
+
 static int exynos_ufs_pre_link(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
@@ -812,6 +833,8 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_phy_time_attr(ufs);
 	exynos_ufs_config_phy_cap_attr(ufs);
 
+	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
+
 	if (ufs->drv_data->pre_link)
 		ufs->drv_data->pre_link(ufs);
 
@@ -1202,6 +1225,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hce_enable_notify		= exynos_ufs_hce_enable_notify,
 	.link_startup_notify		= exynos_ufs_link_startup_notify,
 	.pwr_change_notify		= exynos_ufs_pwr_change_notify,
+	.setup_clocks			= exynos_ufs_setup_clocks,
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
-- 
2.33.0

