Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885A1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 13:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiEENGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 09:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376555AbiEENGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 09:06:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E3F562E4
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 06:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E65761DFA
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 13:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6F01C385A4
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 13:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651755789;
        bh=/gFi2ewnd58ygBh6Mx6uB6noejZplB1O8zrnBuZa/Yw=;
        h=From:To:Subject:Date:From;
        b=BfaUr6ktCJMd+3PNxyhgndRIrSE5qUvvVic2XCUJMmiVZEyGY3KkYtvow37ot4EY/
         NnGC/88RwzFcCy2s7mZz6UogwxPvNBtOBcWl7PmcBEyC+rKTuNRmn7vjH2mrlnO9jh
         JOsG1pJOweeDotFfKfLqTi9H84i7IuTq8tDAWCVb+dHelpgM8usdWnswLhWhJeEP2O
         7hgG1v2foZ1nNgUzeRHZyKyGLZDccIRMS4mDW+9v4K+MPOku7pL86hp8PaO4xj1WBL
         n/AZCNkeMEKDnxVcCUET47X9G9+npR0pFplzzY+u1ZZmiMjSYtEq4RA5nQQARaf5bi
         /BHC/NTwV/UrA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C76E0CAC6E2; Thu,  5 May 2022 13:03:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 215943] New: UBSAN: array-index-out-of-bounds in
 drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
Date:   Thu, 05 May 2022 13:03:09 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: christian.d.dietrich@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-215943-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215943

            Bug ID: 215943
           Summary: UBSAN: array-index-out-of-bounds in
                    drivers/scsi/megaraid/megaraid_sas_fp.c:103:32
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.15.27
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: christian.d.dietrich@gmail.com
        Regression: No

This bug also seems to affect other users / hardware:
https://www.spinics.net/lists/kernel/msg4294764.html (H710P: LSI 2008 / H730
mini & H730P: LSI 3108)

Apart from the kernel message, everything seems to be working so far.

AVAGO MegaRAID SAS 9361-4i controller:

Basics :
=3D=3D=3D=3D=3D=3D
Controller =3D 0
Model =3D AVAGO MegaRAID SAS 9361-4i
Serial Number =3D SK71088275
Current Controller Date/Time =3D 05/05/2022, 12:55:31
Current System Date/time =3D 05/05/2022, 14:55:30
SAS Address =3D 500605b00cd3ce20
PCI Address =3D 00:51:00:00
Mfg Date =3D 03/13/17
Rework Date =3D 00/00/00
Revision No =3D 12A


Version :
=3D=3D=3D=3D=3D=3D=3D
Firmware Package Build =3D 24.21.0-0148
Firmware Version =3D 4.680.00-8555
CPLD Version =3D 26747-01A
Bios Version =3D 6.36.00.3_4.19.08.00_0x06180205
HII Version =3D 03.25.05.14
Ctrl-R Version =3D 5.19-0606
Preboot CLI Version =3D 01.07-05:#%0000
NVDATA Version =3D 3.1705.00-0024
Boot Block Version =3D 3.07.00.00-0004
Driver Name =3D megaraid_sas
Driver Version =3D 07.717.02.00-rc1

Kernel message:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
UBSAN: array-index-out-of-bounds in
/build/linux-HMZHpV/linux-5.15.0/drivers/scsi/megaraid/megaraid_sas_fp.c:10=
3:32
index 1 is out of range for type 'MR_LD_SPAN_MAP [1]'
CPU: 41 PID: 268 Comm: kworker/41:0H Not tainted 5.15.0-27-generic #28-Ubun=
tu
Hardware name: Supermicro Super Server/H11DSU-iN, BIOS 1.3 07/15/2019
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 <TASK>
 show_stack+0x52/0x58
 dump_stack_lvl+0x4a/0x5f
 dump_stack+0x10/0x12
 ubsan_epilogue+0x9/0x45
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 MR_BuildRaidContext+0xa5a/0xb50 [megaraid_sas]
 megasas_build_ldio_fusion+0x5b5/0x9a0 [megaraid_sas]
 megasas_build_io_fusion+0x40e/0x450 [megaraid_sas]
 megasas_build_and_issue_cmd_fusion+0xa5/0x370 [megaraid_sas]
 megasas_queue_command+0x1b5/0x1f0 [megaraid_sas]
 ? ktime_get+0x46/0xc0
 scsi_dispatch_cmd+0x93/0x1f0
 scsi_queue_rq+0x2d1/0x690
 blk_mq_dispatch_rq_list+0x126/0x600
 ? __sbitmap_queue_get+0x1/0x10
 __blk_mq_do_dispatch_sched+0xba/0x2d0
 ? ttwu_do_wakeup+0x1c/0x160
 __blk_mq_sched_dispatch_requests+0x104/0x150
 blk_mq_sched_dispatch_requests+0x35/0x60
 __blk_mq_run_hw_queue+0x34/0xb0
 blk_mq_run_work_fn+0x1b/0x20
 process_one_work+0x22b/0x3d0
 worker_thread+0x53/0x410
 ? process_one_work+0x3d0/0x3d0
 kthread+0x12a/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
