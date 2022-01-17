Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A1DC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jan 2022 13:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbiAQNyM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:54:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36074 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235891AbiAQNyL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Jan 2022 08:54:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20H99moO014239;
        Mon, 17 Jan 2022 05:54:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=PvBZc0TiJMRSxFZcqfjl1cdrRhcMYR3xmQy0NUBTnss=;
 b=VxLrYEjZskweeDLRzn0LFQ4ugbRsa2kQDT4UVngP0OmviQZAG21W4W9xaFtXNQ0DausM
 aZd2P8xKXPr+HA5GACB5o6alOCT2R7AmyPwGAhrq/da0QSB5npySE0ccN1ThvcJzaZ7G
 HEOBqUpuITOwscbO61a8/+FDM2phz4pUt4fSE2THvqqhlt9L9eckuVtbRIb3XlQyGj1r
 gvZ03qx9qx9NftuFG9nNwUH1SxKx117CRKCqQghKfpztvJMaO3EuEweMaMyHeX2m07T1
 JZR6+RXOc1wo35v685R3g956tElCpKV8VnnO+n+QDNvrD7R6xAGgl1RG5IvDcKFg8SMk VQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dn5gg8q0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 05:54:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 Jan
 2022 05:54:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 17 Jan 2022 05:54:07 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B50AC5B6921;
        Mon, 17 Jan 2022 05:54:07 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20HDs26S006307;
        Mon, 17 Jan 2022 05:54:02 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20HDrvhp006306;
        Mon, 17 Jan 2022 05:53:57 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <loberman@redhat.com>,
        <jpittman@redhat.com>, <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/3] qedf: Fix refcount issue when LOGO is received during TMF
Date:   Mon, 17 Jan 2022 05:53:10 -0800
Message-ID: <20220117135311.6256-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220117135311.6256-1-njavali@marvell.com>
References: <20220117135311.6256-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: b3HX0RiGwtsHiSIcCkIY1JgMsYT5oCmV
X-Proofpoint-GUID: b3HX0RiGwtsHiSIcCkIY1JgMsYT5oCmV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_06,2022-01-14_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Hung task call trace was seen during LOGO processing.

[  974.309060] [0000:00:00.0]:[qedf_eh_device_reset:868]: 1:0:2:0: LUN RESET Issued...
[  974.309065] [0000:00:00.0]:[qedf_initiate_tmf:2422]: tm_flags 0x10 sc_cmd 00000000c16b930f op = 0x2a target_id = 0x2 lun=0
[  974.309178] [0000:00:00.0]:[qedf_initiate_tmf:2431]: portid=016900 tm_flags =LUN RESET
[  974.309222] [0000:00:00.0]:[qedf_initiate_tmf:2438]: orig io_req = 00000000ec78df8f xid = 0x180 ref_cnt = 1.
[  974.309625] host1: rport 016900: Received LOGO request while in state Ready
[  974.309627] host1: rport 016900: Delete port
[  974.309642] host1: rport 016900: work event 3
[  974.309644] host1: rport 016900: lld callback ev 3
[  974.313243] [0000:61:00.2]:[qedf_execute_tmf:2383]:1: fcport is uploading, not executing flush.
[  974.313295] [0000:61:00.2]:[qedf_execute_tmf:2400]:1: task mgmt command success...
[  984.031088] INFO: task jbd2/dm-15-8:7645 blocked for more than 120 seconds.
[  984.031136]       Not tainted 4.18.0-305.el8.x86_64 #1

[  984.031166] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  984.031209] jbd2/dm-15-8    D    0  7645      2 0x80004080
[  984.031212] Call Trace:
[  984.031222]  __schedule+0x2c4/0x700
[  984.031230]  ? unfreeze_partials.isra.83+0x16e/0x1a0
[  984.031233]  ? bit_wait_timeout+0x90/0x90
[  984.031235]  schedule+0x38/0xa0
[  984.031238]  io_schedule+0x12/0x40
[  984.031240]  bit_wait_io+0xd/0x50
[  984.031243]  __wait_on_bit+0x6c/0x80
[  984.031248]  ? free_buffer_head+0x21/0x50
[  984.031251]  out_of_line_wait_on_bit+0x91/0xb0
[  984.031257]  ? init_wait_var_entry+0x50/0x50
[  984.031268]  jbd2_journal_commit_transaction+0x112e/0x19f0 [jbd2]
[  984.031280]  kjournald2+0xbd/0x270 [jbd2]
[  984.031284]  ? finish_wait+0x80/0x80
[  984.031291]  ? commit_timeout+0x10/0x10 [jbd2]
[  984.031294]  kthread+0x116/0x130
[  984.031300]  ? kthread_flush_work_fn+0x10/0x10
[  984.031305]  ret_from_fork+0x1f/0x40

There was a ref count issue when LOGO is received during TMF.
This leads to one of the IO hanging with the driver.
Fix the ref count.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 99a56ca1fb16..fab43dabe5b3 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2250,6 +2250,7 @@ int qedf_initiate_cleanup(struct qedf_ioreq *io_req,
 	    io_req->tm_flags == FCP_TMF_TGT_RESET) {
 		clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);
 		io_req->sc_cmd = NULL;
+		kref_put(&io_req->refcount, qedf_release_cmd);
 		complete(&io_req->tm_done);
 	}
 
-- 
2.23.1

