Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A4BC83012
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D80292065C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rafnqVC/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392168AbgLAQVq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:21:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43842 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392160AbgLAQVq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:21:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G4v54062860;
        Tue, 1 Dec 2020 16:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=xtGuR3iEY39Besy2+p0OPoRIlXoowV1B8IgiXcLXIP0=;
 b=rafnqVC/4z81JXuEzzedgnUYcOP/R5vBRRVI5u/bkAU7AdEwgg3X5JA3u4XoxBZi6CF4
 lZbogreStAoZi69TnPSnfYfFXXqCKePpKB1CMlS3QUmOVYuF0ixTw6vfydqEei1we3M6
 fuZGYRS2qKjG4wWc6bIHMZPynfMnMyF9JuIPBAZ23Nfhsc4xTyfSJJHfZnA6gaSwS3VA
 A0M8KhBagD3HRtqvz1fSe7NjvBkBexRYtz8U2BGwlGX3DN2sSnJ+TS1pCKx9z6SooM3e
 aH8zaKkmLB/57t1IllIGzWh1ol+AZl4sS19bFQuCOfsUjCoBUWwQR7I6JOh41GOHiSW6 /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2aukgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:21:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1G67Jm042822;
        Tue, 1 Dec 2020 16:19:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3540ey68p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:19:03 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GJ2JB000398;
        Tue, 1 Dec 2020 16:19:02 GMT
Received: from [192.168.1.15] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:19:02 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 12/15] qla2xxx: Fix the call trace for flush workqueue
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201201082730.24158-13-njavali@marvell.com>
Date:   Tue, 1 Dec 2020 10:19:00 -0600
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C2548017-BF58-4CFE-92FD-7D4748FE6A2A@oracle.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-13-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Saurav Kashyap <skashyap@marvell.com>
>=20
> The call trace was because workqueue was allocated without any
> flags, added WQ_MEM_RECLAIM as flag while allocation.
>=20
> kernel: workqueue: WQ_MEM_RECLAIM
> kblockd:blk_mq_run_work_fn is flushing !WQ_MEM_RECLAIM qla2xxx_wq:0x0
> kernel: WARNING: CPU: 0 PID: 2475 at
> kernel/workqueue.c:2593 check_flush_dependency+0x110/0x130
> kernel: CPU: 0 PID: 2475 Comm: kworker/0:1H Kdump:
> loaded Tainted: G           OE    --------- -  - 4.18.0-193.el8.x86_64 =
#1
> kernel: Hardware name: HPE ProLiant XL170r Gen10/ProLiant XL170r =
Gen10, BIOS U38 05/21/2019
> kernel: Workqueue: kblockd blk_mq_run_work_fn
> kernel: RIP: 0010:check_flush_dependency+0x110/0x130
> kernel: Code: ff ff 48 8b 50 18 48 8d 8b b0 00 00 00 49 89 e8 48 81 c6 =
b0 00 00 00 48 c7 c7 00 1e e9
> 	95 c6 05 dc 9a 2f 01 01 e8 1a 42 fe ff <0f> 0b e9 0a ff ff ff 80 =
3d ca 9a 2f 01 0 0 75 95 e9 41 ff ff ff 90
> kernel: RSP: 0018:ffffa40f48b2baf8 EFLAGS: 00010282
> kernel: RAX: 0000000000000000 RBX: ffff946795282600 RCX: =
0000000000000000
> kernel: RDX: 000000000000005f RSI: ffffffff96a1af7f RDI: =
0000000000000246
> kernel: RBP: 0000000000000000 R08: ffffffff96a1af20 R09: =
0000000000029480
> kernel: R10: 00080c89bb3e7462 R11: 00000000000009ab R12: =
ffff946773628000
> kernel: R13: 0000000000000282 R14: 0000000000000246 R15: =
ffffa40f48b2bb40
> kernel: FS: 	0000000000000000(0000) 	GS:ffff94679fa00000(0000) =
knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 00005570c4b60110 CR3: 000000029140a005 CR4: =
00000000007606f0
> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> kernel: PKRU: 55555554
> kernel: Call Trace:
> kernel: flush_workqueue+0x13a/0x440
> kernel: qla2x00_wait_for_sess_deletion+0x1d6/0x200 [qla2xxx]
> kernel: ? finish_wait+0x80/0x80
> kernel: qla2xxx_disable_port+0x2b/0x30 [qla2xxx]
> kernel: qla2x00_process_vendor_specific+0x1dc9/0x2d20 [qla2xxx]
> kernel: ? blk_rq_map_sg+0x195/0x570
> kernel: qla24xx_bsg_request+0x1a3/0xf90 [qla2xxx]
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c =
b/drivers/scsi/qla2xxx/qla_os.c
> index f9c8ae9d669e..a75edba2b334 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3265,7 +3265,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
> 	    "req->req_q_in=3D%p req->req_q_out=3D%p rsp->rsp_q_in=3D%p =
rsp->rsp_q_out=3D%p.\n",
> 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, =
rsp->rsp_q_out);
>=20
> -	ha->wq =3D alloc_workqueue("qla2xxx_wq", 0, 0);
> +	ha->wq =3D alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
> 	if (unlikely(!ha->wq)) {
> 		ret =3D -ENOMEM;
> 		goto probe_failed;
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

