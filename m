Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C890AE7D0BC
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 01:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjIVBGX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 21:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjIVBGW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 21:06:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EC4F5
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 18:06:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38LIsRq8018728;
        Fri, 22 Sep 2023 01:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=4UT5ta5NuMcrDnmHbRUc8rYysmM/Mif9cHd/fXt51Xs=;
 b=S4SWi7BOgSVSB/A3eoFsL/M1cBBrOKaO62AyCcZXrV5xExIXztCW03+Bjm4KO9hin2HC
 V3IUlyLwe28L18Un2M1xIwZgBJujsfdfg0baDV83M0KYw8V89X5LsJgW4U4zSnZOPOCu
 HfU8xHPdVCU2+XVUnc+BCY6I5MGTqM2YHc+t9/yI1ySFpjTRngi6eVkZ/44KCoFAARpX
 a4nenNGB5HtGmuzJJbbwJnw1YcJzoBPr+LUTgcaWyhNclNTp3ZqY6OXRjQYEnlqhwo+e
 VvH5f841a4K8bVTTF5/um6rrpMcSOtNty1QwftX+VEwfLiMiUWRBjwsjHha/RaBVA5Lc 8Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tt00ka6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:06:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38LMoYHe040524;
        Fri, 22 Sep 2023 01:06:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t8u19bn1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Sep 2023 01:06:04 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38M164sp032168;
        Fri, 22 Sep 2023 01:06:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t8u19bn0m-1;
        Fri, 22 Sep 2023 01:06:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        Alex Henrie <alexhenrie24@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: imm: Add a module parameter for the transfer mode
Date:   Thu, 21 Sep 2023 21:05:51 -0400
Message-Id: <169534443609.456601.14726604532293485281.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831054620.515611-1-alexhenrie24@gmail.com>
References: <20230831054620.515611-1-alexhenrie24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_01,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309220008
X-Proofpoint-GUID: V5AI-NOunaln2uyA00VmW30oRaqgwurg
X-Proofpoint-ORIG-GUID: V5AI-NOunaln2uyA00VmW30oRaqgwurg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Aug 2023 23:23:48 -0600, Alex Henrie wrote:

> Fix in the imm driver the same problem that was fixed in the ppa driver
> by commit 68a4f84a17c1 ("scsi: ppa: Add a module parameter for the
> transfer mode").
> 
> Tested and confirmed working with an Iomega Z250P zip drive and a
> StarTech PEX1P2 AX99100 PCIe parallel port.
> 
> [...]

Applied to 6.7/scsi-queue, thanks!

[1/1] scsi: imm: Add a module parameter for the transfer mode
      https://git.kernel.org/mkp/scsi/c/b0597fd5a953

-- 
Martin K. Petersen	Oracle Linux Engineering
