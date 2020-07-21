Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6B3C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110D220729
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:56:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FNRvnQd5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgGUJ4w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:56:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35404 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgGUJ4w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 05:56:52 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200721095648epoutp025ba9dde4401103ff4f9d06a4f592616e~jvAHPx2nh0040900409epoutp02G
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:56:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200721095648epoutp025ba9dde4401103ff4f9d06a4f592616e~jvAHPx2nh0040900409epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595325409;
        bh=JnwTycxHSEDaTi6zKAdOzNcEOUbdyuPMh/5O4dnQ0uo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=FNRvnQd5ae7yZ+bEnyq5nqao768UqFVG3tQA1gjTCecVC/gK+k35dwo1bvBZfkjUE
         IvMC4IKAamhmGVMuRtbl3T7oP97O28MNk+Kl4xSRouo38Ap6gtuvpoRSYiwIW7Wk6W
         NoHF3lPitSwkjkYphTLNnA8V9WLvNofPCqp1xKLo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200721095648epcas2p4d52a1e313336bb6fd174410a97cf3155~jvAGnllyv2747927479epcas2p4K;
        Tue, 21 Jul 2020 09:56:48 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B9vBj35kgzMqYkj; Tue, 21 Jul
        2020 09:56:45 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.0E.27013.DDBB61F5; Tue, 21 Jul 2020 18:56:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200721095644epcas2p4aa2e620257686679e6c9e58ccabeac34~jvADggh6Z2747427474epcas2p4L;
        Tue, 21 Jul 2020 09:56:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200721095644epsmtrp1480020fcc1fbc66965c2a6e5b3deaa70~jvADfr8MO3066030660epsmtrp1f;
        Tue, 21 Jul 2020 09:56:44 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-90-5f16bbddced7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.13.08382.CDBB61F5; Tue, 21 Jul 2020 18:56:44 +0900 (KST)
