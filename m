Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094FCC6FD1D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 04:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCQEEp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Mar 2023 00:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCQEEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2023 00:04:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE175CC10
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2023 21:04:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32H3YVvh016277;
        Fri, 17 Mar 2023 04:04:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=gnWrfW7/A3ADXIOcnZST36Lqt+EFBkmjSRaDvfhpHTs=;
 b=dVLYjIgYX/VFQBqFSxRolnMkk8zzZBGQrm1MTeirMznrgD/F/L8VXj2jHo0hE4Ct5MPg
 GtZvOXv2HpO4uOPPrKx0tnN5ro3IijrBmhaJ41kIGrx4ZkN8aPUOqsxIQ3ia6XDVYZAu
 bQphWn2fM7X5sttOLymem2b1eGohQA65nJk3TdWmp6qo9PP3B5CpuTMrwjcELVTWGaFc
 OSGWQsAqMMaW2OdmpImaisfH5Z0GpG+XVKgT1jKFSQN6eBKSGnTTFvyRa8xpD7wkGzU4
 GKfhMXt6C0KXlUNgQw2mNnUbOvvBzjyVj+VCmyO9e4p3Tf2GczyXTZBR08kAdtUndmsv cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs292vj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 04:04:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32H3UgHQ029713;
        Fri, 17 Mar 2023 04:04:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqq66kgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 04:04:24 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32H44Opk039895;
        Fri, 17 Mar 2023 04:04:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pbqq66kg0-1;
        Fri, 17 Mar 2023 04:04:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] Add poll support for hisi_sas v3 hw
Date:   Fri, 17 Mar 2023 00:04:15 -0400
Message-Id: <167902578897.2716271.17282536491781825038.b4-ty@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
References: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_01,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=614
 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303170023
X-Proofpoint-ORIG-GUID: ddsNY7X_qbXONuI_RM0wXRzCJYLp98Fu
X-Proofpoint-GUID: ddsNY7X_qbXONuI_RM0wXRzCJYLp98Fu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 07 Mar 2023 14:09:11 +0800, chenxiang wrote:

> To support IO_URING IOPOLL support for hisi_sas, need to do:
> - Add and fill mq_poll interface to poll queue;
> - For internal IOs (including internal abort IOs), need to deliver and
> complete them through non-iopoll queue (queue 0);
> 
> It only sends internal abort commands to non-poll queue which actually
> requires to send a internal abort command to every queue, so it still has
> a risk. Make iopoll support module parameter as "experimental".
> 
> [...]

Applied to 6.4/scsi-queue, thanks!

[1/4] scsi: hisi_sas: Add function complete_v3_hw()
      https://git.kernel.org/mkp/scsi/c/538a60468966
[2/4] scsi: hisi_sas: Add poll support for v3 hw
      https://git.kernel.org/mkp/scsi/c/0e47effa7706
[3/4] scsi: hisi_sas: Sync complete queue for poll queue
      https://git.kernel.org/mkp/scsi/c/b711ef5e176b
[4/4] scsi: hisi_sas: Add device attribute experimental_iopoll_q_cnt for v3 hw
      https://git.kernel.org/mkp/scsi/c/0c2fb1701155

-- 
Martin K. Petersen	Oracle Linux Engineering
