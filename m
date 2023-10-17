Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E606DCDB465
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 01:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbjJQBMm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 21:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbjJQBMh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 21:12:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2CD11C
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 18:12:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO3eU011113;
        Tue, 17 Oct 2023 01:12:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=8MkbDOFIIqVTnXmlDLBzoe5BJV+y4iy5257XGu7kwtc=;
 b=GsKXzH96u2u+BGH94siL4ak0dBPe3E4z6NHD6QBZnFnZ82DuDqLiR+BwTC9y/JgXHFbN
 9Slo1eSi5uVb2WhLF/jiwFUHVFDw8SDnfnvRdbWD06Xxfsm7pp13r/hvbzM5qjXaWYh7
 5GO3CeyYGMf4ztTZ4P5HfhFKJxaqVVte3HszwBE9V2kKlZmv7RGQRbhxyxRgUXx4C9AM
 j8rjTWbDlcVzKucRfN9daW8xqJ6JdewvVk6Xa2M6xLhxNkh2uOe7EPPVPJV3HAOVK6vi
 d941ckYqmlZmlx1yrmcrbGUh6evTdRHB8utFa1hfwRCNc71qMO/e099m4VfqqA4Lp387 IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjync0vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GMib41021644;
        Tue, 17 Oct 2023 01:12:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg50bkep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 01:12:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39H1Bjk4034771;
        Tue, 17 Oct 2023 01:12:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3trg50bke5-1;
        Tue, 17 Oct 2023 01:12:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: Fix double free of dsd_list during driver load.
Date:   Mon, 16 Oct 2023 21:12:21 -0400
Message-Id: <169750497323.2313994.2748057191639043894.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016101749.5059-1-njavali@marvell.com>
References: <20231016101749.5059-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=509
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170008
X-Proofpoint-GUID: 5UtVh1cP29QbIicqcZ1pjPTH-GZgO-7i
X-Proofpoint-ORIG-GUID: 5UtVh1cP29QbIicqcZ1pjPTH-GZgO-7i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Oct 2023 15:47:49 +0530, Nilesh Javali wrote:

> On driver load, scsi_add_host can fail. This trigger the free path
> to call qla2x00_mem_free() multiple times. This cause Null pointer
> access of ha->base_qpair. Add check before access to free.
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
>  IP: [<ffffffffc118f73c>] qla2x00_mem_free+0x51c/0xcb0 [qla2xxx]
>  PGD 8000001fcfe4a067 PUD 1fc8f0a067 PMD 0
>  Oops: 0000 [#1] SMP
>  RIP: 0010:[<ffffffffc118f73c>]  [<ffffffffc118f73c>] qla2x00_mem_free+0x51c/0xcb0 [qla2xxx]
>  RSP: 0018:ffff8ace97a93a30  EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff8ace8efd0000 RCX: 000000000000488f
>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>  RBP: ffff8ace97a93a60 R08: 000000000001f040 R09: ffffffff8678209b
>  R10: ffff8acf7d6df040 R11: ffffc591c0fcc980 R12: ffffffff87034800
>  R13: ffff8acf0e3cc740 R14: ffff8ace8efd0000 R15: 00000000fffffff4
>  FS:  00007f4cf5449740(0000) GS:ffff8acf7d6c0000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000030 CR3: 0000001fc2f6c000 CR4: 00000000007607e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
>   [<ffffffff86781f18>] ? kobject_put+0x28/0x60
>   [<ffffffffc119a59c>] qla2x00_probe_one+0x19fc/0x3040 [qla2xxx]
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] qla2xxx: Fix double free of dsd_list during driver load.
      https://git.kernel.org/mkp/scsi/c/097c06394c83

-- 
Martin K. Petersen	Oracle Linux Engineering