Received: from rack03.dsn.sec.samsung.com (unknown [12.36.155.109]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200721095644epsmtip233f5ae584c7eb62a0757370db41b94b6~jvADOXfeY0445804458epsmtip2f;
        Tue, 21 Jul 2020 09:56:44 +0000 (GMT)
From:   SEO HOYOUNG <hy50.seo@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com
Cc:     SEO HOYOUNG <hy50.seo@samsung.com>
Subject: [RFC PATCH v3 0/3] Support vendor specific operations for WB
Date:   Tue, 21 Jul 2020 18:57:09 +0900
Message-Id: <cover.1595325064.git.hy50.seo@samsung.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmqe7d3WLxBh3TxSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mB26Py1e8
        PS739TJ5TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAI6oHJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoEOVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5Gdd3LGMtOM9RcfjAK7YG
        xmdsXYycHBICJhIHp95i72Lk4hAS2MEoseHfSjYI5xOjxL9jLxghnG+MEqv2fWaCaWnc/wqq
        ZS+jxMnv01hBEkICPxglNr4PArHZBDQk1hw7xARSJCLwgVHi6IrZYEXMAmoSn+8uY+li5OAQ
        FnCV+HM7DCTMIqAq0fViIdgCXgFziTMrj7NALJOXWNTwGyouKHFy5hMWiDHyEs1bZzODzJcQ
        aOSQOHNpNytEg4vElbabUM3CEq+Ob2GHsKUkXva3Qdn1ElPurWKBaO5hlNiz4gTUa8YSs561
        M4IcxyygKbF+lz6IKSGgLHHkFtRePomOw3/ZIcK8Eh1tQhCNShJn5t6GCktIHJydAxH2kFj/
        dwkjJHRiJS6cf8I6gVF+FpJnZiF5ZhbC2gWMzKsYxVILinPTU4uNCkyQ43QTIzitannsYJz9
        9oPeIUYmDsZDjBIczEoivBN5hOOFeFMSK6tSi/Lji0pzUosPMZoCg3cis5Rocj4wseeVxBua
        GpmZGViaWpiaGVkoifO+s7oQJySQnliSmp2aWpBaBNPHxMEp1cDUy/MpLcFxC/+MX6lcPgIu
        Jnp6yXP52RpmbzEWOe76WIDJxWrbopl/mq4cWmA3L2PNpuvqFrwrfxv7H60+tL9gYsxEkef+
        7+tMNs0yy/+nH/fyxtrlKTMyEy9NL1lQyar++8axptDF6+ba62yQ+r6rz+VrZ/wOt10qZ5w2
        njpzz5X1ze29iy/tii5qVb11cO061Zo4hxfqt7LsqtNnplhWHuxacqHhjNQqjkXb5U5y5Nnp
        ba5qEbjf47JkXXHkNIeVrPNt9f0tkpbEP/l7puuk2cN7XoWfXhgxuVu8rrxkPZun36fdLrau
        5QO/Wd+V8stHVdSSBF+xHJxkcPfpAn4f/rdf8m0/RjkUTLG0+7dbiaU4I9FQi7moOBEA/ZPY
        7zQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSvO6d3WLxBofPGlo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYvXiBywWi25sY7Lovr6DzWL58X9MDtwel694
        e1zu62XymLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MARxRXDYpqTmZZalF+nYJXBnX
        dyxjLTjPUXH4wCu2BsZnbF2MnBwSAiYSjftfsXcxcnEICexmlHh7ZzsTREJC4v/iJihbWOJ+
        yxFWiKJvjBIrT7xkBEmwCWhIrDl2CKxIROAPo8Sk03EgNrOAmsTnu8tYuhg5OIQFXCX+3A4D
        CbMIqEp0vVgIVs4rYC5xZuVxFoj58hKLGn5DxQUlTs58wgIxRl6ieets5gmMfLOQpGYhSS1g
        ZFrFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc6FqaOxi3r/qgd4iRiYPxEKMEB7OS
        CO9EHuF4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw3ChfGCQmkJ5akZqemFqQWwWSZODilGphq
        vZ8uzzz6m/dy/UTjMrW78sIdq6QXXW9xeH/n30HlfCEe0aDE5Ne3Ok5/2Bv4bEVL+ftvCh+D
        VaYoLfXrqH5yeqfoU26Xvzuf9u18qLScU33Hy5lhv+3mbY5yE1nl/Gd9a4fOjJ1LshS1246u
        qC8QyLV48sTjqPPM+AftP515xZIuSNc/E+/5/O/Xkdq9GxL+PNp4gm3znQa3l6rNHiFy2xkL
        q0Wn8ZeWqp28Y7rkqXBMa4GI0v43adHLDP8e0b92cmYuX+zqA9yvl6fYiFd9Uj0S+V3u8rKH
        LYnnotorlym88UzVuSTHmbbr6Jyki/OTCznXTl8zjanYqMnQfxP3xNfVOzOC2LqrdjdVcbcr
        sRRnJBpqMRcVJwIAJdSDT+MCAAA=
X-CMS-MailID: 20200721095644epcas2p4aa2e620257686679e6c9e58ccabeac34
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200721095644epcas2p4aa2e620257686679e6c9e58ccabeac34
References: <CGME20200721095644epcas2p4aa2e620257686679e6c9e58ccabeac34@epcas2p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi all,
Here is v3 of the patchset.
This patchs for supporting WB of vendor specific.
- when UFS reset and restore, need to cleare WB buffer.
- need to check WB buffer and flush operate before enter suspend
- do not enable WB with UFS probe.

[v1 -> v2]
- The ufshcd_reset_vendor() fuction for WB reset.
So I modified function name.
- uploade vendor wb code.

[v2 -> v3]
modified minor details about blank, typing error etc..


SEO HOYOUNG (3):
  scsi: ufs: modify write booster
  scsi: ufs: modify function call name When ufs reset and restore, need
    to disable write booster
  scsi: ufs: add vendor specific write booster

 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufs-exynos.c |   6 +
 drivers/scsi/ufs/ufs_ctmwb.c  | 270 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs_ctmwb.h  |  26 ++++
 drivers/scsi/ufs/ufshcd.c     |  22 ++-
 drivers/scsi/ufs/ufshcd.h     |  43 ++++++
 6 files changed, 363 insertions(+), 5 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
 create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h

-- 
2.26.0

