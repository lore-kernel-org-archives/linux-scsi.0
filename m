Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCB7C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D140206D5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgLBN2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:28:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6442 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbgLBN2V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:28:21 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DQdRu021231
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:27:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=et3HKOl0vxz5WgqKiXTZcKEKUenM2r67/rJdzYHpjP0=;
 b=f3P/1HOtnCUlm81DI9JRiYNtAK6GRwOukFHdi3XNk/1e/IgaQh7ke8KHRZxYdXnXn1xh
 uvvLVWcnIqbI2k6ZTDRQrlA7padzCkj9+SUrLv2ztfu2gpPkNVynbJ/gqmv9YO/R69vs
 I477ErRX0LfmexzxCKhkbeT/rqM8vn7EbTWY4de65i1lF48T4MzYv39AszVvs85Z6nm+
 D6Ik/Ub3ygMVY3HjXkGx70x5V9ykWdE0xIetjmZtK47tZ18wQwI6rIiisKrcEmF5IQMP
 3uCy55Dto40JRtJbEAe26OIC0TdTsEtR80Pm7AGtCtktnfLsnzuvJ2JX9suBioiZoMyv nw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 355w50a4c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:27:40 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:27:38 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:27:38 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:27:38 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 4814F3F703F;
        Wed,  2 Dec 2020 05:27:38 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DRcWn020083;
        Wed, 2 Dec 2020 05:27:38 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DRc06020073;
        Wed, 2 Dec 2020 05:27:38 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 10/15] qla2xxx: Handle aborts correctly for port undergoing deletion
Date:   Wed, 2 Dec 2020 05:23:07 -0800
Message-ID: <20201202132312.19966-11-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Call trace observed while shutting down the adapter ports (LINK DOWN).
Handle aborts correctly.

localhost kernel: INFO: task nvme:44209 blocked for more than 120 seconds.
localhost kernel: "echo 0 >/proc/sys/kernel/hung_task_timeout_secs" disables this message.
localhost kernel: nvme            D ffff88b45fb5acc0     0 44209 1 0x00000080
localhost kernel: Call Trace:
localhost kernel: [<ffffffffbd187169>] schedule+0x29/0x70
localhost kernel: [<ffffffffbd184c51>] schedule_timeout+0x221/0x2d0
localhost kernel: [<ffffffffbcad7229>] ? ttwu_do_wakeup+0x19/0xe0
localhost kernel: [<ffffffffbcad735f>] ? ttwu_do_activate+0x6f/0x80
localhost kernel: [<ffffffffbcada830>] ? try_to_wake_up+0x190/0x390
localhost kernel: [<ffffffffbd18751d>] wait_for_completion+0xfd/0x140
localhost kernel: [<ffffffffbcadaaf0>] ? wake_up_state+0x20/0x20
localhost kernel: [<ffffffffbcabe3da>] flush_work+0x10a/0x1b0
localhost kernel: [<ffffffffbcabb0f0>] ? move_linked_works+0x90/0x90
localhost kernel: [<ffffffffbcabe6cf>] flush_delayed_work+0x3f/0x50
localhost kernel: [<ffffffffc0452767>] nvme_fc_init_ctrl+0x657/0x6a0 [nvme_fc]
localhost kernel: [<ffffffffc045293a>] nvme_fc_create_ctrl+0x18a/0x210 [nvme_fc]
localhost kernel: [<ffffffffc028962f>] nvmf_dev_write+0x98f/0xb35 [nvme_fabrics]
localhost kernel: [<ffffffffbcd08927>] ? security_file_permission+0x27/0xa0
localhost kernel: [<ffffffffbcc4db50>] vfs_write+0xc0/0x1f0
localhost kernel: [<ffffffffbcc4e92f>] SyS_write+0x7f/0xf0
localhost kernel: [<ffffffffbd193f92>] system_call_fastpath+0x25/0x2a

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d4159d5a4ffd..eab559b3b257 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -227,7 +227,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
 	       __func__, sp, sp->handle, fcport, fcport->deleted);
 
-	if (!ha->flags.fw_started && fcport->deleted)
+	if (!ha->flags.fw_started || fcport->deleted)
 		goto out;
 
 	if (ha->flags.host_shutting_down) {
-- 
2.19.0.rc0

