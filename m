Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736A1C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 02:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjEQCNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 22:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjEQCNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 22:13:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED50A49C1
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 19:12:59 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJxWrY010633;
        Wed, 17 May 2023 02:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=05UYmD9pGQVNz+WWHB2rq8ctVNqNg1EevcqNiHrYPn8=;
 b=IAH4/3hUuuX9iPYKrGOCbBXHIcmtigSm9IJIOmAB7VpDH6qG/ohQmMiE1dbran6MBEfH
 ZuorJLtjsRv2E7JgvHgUbYcKMnAK6R69CsOJXIi9QS/BfrlIKtSdK4WjkrwqejZmggyW
 k18lQvzNah83j6hSGN1l250LYRfzaqzQWlKwlWGLabtlgxx558F/Iw+9m+HzpVaQHZ2G
 jAhlP9yAjwgC4JFIJHSBAMnfX1KDxS5ynmMMZ2GwwgIZIAQby90Ha+Ya6UIkOQBrRgYO
 0HvZhBc22E+GKaplLhz7lrhBYA6hId50KHz8FH4O5AwMERMkA7RRpEWo6l92+6GWckfQ DA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj1fc4qgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34H26RsQ025028;
        Wed, 17 May 2023 02:12:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj104tw0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 02:12:42 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34H2CdOC016064;
        Wed, 17 May 2023 02:12:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qj104tw04-2;
        Wed, 17 May 2023 02:12:42 +0000
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
Subject: Re: [PATCH 00/12] smartpqi updates
Date:   Tue, 16 May 2023 22:12:25 -0400
Message-Id: <168428950418.722180.9968022205224958464.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170016
X-Proofpoint-ORIG-GUID: A-l10Y6XJ1mB_zlU5JTy3_Ps6CE11GNe
X-Proofpoint-GUID: A-l10Y6XJ1mB_zlU5JTy3_Ps6CE11GNe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Apr 2023 10:37:00 -0500, Don Brace wrote:

> These patches are based on Martin Petersen's 6.4/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.4/scsi-queue
> 
> This set of changes consists of:
> 
> * Map entire BAR 0.
>    The driver was mapping up to and including the controller registers,
>    but not all of BAR 0.
>  * Add PCI IDs to support new controllers.
>  * Clean up some code by removing unnecessary NULL checks.
>    This cleanup is a result of a Coverity report.
>  * Correct a rare memory leak whenever pqi_sas_port_add_rhpy() returns
>    an error. This was Suggested by: Yang Yingliang <yangyingliang@huawei.com>
>  * Remove atomic operations on variable raid_bypass_cnt. Accuracy is not
>    required for driver operation. Change type from atomic_t to unsigned int.
>  * Correct a rare drive hot-plug removal issue where we get a NULL
>    io_request. We added a check for this condition.
>  * Turn on NCQ priority for AIO requests to disks comprising RAID devices.
>  * Correct byte aligned writew() operations on some ARM servers. Changed
>    the writew() to two writeb() operations.
>  * Change how the driver checks for a sanitize operation in progress.
>    We were using TEST UNIT READY. We removed the TEST UNIT READY code and
>    are now using the controller's firmware information in order to avoid
>    issues caused by drives failing to complete TEST UNIT READY.
>  * Some customers have been requesting that we add the NUMA node
>    to /sys/block/sd<scsi device>/device like the nvme driver does.
>  * Update the copyright information to match the current year.
>  * Bump the driver version to 2.1.22-040.
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[01/12] smartpqi: map full length of PCI BAR 0
        https://git.kernel.org/mkp/scsi/c/3e7e55aa3df2
[02/12] smartpqi: Add new controller PCI IDs
        https://git.kernel.org/mkp/scsi/c/fe0375d48513
[03/12] smartpqi: remove null pointer check
        https://git.kernel.org/mkp/scsi/c/889cda36db99
[04/12] smartpqi: fix-rare-sas-transport-mem-leak
        https://git.kernel.org/mkp/scsi/c/2312e844dc8d
[05/12] smartpqi: Remove contention for raid_bypass_cnt
        https://git.kernel.org/mkp/scsi/c/80d560d94fa9
[06/12] smartpqi: validate block layer host tag
        https://git.kernel.org/mkp/scsi/c/5c9e3c1c5276
[07/12] smartpqi: Add support for RAID NCQ priority
        https://git.kernel.org/mkp/scsi/c/68f7920492be
[08/12] smartpqi: fix byte aligned writew for ARM servers
        https://git.kernel.org/mkp/scsi/c/c23efd9eadd8
[09/12] smartpqi: stop sending driver initiated TURs
        https://git.kernel.org/mkp/scsi/c/2eddf98d0152
[10/12] smartpqi: Add sysfs entry for numa node in /sys/block/sdX/device.
        https://git.kernel.org/mkp/scsi/c/d2c7583f27cc
[11/12] smartpqi: update copyright to 2023
        https://git.kernel.org/mkp/scsi/c/49fd52d4991f
[12/12] smartpqi: update version to 2.1.22-040
        https://git.kernel.org/mkp/scsi/c/fcb405111a24

-- 
Martin K. Petersen	Oracle Linux Engineering
