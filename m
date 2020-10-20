Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DC2C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 08:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20C832237B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 08:44:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Rx9IunAt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389322AbgJTIoh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 04:44:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45681 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389155AbgJTIog (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 04:44:36 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201020084433epoutp04fd4262eaead847b5cfcb46548e193f3f~-puAUSMIH2227622276epoutp04N
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 08:44:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201020084433epoutp04fd4262eaead847b5cfcb46548e193f3f~-puAUSMIH2227622276epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603183473;
        bh=lz40hHps79hqNfcnD+cI3oHpIVLgeD6CDqiBeBo/A8M=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Rx9IunAtzDT5HkmNrd/VFhVR2TmUebfgTkm9CWSCahfAyVwMIKK4qU7muocS/YtcL
         TfzHkSYzFDAmMeDIarR8ia1YN7j9duMXHfWMV4pf88L7nnKccKH0vxAk2tI45iMDSZ
         WPgYuiDYYuhD2js0nkA+x834dvRnJwUVqDzlx1XU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201020084433epcas2p4cbaa3d6b62ac518b6dc2907314aeeacf~-pt-8mS9-2009820098epcas2p4c;
        Tue, 20 Oct 2020 08:44:33 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4CFnHM1KdnzMqYks; Tue, 20 Oct
        2020 08:44:31 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.C4.09908.E63AE8F5; Tue, 20 Oct 2020 17:44:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201020084429epcas2p3685bcb89c3ab1cacefb183384dcb2b6e~-pt8N9Klx1163711637epcas2p3V;
        Tue, 20 Oct 2020 08:44:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201020084429epsmtrp26e7e060944491e80b04cf5bed8c37873~-pt8NQfXL3034530345epsmtrp22;
        Tue, 20 Oct 2020 08:44:29 +0000 (GMT)
X-AuditID: b6c32a48-139ff700000026b4-60-5f8ea36e030a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.8B.08604.D63AE8F5; Tue, 20 Oct 2020 17:44:29 +0900 (KST)
Received: from localhost.localdomain (unknown [10.229.9.51]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201020084429epsmtip163ac5d1c869d0dcc3ece584d2081c6aa~-pt8CZHLb0582605826epsmtip1V;
        Tue, 20 Oct 2020 08:44:29 +0000 (GMT)
From:   Chanho Park <chanho61.park@samsung.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>
Subject: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Date:   Tue, 20 Oct 2020 17:44:22 +0900
Message-Id: <20201020084422.109585-1-chanho61.park@samsung.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmhW7e4r54g113NS0ezNvGZvHy51U2
        i8v7tS0W3djGZHF51xw2i+7rO9gslh//x+TA7jFh0QFGj49Pb7F49G1ZxejxeZOcR/uBbqYA
        1qgcm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
        yhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BYaGBXrFibnFpXnpesn5uVaGBgZGpkCV
        CTkZH958YS+4LFgx8esdxgbGvXxdjJwcEgImEm//fGPvYuTiEBLYwSix/tIfJgjnE6PEp389
        TCBVQgLfGCUm3NCC6Tj37gcLRNFeRomXk5ZCOR8ZJX5P2scOUsUmoCux5fkrxi5GDg4RASOJ
        a6s8QWqYBaYzShxc+ZENpEZYwE1i5/5zrCA1LAKqEhO6lUHCvAL2EqvP72SBWCYv8bR3OTNE
        XFDi5MwnYHFmoHjz1tnMEDWn2CV+LAqFsF0kvkyBOEFCQFji1fEtULaUxOd3e9kg7HqJFY+a
        mEHukRDoAXpg2j+oQfYSM58uZQK5h1lAU2L9Ln0QU0JAWeLILai1fBIdh/+yQ4R5JTrahCAa
        1SUObJ8OdbGsRPecz6wQtofE3XfHWSFBGCvx4Px81gmM8rOQPDMLyTOzEPYuYGRexSiWWlCc
        m55abFRgghylmxjB6VDLYwfj7Lcf9A4xMnEwHmKU4GBWEuGdwNoXL8SbklhZlVqUH19UmpNa
        fIjRFBi6E5mlRJPzgQk5ryTe0NTIzMzA0tTC1MzIQkmcV0WvI15IID2xJDU7NbUgtQimj4mD
        U6qBKXl+Z+cn1aytrMtsXPXeKxj/+fbjXfN5qSm3popYdfNesN/3Kr5XOWaJfNo/fdckdgHP
        g+8nynxIt1aN/fWU2e1jjMYZ8//f52abzV9/7hM/R8L16t8bur3YM2v+J/9ayfQw7sbtZBl9
        7nsf7vbxm65dyTj9YMtrK3ethScvrTXbvFHos3zizQ9d2udEJQuDJTd8vRXtcvTbw5bD9Xo1
        qWuefGJgeXN62lERvxP212Km3zp1vPvfvHt7PlnUFe16l6Lp0cW88FDXSrcHRYdVHgprpV1L
        yNaeskZSyIaj6o1wyf2c/wcfLXx2d/f9FbWxQuE5WbPrBCrM1NZsUfGwZS9VXByy3vzbNZnY
        9rbtwUosxRmJhlrMRcWJABtuQNkQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWy7bCSnG7u4r54gyeNvBYP5m1js3j58yqb
        xeX92haLbmxjsri8aw6bRff1HWwWy4//Y3Jg95iw6ACjx8ent1g8+rasYvT4vEnOo/1AN1MA
        axSXTUpqTmZZapG+XQJXxoc3X9gLLgtWTPx6h7GBcS9fFyMnh4SAicS5dz9Yuhi5OIQEdjNK
        HHlzmR0iISvx7N0OKFtY4n7LEVaIoveMEq/W3QRLsAnoSmx5/ooRxBYBmjTj1juwImaB2YwS
        e44vBksIC7hJ7Nx/DijBwcEioCoxoVsZJMwrYC+x+vxOFogF8hJPe5czQ8QFJU7OfAIWZwaK
        N2+dzTyBkW8WktQsJKkFjEyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCg1RLcwfj
        9lUf9A4xMnEwHmKU4GBWEuGdwNoXL8SbklhZlVqUH19UmpNafIhRmoNFSZz3RuHCOCGB9MSS
        1OzU1ILUIpgsEwenVANT0z99o2VK6rtSl+Uff66o9OvW8+Rp2c4XSpy4jZ0ZfvP6WV5Q+SMn
        sXhbCsPMIx+fn6oyU/njLnY7r1Yras2XdN6sqzJ9+Vd7Z9R+3fgq12156RXOWE0BzxL+0N5V
        E/XFWI+f/TkpJvnDYUWx49Fm0+YysuvaBP2sjdn7y+rni7cH+gS/8DzNYX0Ry+/xVTQx5e+U
        mCtvWrim1F8QU0qenR1XITxfrGOxXpHj+poTfE/f8oRKztl7YV25yhIZ1g0RV7/VFUrMder3
        y+d2uvqn6OqR+IvzGZk/Xss1n6L31+XyOh3nzekZ8VbHAp8df2vhmMIivYgtIujVJu5LjS9l
        eBhmTNx/rE/4kt6dzBlKLMUZiYZazEXFiQDaXxrZwQIAAA==
X-CMS-MailID: 20201020084429epcas2p3685bcb89c3ab1cacefb183384dcb2b6e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201020084429epcas2p3685bcb89c3ab1cacefb183384dcb2b6e
References: <CGME20201020084429epcas2p3685bcb89c3ab1cacefb183384dcb2b6e@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By doing scan as asynchronous way, scsi device scannning can be out of
order execution. It is no problem if there is a ufs host but the scsi
device name of each host can be changed according to the scan sequences.

Ideal Case) host0 scan first
host0 will be started from /dev/sda
 -> /dev/sdb (BootLUN0 of host0)
 -> /dev/sdc (BootLUN1 of host1)
host1 will be started from /dev/sdd

This might be an ideal case and we can easily find the host device by
this mappinng.

However, Abnormal Case) host1 scan first,
host1 will be started from /dev/sda and host0 will be followed later.

To make sure the scan sequences according to the host, we can use a
bitmap which hosts are scanned and wait until previous hosts are
finished to scan.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..1ced5996e988 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -13,6 +13,7 @@
 #include <linux/devfreq.h>
 #include <linux/nls.h>
 #include <linux/of.h>
+#include <linux/bitmap.h>
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
@@ -214,6 +215,10 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	END_FIX
 };
 
+/* Ordered scan host */
+static unsigned long scanned_hosts = 0;
+static wait_queue_head_t scan_wq = __WAIT_QUEUE_HEAD_INITIALIZER(scan_wq);
+
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -7709,8 +7714,13 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
-	/* Probe and add UFS logical units  */
+	/* Probe and add UFS logical units. Sequential scan by host_no */
+	wait_event(scan_wq,
+		   find_first_zero_bit(&scanned_hosts, hba->host->max_id) ==
+		   hba->host->host_no);
 	ret = ufshcd_add_lus(hba);
+	set_bit(hba->host->host_no, &scanned_hosts);
+	wake_up(&scan_wq);
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
-- 
2.28.0

