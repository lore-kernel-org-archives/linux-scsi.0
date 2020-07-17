Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6735AC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF2D2071A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tgoRc7kK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGQHj5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:39:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48818 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgGQHj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 03:39:56 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200717073953epoutp027d3dc5f0de77b605b9321bcb1e6b116b~iejadLK_H2589525895epoutp02K
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2020 07:39:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200717073953epoutp027d3dc5f0de77b605b9321bcb1e6b116b~iejadLK_H2589525895epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594971593;
        bh=ADCQzzRrH1eoxmBwkQf8ZO9BTJc9L3rKrcuYmE8vF2A=;
        h=From:To:Subject:Date:References:From;
        b=tgoRc7kKcvpVhy4tDl4J03rlLDDRRVfYOFEw0gnmPqn6Q/yW09FDsqNUm4zagBI5v
         mD6kzYi9WMO0cD8RQ1+r9NBvXNJSz56fMC5HoWmir5cfVaNPoqmicShsvAz8ck3LuT
         0PcAC/1UNSc0Ls+NlxE3bEL8zs6qFCExb++r4zJU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200717073952epcas2p2b9b45169bd6f0e4fbc3e9df4b182df23~iejZyhlCX3140231402epcas2p2N;
        Fri, 17 Jul 2020 07:39:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B7NLZ4l7MzMqYlt; Fri, 17 Jul
        2020 07:39:50 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.EC.18874.6C5511F5; Fri, 17 Jul 2020 16:39:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c~iejXzZLHH3210832108epcas2p3M;
        Fri, 17 Jul 2020 07:39:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200717073950epsmtrp2577f884be932936e145915ada6c785a7~iejXyhz771245312453epsmtrp2C;
        Fri, 17 Jul 2020 07:39:50 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-b8-5f1155c6e34b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.ED.08303.6C5511F5; Fri, 17 Jul 2020 16:39:50 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200717073949epsmtip1a30837836fce518b9cf9906820e974be~iejXkI8wR0128701287epsmtip1u;
        Fri, 17 Jul 2020 07:39:49 +0000 (GMT)
From:   Lee Sang Hyun <sh425.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, kwmad.kim@samsung.com
Subject: [RFC PATCH v2] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba()
 failed
Date:   Fri, 17 Jul 2020 16:31:47 +0900
Message-Id: <1594971107-37463-1-git-send-email-sh425.lee@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmqe6xUMF4g7X7VSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORkfd59hLVjPUfHn7nymBsYW9i5GTg4JAROJH83vmbsYuTiEBHYwSvQ0XWKCcD4xSlzbvpoN
        wvnMKPHtWjsbTEv/hLnsEIldjBIvX3xhgXB+MErsOXmPGaSKTUBb4u61WWBVIgKnmCTevfzJ
        CJIQFgiWuHK5AayIRUBV4vmOw2BjeQVcJfobL7JCrJCTuHmuE+wqCYG37BLLH7+CSrhIvJ31
        G+oOYYlXx7dAvSEl8fndXqh4ucTuvqtsEM0tjBLv125ihkgYS8x61g50BQcHs4CmxPpd+iCm
        hICyxJFbLCAVzAJ8Eh2H/7JDhHklOtqEIBqVJc68Wwu1SVLiYesmJogSD4nznaYgYSGBWIlH
        U06zTGCUmYUwfgEj4ypGsdSC4tz01GKjAiPkmNnECE6AWm47GKe8/aB3iJGJg/EQowQHs5II
        7/yXAvFCvCmJlVWpRfnxRaU5qcWHGE2BwTWRWUo0OR+YgvNK4g1NjczMDCxNLUzNjCyUxHnr
        FS/ECQmkJ5akZqemFqQWwfQxcXBKNTAVH68JD2gOKrv4LVbr+QrRJeoC53bNO3+AJ4xjw7yK
        BVPWqTH+vzV7q1lY2t6oZoFpt0J8muYd+aR58P1ad3uRU4ueTmjkPcHNfi1e9rPJtsuB7YuN
        Uhis4k96q8w8bX3U6r2IVGHmLkGtHWGPunW4FmW/evX6zZnFj+7P0qgxaHp1snQKW+qessAk
        3dglHDrmGtw/7H6U/42PXrT1hO2R+ya/I2d7PDTrOpWco2/4wepBzLw2ybsRzp+maS5acE8x
        Rnrt5f82M/sePtDimn76QNeePdkrC45cYY7Wu7uoOvW+TodotVD9RfauqgUT5Z+u/G39gDmi
        U83QPaKrY+6DpiYR/eQIwUPt+Z1S058osRRnJBpqMRcVJwIA+Pv3OwkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSnO6xUMF4gytnWCwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVnc3HKUxaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        KC6blNSczLLUIn27BK6Mj7vPsBas56j4c3c+UwNjC3sXIyeHhICJRP+EuWC2kMAORomFrzQg
        4pISEy81MULYwhL3W46wdjFyAdV8Y5Q4tOInC0iCTUBb4u61WewgCRGBO0wSLzv7mUESwgKB
        EpNP7GUCsVkEVCWe7zjMBmLzCrhK9DdeZIWYKidx81wn8wRG7gWMDKsYJVMLinPTc4sNC4zy
        Usv1ihNzi0vz0vWS83M3MYIDUktrB+OeVR/0DjEycTAeYpTgYFYS4Z3/UiBeiDclsbIqtSg/
        vqg0J7X4EKM0B4uSOO/XWQvjhATSE0tSs1NTC1KLYLJMHJxSDUzsc/5k5Xc9+rE119pq5sZp
        m/ZFzjSfY6CtzKzzoGqnxFWGY7WhxufPXGX6MCF6xYSoV/4sXaFX+ycekhJ7afrS6E9Da9u2
        L46/V/boJayI8HqwQ+vYzVcKlvdmMEp86jy4/EjU/X9mwusEAjUPbfx79W4671L2hbuU91e0
        u82K+R28PrrfqvrWtrK7p4uEFvAo7D4x8YX5+QKDU46xffxXrz78vog/UP1b1aHNiR/ldiT8
        /dgq+mixzfLQSC3HhmNLLFNWN7YKfFgqd+p5uKCNGltq8CNhnzff2c9KPXmTrOtfP2uzvhDz
        AmXDdXc1N0qGxolqsPDxTv7EfsVz5uytix7xTJ08xe5cyr2Vf/89UGIpzkg01GIuKk4EAPJN
        pMi3AgAA
X-CMS-MailID: 20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c
References: <CGME20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

set STATE_ERR like below to prevent a lockup(IO stuck)
when ufshcd_probe_hba() returns error.

Change-Id: I6c85ff290503cc9414d7f5fdd934295497b854ff
Signed-off-by: Lee Sang Hyun <sh425.lee@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ad4fc82..37e4105 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7368,6 +7368,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 {
 	int ret;
 	ktime_t start = ktime_get();
+	unsigned long flags;
 
 	ret = ufshcd_link_startup(hba);
 	if (ret)
@@ -7439,6 +7440,11 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	ufshcd_auto_hibern8_enable(hba);
 
 out:
+	if (ret) {
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-- 
2.7.4

