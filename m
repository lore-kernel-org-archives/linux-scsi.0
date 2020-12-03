Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7546C71156
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 561B52086A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgLCFir (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 00:38:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16664 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgLCFir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 00:38:47 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201203053819epoutp0110f5dfb893a88ed0e094ccf9ac3dfee9~NHj9ZUaG90849908499epoutp01i
        for <linux-scsi@vger.kernel.org>; Thu,  3 Dec 2020 05:38:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201203053819epoutp0110f5dfb893a88ed0e094ccf9ac3dfee9~NHj9ZUaG90849908499epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606973899;
        bh=4jHWrpokghYMgMz6L5AJmcV9eOz8vrld1J3+tnwGXaQ=;
        h=From:To:Subject:Date:References:From;
        b=ryv/sA+zk5hYG+fkUgTfJMURcR7GovMwAJKGRjDLcU+vSeFnZr8esc+BPrPWoPxIe
         OFx6j+23VHu6PefMfOS/gw8zDFFbKea2cWPkoPuCS3PN52KRlM1CTSQTwaIKFMaQ9D
         2OzUL2vUUEH7QBzN2tGWq0UcRw5mKzQtpZyEpZvw=
Received: from epsmges1p1.samsung.com (unknown [182.195.42.53]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201203053819epcas1p38ff6db6abc3ab5bce9fce8f1d9b3dfbc~NHj8_eaLy2374623746epcas1p3h;
        Thu,  3 Dec 2020 05:38:19 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.67.02418.AC978CF5; Thu,  3 Dec 2020 14:38:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d~NHj8qiJFm0736507365epcas1p2A;
        Thu,  3 Dec 2020 05:38:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201203053818epsmtrp1f58f1ffac9a13b6eb8409fe936ac67d7~NHj8qAoH20244902449epsmtrp1M;
        Thu,  3 Dec 2020 05:38:18 +0000 (GMT)
X-AuditID: b6c32a35-c0dff70000010972-db-5fc879caa481
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7C.1B.08745.AC978CF5; Thu,  3 Dec 2020 14:38:18 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.68]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201203053818epsmtip10f22134837e3406d1052d92b81dfa2b0~NHj8dzZFB1208412084epsmtip1Y;
        Thu,  3 Dec 2020 05:38:18 +0000 (GMT)
From:   Jintae Jang <jt77.jang@samsung>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jt77.jang@samsung.com
Subject: [PATCH] scsi: ufs: Adjust ufshcd_hold() during sending attribute
 requests
Date:   Thu,  3 Dec 2020 14:25:32 +0900
Message-Id: <1606973132-5937-1-git-send-email-user@jang-Samsung-DeskTop-System>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42LZdlhTX/dU5Yl4g0NvrC12PD/DbtF9fQeb
        xfLj/5gcmD0+Pr3F4tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZqw7cYSo4wFsxc6FhA+Mn
        ri5GTg4JAROJOc1drF2MXBxCAjsYJZ4umMAI4XxilDjz4iYbhPOZUWJz835GmJa1k7dDJXYx
        SizZ3sMKV7Vg3iMmkCo2AVWJnVcPsoHYIgLBEgumbQWzhQVCJL7c+cwOYrMA1Xz9eIoZxOYV
        8JdYeXQD1AY5iZPHJoMNlRD4ziZx/8NJdoiEi8S2ZRdYIWxhiVfHt0DFpSRe9rcB2RwczAKa
        Eut36UOEFSV2/p4LNpNZgE/i3VeQQzmA4rwSHW1CECXKEv9/HGOGsCUltk/dAWV7SPQc+cYC
        YgsJxEpM+/2DfQKj5CyEBQsYGVcxiqUWFOempxYbFhjqFSfmFpfmpesl5+duYgRHlZbpDsaJ
        bz/oHWJk4mA8xCjBwawkwsvy70i8EG9KYmVValF+fFFpTmrxIUZpDhYlcd4/2h3xQgLpiSWp
        2ampBalFMFkmDk6pBia3kl8zK//zmliuiXnMdnR5uZPJE84Fb2IMbS5fD+G7GCfxxULiauhv
        HjZJzjkbf2ht60radtv/7oFdonfitkc+qVvHe+d4zqtdNj8XTGu2mTc/p+BJ+dq6w1+npN3J
        c+l3Zov6+Hnh/zOGWholP7afE1+sHvnexp6Xk+fW18W/haV1V55tVrJfacBtWzHBKJNpWt96
        CUH71ZIBM1wyRJqqnTj7LvbaNggaS3MoKV95q5Y1X/vCCQHvPN8zt09XKC07JTKNfVFvl+8L
        dZklfzJCUkR/Vki8k3t4XmzPp+8/VDgKJ2a525WJHgufGKv95t/9+9WVwUlN7Y9/Ba1T2/fh
        se+dqLeb+dMd37dfzlFiKc5INNRiLipOBAAWKRzMGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJMWRmVeSWpSXmKPExsWy7bCSnO6pyhPxBosuK1rseH6G3aL7+g42
        i+XH/zE5MHt8fHqLxaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyVh24w1RwgLdi5kLDBsZP
        XF2MnBwSAiYSaydvZ+ti5OIQEtjBKLHx3R0miISkxIzG9axdjBxAtrDE4cPFEDUfGSUOtN1n
        A6lhE1CV2Hn1IJgtIhAq8fxnLyOILSwQJNG9/A47iM0CVPP14ylmEJtXwF9i5dENjBDz5SRO
        HpvMOoGRewEjwypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjGB/a2ntYNyz6oPeIUYm
        DsZDjBIczEoivCz/jsQL8aYkVlalFuXHF5XmpBYfYpTmYFES5/06a2GckEB6YklqdmpqQWoR
        TJaJg1OqgWlpruAL3nLdsv+yby79m/xk5bIj3z839a1IOfQojUmkw2TTZGm5gGVib68sY1ex
        skte8vZAxMzExflH9j2bt69uQUV9E3eUn9ixJ0uCvvqEBhk+VY/YqpxYEOK/3P/Atxksb85l
        cEqutzmwesr9g+pT3pTruUb+Oc0VLdbpVvHzWKm8YuuVWpG+2JTu9Y81s1YYWoanbswK9bA/
        ujxYhyfr3ORbkikLZ0389JN/yff5k8UXO21bvvJ/wqu813ILUzWLRNYvOrAi+vu+Ht/kyleS
        J79fSPM85HFLetWvSdY3qyYXrH14SyN+Z9+5HC4TtovR1rxxkl+vznmafyz8t46/vTqj5svb
        /FvOzfr38HaBEktxRqKhFnNRcSIAm1MqQGYCAAA=
X-CMS-MailID: 20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
X-CMS-RootMailID: 20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d
References: <CGME20201203053818epcas1p2aef4dce58afcac06fb28354146254c8d@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: jintae jang <jt77.jang@samsung.com>

Invalidation check of arguments should have been checked before
ufshcd_hold(). It can help to prevent ufshcd_hold()/
ufshcd_release() from being invoked unnecessarily.

Signed-off-by: jintae jang <jt77.jang@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 51b4e0a..0b60931 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2978,14 +2978,14 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
 	if (!attr_val) {
 		dev_err(hba->dev, "%s: attribute value required for opcode 0x%x\n",
 				__func__, opcode);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
+	ufshcd_hold(hba, false);
+
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
@@ -3069,21 +3069,20 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 
 	BUG_ON(!hba);
 
-	ufshcd_hold(hba, false);
 	if (!desc_buf) {
 		dev_err(hba->dev, "%s: descriptor buffer required for opcode 0x%x\n",
 				__func__, opcode);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	if (*buf_len < QUERY_DESC_MIN_SIZE || *buf_len > QUERY_DESC_MAX_SIZE) {
 		dev_err(hba->dev, "%s: descriptor buffer size (%d) is out of range\n",
 				__func__, *buf_len);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
+	ufshcd_hold(hba, false);
+
 	mutex_lock(&hba->dev_cmd.lock);
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
-- 
1.9.1

