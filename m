Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F84BC43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiLADrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiLADqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F65E9FA8F
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:04 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B13PODq016237;
        Thu, 1 Dec 2022 03:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=qgkrcvzNcCEg+7bMHzkenKGoLfL/dLYpFuUrDB/8oYo=;
 b=OZ9/NDWyo/Y6pleME3MUowhh6ocuwyYok8TrlVWp4IWx9Aq4ugW8Y7hyy48B3v59IeN0
 PyrG+19XFgYbzWYR+8DWXEa4liMid5c8xpjwBFP12fn+rvjLClph6nKJFKQMOcew02L5
 XdehNzq5whXOOjd8ERM/cBm6kVktKlRR88Kb0N91nDifCKhkR3pXL7dOBOXCGrbus42J
 nPkppa4bTrIvnRCLESRir8snYPuE5GpB0+Z1kBu36RFqhFLZvBQbElgJNM36ctvMgnkq
 gjzHcSZ/bhhju86kLiYgeJV+BMtFrIYJBN9kanSxROFS0yWu+V6N/Rbxdd61l9jv7is0 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemjjp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B13NYw6007933;
        Thu, 1 Dec 2022 03:46:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbq6033801;
        Thu, 1 Dec 2022 03:45:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-23;
        Thu, 01 Dec 2022 03:45:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] scsi: sd: call SYNC 16 in place of SYNC 10 on ZBC devices
Date:   Thu,  1 Dec 2022 03:45:24 +0000
Message-Id: <166986602286.2101055.14295962844539176779.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115002905.1709006-1-shinichiro.kawasaki@wdc.com>
References: <20221115002905.1709006-1-shinichiro.kawasaki@wdc.com>
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
X-Proofpoint-ORIG-GUID: eM9exh6xed28l6NkMSmAqOIvmhLZ4KcC
X-Proofpoint-GUID: eM9exh6xed28l6NkMSmAqOIvmhLZ4KcC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Nov 2022 09:29:05 +0900, Shin'ichiro Kawasaki wrote:

> ZBC Zoned Block Commands specification mandates SYNCHRONIZE CACHE (16)
> for host-managed zoned block devices, but does not mandate SYNCHRONIZE
> CACHE (10). Call SYNCHRONIZE CACHE (16) in place of SYNCHRONIZE CACHE
> (10) to ensure that the command is always supported. For this purpose,
> add use_16_for_sync flag to struct scsi_device in same manner as
> use_16_for_rw flag.
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: sd: call SYNC 16 in place of SYNC 10 on ZBC devices
      https://git.kernel.org/mkp/scsi/c/42c590772886

-- 
Martin K. Petersen	Oracle Linux Engineering
