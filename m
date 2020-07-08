Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EF1C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 01:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7228720738
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 01:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YV97hX6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgGHBwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 21:52:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32714 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728740AbgGHBwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 21:52:49 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200708015247epoutp044dc9ca29c2aaa87adb13b3d665f0e44c~fpAynkfpu2381423814epoutp04V
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 01:52:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200708015247epoutp044dc9ca29c2aaa87adb13b3d665f0e44c~fpAynkfpu2381423814epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594173167;
        bh=EI4Qg+hIMErHH7UVfAGd/knk+BDJIvFZtN+jXmZCsTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=YV97hX6mboz+0M2ls2zmB/IIl/bjLgQxX2SsS/f2ezQn+/8vpzMziQd8woBQgIIe0
         lejoraCVHJkAh0xDvB3RDQ4H/9fqHOcLBaJP20CMl0vrwKohPmWvX68zg2Bj64dHdZ
         mdetW5aV7y/QIiSac7RP2JeTJCxXrXZDR0zlNWss=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200708015246epcas2p1097cc50eaeceeedb83437ad93fde03c4~fpAx7it6E0095000950epcas2p1M;
        Wed,  8 Jul 2020 01:52:46 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B1j4D1zm8zMqYky; Wed,  8 Jul
        2020 01:52:44 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.36.19322.BE6250F5; Wed,  8 Jul 2020 10:52:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200708015243epcas2p1f32f0f160c9846b1663d8d0639d70b88~fpAvB0Iln0095000950epcas2p1C;
        Wed,  8 Jul 2020 01:52:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200708015243epsmtrp113ea1acc49a40e970a8ddafc79ad7a5b~fpAvA7HNm2336223362epsmtrp1-;
        Wed,  8 Jul 2020 01:52:43 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-6e-5f0526ebf3df
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.6D.08303.BE6250F5; Wed,  8 Jul 2020 10:52:43 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200708015243epsmtip10a83f87aba2098bf73ea84ccd06669ba~fpAuxvKBz2573425734epsmtip1o;
        Wed,  8 Jul 2020 01:52:43 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v4 1/3] ufs: introduce a callback to get info of command
 completion
