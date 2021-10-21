Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050B5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3376611CB
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhJUDpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:45:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:43870 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230103AbhJUDpP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2C5nv019145;
        Thu, 21 Oct 2021 03:42:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=/8YsToP6j1aQC1eqi7PX08taVbr2nxYHJARNqDEe5PQ=;
 b=P2lK6VXXcpxe8J6TH6EfF1XEQ1675ZE4z2Zg5ZxqkhTBPcwcFOl+RzYZfSd5fRDQZImN
 yLqCJ5uI9p+nbwIAwLM8KmxB4AxzEN7a0553B5kJA1ObGBrh1O9KcKhiML4IEUJdk/tM
 b9xxt6HZII07H7Jt4MBg0kOurPeQPqgS++p4V3rpiyiMZ4LACYKtcf/wJPhHeHNKXWKK
 6PAJjJ77IMlnUIMIxa/5En1TpRNTYibwaj/CyX6bJeaQJTHO34R8KTp6+w4n29x///d3
 oJ/lUJy4++2OHetgLSpISe19ycgEYH7xUb1+LAigzaasda74jGMb3DhWjYqsBT5LMhdX Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypjhtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esix078017;
        Thu, 21 Oct 2021 03:42:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:42:57 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu7m082116;
        Thu, 21 Oct 2021 03:42:56 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-2;
        Thu, 21 Oct 2021 03:42:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcmu: allocate zeroed pages for data area
Date:   Wed, 20 Oct 2021 23:42:33 -0400
Message-Id: <163478764104.7011.12641078538939220636.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211013171606.25197-1-bostroesser@gmail.com>
References: <20211013171606.25197-1-bostroesser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Dp7yJoexljGRXYB6WNeXPSnlc61GxdtD
X-Proofpoint-GUID: Dp7yJoexljGRXYB6WNeXPSnlc61GxdtD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Oct 2021 19:16:06 +0200, Bodo Stroesser wrote:

> Tcmu populates the data area (used for communication with
> userspace) with pages that are allocated by calling
> alloc_page(GFP_NOIO).
> Therefore previous content of the allocated pages is exposed
> to user space. Avoid this by adding __GFP_ZERO flag.
> 
> Zeroing the pages does (nearly) not affect tcmu throughput,
> because allocated pages are re-used for the data transfers of
> later SCSI cmds.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: target: tcmu: allocate zeroed pages for data area
      https://git.kernel.org/mkp/scsi/c/1d2ac7b69d6a

-- 
Martin K. Petersen	Oracle Linux Engineering
