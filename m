Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3727C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E6C12250F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbhAKJd3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:33:29 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64588 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728377AbhAKJd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 04:33:29 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B9VIwT013271
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 01:32:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=JAbKQUZjnZVEDSeOC/3Y1bAI/hQc7x8dvGuOdiL+AfA=;
 b=P7PNKI0ZPC69XMLSZSRirZyIFkIgICGkX/cBC2NRtXncTf2Snh/o+fCWiZcpdMBBTiLR
 71FOp1sxb01VbhWcl1ab0voC8Z9ai18x3KaanyZgdC8uEKYM/VKy5OEpnbT+NhhEA89n
 V2uAmI9f/grCR8BO5pB7MSvd3kbLh08n6piBXCXhLLkaUk1fAD1QfMpmtKWyj5wArLSc
 MWb6rD/exRfEY5aVedgP0LI5tp8m7xz5IgfNOsw4qMzCzqydcsJm8QOAJuyauWz8msCf
 5ZTDRHqEGcT5VGMwBD1dXMWzjVgBTBRQjd+wbn4r8EzFYvnS/OoioV6vdYh6Dnxhkwwi xA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpkfyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 01:32:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 01:32:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 Jan 2021 01:32:46 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9AAE53F703F;
        Mon, 11 Jan 2021 01:32:46 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 10B9WkGZ001268;
        Mon, 11 Jan 2021 01:32:46 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 10B9Wkv0001258;
        Mon, 11 Jan 2021 01:32:46 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 2/7] qla2xxx: Add error counters to debugfs node
Date:   Mon, 11 Jan 2021 01:31:29 -0800
Message-ID: <20210111093134.1206-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210111093134.1206-1-njavali@marvell.com>
References: <20210111093134.1206-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Display error counters via debugfs node.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index d5ebcf7d70ff..ccce0eab844e 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -286,6 +286,10 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
 		core_qla_snd_status, qla_core_ret_sta_ctio, core_qla_free_cmd,
 		num_q_full_sent, num_alloc_iocb_failed, num_term_xchg_sent;
 	u16 i;
+	fc_port_t *fcport = NULL;
+
+	if (qla2x00_chip_is_down(vha))
+		return 0;
 
 	qla_core_sbt_cmd = qpair->tgt_counters.qla_core_sbt_cmd;
 	core_qla_que_buf = qpair->tgt_counters.core_qla_que_buf;
@@ -349,6 +353,30 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void *unused)
 		vha->qla_stats.qla_dif_stats.dif_ref_tag_err);
 	seq_printf(s, "DIF App tag err = %d\n",
 		vha->qla_stats.qla_dif_stats.dif_app_tag_err);
+
+	seq_puts(s, "\n");
+	seq_puts(s, "Initiator Error Counters\n");
+	seq_printf(s, "HW Error Count =		%14lld\n",
+		   vha->hw_err_cnt);
+	seq_printf(s, "Link Down Count =	%14lld\n",
+		   vha->short_link_down_cnt);
+	seq_printf(s, "Interface Err Count =	%14lld\n",
+		   vha->interface_err_cnt);
+	seq_printf(s, "Cmd Timeout Count =	%14lld\n",
+		   vha->cmd_timeout_cnt);
+	seq_printf(s, "Reset Count =		%14lld\n",
+		   vha->reset_cmd_err_cnt);
+	seq_puts(s, "\n");
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (!fcport || !fcport->rport)
+			continue;
+
+		seq_printf(s, "Target Num = %7d Link Down Count = %14lld\n",
+			   fcport->rport->number, fcport->tgt_short_link_down_cnt);
+	}
+	seq_puts(s, "\n");
+
 	return 0;
 }
 
-- 
2.19.0.rc0

