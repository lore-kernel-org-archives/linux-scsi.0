Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32F3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 05:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240348AbiCOFNv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 01:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344890AbiCOFNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 01:13:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C5949C8A
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 22:12:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3JkQn019890;
        Tue, 15 Mar 2022 05:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=a383ve6gQZ9xAjoU6/yeMuYCvtgHUgCXYZzTiet+PsU=;
 b=VxsL7Gexdmdm5REAFgD/IzGs1XFh81v4eJzB2e7EQw9ZK5BgP//3p2VQJQgbcMm+St+J
 2A4IBJAmAFkJS9F4WhakUlPDNg8BlJ6/+KwkBIwxi7E1htuY8UeCUtfHdqoxCzZbqSsD
 AAs8JT4+0EAzXIXnqThSJAfcOrpxu9aLRW5bMnb0yOecsnSmbUhYOLSjtC47Qz+aVVzS
 EUtcgcYVZcIcv4uGRllCpSabt39rn+gFeasgW9/Woay0NmDaA+xV2FNenog9w22Nq1HM
 uv/adVB9ZiaAeqXNnvzTAFZXH3STiP5INCJCWxXG0qClDAkLyC0pVYaPgtxSg+JK/tgr 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5xwhyk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:01:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22F4unuf096922;
        Tue, 15 Mar 2022 05:01:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3et65p9vr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:01:56 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22F51tan104374;
        Tue, 15 Mar 2022 05:01:55 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3et65p9vr1-1;
        Tue, 15 Mar 2022 05:01:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Matt Lupfer <mlupfer@ddn.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: page fault in reply q processing
Date:   Tue, 15 Mar 2022 01:01:53 -0400
Message-Id: <164732049215.22057.1608832955763378035.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <d625deae-a958-0ace-2ba3-0888dd0a415b@ddn.com>
References: <d625deae-a958-0ace-2ba3-0888dd0a415b@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: F03fzDfsv4SDFzwR6Nd7CuHjj5SUjuTr
X-Proofpoint-ORIG-GUID: F03fzDfsv4SDFzwR6Nd7CuHjj5SUjuTr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Mar 2022 15:27:02 +0000, Matt Lupfer wrote:

> We encountered a page fault in mpt3sas on a LUN reset error path:
> 
> [  145.763216] mpt3sas_cm1: Task abort tm failed: handle(0x0002),timeout(30) tr_method(0x0) smid(3) msix_index(0)
> [  145.778932] scsi 1:0:0:0: task abort: FAILED scmd(0x0000000024ba29a2)
> [  145.817307] scsi 1:0:0:0: attempting device reset! scmd(0x0000000024ba29a2)
> [  145.827253] scsi 1:0:0:0: [sg1] tag#2 CDB: Receive Diagnostic 1c 01 01 ff fc 00
> [  145.837617] scsi target1:0:0: handle(0x0002), sas_address(0x500605b0000272b9), phy(0)
> [  145.848598] scsi target1:0:0: enclosure logical id(0x500605b0000272b8), slot(0)
> [  149.858378] mpt3sas_cm1: Poll ReplyDescriptor queues for completion of smid(0), task_type(0x05), handle(0x0002)
> [  149.875202] BUG: unable to handle page fault for address: 00000007fffc445d
> [  149.885617] #PF: supervisor read access in kernel mode
> [  149.894346] #PF: error_code(0x0000) - not-present page
> [  149.903123] PGD 0 P4D 0
> [  149.909387] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  149.917417] CPU: 24 PID: 3512 Comm: scsi_eh_1 Kdump: loaded Tainted: G S         O      5.10.89-altav-1 #1
> [  149.934327] Hardware name: DDN           200NVX2             /200NVX2-MB          , BIOS ATHG2.2.02.01 09/10/2021
> [  149.951871] RIP: 0010:_base_process_reply_queue+0x4b/0x900 [mpt3sas]
> [  149.961889] Code: 0f 84 22 02 00 00 8d 48 01 49 89 fd 48 8d 57 38 f0 0f b1 4f 38 0f 85 d8 01 00 00 49 8b 45 10 45 31 e4 41 8b 55 0c 48 8d 1c d0 <0f> b6 03 83 e0 0f 3c 0f 0f 85 a2 00 00 00 e9 e6 01 00 00 0f b7 ee
> [  149.991952] RSP: 0018:ffffc9000f1ebcb8 EFLAGS: 00010246
> [  150.000937] RAX: 0000000000000055 RBX: 00000007fffc445d RCX: 000000002548f071
> [  150.011841] RDX: 00000000ffff8881 RSI: 0000000000000001 RDI: ffff888125ed50d8
> [  150.022670] RBP: 0000000000000000 R08: 0000000000000000 R09: c0000000ffff7fff
> [  150.033445] R10: ffffc9000f1ebb68 R11: ffffc9000f1ebb60 R12: 0000000000000000
> [  150.044204] R13: ffff888125ed50d8 R14: 0000000000000080 R15: 34cdc00034cdea80
> [  150.054963] FS:  0000000000000000(0000) GS:ffff88dfaf200000(0000) knlGS:0000000000000000
> [  150.066715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  150.076078] CR2: 00000007fffc445d CR3: 000000012448a006 CR4: 0000000000770ee0
> [  150.086887] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  150.097670] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  150.108323] PKRU: 55555554
> [  150.114690] Call Trace:
> [  150.120497]  ? printk+0x48/0x4a
> [  150.127049]  mpt3sas_scsih_issue_tm.cold.114+0x2e/0x2b3 [mpt3sas]
> [  150.136453]  mpt3sas_scsih_issue_locked_tm+0x86/0xb0 [mpt3sas]
> [  150.145759]  scsih_dev_reset+0xea/0x300 [mpt3sas]
> [  150.153891]  scsi_eh_ready_devs+0x541/0x9e0 [scsi_mod]
> [  150.162206]  ? __scsi_host_match+0x20/0x20 [scsi_mod]
> [  150.170406]  ? scsi_try_target_reset+0x90/0x90 [scsi_mod]
> [  150.178925]  ? blk_mq_tagset_busy_iter+0x45/0x60
> [  150.186638]  ? scsi_try_target_reset+0x90/0x90 [scsi_mod]
> [  150.195087]  scsi_error_handler+0x3a5/0x4a0 [scsi_mod]
> [  150.203206]  ? __schedule+0x1e9/0x610
> [  150.209783]  ? scsi_eh_get_sense+0x210/0x210 [scsi_mod]
> [  150.217924]  kthread+0x12e/0x150
> [  150.224041]  ? kthread_worker_fn+0x130/0x130
> [  150.231206]  ret_from_fork+0x1f/0x30
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: page fault in reply q processing
      https://git.kernel.org/mkp/scsi/c/69ad4ef868c1

-- 
Martin K. Petersen	Oracle Linux Engineering
