Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DBDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 11:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349586AbiDZLqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346071AbiDZLqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 07:46:17 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902F23BF8D
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 04:43:08 -0700 (PDT)
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220426114302epoutp04f84b3dea89b390f262949f7b304cdeb5~pb4tqt0uO3158731587epoutp04j
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2022 11:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220426114302epoutp04f84b3dea89b390f262949f7b304cdeb5~pb4tqt0uO3158731587epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650973383;
        bh=YE9iUr9/jWW+X/EahStx2IppwtG/JSA/KIYvvhie8vI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=a4HfZnXByYJq5Y7TqW8ucRa9jsxs4tRbmUuJqaVzRXpGZadHb8UVzBQ3xUMKkemqb
         yl03YtJq9M0QvPC/18QT2Ls+SdSezXGznZOyPk2mfo/hQYy/Ust/kBBcpobzgdseqw
         4af5eBxEQXhK2DAM7ySk+VACRMOGcgzNpXVB3u+0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20220426114302epcas3p132d41aac8d00da7937b2f717bbb21188~pb4tBgDT31614516145epcas3p1Z;
        Tue, 26 Apr 2022 11:43:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4Kng460ycCz4x9Q3; Tue, 26 Apr 2022 11:43:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 6/6] scsi: ufshpb: Cleanup ufshpb_suspend/resume
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "powen.kao@mediatek.com" <powen.kao@mediatek.com>,
        cpgsproxy3 <cpgsproxy3@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220424220713.1253049-7-huobean@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01650973382114.JavaMail.epsvc@epcpadp4>
Date:   Mon, 25 Apr 2022 11:25:19 +0900
X-CMS-MailID: 20220425022519epcms2p1fe1a24e91f1bd69dfe04f8fabb18bbf8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220424220758epcas2p398348a86cb11bced52451da2de09629d
References: <20220424220713.1253049-7-huobean@gmail.com>
        <20220424220713.1253049-1-huobean@gmail.com>
        <CGME20220424220758epcas2p398348a86cb11bced52451da2de09629d@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>From: Bean Huo <beanhuo@micron.com>
> 
>ufshpb_resume() is only called when the HPB state is HPB_SUSPEND, so
>the check statement for "ufshpb_get_state(hpb) != HPB_PRESENT" is useless.
> 
>Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong Park

>---
> drivers/scsi/ufs/ufshpb.c | 15 ++++-----------
> 1 file changed, 4 insertions(+), 11 deletions(-)
> 
>diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>index 7868412054bf..10f40e390dc5 100644
>--- a/drivers/scsi/ufs/ufshpb.c
>+++ b/drivers/scsi/ufs/ufshpb.c
>@@ -2349,11 +2349,9 @@ void ufshpb_suspend(struct ufs_hba *hba)
> 
>         shost_for_each_device(sdev, hba->host) {
>                 hpb = ufshpb_get_hpb_data(sdev);
>-                if (!hpb)
>+                if (!hpb || ufshpb_get_state(hpb) != HPB_PRESENT)
>                         continue;
> 
>-                if (ufshpb_get_state(hpb) != HPB_PRESENT)
>-                        continue;
>                 ufshpb_set_state(hpb, HPB_SUSPEND);
>                 ufshpb_cancel_jobs(hpb);
>         }
>@@ -2366,20 +2364,15 @@ void ufshpb_resume(struct ufs_hba *hba)
> 
>         shost_for_each_device(sdev, hba->host) {
>                 hpb = ufshpb_get_hpb_data(sdev);
>-                if (!hpb)
>+                if (!hpb || ufshpb_get_state(hpb) != HPB_SUSPEND)
>                         continue;
> 
>-                if ((ufshpb_get_state(hpb) != HPB_PRESENT) &&
>-                    (ufshpb_get_state(hpb) != HPB_SUSPEND))
>-                        continue;
>                 ufshpb_set_state(hpb, HPB_PRESENT);
>                 ufshpb_kick_map_work(hpb);
>                 if (hpb->is_hcm) {
>-                        unsigned int poll =
>-                                hpb->params.timeout_polling_interval_ms;
>+                        unsigned int poll = hpb->params.timeout_polling_interval_ms;
> 
>-                        schedule_delayed_work(&hpb->ufshpb_read_to_work,
>-                                msecs_to_jiffies(poll));
>+                        schedule_delayed_work(&hpb->ufshpb_read_to_work, msecs_to_jiffies(poll));
>                 }
>         }
> }
>-- 
>2.34.1
> 
> 
