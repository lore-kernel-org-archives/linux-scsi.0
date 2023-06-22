Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F44EB64D7
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jun 2023 01:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjFVB0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 21:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjFVB0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 21:26:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C20A1BD2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 18:26:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKQH2E003650;
        Thu, 22 Jun 2023 01:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=dMgHshrUlQIFveB/CBZGmy8bH7J9o/VrypPqjUEUZwg=;
 b=IgZ85ABz0pNfbdtuCLXQJ3iKEmq2n8qmVf7nQFfTyjeHhHHKvuAm2supxRJHQef5nMaE
 SAWaHTyfAAHAOVYjolpFOfCDKP9F+ucjc+BifLXReuuVl8USjiE0JCQDH26hOn/QTvVS
 jV6Do9zSf1SVhKaZVWaL0u+c3x3uWvbFlloGvQLbEO398W1UB/z+ZV9hfpN9+qfL98J8
 d4sFKJG3dFJUVkaUKrwsoerkFjBqoTrC3NuRRikn1v9EBeWaqX/mWaI6XiikNw//9ipw
 zkNJn//DmYblqqBU5Om3MK+FFV6hSmZ1GDmlZs638W0NoGyACbEnHEzY9POJDrSs8hb+ Jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r95cu0qyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35M1EcFX038594;
        Thu, 22 Jun 2023 01:26:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r9396thyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 01:26:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M1QXb3038374;
        Thu, 22 Jun 2023 01:26:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3r9396thxp-7;
        Thu, 22 Jun 2023 01:26:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: Remove unused nvme_ls_waitq wait queue.
Date:   Wed, 21 Jun 2023 21:26:25 -0400
Message-Id: <168739587261.247655.4452828243282972404.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615074633.12721-1-njavali@marvell.com>
References: <20230615074633.12721-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_14,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=863 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306220009
X-Proofpoint-GUID: CTdCjL__kAhZjgNowYsSDUbgEkUjNFiT
X-Proofpoint-ORIG-GUID: CTdCjL__kAhZjgNowYsSDUbgEkUjNFiT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Jun 2023 13:16:33 +0530, Nilesh Javali wrote:

> System crash when qla2x00_start_sp(sp) returns error code EGAIN
> and wake_up gets called for uninitialized wait queue
> sp->nvme_ls_waitq.
> 
>     qla2xxx [0000:37:00.1]-2121:5: Returning existing qpair of ffff8ae2c0513400 for idx=0
>     qla2xxx [0000:37:00.1]-700e:5: qla2x00_start_sp failed = 11
>     BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>     PGD 0 P4D 0
>     Oops: 0000 [#1] SMP NOPTI
>     Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 09/03/2021
>     Workqueue: nvme-wq nvme_fc_connect_ctrl_work [nvme_fc]
>     RIP: 0010:__wake_up_common+0x4c/0x190
>     RSP: 0018:ffff95f3e0cb7cd0 EFLAGS: 00010086
>     RAX: 0000000000000000 RBX: ffff8b08d3b26328 RCX: 0000000000000000
>     RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff8b08d3b26320
>     RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffe8
>     R10: 0000000000000000 R11: ffff95f3e0cb7a60 R12: ffff95f3e0cb7d20
>     R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
>     FS:  0000000000000000(0000) GS:ffff8b2fdf6c0000(0000) knlGS:0000000000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 0000000000000000 CR3: 0000002f1e410002 CR4: 00000000007706e0
>     DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>     DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>     PKRU: 55555554
>     Call Trace:
>      __wake_up_common_lock+0x7c/0xc0
>      qla_nvme_ls_req+0x355/0x4c0 [qla2xxx]
>      ? __nvme_fc_send_ls_req+0x260/0x380 [nvme_fc]
>      ? nvme_fc_send_ls_req.constprop.42+0x1a/0x45 [nvme_fc]
>      ? nvme_fc_connect_ctrl_work.cold.63+0x1e3/0xa7d [nvme_fc]
> 
> [...]

Applied to 6.5/scsi-queue, thanks!

[1/1] qla2xxx: Remove unused nvme_ls_waitq wait queue.
      https://git.kernel.org/mkp/scsi/c/20fce500b232

-- 
Martin K. Petersen	Oracle Linux Engineering
