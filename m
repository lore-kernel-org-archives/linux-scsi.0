Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77591C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhKWDs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:48:26 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:17356 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232981AbhKWDsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:48:23 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN2Pv1f024190;
        Tue, 23 Nov 2021 03:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=p140Ja0mqfvE6BdD5q4qq/4GgkMFr3LY0L6EzEUbeMg=;
 b=jS43kzDyQEcHiwTpQ6wGL/Ol8HCaTc2MFFUb1CnNlFa9kxNQ8yMnL+d+5hWCtDdEQ1PC
 SaAEn/qYwFRaTMuGpljhPyK9Mi3ULuVuTl6oDb7uFE8EQdEOx6/5TwjeCWNpIaInMSCz
 CqGcfuC0jlGByvprQ2z4GTa/IuMN9zo70HV9f241pD1igZmtswJA/WO8h24yo8pft7UW
 KTOg0FR1NKgcsAFVpOovo4Tng/1EeGjJvK58LbOZlzw+MuZjTPdaoP908S8rteXP+8+n
 9vyYw5YDQGbwsrh+jvMH0zK9gzolUjSH5OXiK6W90ckdndQTCZ5yLQ62V3BVdKcrczye gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg5gj69m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:45:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3akN5044380;
        Tue, 23 Nov 2021 03:45:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3ceq2djd3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:45:11 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3jATp070854;
        Tue, 23 Nov 2021 03:45:10 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3ceq2djd2x-1;
        Tue, 23 Nov 2021 03:45:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        George Kennedy <george.kennedy@oracle.com>,
        dgilbert@interlog.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: sanity check block descriptor length in resp_mode_select
Date:   Mon, 22 Nov 2021 22:45:07 -0500
Message-Id: <163763907099.20472.9018819548553170425.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1637262208-28850-1-git-send-email-george.kennedy@oracle.com>
References: <1637262208-28850-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 5STSdlRBFyEU0x8Eagxj2o_QRvJ2luvf
X-Proofpoint-ORIG-GUID: 5STSdlRBFyEU0x8Eagxj2o_QRvJ2luvf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Nov 2021 14:03:28 -0500, George Kennedy wrote:

> In resp_mode_select() sanity check the block descriptor len to avoid UAF.
> 
> BUG: KASAN: use-after-free in resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
> Read of size 1 at addr ffff888026670f50 by task scsicmd/15032
> 
> CPU: 1 PID: 15032 Comm: scsicmd Not tainted 5.15.0-01d0625 #15
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:107
>  print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:257
>  kasan_report.cold.14+0x7d/0x117 mm/kasan/report.c:443
>  __asan_report_load1_noabort+0x14/0x20 mm/kasan/report_generic.c:306
>  resp_mode_select+0xa4c/0xb40 drivers/scsi/scsi_debug.c:2509
>  schedule_resp+0x4af/0x1a10 drivers/scsi/scsi_debug.c:5483
>  scsi_debug_queuecommand+0x8c9/0x1e70 drivers/scsi/scsi_debug.c:7537
>  scsi_queue_rq+0x16b4/0x2d10 drivers/scsi/scsi_lib.c:1521
>  blk_mq_dispatch_rq_list+0xb9b/0x2700 block/blk-mq.c:1640
>  __blk_mq_sched_dispatch_requests+0x28f/0x590 block/blk-mq-sched.c:325
>  blk_mq_sched_dispatch_requests+0x105/0x190 block/blk-mq-sched.c:358
>  __blk_mq_run_hw_queue+0xe5/0x150 block/blk-mq.c:1762
>  __blk_mq_delay_run_hw_queue+0x4f8/0x5c0 block/blk-mq.c:1839
>  blk_mq_run_hw_queue+0x18d/0x350 block/blk-mq.c:1891
>  blk_mq_sched_insert_request+0x3db/0x4e0 block/blk-mq-sched.c:474
>  blk_execute_rq_nowait+0x16b/0x1c0 block/blk-exec.c:63
>  sg_common_write.isra.18+0xeb3/0x2000 drivers/scsi/sg.c:837
>  sg_new_write.isra.19+0x570/0x8c0 drivers/scsi/sg.c:775
>  sg_ioctl_common+0x14d6/0x2710 drivers/scsi/sg.c:941
>  sg_ioctl+0xa2/0x180 drivers/scsi/sg.c:1166
>  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:52
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:50
>  entry_SYSCALL_64_after_hwframe+0x44/0xae arch/x86/entry/entry_64.S:113
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: sanity check block descriptor length in resp_mode_select
      https://git.kernel.org/mkp/scsi/c/e0a2c28da11e

-- 
Martin K. Petersen	Oracle Linux Engineering
