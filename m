Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7766C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8BFD61AD2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhKSEUE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:20:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19594 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233983AbhKSEUC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:20:02 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4C20U020979;
        Fri, 19 Nov 2021 04:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=Y69FHpOAx57lLd3f+zNs2LCJmaW7F6iBzQxq4zJsLj4=;
 b=MsDg0vDN151NCtw+7aIdmzfl7kGhUZhHGIpOQJevjGwmLeAHPtpSgIoRSvX9ubQki5fN
 jBpQvg6c3DpMBY66itM7k+ygdXY45uZ+EHJczbjCrCU2wzAIT61EIua9nmkH7wmSoQvz
 gXNJyPPC4labbaRzvUr9vpYFMZhJwZeQA2872kUmATxkh8vTSIYlHO03WTc/ql8Pa1B4
 q1hijT/Ldp3vfMGSq7pYV7t9Z2aF8mTuK15xoPLTfU6Qb7dTSPebqwWVRWnUxEd/oEX8
 qPPaV4fOnQp/jMQ/P6kwGi7sbvC5m3FDQqa/hkAQL64rNvajne6vdSrRto9Ad5HMcVjC tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd4qyucj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBOf020402;
        Fri, 19 Nov 2021 04:16:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:47 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwK024731;
        Fri, 19 Nov 2021 04:16:46 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-3;
        Fri, 19 Nov 2021 04:16:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     cgel.zte@gmail.com, stanley.chu@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        linux-mediatek@lists.infradead.org, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Zeal Robot <zealci@zte.com.cn>, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: add put_device() after of_find_device_by_node()
Date:   Thu, 18 Nov 2021 23:16:32 -0500
Message-Id: <163729506337.21244.16117956445573879495.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110105133.150171-1-ye.guojin@zte.com.cn>
References: <20211110105133.150171-1-ye.guojin@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: _y2LW0XTb1knUXYDye0z3F6PA7Vd0Tid
X-Proofpoint-GUID: _y2LW0XTb1knUXYDye0z3F6PA7Vd0Tid
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Nov 2021 10:51:33 +0000, cgel.zte@gmail.com wrote:

> From: Ye Guojin <ye.guojin@zte.com.cn>
> 
> This was found by coccicheck:
> ./drivers/scsi/ufs/ufs-mediatek.c, 211, 1-7, ERROR missing put_device;
> call of_find_device_by_node on line 1185, but without a corresponding
> object release within this function.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-mediatek: add put_device() after of_find_device_by_node()
      https://git.kernel.org/mkp/scsi/c/cc03facb1c42

-- 
Martin K. Petersen	Oracle Linux Engineering
