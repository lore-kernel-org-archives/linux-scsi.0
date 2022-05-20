Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDB5C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344356AbiETBJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344283AbiETBJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:09:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3020B13325B;
        Thu, 19 May 2022 18:09:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0J3Nn003574;
        Fri, 20 May 2022 01:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=twlSiCVktEMVFkg0yLeZ2e21MvQSw4k82dnQDHeH+/g=;
 b=rYR2rVKi2tTm2GZPmqihbDjX+IwZZyZvPvhDJ4KDCuBXbM7GnRlXlk4Pyx8JSpv3YzD7
 Le+5ES/JZF0nD2uOrYWY734+8GfAGsBpdLjTuGkh4vZAhDx1U8GQjmy8USlAz1+kvOM+
 YSwc6W7VeRsvbRn6Trjt+Je1PMv889gC0p2fDDm8Ob2rbUfmgveGA7YYAh1BqGuVuUDq
 zsIwj3vk/4vxDWruN44ZUtdJhz+EG2hBxxgTrujofxmMH6brRdeajUrGHsRKpLzwjwHH
 UXq19EUWUgzfKZJO8mGCXxODQh+DFNdW4NJ68MxBgQI28hyZoal1lXpAXtQFrV+rCRc6 5A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytwu9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K15nCZ020204;
        Fri, 20 May 2022 01:09:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crytpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:26 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24K19GKJ030710;
        Fri, 20 May 2022 01:09:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crythd-8;
        Fri, 20 May 2022 01:09:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, kernel-janitors@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH] scsi: mpi3mr: Return error if dma_alloc_coherent() fails
Date:   Thu, 19 May 2022 21:09:07 -0400
Message-Id: <165300891230.11465.14769224499541486681.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <YnOmMGHqCOtUCYQ1@kili>
References: <YnOmMGHqCOtUCYQ1@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: HCoQnjS5qc2SjeoNADpigxepp3FibgAr
X-Proofpoint-ORIG-GUID: HCoQnjS5qc2SjeoNADpigxepp3FibgAr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 5 May 2022 13:25:52 +0300, Dan Carpenter wrote:

> Return -ENOMEM instead of success if dma_alloc_coherent() fails.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Return error if dma_alloc_coherent() fails
      https://git.kernel.org/mkp/scsi/c/bc7896d31a92

-- 
Martin K. Petersen	Oracle Linux Engineering
