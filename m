Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422B4C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 044DD64FB1
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhBEBt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 20:49:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18878 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhBEBty (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 20:49:54 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210205014909epoutp04754a44fb838c114267a68ef22d717ef5~gtuIrAq303209632096epoutp04O
        for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2021 01:49:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210205014909epoutp04754a44fb838c114267a68ef22d717ef5~gtuIrAq303209632096epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612489749;
        bh=wNEhNzaPW//33H4RoTFNNydg7Mr5bSv+r/oH3A9X9NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjpG6qAwKff0vqtwqRPrxXU7MRb0AJmSt/Jmy4V8PXUK1zfimv8HBzV5BFb6E3TOj
         yW+lN/iVSnac+1IC229RRYRxgpwfu/k0HU7X34kSOY/mGEOmcUJAn77xOK+mXP+QYo
         9ARCRHsrHTXqiIuQevM3jDg+HCfowKmLqjwYYXdw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210205014907epcas1p47286e30d40ba35aee8dfc0c159555acc~gtuHZ-psj0170901709epcas1p4N;
        Fri,  5 Feb 2021 01:49:07 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.162]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DWyyC00Xgz4x9Q1; Fri,  5 Feb
        2021 01:49:07 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.AE.09577.214AC106; Fri,  5 Feb 2021 10:49:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210205014906epcas1p4273577a5af2d2a0786ddf794cd32d494~gtuGBACXt1005010050epcas1p4q;
        Fri,  5 Feb 2021 01:49:06 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210205014906epsmtrp1acef36e8bd14993550ffa4bd1e96da8b~gtuF-Am8A0437704377epsmtrp1c;
        Fri,  5 Feb 2021 01:49:06 +0000 (GMT)
X-AuditID: b6c32a39-c13ff70000002569-b2-601ca412a6e1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.4A.08745.214AC106; Fri,  5 Feb 2021 10:49:06 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210205014905epsmtip2bfe60057017bbb33ae02403c8610daed~gtuFqfapT0103001030epsmtip2D;
        Fri,  5 Feb 2021 01:49:05 +0000 (GMT)
From:   DooHyun Hwang <dh0421.hwang@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com,
        DooHyun Hwang <dh0421.hwang@samsung.com>
Subject: [PATCH 2/3] scsi: ufs: set device state to power-off before 1st
 link startup