Date:   Wed,  8 Jul 2020 10:44:46 +0900
Message-Id: <411c10be23c6bb4bef0e4cf3a76a963bc653bdeb.1594097045.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594097045.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594097045.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmue5rNdZ4g4mzTC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORl/b75mLzglVDF73wHWBsYl/F2MnBwSAiYSGzb8Z+ti5OIQEtjBKHG3/yqU84lR4t6dXcwg
        VUICnxklGnrluhg5wDq+tLNC1OxilFj1fzkbRM0PRolHh/VBbDYBTYmnN6cygRSJCGxmkni1
        4D7YIGYBdYldE04wgdjCApESXXOuMoLYLAKqEh3POsEG8QpES3RNX8wIcZ6cxM1znWC9nAKW
        Es9vTmJDZXMB1UzlkJg29zg7RIOLxK+lM6FsYYlXx7dA2VISL/vboOx6iX1TG1ghmnsYJZ7u
        +we1zVhi1rN2RpA3mYFeWL9LH+JjZYkjt1gg7ueT6Dj8lx0izCvR0SYE0ags8WvSZKghkhIz
        b96B2uQhsfz7ZiZIYAFtWtWziHECo/wshAULGBlXMYqlFhTnpqcWGxUYIkfeJkZwGtVy3cE4
        +e0HvUOMTByMhxglOJiVRHgNFFnjhXhTEiurUovy44tKc1KLDzGaAgNyIrOUaHI+MJHnlcQb
        mhqZmRlYmlqYmhlZKInz5ipeiBMSSE8sSc1OTS1ILYLpY+LglGpgOqTB0ma6+GzWYqYTPeX9
        DMd9PDQXu8Stfrn4q1+ymaF+lkipttHCnLmcv9u3Lvx0Y2XEuvIXfv4rqz5Zr93jvtiAh7/+
        wru3wUd2/W0vO28d84wt/Ej3xBjdUs3863XvnaNzztyZO6fjznWFnobcDdutChrvhrlksqtE
        6u2rWbuy++6pPb53Zv5h6+OZxxwddsjvWHRc0M7o6sZT0xSn6GnIvt3CX3QvM+w++3q1tZZH
        lj2adYJ7S+eHydKfdVW5Z3wqfhE/SbfE8ajwitffSnenfC+zZHCo9601sU1dULszb+qp11UH
        mTe73Mi602v2VdTsYInElL6ssOXGIm9lbFxUP8eLNttI7XghfstViaU4I9FQi7moOBEAhajT
        xiwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnO5rNdZ4g2tTxCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6MvzdfsxecEqqYve8AawPjEv4uRg4OCQETiS/trF2MXBxCAjsYJTrX
        PWDuYuQEiktKnNj5nBHCFpa433IEqugbo0T7kTdgRWwCmhJPb05lAkmICBxmkvi/9Tk7SIJZ
        QF1i14QTTCC2sEC4xJslJ8AmsQioSnQ862QDsXkFoiW6pi+G2iAncfNcJ9hQTgFLiec3J4HV
        CAlYSDxf8IIJl/gERoEFjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCI0FLawfj
        nlUf9A4xMnEwHmKU4GBWEuE1UGSNF+JNSaysSi3Kjy8qzUktPsQozcGiJM77ddbCOCGB9MSS
        1OzU1ILUIpgsEwenVAOTuOObH3NFX316Fdyj8bnjJd/5DQe1knbvmq8t9/zuEaMKE6t50b1C
        Iaqb35rdEZ2zo/Qx907HWVOlpPZbtb9926VQPCPD+X96ose0g3UbZ1hP/Bmc9tPxs8O07dtT
        Q10dQ7V/BC3cMS+Q8cEW60X6QdwxmTEvC0L8TkjeTmjfGRkQ8e8vxynnt9Z3Oy4Hrihd1LKk
        +/PB9EdVfwpn8E8I5nHoXGMeq92oVLY0+Dvnjvj/y3MLTswx81UXCSjYsurofZu5Fr9fKpp8
        KZcXrdBXv/uDYUep4vRnq90/6kSzVwut5WFzK6zfsNF9Vd4ig485BVse/nDRjsia8cZ7/YSL
        2uaec4WSWCuEmK8/bi1XYinOSDTUYi4qTgQAujkxbvMCAAA=
X-CMS-MailID: 20200708015243epcas2p1f32f0f160c9846b1663d8d0639d70b88
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708015243epcas2p1f32f0f160c9846b1663d8d0639d70b88
References: <cover.1594097045.git.kwmad.kim@samsung.com>
        <CGME20200708015243epcas2p1f32f0f160c9846b1663d8d0639d70b88@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some SoC specific might need command history for
various reasons, such as stacking command contexts
in system memory to check for debugging in the future
or scaling some DVFS knobs to boost IO throughput.

What you would do with the information could be
variant per SoC vendor.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52abe82..3326236 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4882,6 +4882,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		cmd = lrbp->cmd;
+		ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true : false);
 		if (cmd) {
 			ufshcd_add_command_trace(hba, index, "complete");
 			result = ufshcd_transfer_rsp_status(hba, lrbp);
@@ -4890,6 +4891,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			lrbp->compl_time_stamp = ktime_get();
+
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c774012..e5353d6 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -294,6 +294,7 @@ struct ufs_hba_variant_ops {
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
+	void	(*compl_xfer_req)(struct ufs_hba *hba, int tag, bool is_scsi);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1070,6 +1071,13 @@ static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
 		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
 }
 
+static inline void ufshcd_vops_compl_xfer_req(struct ufs_hba *hba,
+					      int tag, bool is_scsi)
+{
+	if (hba->vops && hba->vops->compl_xfer_req)
+		hba->vops->compl_xfer_req(hba, tag, is_scsi);
+}
+
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
-- 
2.7.4

