Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15105C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbiKQS2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiKQS2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:28:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22174742FE
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:28:41 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHGFMd7007332;
        Thu, 17 Nov 2022 18:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=FsByhvWq9O6a8wiPrAHR1GJnIIBZwa85thwxtq7GXZM=;
 b=ojEo/Dd9PEm0f5P8rRy/VLoigJqkvivtRsEhrHUGIx9l2dW1EuUeVRbvc6XTuFdo/7iU
 Q8m1tbGcNAp2O2KNfTqynJ59ilJlmDZEdm4iQgK84ucAVRRe6SVsuC2mQi6UMjXdBEP6
 QB76ZbzKUYmk1N6gX2L8UW3jfvb0997AHfxeozTUHoD9ReSdOOoytQGHkiMdwNPnn5wA
 pAGmF/IUPIxi66RZbxVoWV4423W40O80MRe5Gk7c55mnJiOHIU4BDAEbqVknjZGrcivK
 a4HZ0/WXIbxzFDgT1qyrt/Hah/2Ne4RR/TOsF2sHvOXQYAGTZJ5Qem62jIobwG1rSm6f oA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv3nsa6f3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHHZPj008784;
        Thu, 17 Nov 2022 18:28:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xft5qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:38 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHISanq025586;
        Thu, 17 Nov 2022 18:28:37 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kt1xft5pj-2;
        Thu, 17 Nov 2022 18:28:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2] scsi: mpi3mr: suppress command reply debug prints
Date:   Thu, 17 Nov 2022 13:28:32 -0500
Message-Id: <166870940535.1572108.4916613943315175596.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221111014449.1649968-1-shinichiro.kawasaki@wdc.com>
References: <20221111014449.1649968-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-GUID: gsm8YDfn5EegPZzhuCmcPoRRARVHPsS0
X-Proofpoint-ORIG-GUID: gsm8YDfn5EegPZzhuCmcPoRRARVHPsS0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Nov 2022 10:44:49 +0900, Shin'ichiro Kawasaki wrote:

> After it receives command reply, mpi3mr driver checks command result. If
> the result is not zero, it prints out command information. This debug
> information is confusing since they are printed even when the non-zero
> result is expected. "Power-on or device reset occurred" is printed for
> Test Unit Ready command at drive detection. Inquiry failure for
> unsupported VPD page header is also printed. They are harmless but look
> like failures.
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: mpi3mr: suppress command reply debug prints
      https://git.kernel.org/mkp/scsi/c/7d21fcfb4095

-- 
Martin K. Petersen	Oracle Linux Engineering
