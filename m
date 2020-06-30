Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97995C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B5A2065F
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="fEseR8QZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732645AbgF3Krl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:41 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.67]:59762 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732632AbgF3Krj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514056; i=@ts.fujitsu.com;
        bh=vdzn2Shggcu4jOjLNhNNQQPV0VmW/oVluZjnN8K18Vs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=fEseR8QZVZZ4seiYo2tYi3iIyojz/9sCzcsrHxVMSmQr208ZX8mk94nIyRjgwvYW2
         QBTiHkj7aO1zasjsj2M+vW7BE3YlguRwfm3fwWdIxit4UXSd3iMvh/YkMRqqmuJ6M+
         inLF5WnF5okT3PdmtmxrfBIjn8osW40WnS+SPj8HEmVtAG/keGsFcYSr8kmX517aq1
         2EkwoXJDF1MbSdHlM4aaeSOlTsV518nfwyhTjCDRXkvJeQpb3IZQHFL4+ZVRyxT207
         2Sf43n9BqAGPCrH+XDDeJVrpG7y+DlvImcSHSCJw1TQJFlRU3DdDjI2t6PV5Sz2f8o
         rqo1M5ZYJPuWw==
Received: from [100.112.199.31] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id 5C/10-51693-7481BFE5; Tue, 30 Jun 2020 10:47:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MxRddd4ne
  cwZH/qhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjD9v21kK
  HslXtF2+zt7AeE66i5GLQ0hgMqPE7/9rmLoYOYGc6YwS+17WgthsAgYSKybdZwEpEhFYwyix8
  s48ZpAEs4CexLR/69hBbGEBN4m3M9ewgdgsAqoSi1ddZASxeQXsJHpfrGEBsSUE5CU6DkwGsz
  kF7CXWHj7NArHMTmLt5plsExi5FzAyrGK0SCrKTM8oyU3MzNE1NDDQNTQ00jW0tNA1NDfWS6z
  STdJLLdUtTy0u0TXUSywv1iuuzE3OSdHLSy3ZxAgMk5SCY2t3MPa8+aB3iFGSg0lJlPfev19x
  QnxJ+SmVGYnFGfFFpTmpxYcYZTg4lCR428V+xwkJFqWmp1akZeYAQxYmLcHBoyTC2y4ElOYtL
  kjMLc5Mh0idYlSUEuddCdInAJLIKM2Da4PFySVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwr
  wJ4kBTeDLzSuCmvwJazAS0+JrWL5DFJYkIKakGpmn/+n9ZHpgizxY358XvUJNd/qo9axmFzv+
  a+L+qIuId82z/zlXN+wPZVvwscFOsvS4fdXBRldMRht8NL9nOGYgFbQ+ZayS40PeM/6omq/lf
  j4Xa5s5XPc2m7rv/VnfYDMc5Cp7fqyt/8IulVLu6fshg2G5aWM2mmfJiCcOtu8e2nnu7ZleUt
  W7E+89qQrGyLRdin2fFdhdwFWj5RZotYTitqpzO+LbpM8vXrrVrcr02T7f7P3XSoeOu/zc/n7
  Vp5rZPM2Ymt1zM9zVY4JcSqGHXVPJP4Za2+JS397P/LnPeKLF17Tr9zHV6a+qeHL3xK7DNe5Z
  I1u9DIjVPDnzc9Xqq8y/7pw/UnXpY2VSzQpVYijMSDbWYi4oTAbZ6oIsOAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-4.tower-287.messagelabs.com!1593514054!1111983!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 25731 invoked from network); 30 Jun 2020 10:47:35 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-4.tower-287.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlT9V025874;
        Tue, 30 Jun 2020 11:47:29 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 065D3206A5;
        Tue, 30 Jun 2020 12:47:29 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 2/8] scsi: target: Add tmr_notify backend function
Date:   Tue, 30 Jun 2020 12:47:03 +0200
Message-Id: <20200630104709.23066-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Target core is modified to call an optional backend
callback function if a TMR is received or commands
are aborted implicitly after a PR command was received.
The backend function takes as parameters the se_dev, the
type of the TMR, and the list of aborted commands.
If no commands were aborted, an empty list is supplied.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_tmr.c       | 16 +++++++++++++++-
 drivers/target/target_core_transport.c |  1 +
 include/target/target_core_backend.h   |  2 ++
 include/target/target_core_base.h      |  1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index b65d7a0a5df1..39d93357db65 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -116,6 +116,7 @@ void core_tmr_abort_task(
 	struct se_tmr_req *tmr,
 	struct se_session *se_sess)
 {
+	LIST_HEAD(aborted_list);
 	struct se_cmd *se_cmd, *next;
 	unsigned long flags;
 	bool rc;
@@ -144,7 +145,7 @@ void core_tmr_abort_task(
 		if (!rc)
 			continue;
 
-		list_del_init(&se_cmd->state_list);
+		list_move_tail(&se_cmd->state_list, &aborted_list);
 		se_cmd->state_active = false;
 
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
@@ -157,6 +158,11 @@ void core_tmr_abort_task(
 			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
 					0);
 
+		if (dev->transport->tmr_notify)
+			dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
+						   &aborted_list);
+
+		list_del_init(&se_cmd->state_list);
 		target_put_cmd_and_wait(se_cmd);
 
 		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
@@ -167,6 +173,9 @@ void core_tmr_abort_task(
 	}
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
+	if (dev->transport->tmr_notify)
+		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
+
 	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
 			tmr->ref_task_tag);
 	tmr->response = TMR_TASK_DOES_NOT_EXIST;
@@ -318,6 +327,11 @@ static void core_tmr_drain_state_list(
 	}
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
+	if (dev->transport->tmr_notify)
+		dev->transport->tmr_notify(dev, preempt_and_abort_list ?
+					   TMR_LUN_RESET_PRO : TMR_LUN_RESET,
+					   &drain_task_list);
+
 	while (!list_empty(&drain_task_list)) {
 		cmd = list_entry(drain_task_list.next, struct se_cmd, state_list);
 		list_del_init(&cmd->state_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 90ecdd706a01..5834679c1b29 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2941,6 +2941,7 @@ static const char *target_tmf_name(enum tcm_tmreq_table tmf)
 	case TMR_LUN_RESET:		return "LUN_RESET";
 	case TMR_TARGET_WARM_RESET:	return "TARGET_WARM_RESET";
 	case TMR_TARGET_COLD_RESET:	return "TARGET_COLD_RESET";
+	case TMR_LUN_RESET_PRO:		return "LUN_RESET_PRO";
 	case TMR_UNKNOWN:		break;
 	}
 	return "(?)";
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index f51452e3b984..6336780d83a7 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -40,6 +40,8 @@ struct target_backend_ops {
 	ssize_t (*show_configfs_dev_params)(struct se_device *, char *);
 
 	sense_reason_t (*parse_cdb)(struct se_cmd *cmd);
+	void (*tmr_notify)(struct se_device *se_dev, enum tcm_tmreq_table,
+			   struct list_head *aborted_cmds);
 	u32 (*get_device_type)(struct se_device *);
 	sector_t (*get_blocks)(struct se_device *);
 	sector_t (*get_alignment_offset_lbas)(struct se_device *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 18c3f277b770..549947d407cf 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -207,6 +207,7 @@ enum tcm_tmreq_table {
 	TMR_LUN_RESET		= 5,
 	TMR_TARGET_WARM_RESET	= 6,
 	TMR_TARGET_COLD_RESET	= 7,
+	TMR_LUN_RESET_PRO	= 0x80,
 	TMR_UNKNOWN		= 0xff,
 };
 
-- 
2.12.3

