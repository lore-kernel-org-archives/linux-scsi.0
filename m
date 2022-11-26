Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F378C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 03:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiKZD2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 22:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiKZD16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 22:27:58 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A3F13D77
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 19:27:57 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AQ32DZF017128;
        Sat, 26 Nov 2022 03:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=v+2JblnBqhJp++gsxOJaF38ymm9CvQf9EhBuMJEpTS4=;
 b=PlzdUT4KFNXqMqRAVUW1zyLcbnyp41KLxio3b5uECnuhApEBDMkP1QSAh2YODz0OMFnC
 tEUzXaxuCfyN4Ro9BxJ5Uk0aq/EKVFn7nIzTEkScfRcvr663nTBjZlrm9c0n8GBCFXdv
 /GIX/mEqhRpZP5dbtVV0b9Tiu+wYOboJ72uWtFh/G9WH1EPBM0wQasTHmvhGgGYl3uHO
 plSRjmSzYcemFqqRiSb5UlFK+Vg1ZgSm9/6iK4X/FD5xH3N8Xq7OdPOuGgkMg1V2hEyX
 PWqdotIOtjQwSdgWO6LqR0FfYjz43l2UMF1CMZNy9xF4aN1XdKNqat1+KHspDR8+XpP0 wA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m397f8250-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AQ1XTW9007302;
        Sat, 26 Nov 2022 03:27:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3988b7yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 03:27:44 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AQ3RhsR028327;
        Sat, 26 Nov 2022 03:27:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m3988b7y9-3;
        Sat, 26 Nov 2022 03:27:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hch@infradead.org, Kevin.Barnett@microchip.com, POSWALD@suse.com,
        kumar.meiyappan@microchip.com, joseph.szczypek@hpe.com,
        mike.mcgowen@microchip.com, jejb@linux.vnet.ibm.com,
        scott.benesh@microchip.com, jeremy.reeves@microchip.com,
        gerry.morong@microchip.com, scott.teel@microchip.com,
        Don Brace <don.brace@microchip.com>,
        Justin.Lindley@microchip.com, murthy.bhat@microchip.com,
        mahesh.rajashekhara@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] smartpqi updates
Date:   Sat, 26 Nov 2022 03:27:34 +0000
Message-Id: <166943312541.1684293.537092185896417245.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-26_02,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxlogscore=654 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260024
X-Proofpoint-ORIG-GUID: TWxOTz9i68RMT3WotMkP43Wc9LcNFYLY
X-Proofpoint-GUID: TWxOTz9i68RMT3WotMkP43Wc9LcNFYLY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Nov 2022 13:21:32 -0600, Don Brace wrote:

> These patches are based on Martin Petersen's 6.2/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.2/scsi-queue
> 
> This set of changes consists of:
>  * Add support for host_tagset.
>    Originally proposed by Hannes Reinecke here:
>    At the time, we wanted to fully test multipath failover before
>    accepting his patch. There have been a few changes in our queuing layer
>    since his patch, so I'm applying it with the required updates.
>    We moved the reserved command section to the end of the command pool,
>    eliminating some math in the submission threads.
>  * Add PCI-IDs for new storage devices.
>  * Corrects maximum LUN number for multi-actuator devices. This update
>    is more cosmetic. No bugs have been filed.
>  * Change the sysfs "raid_level" entry to "N/A" for controller devices.
>  * Correct a rare kernel Oops when removing the smartpqi driver managing
>    multi-actuator devices.
>  * Add in a controller cache flush during driver removal.
>  * Initialize our feature_section structures to 0. More of an alignment
>    with our in-house driver.
>  * Bump the driver version to 2.1.20-035
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/8] smartpqi: convert to host_tagset
      https://git.kernel.org/mkp/scsi/c/b27ac2faa2fc
[2/8] smartpqi: Add new controller PCI IDs
      https://git.kernel.org/mkp/scsi/c/0b93cf2a9097
[3/8] smartpqi: correct max lun number
      https://git.kernel.org/mkp/scsi/c/7c56850637ea
[4/8] smartpqi: change sysfs raid_level attribute to N/A for controllers
      https://git.kernel.org/mkp/scsi/c/cbe42ac15698
[5/8] smartpqi: correct device removal for multiactuator devices
      https://git.kernel.org/mkp/scsi/c/cc9befcbbb5e
[6/8] smartpqi: add controller cache flush during rmmod
      https://git.kernel.org/mkp/scsi/c/14063fb625c4
[7/8] smartpqi: initialize feature section info
      https://git.kernel.org/mkp/scsi/c/921800a1deea
[8/8] smartpqi: change version to 2.1.20-035
      https://git.kernel.org/mkp/scsi/c/2ae45329a956

-- 
Martin K. Petersen	Oracle Linux Engineering
