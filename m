Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38909C19F21
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 03:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbiG0DQ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 23:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbiG0DQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 23:16:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1DB3DF11;
        Tue, 26 Jul 2022 20:16:06 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2jYA8010356;
        Wed, 27 Jul 2022 03:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=eTNte9MIt+8Vvym1DvVtCpuN3efE4ZNpyAExgwkCahc=;
 b=jqC4JMIiVHMqBIwZajUXXmpp3Y4452TFiAurS5j4mYgXyIvpfKP8VBpWUw6Hb2DiBI5h
 RvHtcJI1eA0KHMJ/IBaoCtU0AVoYQjewalHFUmbHLJBlSgAfysOZeFGOxDF5PHWsuecQ
 gwMtygKNJ/XaLypO7w0E3s/rabe8Di0yyC79BpN3TMpSx8zQovw2g6RuZpP/YWDKqeFn
 81aSIxQC8HeVou5OrTnJ7b4Jd4i5gCu/1ZbjwEZXUu+lb214ZRXcFgm+RW6JPTmaHm6U
 jUyFpSQ6Xo5H3wioJqdK9Qr4W1AFT6wQFKWiidsVHGbRyCjmge/dCi/DDVK+ntK+xIAI Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9a9g7p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:16:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26QNebek034539;
        Wed, 27 Jul 2022 03:16:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh633p3vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:16:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26R3E0gu008228;
        Wed, 27 Jul 2022 03:16:01 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hh633p3uc-2;
        Wed, 27 Jul 2022 03:16:01 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: unlock on error path
Date:   Tue, 26 Jul 2022 23:15:55 -0400
Message-Id: <165889172880.804.11733311271243442734.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YtVCEsxMU8buuMjP@kili>
References: <YtVCEsxMU8buuMjP@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=744 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270009
X-Proofpoint-GUID: hP60CSNhmeP8mCVidWxQc3nULCUjwiGi
X-Proofpoint-ORIG-GUID: hP60CSNhmeP8mCVidWxQc3nULCUjwiGi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Jul 2022 14:20:50 +0300, Dan Carpenter wrote:

> There is some clean up necessary before returning.  Smatch complains:
> 
>     drivers/scsi/mpi3mr/mpi3mr_fw.c:4786 mpi3mr_soft_reset_handler()
>     warn: inconsistent returns '&mrioc->reset_mutex'.
>       Locked on  : 4730
>       Unlocked on: 4786
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: mpi3mr: unlock on error path
      https://git.kernel.org/mkp/scsi/c/2a8a0147cb52

-- 
Martin K. Petersen	Oracle Linux Engineering
