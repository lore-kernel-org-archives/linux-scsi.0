Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF37FEE49B2
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbjHYBN7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbjHYBNn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578041BFB
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:40 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJENTV021958;
        Fri, 25 Aug 2023 01:13:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=aFslsKHoiIvoq1xhHq6JtWXzDOm8ka0CE4o32ZM60nY=;
 b=ikju9Ww97xpJ8D4IpsZiyXDx3Eamb6RA06SEwGIsJltaSpsGQ++RQ08OAN0BL6h5d+7+
 yGh72cQ0a2nAIqeaMs7VXAF8y4yBYSSSf86zLosnMJ2Ul5txNwjLP7WGEqKYv8/pF4E3
 +yI8rS3r6YiqDkGkc9vbs8l6pKr0fte9pGx2udU65pSbjWXUaq2iZxdOqIyEZsc3vIUC
 Z7K9mIdXwGiSQ/l8NUilXRr1Th4HtPzjEplBrmZ7Uuw3Y0Hq3rM4iS8/NxjuDts4r8l5
 IrQDhkB2LouHZ10hiYGN74eDVZejtHIG0xVF4RtDNHl0NCAC1V6L+Jdoa2UZMtvbJx/U AA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yu5htj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0O6ai036234;
        Fri, 25 Aug 2023 01:13:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqffg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVDr019787;
        Fri, 25 Aug 2023 01:13:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-1;
        Fri, 25 Aug 2023 01:13:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        alan@llwyncelyn.cymru, Alex Henrie <alexhenrie24@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: ppa: Fix compilation with PPA_DEBUG=1
Date:   Thu, 24 Aug 2023 21:12:47 -0400
Message-Id: <169292577126.789945.137817386508344875.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230807155856.362864-1-alexhenrie24@gmail.com>
References: <20230807155856.362864-1-alexhenrie24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=849 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-GUID: _Ijxdrv6w10-ohIyY3Yps6qRgCl_iuxU
X-Proofpoint-ORIG-GUID: _Ijxdrv6w10-ohIyY3Yps6qRgCl_iuxU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 07 Aug 2023 09:52:57 -0600, Alex Henrie wrote:

> Fix a regression introduced in February 2003 in Linux 2.5.61 by a patch
> from Alan Cox titled "fix ppa for new scsi".[1]
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/2] scsi: ppa: Fix compilation with PPA_DEBUG=1
      https://git.kernel.org/mkp/scsi/c/b68442ebda9c
[2/2] scsi: ppa: Add a module parameter for the transfer mode
      https://git.kernel.org/mkp/scsi/c/68a4f84a17c1

-- 
Martin K. Petersen	Oracle Linux Engineering
