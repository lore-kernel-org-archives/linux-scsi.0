Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82D3C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D682610CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhJUDpo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48852 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhJUDpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:20 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L1MeS4020970;
        Thu, 21 Oct 2021 03:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=KmPjvWP7uHNVKZb/bfyFWcjICvRoWEiuSuB3zepHOns=;
 b=L6EPcrf7R3XvzwYrafpXK97Fr9gOAjosrEsrUjDvN/xVCVvYXKFuQp9pIeTGihpb9UIe
 Ouf6N+UKgsYvUxZmPwTbU3pPY5wpf3glZ+3kgNG5SSGfmJeubqy2Iw1aYt+7HS/NmT4O
 xjgfskLbBY1WpPTO+LsrrCcZd+bGkUuBJj/SM+HiUAQNW1HKNFQCehE2iR0mUVJAo47c
 H3Gwhp/ftX/NZ7wBfjTnluyIP00WeiYZFt5O2QrMYQbtyHv1dpUgb8j8z0L5hajRJ502
 eT2lAt4mq/WWJrOaSXLtnoiRv0sm4pbzpEv8ULzpJg8E0mG/rctvHt+glr/KtOLTNcRZ 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9v8vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3etvY078225;
        Thu, 21 Oct 2021 03:43:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:02 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu80082116;
        Thu, 21 Oct 2021 03:43:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-8;
        Thu, 21 Oct 2021 03:43:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: use scnprintf() instead of snprintf()
Date:   Wed, 20 Oct 2021 23:42:39 -0400
Message-Id: <163478764103.7011.7736758287562784042.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013083005.GA8592@kili>
References: <20211013083005.GA8592@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: -u-u4iDzw6KRgkd9AWtIZeYurMw1N_m8
X-Proofpoint-GUID: -u-u4iDzw6KRgkd9AWtIZeYurMw1N_m8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 11:30:05 +0300, Dan Carpenter wrote:

> I intended to move from snprintf() to scnprintf() in the previous
> patch but I messed up and did not do that.  The result of my bug is
> that it this function could trigger a WARN() if the buffer is too
> large.
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: mpi3mr: use scnprintf() instead of snprintf()
      https://git.kernel.org/mkp/scsi/c/30e99f05f8b1

-- 
Martin K. Petersen	Oracle Linux Engineering
