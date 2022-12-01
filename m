Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5FAC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiLADrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiLADqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353459FEF2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:10 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1297Hj022941;
        Thu, 1 Dec 2022 03:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ln4VY3AYABdaUlLq9wLOD6B58K9GMKmYjpAtdb45I6w=;
 b=LZ2ASMCI+iaTdQR587h/mw9retYVhSByQVQAcTNCaU6Uq/00qzXsobPYeY/jx31Lgz1X
 GrsskpQdf1OCvI5G9PQ6bzZtvvCtNTyLpe+J09K9aOmJ7GkDiTsyMN5elo+Fzhaz79SF
 U7+MFqKUFfOx5MzJ5td5Mkn5gj00xyOfiZ1RHBOzzs7p6Fvq0yj8BDHcYCqQtYFgTc5y
 Ozf8ubh7Q9NiQksNGrABFV8IvmApzUW7krh8qS8oSBNtUgPwPjZpLpdZ8WojuEY9V71Y
 Mmop1swNZJvww7QH2uxC6J30X4SpibTXL1ol5qkXcWoA00E2CXAqsutXKKDVRuJRDVrJ tA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B12NVZi007685;
        Thu, 1 Dec 2022 03:46:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2d1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:04 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbqG033801;
        Thu, 1 Dec 2022 03:46:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-28;
        Thu, 01 Dec 2022 03:46:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com
Subject: Re: [PATCH] scsi: scsi_debug: fix possible name leak in sdebug_add_host_helper()
Date:   Thu,  1 Dec 2022 03:45:29 +0000
Message-Id: <166986602284.2101055.6946595367935631373.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221112131010.3757845-1-yangyingliang@huawei.com>
References: <20221112131010.3757845-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: QHXEGMRMyPduhDpdXH80V2Sg8Kd8msmC
X-Proofpoint-ORIG-GUID: QHXEGMRMyPduhDpdXH80V2Sg8Kd8msmC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 12 Nov 2022 21:10:10 +0800, Yang Yingliang wrote:

> Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
> bus_id string array"), the name of device is allocated dynamically,
> it needs be freed, when device_register() returns error.
> 
> As comment of device_register() says, it should use put_device()
> to give up the reference in the error path. So fix this by calling
> put_device(), then the name can be freed in kobject_cleanup(), and
> sdbg_host is freed in sdebug_release_adapter().
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: scsi_debug: fix possible name leak in sdebug_add_host_helper()
      https://git.kernel.org/mkp/scsi/c/e6d773f93a49

-- 
Martin K. Petersen	Oracle Linux Engineering
