Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC62C6379F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Jan 2023 03:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjANDTh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjANDTg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 22:19:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0709B892ED
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2023 19:19:36 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30E2vw6U023661;
        Sat, 14 Jan 2023 03:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=pkffGIpZBNdI3TASeJWTkWR7Bdi+LB0HcGWCVPw+pEw=;
 b=i9BvjIBiFt8Grw7ElZ/7g/Gnr5SaQooGBl9ZCdJGQYIVww9unp+Qs1m+b2CWotUHr2dN
 5/sxy7rghKrC9QSmGgMcZ80VG9aAHfad6i9zY7BbFxJ539J1E/zTBlmzjHgqXwFPRdIY
 wiUrJGnr4bOXixv9p1bfPa+phdId3508GIqaDRPo4Oud8e/XtNir0gnTALkV3nh36iPd
 D2wMI6cmEI+S7Jfh5S31BLCtwAkY4NCdrAxQI7RfGKgg4GrQDTwQ/9cQL+q1nMp7G5ms
 dH5S06T0a6EkRwAv/1SUc6ZUzHfQT4L1Jrq1glslLpmi6vHESCdvgH5lq9gZwwR1wUhF Ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3kaa813t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30E2mjk4005846;
        Sat, 14 Jan 2023 03:19:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n3kxgrjut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 03:19:32 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30E3JVop032298;
        Sat, 14 Jan 2023 03:19:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3n3kxgrjun-1;
        Sat, 14 Jan 2023 03:19:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Justin Tee <justintee8345@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.10
Date:   Fri, 13 Jan 2023 22:19:25 -0500
Message-Id: <167366567316.3069740.1027608315657447483.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=881 phishscore=0
 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301140021
X-Proofpoint-GUID: oTXXg5gqf-eUBUxCDpku1CwSkVy9dSGu
X-Proofpoint-ORIG-GUID: oTXXg5gqf-eUBUxCDpku1CwSkVy9dSGu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 09 Jan 2023 15:33:05 -0800, Justin Tee wrote:

> Update lpfc to revision 14.2.0.10
> 
> This patch set contains fixes for bugs, kernel test robot, and introduces
> new attention type event handling.
> 
> The patches were cut against Martin's 6.3/scsi-queue tree.
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[01/12] lpfc: Fix space indentation in lpfc_xcvr_data
	https://git.kernel.org/mkp/scsi/c/6058304a66ba
[02/12] lpfc: Replace outdated strncpy with strscpy
	https://git.kernel.org/mkp/scsi/c/1f7b5f94f8d0
[03/12] lpfc: Resolve miscellaneous variable set but not used compiler warnings
	https://git.kernel.org/mkp/scsi/c/7ab07683aa4c
[04/12] lpfc: Set max dma segment size to hba supported SGE length
	https://git.kernel.org/mkp/scsi/c/b5c894cf430e
[05/12] lpfc: Remove redundant clean up code in disable_vport
	https://git.kernel.org/mkp/scsi/c/f81395570e6c
[06/12] lpfc: Remove duplicate ndlp kref decrement in lpfc_cleanup_rpis
	https://git.kernel.org/mkp/scsi/c/ecdf4ddf4eb7
[07/12] lpfc: Exit PRLI completion handling early if ndlp not in PRLI_ISSUE state
	https://git.kernel.org/mkp/scsi/c/c051f1a424a1
[08/12] lpfc: Fix use-after-free KFENCE violation during sysfs firmware write
	https://git.kernel.org/mkp/scsi/c/21681b81b9ae
[09/12] lpfc: Reinitialize internal VMID data structures after FLOGI completion
	https://git.kernel.org/mkp/scsi/c/f1d2337d3e58
[10/12] lpfc: Introduce new attention types for lpfc_sli4_async_fc_evt hdlr
	https://git.kernel.org/mkp/scsi/c/96fb8c34e5c1
[11/12] lpfc: Update lpfc version to 14.2.0.10
	https://git.kernel.org/mkp/scsi/c/41cf6bbe3d99
[12/12] Copyright updates for 14.2.0.10 patches
	https://git.kernel.org/mkp/scsi/c/191b5a38771d

-- 
Martin K. Petersen	Oracle Linux Engineering
