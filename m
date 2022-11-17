Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888E0C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240356AbiKQS3A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbiKQS24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:28:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE90A7C473
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:28:54 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHIPXQE014158;
        Thu, 17 Nov 2022 18:28:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=kDCnt0JWtMFLRcavd3UttqPpu8I7mE4yCGzQz1II49U=;
 b=KiTJWHjA4fks38LyIKOUiV6RVFvohX3h23WnqZdn5gU39ip9liStSKVcpE/VRXoJLrf0
 EuPHqd06crM6s+s3hNwT+r1r8VbUyAnlJONRwGZ0kerEmiJWywjGgVvjc4kbfEraWbr0
 OxsAojon/HKhUrJqN7ejOETjlYr6vUlB7mLuEc1zw79TWqj5LMoGEVcV0PkvKAyPq4OW
 3BOkayOStdpG3dlTtdVx0Oa+9bQ1YAESjvG1bMxcKgwtpSwpRDpGcURVPIrDsD3znnEk
 Mb5BGP1djIayVm2f4xV9ocRkuAxfpVMoJN9bb4JEeAZbA63UeCgPGjRiGu2l5j0rlpLf vg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3jst0mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHFlNg008684;
        Thu, 17 Nov 2022 18:28:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xft5rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHISanw025586;
        Thu, 17 Nov 2022 18:28:39 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kt1xft5pj-5;
        Thu, 17 Nov 2022 18:28:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, michael.christie@oracle.com,
        Zhou Guanghui <zhouguanghui1@huawei.com>, lduncan@suse.com,
        cleech@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Subject: Re: [PATCH v2] scsi: iscsi: fix possible memory leak when device_register failed
Date:   Thu, 17 Nov 2022 13:28:35 -0500
Message-Id: <166870940541.1572108.9806675424150133794.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221110033729.1555-1-zhouguanghui1@huawei.com>
References: <20221110033729.1555-1-zhouguanghui1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=923 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-ORIG-GUID: n2GK2G4JFAVLxdI2xOQneRjpXrWYW8ln
X-Proofpoint-GUID: n2GK2G4JFAVLxdI2xOQneRjpXrWYW8ln
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Nov 2022 03:37:29 +0000, Zhou Guanghui wrote:

> If device_register() returns error, the name allocated by the
> dev_set_name() need be freed. As described in the comment of
> device_register(), we should use put_device() to give up the
> reference in the error path.
> 
> Fix this by calling put_device(), the name will be freed in the
> kobject_cleanup(), and this patch modified resources will be
> released by calling the corresponding callback function in the
> device_release().
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: iscsi: fix possible memory leak when device_register failed
      https://git.kernel.org/mkp/scsi/c/f014165faa7b

-- 
Martin K. Petersen	Oracle Linux Engineering