UBSAN: array-index-out-of-bounds in
/build/linux-HMZHpV/linux-5.15.0/drivers/scsi/megaraid/megaraid_sas_fp.c:10=
3:32
index 1 is out of range for type 'MR_LD_SPAN_MAP [1]'
CPU: 41 PID: 268 Comm: kworker/41:0H Not tainted 5.15.0-27-generic #28-Ubun=
tu
Hardware name: Supermicro Super Server/H11DSU-iN, BIOS 1.3 07/15/2019
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 <TASK>
 show_stack+0x52/0x58
 dump_stack_lvl+0x4a/0x5f
 dump_stack+0x10/0x12
 ubsan_epilogue+0x9/0x45
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 ? _printk+0x58/0x6f
 MR_GetPhyParams+0x3d9/0x700 [megaraid_sas]
 ? ubsan_epilogue+0x15/0x45
 MR_BuildRaidContext+0x402/0xb50 [megaraid_sas]
 megasas_build_ldio_fusion+0x5b5/0x9a0 [megaraid_sas]
 megasas_build_io_fusion+0x40e/0x450 [megaraid_sas]
 megasas_build_and_issue_cmd_fusion+0xa5/0x370 [megaraid_sas]
 megasas_queue_command+0x1b5/0x1f0 [megaraid_sas]
 ? ktime_get+0x46/0xc0
 scsi_dispatch_cmd+0x93/0x1f0
 scsi_queue_rq+0x2d1/0x690
 blk_mq_dispatch_rq_list+0x126/0x600
 ? __sbitmap_queue_get+0x1/0x10
 __blk_mq_do_dispatch_sched+0xba/0x2d0
 ? ttwu_do_wakeup+0x1c/0x160
 __blk_mq_sched_dispatch_requests+0x104/0x150
 blk_mq_sched_dispatch_requests+0x35/0x60
 __blk_mq_run_hw_queue+0x34/0xb0
 blk_mq_run_work_fn+0x1b/0x20
 process_one_work+0x22b/0x3d0
 worker_thread+0x53/0x410
 ? process_one_work+0x3d0/0x3d0
 kthread+0x12a/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
UBSAN: array-index-out-of-bounds in
/build/linux-HMZHpV/linux-5.15.0/drivers/scsi/megaraid/megaraid_sas_fp.c:11=
5:31
index 1 is out of range for type 'MR_LD_SPAN_MAP [1]'
CPU: 41 PID: 268 Comm: kworker/41:0H Not tainted 5.15.0-27-generic #28-Ubun=
tu
Hardware name: Supermicro Super Server/H11DSU-iN, BIOS 1.3 07/15/2019
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 <TASK>
 show_stack+0x52/0x58
 dump_stack_lvl+0x4a/0x5f
 dump_stack+0x10/0x12
 ubsan_epilogue+0x9/0x45
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 ? _printk+0x58/0x6f
 MR_GetPhyParams+0x509/0x700 [megaraid_sas]
 MR_BuildRaidContext+0x402/0xb50 [megaraid_sas]
 megasas_build_ldio_fusion+0x5b5/0x9a0 [megaraid_sas]
 megasas_build_io_fusion+0x40e/0x450 [megaraid_sas]
 megasas_build_and_issue_cmd_fusion+0xa5/0x370 [megaraid_sas]
 megasas_queue_command+0x1b5/0x1f0 [megaraid_sas]
 ? ktime_get+0x46/0xc0
 scsi_dispatch_cmd+0x93/0x1f0
 scsi_queue_rq+0x2d1/0x690
 blk_mq_dispatch_rq_list+0x126/0x600
 ? __sbitmap_queue_get+0x1/0x10
 __blk_mq_do_dispatch_sched+0xba/0x2d0
 ? ttwu_do_wakeup+0x1c/0x160
 __blk_mq_sched_dispatch_requests+0x104/0x150
 blk_mq_sched_dispatch_requests+0x35/0x60
 __blk_mq_run_hw_queue+0x34/0xb0
 blk_mq_run_work_fn+0x1b/0x20
 process_one_work+0x22b/0x3d0
 worker_thread+0x53/0x410
 ? process_one_work+0x3d0/0x3d0
 kthread+0x12a/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
