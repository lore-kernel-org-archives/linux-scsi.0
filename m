Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697E3C76196
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 02:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDLCJF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 22:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjDLCJE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 22:09:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041A446B8
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 19:09:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLN8Tr016812;
        Wed, 12 Apr 2023 02:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=mv8148HRryzH7GPs8DfFYYjDk/klljCu0UrdIP1+Nw4=;
 b=LRvdKu3PRip0PNoBKgZBYzyzTRkFAh7i7CJ47BcrWZ1FvJcxZ46+pht6zZ5MtXyWCJDa
 96uYLBvTav36SfxFMgfPdSEKBIGlL0W87NtHnFjP/ITiKquGil2i6s6p/pRPUxOo51v1
 6dpyDBMd4EsQQkzM5uaPhBfdW7d1yn4bMA57O2A2IPwSWmpe7FljTwqcrSDZbMgOlSa/
 4I2Qze6TN+Dv1xhkxSfV+EK+ZHxSOX1anBaObAMKSVFHRHuJT/9mq6MOC98LZRIm9Dcz
 XHCfJdiqsNZYZQ5JrwG5VqY78dSAXlL8bEsJ/dO7/gq70ILGH/1atylhlIXWMygMfrTo BQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc6xe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C00xac008083;
        Wed, 12 Apr 2023 02:05:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc54tw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 02:05:03 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33C24xee031283;
        Wed, 12 Apr 2023 02:05:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3puwc54tqc-10;
        Wed, 12 Apr 2023 02:05:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com,
        Xingui Yang <yangxingui@huawei.com>
Subject: Re: [PATCH v3] scsi: libsas: abort all inflight requests when device is gone
Date:   Tue, 11 Apr 2023 22:04:50 -0400
Message-Id: <168126077047.185856.4443268819384701166.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230330110930.175539-1-yanaijie@huawei.com>
References: <20230330110930.175539-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=695 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120016
X-Proofpoint-GUID: Trc7ZcznXs5IrCJxyJwptKYSLCJWk7w-
X-Proofpoint-ORIG-GUID: Trc7ZcznXs5IrCJxyJwptKYSLCJWk7w-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Mar 2023 19:09:30 +0800, Jason Yan wrote:

> When a disk is removed with inflight IO, the application need to wait
> for 30 senconds(depends on the timeout configuration) to get back from
> the kernel. Xingui tried to fix this issue by aborting the ATA link for
> SATA devices[1]. However this approach left the SAS devices unresolved.
> 
> This patch try to fix this issue by aborting all inflight requests while
> the device is gone. This is implemented by itering the tagset.
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[1/1] scsi: libsas: abort all inflight requests when device is gone
      https://git.kernel.org/mkp/scsi/c/0e4b1791d9b1

-- 
Martin K. Petersen	Oracle Linux Engineering
