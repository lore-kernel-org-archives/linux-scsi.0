Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C57C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF9E60FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhJUDpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63784 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231370AbhJUDph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:37 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L3dUmU020876;
        Thu, 21 Oct 2021 03:43:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=vBz/VBNsTS7CuQkk+j6itYx/A2C9bynTwiXjcF08xFQ=;
 b=CRjDEYswaD9FjLN7nYOiA6HOS1Jn60BhlOWqlfl8wDhZrA0g6Mdbl2hg0FXrzOAOm9Bm
 HKETtF3FDdPEZPehGnFkrqJ9XSTz4agrYRuDSaKXCd1Mbuuc50LC9mK1cM5qZrdGmmsg
 NoYKFAm+Ns4XzWg9leAVCzwI2nW9lSAtwujwdmZDxfnhRL/sIiEs1BaLV1TKzSWCDgLB
 CfPyRFQpO9Qak0ye2YrTWtP4yGBsjZeATknvGL9wmXvaRrCf2D//MXZAxbyFvY/KPW/r
 ZcZiCXkRomrx10Y14Pw2YsPKlil4AsKAUDL8sSBKetpaBCF9QHU+ckCteWp+sV2f9vq7 xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3etSd078167;
        Thu, 21 Oct 2021 03:43:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:10 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8E082116;
        Thu, 21 Oct 2021 03:43:09 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-15;
        Thu, 21 Oct 2021 03:43:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, jejb@linux.ibm.com, avri.altman@wdc.com,
        peter.wang@mediatek.com, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        cc.chou@mediatek.com, mikebi@micron.com, qilin.tan@mediatek.com,
        jonathan.hsu@mediatek.com, alice.chao@mediatek.com,
        linux-mediatek@lists.infradead.org, lin.gui@mediatek.com,
        wsd_upstream@mediatek.com, chaotian.jing@mediatek.com,
        chun-hung.wu@mediatek.com, powen.kao@mediatek.com,
        jiajie.hao@mediatek.com
Subject: Re: [PATCH v4] scsi: ufs: support vops pre suspend for mediatek to disable auto-hibern8
Date:   Wed, 20 Oct 2021 23:42:46 -0400
Message-Id: <163478764101.7011.14536985076205291052.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006054705.21885-1-peter.wang@mediatek.com>
References: <20211006054705.21885-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: nDl-s5wQYla5k54y0RPFgYOw65fDwy2u
X-Proofpoint-GUID: nDl-s5wQYla5k54y0RPFgYOw65fDwy2u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Oct 2021 13:47:05 +0800, peter.wang@mediatek.com wrote:

> From: Peter Wang <peter.wang@mediatek.com>
> 
> Mediatek UFS design need disable auto-hibern8 before suspend.
> This patch introduce an solution to do pre suspned before SSU
> (sleep) command.
> 
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: support vops pre suspend for mediatek to disable auto-hibern8
      https://git.kernel.org/mkp/scsi/c/9561f58442e4

-- 
Martin K. Petersen	Oracle Linux Engineering
