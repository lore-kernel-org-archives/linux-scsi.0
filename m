Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275C9C4708D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLADqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLADp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:45:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992C49AE2D
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:45:53 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B133ci6022994;
        Thu, 1 Dec 2022 03:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=x3lDptogdHqXU2CEHg3j8EpJdYD/L7+x0mAd2pxDEaE=;
 b=ub74/3Xe0/hH3qZm7Gta4mM1dBRMriYcxijR3tMXBhaLjXbxLYcuVwKpDEwSjOuWGTS6
 C+2jJTu6rveuhT2D2P2QF4RPIjhIrsQyI9rgEpkbLVIOSrysS5Nn4L2n813l6fVAW8xK
 miVivFE8OzGITdVcep58TwgcWXkVmPeGy2n2yyLGcGLcKGNfUIPI2FziC4jiEuabjrAn
 umekn8XqWUo0ZMe0ZK9+7dgsRzD7Q/QdVl8FbLFR3E1XWCnlXZcqm/wDfqQoxFe82wdb
 flm0hoYr5UF0dVWy3A3TYchhn3jTicvDvGU1YOqMf36uIoL5NIwu57fEkDCChOvmsIMR 4Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y43enw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:42 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B13BPOj007645;
        Thu, 1 Dec 2022 03:45:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbpU033801;
        Thu, 1 Dec 2022 03:45:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-5;
        Thu, 01 Dec 2022 03:45:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, nmusini@cisco.com, sebaddel@cisco.com,
        Gaosheng Cui <cuigaosheng1@huawei.com>, JBottomley@Odin.com,
        kartilak@cisco.com, hare@suse.de
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Fix possible UAF in snic_tgt_create
Date:   Thu,  1 Dec 2022 03:45:06 +0000
Message-Id: <166986602290.2101055.12272748018432463980.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221117035100.2944812-1-cuigaosheng1@huawei.com>
References: <20221117035100.2944812-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=855 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: 5YSX35nlQdKS-i_-G4Y_uvfgMbfyEJK7
X-Proofpoint-ORIG-GUID: 5YSX35nlQdKS-i_-G4Y_uvfgMbfyEJK7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Nov 2022 11:51:00 +0800, Gaosheng Cui wrote:

> Smatch report warning as follows:
> 
> drivers/scsi/snic/snic_disc.c:307 snic_tgt_create() warn:
>   '&tgt->list' not removed from list
> 
> If device_add() fails in snic_tgt_create(), tgt will be freed, but
> tgt->list will not be removed from snic->disc.tgt_list, then list
> traversal may cause UAF.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: snic: Fix possible UAF in snic_tgt_create
      https://git.kernel.org/mkp/scsi/c/e118df492320

-- 
Martin K. Petersen	Oracle Linux Engineering