Date:   Fri,  5 Feb 2021 10:36:32 +0900
Message-Id: <20210205013633.16243-2-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210205013633.16243-1-dh0421.hwang@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1ATVxjt3V02CQps46N3MoxCai3SSUhIghcrlBkdXUcc6dhOi04JW1gg
        NCQxm3Ra2x+01MhLiIKjBVGBFirFwUJggCLPjkgLTHmoICrSIhYcLYIVRB5NWDvl37nnnvN9
        93z3XiEufkpKhDqDhTUbGL2UdCdq2rYEyMTfeUcryrsR6hgtJ9G9czUkumK7JkDjz6+TqGUk
        jUBTFSVu6MyvNjfUeKNDgOYWKgRotCIPR6nVORgqGqjBUO2DTgGqX0jBUF/9WRJl3KwlUWn7
        Ioayf7xDoq/nGwl0o/OaG/q+ehCgqt5nRNh6ui/rOEZfqLTSxQ3jGF1ZlkbS9qJmQH/T0UTQ
        MxWpJP3k/i2CznKUAXq6cgN9rDkDi1h1UL89gWViWbMPa4gxxuoM8SHSvQe0O7SaIIVSpgxG
        W6U+BiaJDZHuDI+Q7dLpnXGlPp8yequTimA4ThoQut1stFpYnwQjZwmRsqZYvUmpMMk5Jomz
        GuLlMcakbUqFIlDjVEbrEy4/RaYc0WfJLx5hyeB3QToQCSGlhrPl/SAduAvFVC2AOUtFGL+Y
        ArCwrJ3gF9MAlvT1Oi3CZUtDqp7n6wHsGe7BXKWWRYvDG12YpOSw4XiZm0u0lmrE4O2LTctl
        ceqJs+yth6RLtYb6AI41jgAXJqg34Km2JdyFPagQmPcwC/AH3AjnhzOXeREVCgvTlkhe8yrs
        +HaUcGHcqUmpzsddDSCVIoKzP/XjvHkn/K0hl+DxGjjR7niZWgLHs20vcQaA2a2hvNkOYF97
        JslvqODU9DRwZcapLbCiPoCnfWHdiwLAN/aEj//JdOPH4gFTbWJeshkWL844JQIn9oZfreJZ
        Gv5QXyDgB3cCwKtD5wg78MlbkSZvRZq8//teAHgZWM+auKR4llOaNCsvuBIsP3//4Fpw+tGk
        vBVgQtAKoBCXrvVgbJJosUcs8/kR1mzUmq16lmsFGuesT+CSdTFG5/8xWLRKTaBKpULqoK1B
        GpX0NY+PFfe0YiqesbCfsKyJNf/nw4QiSTKG5e+d2zCQdh0ryUz32uw1ZG0oTXyu62q6qJOp
        BtNMUXXpY8GF6NnhCe3lw/bu2/PauZyBmF2e3V1xCw515LG4s6VtYa/o9geN9ARWv7NphG7J
        tcX9PetXHN7c664+clBdV7L7zMnxD313HHjdN9rukK3bl9sS5aX82f5W3rywSrTYuFByNy7D
        M2omkpuXMFxQ11DreeVHgQ8Sr6DCPsdkt0r+2JJPTcjfC02M6RrMlLDi4FOFqpbV/W8WVxkP
        JbYB8pLhZly249CI35/+Mt/Oo3v2RHkdVU9aLm1bPRb+xZHo83f+Ctzkx3x59e67+zt+8d69
        7/3kt09G3XcURxZo/ggLlRJcAqP0x80c8y9l6FxWhwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvK7QEpkEg6czWCxOPlnDZvFg3jY2
        i71tJ9gtXv68ymZx8GEni8Wn9ctYLWacamO12HftJLvFr7/r2S2erJ/FbNGxdTKTxaIb25gs
        djw/w26x628zk8XlXXPYLLqv72CzWH78H5NF/+q7bBZNf/axWFw7c4LVYunWm4wWmy99Y3EQ
        87jc18vksWBTqcfiPS+ZPDat6mTzmLDoAKNHy8n9LB7f13eweXx8eovFo2/LKkaPz5vkPNoP
        dDMFcEdx2aSk5mSWpRbp2yVwZWz4YlEwmbOi4fdbpgbGC+xdjBwcEgImEns6croYuTiEBHYw
        SpzqeMHSxcgJFJeR6L6/F6pGWOLw4WKImo+MEvsffWUDqWET0JPY07uKFSQhInCOSeL2vCWM
        IA6zwG9GiUk/mtlBqoQFQiXuPd3IBGKzCKhKTD38nxnE5hWwlZj1uo8RYpu8xJ/7PWBxTgE7
        iYWd/8E2CAHVHHm2mhGiXlDi5MwnYNcxA9U3b53NPIFRYBaS1CwkqQWMTKsYJVMLinPTc4sN
        C4zyUsv1ihNzi0vz0vWS83M3MYKjVEtrB+OeVR/0DjEycTAeYpTgYFYS4U1sk0oQ4k1JrKxK
        LcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgWnpicravCTXiMPly89o
        3YxZYLYneuMU94QrWewGofuXrJB6MXXa9x2n7jcWx9XL7Tm+VrnR8aqW2ZwHivX/X5lsP/SQ
        f2X9pmfrzrx6Gtp+4n1fepRGr8V2jqc1XHVJfO4Hm57tvCixusSRxYa9IOJUoIHc44JvVqef
        TbXkCUnjz10jOqes/17jkQ3P5Fi44jOMvwuEFp9P+nPasezsvC+f5W0mpDtLKBZcFf2dzRn5
        UGTLrIgnW76Y5+/1jrnI0n4j/EufMG/ba54UhenpXwJPrvezavwozs6mtXBFrb6uxfsPe/rO
        Om5bbpSns9zIRaNxn1Ayl0/OD9mPv37VBqyPW/1PqVKgiN/wdVZdjxJLcUaioRZzUXEiADHx
        7rBBAwAA
X-CMS-MailID: 20210205014906epcas1p4273577a5af2d2a0786ddf794cd32d494
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210205014906epcas1p4273577a5af2d2a0786ddf794cd32d494
References: <20210205013633.16243-1-dh0421.hwang@samsung.com>
        <CGME20210205014906epcas1p4273577a5af2d2a0786ddf794cd32d494@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the ufshcd init sequence, device state should be power-off
bacause the UFS device is not active.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 286f7c918f0e..32cb3b0dcbcf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9447,13 +9447,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 	atomic_set(&hba->scsi_block_reqs_cnt, 0);
+
 	/*
-	 * We are assuming that device wasn't put in sleep/power-down
-	 * state exclusively during the boot stage before kernel.
-	 * This assumption helps avoid doing link startup twice during
-	 * ufshcd_probe_hba().
+	 * The device-initialize-sequence hasn't been invoked yet.
+	 * Set the device to power-off state
 	 */
-	ufshcd_set_ufs_dev_active(hba);
+	ufshcd_set_ufs_dev_poweroff(hba);
 
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
-- 
2.29.0

