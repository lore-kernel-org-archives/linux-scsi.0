Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52059EB64D7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjFVB17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjFVB16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:27:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F7B26AF
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 18:27:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKF3qZ030168;
        Thu, 22 Jun 2023 01:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=KmJw9gBM755uPsmCtvXxd91jpdF5WyIpNm79vyKLfpU=;
 b=bfA2/IMDIR7VLkp1KOwrkrI2WiKWpaxxC4z3bth2tdrSNL2LMTycUFCcdL3LKUBysznO
 gqn/sF2MGZfnJFtPNVnCP+r7toEGtkAOvJDf6Go+zmJQcgfnSngVwhzj0AapPniwcIvC
 YoL0jw8tEMGM6p5fNJzMm728ziPUOMCttEWJfUK82KTlphAm1QI+8vzwCntLL/yv+qaK
 MWDIPcGC6I46pe/0GLOpIV2s+npyihF0gZOOk/GAsGb2YT9cqzxayK4OrykDoKsX2cgt
 u3zVJiZ9rC051pJJYSzPsU5HHtcjc4fWDepDTg4xAo6yvfM5yEAzCVRb7ouQxUumT109 XA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r94etru71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35M0Bsnn038670;
        Thu, 22 Jun 2023 01:26:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396thxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M1QXap038374;
        Thu, 22 Jun 2023 01:26:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r9396thxp-1;
        Thu, 22 Jun 2023 01:26:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
Date:   Wed, 21 Jun 2023 21:26:19 -0400
Message-Id: <168739587259.247655.4816702978211993046.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613170327.61186-1-adrian.hunter@intel.com>
References: <20230613170327.61186-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=884 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306220009
X-Proofpoint-GUID: 7E0dbiCQ_rRBFhNu8RsXdBGkWAU7Nm2X
X-Proofpoint-ORIG-GUID: 7E0dbiCQ_rRBFhNu8RsXdBGkWAU7Nm2X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 13 Jun 2023 20:03:27 +0300, Adrian Hunter wrote:

> Add PCI ID to support Intel Arrow Lake, same as MTL.
> 
> 

Applied to 6.5/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-pci: Add support for Intel Arrow Lake
      https://git.kernel.org/mkp/scsi/c/51031cc3f903

-- 
Martin K. Petersen	Oracle Linux Engineering
