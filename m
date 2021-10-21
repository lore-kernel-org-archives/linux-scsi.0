Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9B0C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D707260FED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJUDqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1490 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231375AbhJUDpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:39 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1Juvu020887;
        Thu, 21 Oct 2021 03:43:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=k5QG6E5mvC45i9oP0RT243xPqy0otNYD4LoO3zM9VdU=;
 b=I3rwUDVTyJ7H35HaCdLlJoMc6ELAhp4WDbwVloYNz0+38QMPXKgPO7oL2U5QKPL7ze8K
 uZmNtF1GE/EX1uSJMltSIDtbqvT+fwSoO0jGLhM4ozSDEwH3EDzjo3PIFzuf03qil1sk
 mB5ghhqbIgeDUNm4H3SN6/EzyzFd8QJNAMonURyE7Mop0ekmERQIqKvEyYH10HR6r/wP
 vG5Pxtcv59vYq0AJFUvyt35PERcZdZj4hz03XTNqb6BHAwre79bFiHnzbpYZozq7yFVY
 vfiv21fDwyn7Ub+ke4FX4Y//RBOegOHYmXlSyqa748i7I8qL8/tm4Su7Q00Ty1UgwlIb rg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esKH078043;
        Thu, 21 Oct 2021 03:43:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshemc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:16 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8U082116;
        Thu, 21 Oct 2021 03:43:16 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-23;
        Thu, 21 Oct 2021 03:43:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com,
        bvanassche@acm.org, dgilbert@interlog.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 resend 0/2] Fix out-of-bound read in resp_readcap16 and resp_report_tgtpgs
Date:   Wed, 20 Oct 2021 23:42:54 -0400
Message-Id: <163478764103.7011.4537522473639894114.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013033913.2551004-1-yebin10@huawei.com>
References: <20211013033913.2551004-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: iFO0t39hekxTKDypgSzB3bNsWzQGueW6
X-Proofpoint-GUID: iFO0t39hekxTKDypgSzB3bNsWzQGueW6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 11:39:11 +0800, Ye Bin wrote:

> Ye Bin (2):
>   scsi:scsi_debug: Fix out-of-bound read in resp_readcap16
>   scsi:scsi_debug:Fix out-of-bound read in resp_report_tgtpgs
> 
> drivers/scsi/scsi_debug.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/2] scsi:scsi_debug: Fix out-of-bound read in resp_readcap16
      https://git.kernel.org/mkp/scsi/c/4e3ace0051e7
[2/2] scsi:scsi_debug:Fix out-of-bound read in resp_report_tgtpgs
      https://git.kernel.org/mkp/scsi/c/f347c26836c2

-- 
Martin K. Petersen	Oracle Linux Engineering
