Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E5AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1507520774
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 02:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sd3kAFGm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgGHCcE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 22:32:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11654 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgGHCcD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 22:32:03 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200708023200epoutp01380793191a8732e0632584f9e664fb68~fpjCE98bN1153411534epoutp01a
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 02:32:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200708023200epoutp01380793191a8732e0632584f9e664fb68~fpjCE98bN1153411534epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594175520;
        bh=rJrK8YWEMIlsXw1bcpuzIBhBH2129E6jXTK3Xevwysc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=sd3kAFGmkxq34Y9VygZz4Zg4atayw8Pq9rn7UY/wr7wndxRVl7IbNNsOaDHc3Blxt
         D3ITZF1y8nTlVaVQ39MqR4g15ajAIqP0zZ3Jl6ZYfAaEQ0z45YUHIX7/SmADGS3c15
         ASfbJnIvoRnyysT3CSfDqfzwJyc42qpfMn3sb+Ww=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200708023159epcas2p26676e5db137bc73205a74f1afa3484ac~fpjBNgDPV0901609016epcas2p2F;
        Wed,  8 Jul 2020 02:31:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B1jxT288nzMqYkj; Wed,  8 Jul
        2020 02:31:57 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.FD.27441.D10350F5; Wed,  8 Jul 2020 11:31:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200708023156epcas2p188781afcff94b548918326986d58a2d7~fpi_wPehM1707617076epcas2p1j;
        Wed,  8 Jul 2020 02:31:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200708023156epsmtrp2b2f655cc31ab2c865d0cd8847976e824~fpi_vaF5X2368623686epsmtrp2v;
        Wed,  8 Jul 2020 02:31:56 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-1d-5f05301d5fe4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.82.08303.C10350F5; Wed,  8 Jul 2020 11:31:56 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200708023156epsmtip2c495cb244fec98192ea3ad4a1b0e9ba7~fpi_jI41O0096600966epsmtip2P;
        Wed,  8 Jul 2020 02:31:56 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND RFC PATCH v4 3/3] ufs: exynos: implement dbg_register_dump
Date:   Wed,  8 Jul 2020 11:24:01 +0900
Message-Id: <ace3fe9ebea3b82e23c6c6ebc5bd92fbdde23b51.1594174981.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1594174981.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1594174981.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmua6sAWu8wenDXBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIzOBw/YC5bxVDw/MJ25gXEpVxcjJ4eEgInEtc6ZrF2MXBxCAjsYJRr+7GGHcD4xSiw7sgzK
        +cwo0XNoNRtMy5XXJxkhErsYJR7Nmc8E4fxglPi/YAVYFZuApsTTm1PBEiICm5kkXi24zwyS
        YBZQl9g14QQTiC0s4C2xevZBsAYWAVWJ1rWT2UFsXoFoiW2nmlkg1slJ3DzXCdbLKWAp8fJH
        FzsqmwuoZiqHxPWTu6EaXCR6nlxlh7CFJV4d3wJlS0l8frcX6od6iX1TG1ghmnsYJZ7u+8cI
        kTCWmPWsHcjmALpUU2L9Ln0QU0JAWeLILRaI+/kkOg7/ZYcI80p0tAlBNCpL/Jo0GWqIpMTM
        m3egtnpInDz1iwUSQECbbn+6wjyBUX4WwoIFjIyrGMVSC4pz01OLjQqMkeNvEyM4mWq572Cc
        8faD3iFGJg7GQ4wSHMxKIrwGiqzxQrwpiZVVqUX58UWlOanFhxhNgQE5kVlKNDkfmM7zSuIN
        TY3MzAwsTS1MzYwslMR5i60uxAkJpCeWpGanphakFsH0MXFwSjUw1bZf7DSTBkrISW1ivfI0
        7dLj5+uXiNx9fum5bYvJLdUMxvvOMpWLOVRKXFuZmbbXWnZqu/tUbnj075aA+OLNkyc/C+Xq
        vFMi7T3l+xIfp+pQ7mW2BYen3UzfvKxz0QVN59ouz47Lvhtu3w5RPa6x/1BXV29IXRWHpq/H
        q7gal83z41j4z5VXHWf0frzt/Peo/HdXVs0rU//ePKVQbL5FVL50WcjlszMD1A55RxU+ftq5
        QPWTCstXrVQL51vSxx7M7fER1o/hntZlVu3toqu2lq9wT1XM9JuhG2Wzg4/O3GowN+7kgq7j
        HjdTBdtevJWfMbX/JkupyAwtIQm1T/fufGdYqvhaJZ93ktjGR0osxRmJhlrMRcWJAA3Jj/Ev
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvK6MAWu8wcQTehYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCxubjnKYtF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAldG54MH7AXLeCqeH5jO3MC4lKuLkZNDQsBE4srrk4xdjFwcQgI7GCXe
        Hl7GBJGQlDix8zkjhC0scb/lCCuILSTwjVFi18syEJtNQFPi6c2pTCDNIgKHmST+b33ODpJg
        FlCX2DXhBNggYQFvidWzD7KB2CwCqhKtayeD1fAKREtsO9XMArFATuLmuU5mEJtTwFLi5Y8u
        dohlFhL39vcz4RKfwCiwgJFhFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcCRoae1g
        3LPqg94hRiYOxkOMEhzMSiK8Boqs8UK8KYmVValF+fFFpTmpxYcYpTlYlMR5v85aGCckkJ5Y
        kpqdmlqQWgSTZeLglGpgUn+89+WOJIV2jmNK87Jspz3oXO8qkLQz5/+pviqRCVbV62xy/M6b
        7f6ZpqwRfjtgyinPJdGhx1QmqmdsY2+98MLsZf3bLxHXri7UnuH6c5LYtIiQyuxZoS/W36m/
        eMtDdteHnpu5P7KOFQanpDvkM3UeKHpxOIP7VKD6FN4nBiyLfq7/WfmU00Zpsv9+eRPOFalT
        1rfdSNhiprZskQbXuo//yg5cOJlcOevPlvm3BDpmWATEura2Gjw4q8h1+VWxJOv14lmWgXvk
        jNZ5GQvNU/328dCX5prdgh5/dqqoegievvhLQ/vVi4zV082DJVM/pd3sWyy0+GX4833ZHzWe
        ix8oap4Xk+2xmj0/y7JgpRJLcUaioRZzUXEiAGOooLTzAgAA
X-CMS-MailID: 20200708023156epcas2p188781afcff94b548918326986d58a2d7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023156epcas2p188781afcff94b548918326986d58a2d7
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023156epcas2p188781afcff94b548918326986d58a2d7@epcas2p1.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At present, I just add command history print and
you can add various vendor regions.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufs-exynos.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 8c60f7d..815c361 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -1246,6 +1246,29 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return 0;
 }
 
+static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ufs->dbg_lock, flags);
+	if (ufs->under_dump == 0)
+		ufs->under_dump = 1;
+	else {
+		spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+		goto out;
+	}
+	spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+
+	exynos_ufs_dump_info(&ufs->handle, hba->dev);
+
+	spin_lock_irqsave(&ufs->dbg_lock, flags);
+	ufs->under_dump = 0;
+	spin_unlock_irqrestore(&ufs->dbg_lock, flags);
+out:
+	return;
+}
+
 static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.name				= "exynos_ufs",
 	.init				= exynos_ufs_init,
@@ -1258,6 +1281,7 @@ static struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.dbg_register_dump		= exynos_ufs_dbg_register_dump,
 };
 
 static int exynos_ufs_probe(struct platform_device *pdev)
-- 
2.7.4

