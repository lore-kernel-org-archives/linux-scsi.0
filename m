Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76E5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9023A60ED3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhJUDqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65396 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231378AbhJUDpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:39 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L2DQrE019148;
        Thu, 21 Oct 2021 03:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=JIag/1EVROHvvkjVOHL8l+9sTbbjakPfIoreQcn+KZE=;
 b=JnMFKpHLxkHPP6DT78m6Pni74sSuF01LVkzZOcGO1EERPA41pT6WYpZ/FuA1BjoFg5fG
 4EcpM8ZWlbiP34G2PLz+65AHqWPzg58hilnLDohnBo+UC5g4Id3pIFLTHnRMshD6oSDs
 JlqDzulEX+uAmNeVv3nqncbGGeCfaW1rvAchNiTfATzLCYgvbC87Mk17MChnewRTZAVY
 rOAg80aVS+7a+SiBFV82jkGbkrdx7jCMdZ8BctCe7D5jfHRja2A7LtwBX+ctaoOtutmm
 wRvxYJ2pungJXfAYhzoh7k+A734+d6WRhadRJLm/2uIPXzwewHEZggL5NrHAdlvBTfqy Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqypjhuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esRn078107;
        Thu, 21 Oct 2021 03:43:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshemah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu8O082116;
        Thu, 21 Oct 2021 03:43:14 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-20;
        Thu, 21 Oct 2021 03:43:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.bottomley@hansenpartnership.com,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        brking@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in initialize_event_pool
Date:   Wed, 20 Oct 2021 23:42:51 -0400
Message-Id: <163478764103.7011.14545287284915195720.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1547089149-20577-1-git-send-email-tyreld@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: jQ9mMRTUFKSCzcUdde-rNFPZVc6wKMCQ
X-Proofpoint-GUID: jQ9mMRTUFKSCzcUdde-rNFPZVc6wKMCQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Jan 2019 18:59:09 -0800, Tyrel Datwyler wrote:

> During driver probe we allocate a dma region for our event pool.
> Currently, zero is passed for the gfp_flags parameter. Driver probe
> callbacks run in process context and we hold no locks so we can sleep
> here if necessary.
> 
> Fix by passing GFP_KERNEL explicitly to dma_alloc_coherent().
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] ibmvscsi: use GFP_KERNEL with dma_alloc_coherent in initialize_event_pool
      https://git.kernel.org/mkp/scsi/c/3319a8ba82b9

-- 
Martin K. Petersen	Oracle Linux Engineering
