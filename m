Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35984C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 02:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDLCIw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 22:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDLCIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 22:08:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A1530EB
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 19:08:51 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLWEXx016806;
        Wed, 12 Apr 2023 02:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=H4HVSGPQd5MdhtifX1t+9R3f95hv85PiULQeBrO3j8w=;
 b=tRso9KwCMGQ1tFCfpMsXEjdnFoVSFbICs8GstUJWqgXSKd+VgPAhAaHDY/F2iFdv/ehO
 QAQSYYZin0Y++eQNlnltiiNO3ShjQxJUPhsHPqQg7d2Vk2n9xQolDN6LOVHnLltOWS7k
 ItzF1bibcwYLzfvxJrG5wqjzg6s2Gx756Wa3aDxahmH1UlYCZ2/J92O4QkMZU5YQ5vpE
 qPobHo1DvSKt5tbtMEqZ0aqcP7SjN8UE3dgjCanJfHCBTJk30tCUrJOzufqBmh+lKuS3
 X0jK888Vg9wR2Twstn9pYP8StTaZiePBVRh6AL9/IvMzsCKJTQqfwROThb8dvHBo9NlP Qg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc6xdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:01 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BNmuN9008076;
        Wed, 12 Apr 2023 02:05:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc54tu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:00 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33C24xeO031283;
        Wed, 12 Apr 2023 02:04:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3puwc54tqc-2;
        Wed, 12 Apr 2023 02:04:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Some misc changes
Date:   Tue, 11 Apr 2023 22:04:42 -0400
Message-Id: <168126077057.185856.14866204895384383014.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
References: <1679283265-115066-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=832 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120016
X-Proofpoint-GUID: 7QRSYTQS_JHuayR9GFpHHY0oIX4UDhB3
X-Proofpoint-ORIG-GUID: 7QRSYTQS_JHuayR9GFpHHY0oIX4UDhB3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 20 Mar 2023 11:34:21 +0800, chenxiang wrote:

> This series contain some fixes including:
> - Grab sas_dev lock when traversing sas_dev list to avoid NULL pointer
> - Handle NCQ error when IPTT is valid
> - Ensure all enabled PHYs up during controller reset
> - Exit suspend state when usage count of runtime PM is greater than 0
> 
> Xingui Yang (2):
>   scsi: hisi_sas: Grab sas_dev lock when traversing the members of
>     sas_dev.list
>   scsi: hisi_sas: Handle NCQ error when IPTT is valid
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[1/4] scsi: hisi_sas: Grab sas_dev lock when traversing the members of sas_dev.list
      https://git.kernel.org/mkp/scsi/c/71fb36b5ff11
[2/4] scsi: hisi_sas: Handle NCQ error when IPTT is valid
      https://git.kernel.org/mkp/scsi/c/bb544224da77
[3/4] scsi: hisi_sas: Ensure all enabled PHYs up during controller reset
      https://git.kernel.org/mkp/scsi/c/89954f024c3a
[4/4] scsi: hisi_sas: Exit suspending state when usage count is greater than 0
      https://git.kernel.org/mkp/scsi/c/e368d38cb952

-- 
Martin K. Petersen	Oracle Linux Engineering
