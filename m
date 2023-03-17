Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DC0C74A5B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 04:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCQEFW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCQEFO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2023 00:05:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CAA6544E
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 21:05:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GKYhPu001901;
        Fri, 17 Mar 2023 04:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=qpwTJIGxGCtJb0EWOOxoDZ7bzMoTw9oCHdk9okuxlnY=;
 b=v5yJ8XsL5Ge08JNOVKLgpVPoymwZsvJVF1DHSXK2qRBrKKzxhSe0pLGDNyfBcluTglCD
 Imy9R+2qsHLGC3tdLWbKI+BLElM8AaMUq+rAf20u7JjFKq+iR5WRJcd7JS/oIb2MceMk
 HxG4ArBRZmXYhbLhzVb4oH9YPtAmaARsEPOpXBVXMfl4H+7V+1pTBm+SvPIlCClyXL0Y
 oNUFp6SW8Ul6FXaU6mtHBziyk5kFiyitppHErf9jdughMyTNgmruqaVhv15pBxCiZnmE
 zHtmGM+aAKXc9q6qXhCmJ5IX9XGhZyJ7HCpRv+9xGvoI0FBNNp+umsDxuWh+Md+qkaos FA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2ajyan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 04:05:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H13nKO036897;
        Fri, 17 Mar 2023 04:05:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq9jfkpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 04:05:05 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32H454xt027487;
        Fri, 17 Mar 2023 04:05:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pbq9jfkkv-2;
        Fri, 17 Mar 2023 04:05:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        bhazarika@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
Subject: Re: [PATCH 0/2] qla2xxx driver fixes
Date:   Fri, 17 Mar 2023 00:04:53 -0400
Message-Id: <167902587501.2716429.15347737057799964013.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230313043711.13500-1-njavali@marvell.com>
References: <20230313043711.13500-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_01,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=490 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170023
X-Proofpoint-GUID: I6EAOyQY6dar08sH45qgwyNo0aJgKDch
X-Proofpoint-ORIG-GUID: I6EAOyQY6dar08sH45qgwyNo0aJgKDch
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Mar 2023 21:37:09 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver fixes to the scsi tree
> at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 6.3/scsi-fixes, thanks!

[1/2] qla2xxx: perform lockless command completion in abort path
      https://git.kernel.org/mkp/scsi/c/0367076b0817
[2/2] qla2xxx: synchronize the iocb count to be in order
      https://git.kernel.org/mkp/scsi/c/d3affdeb400f

-- 
Martin K. Petersen	Oracle Linux Engineering
