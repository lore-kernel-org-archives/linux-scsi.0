Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D5BEE0203
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbjINBl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbjINBlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:41:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205141FE6
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:41:04 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN5hqb029760;
        Thu, 14 Sep 2023 01:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Irww6ed4APlK+o1yUt5dTUei6eeB/udIWLsdKpThJrc=;
 b=W/MNlrcrhfSkaFkfBf+XUqK10gTX3lg47Pnjpk2tFFhvWgRHVDzU0pwzNtKC4nzZYaS7
 44qQ9qWSa08YcdQGMcZJKZzy3l3psNtQSBiyNA+NMS+8BiGCli12szRQLLT7AsNKMWty
 cRkF9MNr+153f9jZMp63274na6j23B8kAeNQKRm+E4GSD2EE6IOpZgfYgEUYKE7h2Vem
 j45auJy4AbaKF7mJZQdqoTue51Cc2lfqBGKUtUsoca7Tsr572u/zIb4mVC20u+Yq9iKA
 1mG3vAIYrvTyftEdoHQvPSbV+fNjtgk+7VSp//43jgnteiqm5PEHCHXmfZyarJa/TwMJ RQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7rbsbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38E1AEAx007686;
        Thu, 14 Sep 2023 01:40:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:51 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpd038417;
        Thu, 14 Sep 2023 01:40:50 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-9;
        Thu, 14 Sep 2023 01:40:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        Justin Tee <justin.tee@broadcom.com>,
        Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Fix Fix the NULL vs IS_ERR() bug for debugfs_create_file()
Date:   Wed, 13 Sep 2023 21:40:32 -0400
Message-Id: <169465549439.730690.13229441977185695462.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230906030809.2847970-1-ruanjinjie@huawei.com>
References: <20230906030809.2847970-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=924 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: 9UDJr6pzDEQrv886rc42_5YQvm--27BM
X-Proofpoint-GUID: 9UDJr6pzDEQrv886rc42_5YQvm--27BM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 06 Sep 2023 11:08:09 +0800, Jinjie Ruan wrote:

> Since debugfs_create_file() return ERR_PTR and never return NULL, so use
> IS_ERR() to check it instead of checking NULL.
> 
> 

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix Fix the NULL vs IS_ERR() bug for debugfs_create_file()
      https://git.kernel.org/mkp/scsi/c/7dcc683db363

-- 
Martin K. Petersen	Oracle Linux Engineering
