Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50BDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 22:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3AF6112E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 22:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhKDWwn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 18:52:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26118 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhKDWwm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 18:52:42 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211104225002epoutp02d22dfaa6ea93d70c008454dcb30abe44~0eYsUR66p0347503475epoutp02m
        for <linux-scsi@vger.kernel.org>; Thu,  4 Nov 2021 22:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211104225002epoutp02d22dfaa6ea93d70c008454dcb30abe44~0eYsUR66p0347503475epoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1636066202;
        bh=2cYJzWfARjbXZ8J9wEAW74zKQBm59iKLTRa/kNxHvzc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=HIb5Z4CabTAKiMMrThM7P1hMn+5GFP6LP2TjKCrCQJMJvWZNkr/+kScvU4wtdBEfW
         kqfMX6oXMcyhF1x5hgNmP3qf/CWGRamhra9XrQRciJSpsAJRKS7XqEx6nUWgEr4OFP
         THAsJt5ACPnMZZgJnCWYSVb+SHDwXSuD46/8vW/A=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20211104225002epcas3p2aa5550e1cda006a5894a634f8cb53eb8~0eYrpNRXE1424214242epcas3p22;
        Thu,  4 Nov 2021 22:50:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4Hlf3Z0qjwz4x9Q4; Thu,  4 Nov 2021 22:50:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Improve SCSI abort handling
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        VISHAK G <vishak.g@samsung.com>,
        Girish K S <girish.shivananjappa@linaro.org>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        "huobean@gmail.com" <huobean@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20211104181059.4129537-1-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01636066202065.JavaMail.epsvc@epcpadp3>
Date:   Fri, 05 Nov 2021 07:39:06 +0900
X-CMS-MailID: 20211104223906epcms2p2d25c5bf3001403de904317a3d675b5c5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211104181111epcas2p2965ba25c905be783c39f098210cc4c61
References: <20211104181059.4129537-1-bvanassche@acm.org>
        <CGME20211104181111epcas2p2965ba25c905be783c39f098210cc4c61@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,


>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 3b4a714e2f68..d8a59258b1dc 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -7069,6 +7069,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                 goto release;
>         }
> 
>+        lrbp->cmd = NULL;
>         err = SUCCESS;
> 
> release:

I found similar code in the ufshcd_err_handler(). I think the following
patch will required to fix another warning.

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f5ba8f953b87..cce9abc6b879 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6190,6 +6190,7 @@ static void ufshcd_err_handler(struct work_struct *work)
                }
                dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
                        hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
+               hba->lrb[tag].cmd = NULL;
        }

        /* Clear pending task management requests */


Thanks,
Daejun
