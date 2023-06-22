Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818D7EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjFVB0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjFVB0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:26:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8ECA1BD8;
        Wed, 21 Jun 2023 18:26:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LK5bJB030242;
        Thu, 22 Jun 2023 01:26:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=iAvKvpyD9+AEm0PWWcS5pNEpyV0p7B5rAP8sfQGrQmo=;
 b=fOq0EIrG3x9/LkupnpUBeD6Db4s9m41tzBk4E0uKdMX6Gl8m7p3R1rTAgvDbDrgJBRnl
 oWwOz8z5XJAacTknRI+mejOHhwnaegkzcuRfVKLjn4IJ5jy4UM7OtesK5FRJ9qnjOA52
 S2K86IVOjWUS8/UTZYTSk3A8s7jX2OoJg6ud3VLCRNhdVwCbk+1hVsyMX2AppUd403Yf
 HSd4aS3ZIwVxEuS1HdC5DqhiTSP3amEjbxApa//eL+y2EzdCSqACRKeCGZm5dshaUWOr
 5ANDhF4bkqs80masSL+Evbnmk7z3n/a9cU0GzUQ5k6+8bxdJiTiO4lkrA+tXaQRFkFy1 Cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r94etru72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35LND5xG038725;
        Thu, 22 Jun 2023 01:26:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396thyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M1QXb1038374;
        Thu, 22 Jun 2023 01:26:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r9396thxp-6;
        Thu, 22 Jun 2023 01:26:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 0/7] scsi: fixes for targets with many LUNs, and scsi_target_block rework
Date:   Wed, 21 Jun 2023 21:26:24 -0400
Message-Id: <168739587263.247655.4343372939494166224.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230614103616.31857-1-mwilck@suse.com>
References: <20230614103616.31857-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306220009
X-Proofpoint-GUID: QULx5sih8EKdrRi84AvJ54A6XAHbwxOq
X-Proofpoint-ORIG-GUID: QULx5sih8EKdrRi84AvJ54A6XAHbwxOq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Jun 2023 12:36:09 +0200, mwilck@suse.com wrote:

> This patch series addresses some issues we saw in a test setup
> with a large number of SCSI LUNs. The first two patches simply
> increase the number of available sg and bsg devices. 3-5 fix
> a large delay we encountered between blocking a Fibre Channel
> remote port and the dev_loss_tmo. 6 renames scsi_target_block()
> to scsi_block_targets(), and makes additional changes to this API,
> as suggested in the review of the v2 series. 7 improves a warning message.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/7] bsg: increase number of devices
      https://git.kernel.org/mkp/scsi/c/9077fb2ab78c
[2/7] scsi: sg: increase number of devices
      https://git.kernel.org/mkp/scsi/c/37c918e03ef7
[3/7] scsi: merge scsi_internal_device_block() and device_block()
      https://git.kernel.org/mkp/scsi/c/c5e46f7ad43b
[4/7] scsi: don't wait for quiesce in scsi_stop_queue()
      https://git.kernel.org/mkp/scsi/c/d7035b73a73a
[5/7] scsi: don't wait for quiesce in scsi_device_block()
      https://git.kernel.org/mkp/scsi/c/e20fff8a1f49
[6/7] scsi: replace scsi_target_block() by scsi_block_targets()
      https://git.kernel.org/mkp/scsi/c/31950192d939
[7/7] scsi: improve warning message in scsi_device_block()
      https://git.kernel.org/mkp/scsi/c/6d7160c7da6f

-- 
Martin K. Petersen	Oracle Linux Engineering
