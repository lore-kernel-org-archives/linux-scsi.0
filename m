Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F382AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 03:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhLGDth (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 22:49:37 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4798 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhLGDtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 22:49:35 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5C1Z004496;
        Tue, 7 Dec 2021 03:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=2w2ys1vwRK9meV87Nt/7I/qZTMjOnqs0Uc7oBjaACbY=;
 b=kcEQ7uEwrWKxnu+M6KCSrTwToKn4Fjmlm04FcukWi0ez8/mI1sr7cEviEXZgquwRXkpF
 KeeYR1TKY/KpRaGzO+KI4En7hPEDii6YHAwupdhMFn8bD9Gd8jvFXaau+Vcha+UqLnJl
 G5M+u50usipmK9ZKXajoXuZQ9MXSBCNG+xbfIdVhlnq+JlPWLoLVsR9yKHAEe34RTNqN
 RpYpXCwiTrJ9MRVVqOqKsx46OAMsgbX5cZwfnvH8jSsD9LpP+y+A2JX/YI8q9PHScXii
 rmZg9P03KajH/o33xAazOCYJKf61DqsIpGSCqbXLiKOYoZxHwZGRv61GDKjRzjl3g9Lp XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjc08k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73f8Kr174104;
        Tue, 7 Dec 2021 03:46:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cqwex0gje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:46:00 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B73jxG9183597;
        Tue, 7 Dec 2021 03:45:59 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cqwex0ghy-1;
        Tue, 07 Dec 2021 03:45:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Manish Rangankar <mrangankar@marvell.com>, cleech@redhat.com,
        lduncan@suse.com, michael.christie@oracle.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 REPOST] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
Date:   Mon,  6 Dec 2021 22:45:56 -0500
Message-Id: <163884867621.17909.7370020569081635478.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211203095218.5477-1-mrangankar@marvell.com>
References: <20211203095218.5477-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 6wrJCH09LStnWvg5SK4u5wDOaOIPYcER
X-Proofpoint-ORIG-GUID: 6wrJCH09LStnWvg5SK4u5wDOaOIPYcER
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Dec 2021 01:52:18 -0800, Manish Rangankar wrote:

> When issued LUN reset under heavy i/o, we hit the qedi WARN_ON
> because of a mismatch in firmware i/o cmd cleanup request count
> and i/o cmd cleanup response count received. The mismatch is
> because of the race caused by the postfix increment of
> cmd_cleanup_cmpl.
> 
> [qedi_clearsq:1295]:18: fatal error, need hard reset, cid=0x0
> WARNING: CPU: 48 PID: 110963 at drivers/scsi/qedi/qedi_fw.c:1296 qedi_clearsq+0xa5/0xd0 [qedi]
> CPU: 48 PID: 110963 Comm: kworker/u130:0 Kdump: loaded Tainted: G        W
> Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 04/15/2020
> Workqueue: iscsi_conn_cleanup iscsi_cleanup_conn_work_fn [scsi_transport_iscsi]
> RIP: 0010:qedi_clearsq+0xa5/0xd0 [qedi]
>  RSP: 0018:ffffac2162c7fd98 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff975213c40ab8 RCX: 0000000000000000
>  RDX: 0000000000000000 RSI: ffff9761bf816858 RDI: ffff9761bf816858
>  RBP: ffff975247018628 R08: 000000000000522c R09: 000000000000005b
>  R10: 0000000000000000 R11: ffffac2162c7fbd8 R12: ffff97522e1b2be8
>  R13: 0000000000000000 R14: ffff97522e1b2800 R15: 0000000000000001
>  FS:  0000000000000000(0000) GS:ffff9761bf800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1a34e3e1a0 CR3: 0000000108bb2000 CR4: 0000000000350ee0
>  Call Trace:
>   qedi_ep_disconnect+0x533/0x550 [qedi]
>   ? iscsi_dbg_trace+0x63/0x80 [scsi_transport_iscsi]
>   ? _cond_resched+0x15/0x30
>   ? iscsi_suspend_queue+0x19/0x40 [libiscsi]
>   iscsi_ep_disconnect+0xb0/0x130 [scsi_transport_iscsi]
>   iscsi_cleanup_conn_work_fn+0x82/0x130 [scsi_transport_iscsi]
>   process_one_work+0x1a7/0x360
>   ? create_worker+0x1a0/0x1a0
>   worker_thread+0x30/0x390
>   ? create_worker+0x1a0/0x1a0
>   kthread+0x116/0x130
>   ? kthread_flush_work_fn+0x10/0x10
>   ret_from_fork+0x22/0x40
>  ---[ end trace 5f1441f59082235c ]---
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] qedi: Fix cmd_cleanup_cmpl counter mismatch issue.
      https://git.kernel.org/mkp/scsi/c/3fe5185db46f

-- 
Martin K. Petersen	Oracle Linux Engineering
