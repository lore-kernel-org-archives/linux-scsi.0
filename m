Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159B4EE021F
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjINBlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbjINBk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:40:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507FC1BD4
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:40:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DJwhoc015361;
        Thu, 14 Sep 2023 01:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=rsYNyaQKSQXS4boYG5J3POOK1L/2OtxKzRYS7dzNJpk=;
 b=MzlkWyZfEpQtwXX+toyf/4wafkfT490qUArX81L1dBHRvqCTjEJ7leRbFfAK1gJm3Wql
 /WQRM8zVqkfuw+b3KAREExtHarHfGQwqYUwgzqp+ce3E16GoMqFjKwv+L4rA/KdpAXVm
 T3VK+cswIlNS38ihYlc6cry/2chwrLM1GzOn2nenxwFKqC7vX1apP8cTTB2j9abPeuKf
 wKIbBoEAOW4vzivz9uTARIV6LVf+sNQ6urV/b7IfZPosUr9fN5engj89ebohx+QLk1jm
 JQp/W3nA2wIRa8RU0I4DGNCNIzHfozc+uvHLptsxlDfeN9O/Tk7JQoAn56tmNw0jhq59 vw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t37jr30bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38E1Ufd2007598;
        Thu, 14 Sep 2023 01:40:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:49 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpb038417;
        Thu, 14 Sep 2023 01:40:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-8;
        Thu, 14 Sep 2023 01:40:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: use raw_smp_processor_id instead of smp_processor_id
Date:   Wed, 13 Sep 2023 21:40:31 -0400
Message-Id: <169465549429.730690.822218619437035719.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230831112146.32595-2-njavali@marvell.com>
References: <20230831112146.32595-1-njavali@marvell.com> <20230831112146.32595-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=904 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: hP6pOQgpL9HiC8FTZ405HqTV63zZn_it
X-Proofpoint-GUID: hP6pOQgpL9HiC8FTZ405HqTV63zZn_it
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 31 Aug 2023 16:51:46 +0530, Nilesh Javali wrote:

> Following Call Trace was observed,
> 
> localhost kernel: nvme nvme0: NVME-FC{0}: controller connect complete
> localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u129:4/75092
> localhost kernel: nvme nvme0: NVME-FC{0}: new ctrl: NQN "nqn.1992-08.com.netapp:sn.b42d198afb4d11ecad6d00a098d6abfa:subsystem.PR_Channel2022_RH84_subsystem_291"
> localhost kernel: caller is qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> localhost kernel: CPU: 6 PID: 75092 Comm: kworker/u129:4 Kdump: loaded Tainted: G    B   W  OE    --------- ---  5.14.0-70.22.1.el9_0.x86_64+debug #1
> localhost kernel: Hardware name: HPE ProLiant XL420 Gen10/ProLiant XL420 Gen10, BIOS U39 01/13/2022
> localhost kernel: Workqueue: nvme-wq nvme_async_event_work [nvme_core]
> localhost kernel: Call Trace:
> localhost kernel: dump_stack_lvl+0x57/0x7d
> localhost kernel: check_preemption_disabled+0xc8/0xd0
> localhost kernel: qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] qla2xxx: use raw_smp_processor_id instead of smp_processor_id
      https://git.kernel.org/mkp/scsi/c/59f10a05b5c7

-- 
Martin K. Petersen	Oracle Linux Engineering
