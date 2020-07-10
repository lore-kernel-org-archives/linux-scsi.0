Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAB6C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C706620748
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="pICb0YGh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgGJKtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:49:09 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.65]:16998 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727826AbgGJKss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=egmweCa5pZm/0eaUhgjJ9HDsMmuNSgWkgH65Ktkuo60=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=pICb0YGhZ1DmCmOwMP2z+IL5REY533W5uxkuKen4Bs3+YDBuB5fKOa60HevgwT79j
         ekls/mZr/ZwzyphVudVBdncHhUqYs12Zn3bIX0TZ6Ahnj315YvIk9aIKDYhHIov9nZ
         u/KygdApCuB/xXTsGYOl7sxAwpYBFeipsW4YuvLsPfAI/iXtD9mzjn/RA2OEiS1T+m
         ZjlSy7ePdPyMLjNektuKz2vjFTxMc/DKzB2jbwRSppRX8pYtBKZaJGucVfoU7eKgfu
         wk1sjtzOjnj1b2OYtTXTZVMYrG6yZLQLgNHXmKy9AMqsGh0MWucDy77Rw/1gNayJGk
         PY9fXB+p6upVA==
Received: from [100.112.199.31] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-b.eu-west-1.aws.symcld.net id 07/AA-12842-B87480F5; Fri, 10 Jul 2020 10:48:43 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRWlGSWpSXmKPExsViZ8MRqtvtzhF
  v0D9H26L7+g42i+XH/zFZ/J10g9WidelbJgcWj49Pb7F4fN4kF8AUxZqZl5RfkcCa8WBNA3PB
  I/mKO5N9GxjPSXcxcnEICUxmlFi0eiULhDOdUeLEiyb2LkZODjYBA4kVk+6DJUQE1jBKrLwzj
  xkkwSygJzHt3zqwImEBJ4nVjyazgNgsAqoST87vYQOxeQXsJFZ/OQFmSwjIS3QcgKjhFLCX2N
  /1D8wWAqrZ1feQdQIj9wJGhlWM5klFmekZJbmJmTm6hgYGuoaGRrqGlma6ZiZ6iVW6SXqppbr
  lqcUluoZ6ieXFesWVuck5KXp5qSWbGIFBklJwxGEH4/3XH/QOMUpyMCmJ8k77yB4vxJeUn1KZ
  kVicEV9UmpNafIhRhoNDSYJXyo0jXkiwKDU9tSItMwcYsDBpCQ4eJRHe+S5Aad7igsTc4sx0i
  NQpRkUpcd5/zkAJAZBERmkeXBssSi4xykoJ8zIyMDAI8RSkFuVmlqDKv2IU52BUEuaNBtnOk5
  lXAjf9FdBiJqDFRznYQBaXJCKkpBqY9raklTv6drLemmpv+495it/D8vuh+YLbK8K+7d9meMB
  hz+L+374ukivDcu+elum7/eX04ajHB3IOXmi6qZFRPMuIrf6V4AcW3uR3WSIpeY7epz8nXTmw
  jvuplre99o+snX37eMxPO9x+9M75csj/yoC6bSnt/S0sew/wHiqe7btAb1Ody9RFfBfv93hFN
  8dn7Rab08bN5RBbZzH/5o3Hq6Uvm216GXnr+ZQDhx8e5PTjE9vJ1V3+IWHJH0a/eRqbFxw7lG
  Pm1PSpNoTzyqMj+5/+5s/bfFZjefnSjlVKNRfvZPTsUMrlPaR4JO2DiPu57hd5LIE3KjTLHjX
  JJy2qr+g/k/u4pOu6eP27V8IKSizFGYmGWsxFxYkANj9OEw0DAAA=
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-16.tower-291.messagelabs.com!1594378122!1305729!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29652 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-16.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmg8I025757;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 6489520489;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 2/8] scsi: target: Add tmr_notify backend function
Date:   Fri, 10 Jul 2020 12:48:11 +0200
Message-Id: <20200710104817.19462-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
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
index e6e1fa68de54..9fb0be0aa620 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2946,6 +2946,7 @@ static const char *target_tmf_name(enum tcm_tmreq_table tmf)
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

