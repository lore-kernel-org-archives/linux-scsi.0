Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59ACEE0203
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbjINBlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbjINBlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:41:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BC71FD9
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:41:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38E17aOl000876;
        Thu, 14 Sep 2023 01:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=OAOCVNwMBnHQQBjP+bbqWbbYPspVMxo7qjhDfjQH2+c=;
 b=fXi0sg+34/TV+6obajR7mceCdZCWELW2nOo2nFGiZE+KIOOHDP+AUQaV2AD5acybUlU1
 at+fXFlS4imc8ZhFNmh+Wqs0BzRCfBncoKWEUiAlaZoiR3X+xLgXCUWXUnLaX90Cazx2
 DZTNqaGLYvDhln+XOcsmRh72xRIQy+1x1M2rGwjbUl+xrOW0qIEAi4AvPXaGD6AyVsbB
 zV4yGX6J2vtkMYJE8C87f3d2PSXEQYZKeR8uI9HBe4fcM80q+9UGNxoZL0RfaMuULMVK
 HhwniexOZAY7juRUoBE/HjXMc1wLqB+8FZTxTggd+FZ6Bm2l4Jv1ijzs5lOqDuvF2/WX ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7hbq3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38E0or42007757;
        Thu, 14 Sep 2023 01:40:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:52 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpf038417;
        Thu, 14 Sep 2023 01:40:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-10;
        Thu, 14 Sep 2023 01:40:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Arun Easi <aeasi@marvell.com>,
        Jinjie Ruan <ruanjinjie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date:   Wed, 13 Sep 2023 21:40:33 -0400
Message-Id: <169465549432.730690.9271533062136019845.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831140930.3166359-1-ruanjinjie@huawei.com>
References: <20230831140930.3166359-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=754 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: 1REysOYditWgn2qJkbsZhAKiQ2QoPWTR
X-Proofpoint-GUID: 1REysOYditWgn2qJkbsZhAKiQ2QoPWTR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 31 Aug 2023 22:09:29 +0800, Jinjie Ruan wrote:

> Since both debugfs_create_dir() and debugfs_create_file() return
> ERR_PTR and never return NULL, So use IS_ERR() to check it
> instead of checking NULL.
> 
> 

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
      https://git.kernel.org/mkp/scsi/c/d0b0822e32db

-- 
Martin K. Petersen	Oracle Linux Engineering