UBSAN: array-index-out-of-bounds in
/build/linux-HMZHpV/linux-5.15.0/drivers/scsi/megaraid/megaraid_sas_fp.c:12=
5:9
index 1 is out of range for type 'MR_LD_SPAN_MAP [1]'
CPU: 41 PID: 268 Comm: kworker/41:0H Not tainted 5.15.0-27-generic #28-Ubun=
tu
Hardware name: Supermicro Super Server/H11DSU-iN, BIOS 1.3 07/15/2019
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 <TASK>
 show_stack+0x52/0x58
 dump_stack_lvl+0x4a/0x5f
 dump_stack+0x10/0x12
 ubsan_epilogue+0x9/0x45
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 ? _printk+0x58/0x6f
 MR_GetPhyParams+0x407/0x700 [megaraid_sas]
 MR_BuildRaidContext+0x402/0xb50 [megaraid_sas]
 megasas_build_ldio_fusion+0x5b5/0x9a0 [megaraid_sas]
 megasas_build_io_fusion+0x40e/0x450 [megaraid_sas]
 megasas_build_and_issue_cmd_fusion+0xa5/0x370 [megaraid_sas]
 megasas_queue_command+0x1b5/0x1f0 [megaraid_sas]
 ? ktime_get+0x46/0xc0
 scsi_dispatch_cmd+0x93/0x1f0
 scsi_queue_rq+0x2d1/0x690
 blk_mq_dispatch_rq_list+0x126/0x600
 ? __sbitmap_queue_get+0x1/0x10
 __blk_mq_do_dispatch_sched+0xba/0x2d0
 ? ttwu_do_wakeup+0x1c/0x160
 __blk_mq_sched_dispatch_requests+0x104/0x150
 blk_mq_sched_dispatch_requests+0x35/0x60
 __blk_mq_run_hw_queue+0x34/0xb0
 blk_mq_run_work_fn+0x1b/0x20
 process_one_work+0x22b/0x3d0
 worker_thread+0x53/0x410
 ? process_one_work+0x3d0/0x3d0
 kthread+0x12a/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
UBSAN: array-index-out-of-bounds in
/build/linux-HMZHpV/linux-5.15.0/drivers/scsi/megaraid/megaraid_sas_fp.c:15=
1:32
index 1 is out of range for type 'MR_LD_SPAN_MAP [1]'
CPU: 41 PID: 268 Comm: kworker/41:0H Not tainted 5.15.0-27-generic #28-Ubun=
tu
Hardware name: Supermicro Super Server/H11DSU-iN, BIOS 1.3 07/15/2019
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
 <TASK>
 show_stack+0x52/0x58
 dump_stack_lvl+0x4a/0x5f
 dump_stack+0x10/0x12
 ubsan_epilogue+0x9/0x45
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 ? _printk+0x58/0x6f
 MR_GetPhyParams+0x47f/0x700 [megaraid_sas]
 MR_BuildRaidContext+0x402/0xb50 [megaraid_sas]
 megasas_build_ldio_fusion+0x5b5/0x9a0 [megaraid_sas]
 megasas_build_io_fusion+0x40e/0x450 [megaraid_sas]
 megasas_build_and_issue_cmd_fusion+0xa5/0x370 [megaraid_sas]
 megasas_queue_command+0x1b5/0x1f0 [megaraid_sas]
 ? ktime_get+0x46/0xc0
 scsi_dispatch_cmd+0x93/0x1f0
 scsi_queue_rq+0x2d1/0x690
 blk_mq_dispatch_rq_list+0x126/0x600
 ? __sbitmap_queue_get+0x1/0x10
 __blk_mq_do_dispatch_sched+0xba/0x2d0
 ? ttwu_do_wakeup+0x1c/0x160
 __blk_mq_sched_dispatch_requests+0x104/0x150
 blk_mq_sched_dispatch_requests+0x35/0x60
 __blk_mq_run_hw_queue+0x34/0xb0
 blk_mq_run_work_fn+0x1b/0x20
 process_one_work+0x22b/0x3d0
 worker_thread+0x53/0x410
 ? process_one_work+0x3d0/0x3d0
 kthread+0x12a/0x150
 ? set_kthread_struct+0x50/0x50
 ret_from_fork+0x22/0x30
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
