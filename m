Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29D1C433FB
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F65D2071A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 07:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dQw2OTm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgGQHgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:36:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59869 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgGQHgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 03:36:40 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200717073637epoutp03c6fc040aef4cc356748a38b5e81cf198~iegj5dBYF0102401024epoutp03R
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2020 07:36:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200717073637epoutp03c6fc040aef4cc356748a38b5e81cf198~iegj5dBYF0102401024epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594971397;
        bh=ADCQzzRrH1eoxmBwkQf8ZO9BTJc9L3rKrcuYmE8vF2A=;
        h=From:To:Subject:Date:References:From;
        b=dQw2OTm3o0xMz1Wd3+vXzrTqQLaTUvdgr60y7E/c/QRNzFE3DvcEhxVlIT1WmL8Cy
         i3q7QfDoT6aOuHLs8cixwGXaZWwLbnMo1zzq62JfFLKPkKEhl89dXRkqOJtU26pZcv
         7e/zTa/ZiqlrLDH+YI4Qw4TlEu78GIVlXYkwp71I=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200717073636epcas2p3c28b4ecaf66b991a48aedd44b5c85d55~iegjOe7dh1034010340epcas2p34;
        Fri, 17 Jul 2020 07:36:36 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B7NGp6GLPzMqYkj; Fri, 17 Jul
        2020 07:36:34 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        40.FF.27441.105511F5; Fri, 17 Jul 2020 16:36:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200717073633epcas2p21b8f5b5c64626b8ea299930193c6ad56~ieggsk1Gt2840328403epcas2p2q;
        Fri, 17 Jul 2020 07:36:33 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200717073633epsmtrp147dbb84fab6f8a9c042408465123e90d~ieggrycss0130901309epsmtrp1i;
        Fri, 17 Jul 2020 07:36:33 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-a0-5f11550189bf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F2.8D.08303.105511F5; Fri, 17 Jul 2020 16:36:33 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200717073633epsmtip13df85f5434dea714aef347b3ebfa14d6~ieggZzeTh3260332603epsmtip1F;
        Fri, 17 Jul 2020 07:36:33 +0000 (GMT)
From:   Lee Sang Hyun <sh425.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, kwmad.kim@samsung.com
Subject: [PATCH] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba() failed
Date:   Fri, 17 Jul 2020 16:28:16 +0900
Message-Id: <1594970896-36170-1-git-send-email-sh425.lee@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmmS5jqGC8QUeHmcWDedvYLPa2nWC3
        ePnzKpvFwYedLBbTPvxktvi0fhmrxa+/69ktVi9+wGKx6MY2JoubW46yWHRf38Fmsfz4PyaL
        rrs3GC2W/nvL4sDncfmKt8flvl4mjwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMAR
        lWOTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S3kkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIh
        J+Pj7jOsBes5Kv7cnc/UwNjC3sXIySEhYCJxfdNGxi5GLg4hgR2MEhPOnGWGcD4xSkzquccC
        4XxmlLj/ZAEjTMvuk6+YIBK7GCV2zJoC1fKDUWL5iXNsIFVsAtoSd6/NYgdJiAicYpJ49/In
        WLuwgJfE3r9/gOZycLAIqEqcvy0FEuYVcJWY0vAHaoOcxM1znWBDJQTesktsebuMBSLhInF2
        egcbhC0s8er4FqgvpCRe9rdB2eUSu/uuskE0tzBKvF+7iRkiYSwx61k7I8hiZgFNifW79EFM
        CQFliSO3wMYzC/BJdBz+yw4R5pXoaBOCaFSWOPNuLdR0SYmHrZuYIGwPiXstW8FahQRiJWb0
        LGaawCgzC2H+AkbGVYxiqQXFuempxUYFxsgxs4kRnAC13Hcwznj7Qe8QIxMH4yFGCQ5mJRHe
        +S8F4oV4UxIrq1KL8uOLSnNSiw8xmgKDayKzlGhyPjAF55XEG5oamZkZWJpamJoZWSiJ8xZb
        XYgTEkhPLEnNTk0tSC2C6WPi4JRqYHK4ZN3+5mcum9i8VbtdnUOuXGI9+nmR6dyQUMmERZ2m
        M/5nSr51ythyoCKn4JGCWhiDoPqBO5drCgW+/Q1SXjk7Y5H5tKkHmi+eFp7/6azx2SPlr2N0
        v5g8XRSmeGyKsMPVq+ZtMppbRMS7k1NKQ9en82XtfSXFMGF2rljK07zv/KvLP3yrYX57rul5
        d2M1W4uAjkTo9zVuPSJqLerrPfasaT9+3+D2ioyZho+EnIOZBYSOVL99fq7mhF1oWZ3Aqil8
        Eze5vn/PmpfMfvykR+A16+jp3zSP3n271k9+804JF+XM1SzPP+j6XZiq3+77pSD5U2jT/3nJ
        XpskpHZ2b/+a8eDqhIWdFcs1ROfEHVRiKc5INNRiLipOBADhCNUCCQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSnC5jqGC8QdMySYsH87axWextO8Fu
        8fLnVTaLgw87WSymffjJbPFp/TJWi19/17NbrF78gMVi0Y1tTBY3txxlsei+voPNYvnxf0wW
        XXdvMFos/feWxYHP4/IVb4/Lfb1MHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAj
        issmJTUnsyy1SN8ugSvj4+4zrAXrOSr+3J3P1MDYwt7FyMkhIWAisfvkK6YuRi4OIYEdjBJn
        F21jhkhISky81MQIYQtL3G85wgpR9I1RYs6COywgCTYBbYm712axgyREBO4wSbzs7AfrFhbw
        ktj79w9QEQcHi4CqxPnbUiBhXgFXiSkNf6CGykncPNfJPIGRewEjwypGydSC4tz03GLDAqO8
        1HK94sTc4tK8dL3k/NxNjOCA1NLawbhn1Qe9Q4xMHIyHGCU4mJVEeOe/FIgX4k1JrKxKLcqP
        LyrNSS0+xCjNwaIkzvt11sI4IYH0xJLU7NTUgtQimCwTB6dUA5M7f0ilzqFCuaoY4dMqzOdf
        P5/LHSPtP5Uju7/Yo/zb8f//4vXPRf65q/qS/2fsxqcpc65332Y+w9bPKBtbs/zfg7tbOR7H
        XKiZVHH5yPeSyBlx/XPLO7zifR42/rCxZopf8ivn9A02l0cOix0Zb15Q2HFs5qvMyVMqL1vH
        O7u+O7xru5zGSevlQWY911tm1/OpLJpjr+ve+zF1dW3T0+K3dT7LPzgsifL5FDJZkmVNUdlV
        n4jnq3r0pe2fqykfXDVrmu1/7xbV/yqh92don2jK7g5RusXa8en983Tfa/WPTku4vuzyknNu
        rl7798md+M0aOn0bLwU07X2w79Q2/hm9XDzrZPf0TJVm/8qlfkeJpTgj0VCLuag4EQA6I5XB
        twIAAA==
X-CMS-MailID: 20200717073633epcas2p21b8f5b5c64626b8ea299930193c6ad56
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200717073633epcas2p21b8f5b5c64626b8ea299930193c6ad56
References: <CGME20200717073633epcas2p21b8f5b5c64626b8ea299930193c6ad56@epcas2p2.samsung.com>
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

