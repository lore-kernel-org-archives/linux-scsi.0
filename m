Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A63C83F15
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 01:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345665AbjHaBt2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345649AbjHaBtP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 21:49:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF4CC5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 18:49:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37V0DwCN025907;
        Thu, 31 Aug 2023 01:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=7Z3Nv8i07O9PEoRBT2Ze+xOP6paSDBXHdCsFDhIfPiY=;
 b=X77eXeO0g5gN08pnRjqe1fV2vm0QxV9veYtKJB2m+Sq06aK1Fy/L95zlsYq69Bl6O+Ur
 cfnwkh+h9l1hwlFoxZcvhjerrYwDhinH7lcNmi3TFLRvKGYenRFVYtSaHf6hi1OvsNAF
 nL9ioFVcnRWHHQQBKJIk3bI6Lj+Ye2694yhRx97NU51jBz3oUsh2gn/FyBhxhXwmElLo
 tIAIoIXkWcDr60eJnUkkYy11qfed0QYyLh74ksMwhP4XLrpkzHBWidVV4lSl+DlJFbmf
 xA8tWyidjH/kbZCpp7KcikZnlkM3QD/FwWU7Z1ctVDDfHeFYMm4jGG5mNQrSjWH5ZGnO vw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sq9k68sdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37V1ER7L032751;
        Thu, 31 Aug 2023 01:48:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sr6dqtxkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Aug 2023 01:48:56 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37V1mnKp000352;
        Thu, 31 Aug 2023 01:48:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3sr6dqtxfw-4;
        Thu, 31 Aug 2023 01:48:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        kumar.meiyappan@microchip.com, jeremy.reeves@microchip.com,
        david.strahan@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com,
        Don Brace <don.brace@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/8] smartpqi updates
Date:   Wed, 30 Aug 2023 21:48:31 -0400
Message-Id: <169344360121.1293881.3622180607162799833.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230824155812.789913-1-don.brace@microchip.com>
References: <20230824155812.789913-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-31_01,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=808 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308310014
X-Proofpoint-GUID: -qVsI0PtkRQasS8f_OPvJxm6tbEHT5Wv
X-Proofpoint-ORIG-GUID: -qVsI0PtkRQasS8f_OPvJxm6tbEHT5Wv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Aug 2023 10:58:04 -0500, Don Brace wrote:

> cat smartpqi_6.6_cover_letter
> These patches are based on Martin Petersen's 6.6/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.6/scsi-queue
> 
> The biggest functional change to smartpqi is the addition of an abort
> handler. Some customers were complaining about I/O stalls to all devices
> when only one device is reset. Adding an abort handler helps to prevent
> I/O stalls to all devices.
> 
> [...]

Applied to 6.6/scsi-queue, thanks!

[1/8] smartpqi: add abort handler
      https://git.kernel.org/mkp/scsi/c/153c45dd63ef
[2/8] smartpqi: refactor rename MACRO to clarify purpose
      https://git.kernel.org/mkp/scsi/c/43cf3a6eab58
[3/8] smartpqi: refactor rename pciinfo to pci_info
      https://git.kernel.org/mkp/scsi/c/e9c39117b448
[4/8] smartpqi: simplify lun_number assignment
      https://git.kernel.org/mkp/scsi/c/dad662c9fe50
[5/8] smartpqi: enhance shutdown notification
      https://git.kernel.org/mkp/scsi/c/276395d024cc
[6/8] smartpqi: enhance controller offline notification
      https://git.kernel.org/mkp/scsi/c/72b737fa73bf
[7/8] smartpqi: enhance error messages
      https://git.kernel.org/mkp/scsi/c/e1b919494aa9
[8/8] smartpqi: change driver version to 2.1.24-046
      https://git.kernel.org/mkp/scsi/c/08b7ad50c8bc

-- 
Martin K. Petersen	Oracle Linux Engineering
