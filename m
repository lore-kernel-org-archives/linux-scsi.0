Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA105C433E3
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A55B2076A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="CSO3KqOJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGQQMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:34 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.68]:33401 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726633AbgGQQMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002350; i=@ts.fujitsu.com;
        bh=egmweCa5pZm/0eaUhgjJ9HDsMmuNSgWkgH65Ktkuo60=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=CSO3KqOJaayWskJ3mCWrDoUxAGQYXUqDHBhr0iGq6mKnm+V1rTxDM9qf8H1WVqL6u
         mTYVoHZwYMx084qgji3mmb54JJvY8F+w8Awyhz7bZn7BAcYaWpDVVnrkwc0wJiyhPx
         3+JrC+YDELzU9pU3eXkyY4DD1o0l08/ER4igYH3YLEOuB46ugDROhRqrKxuAtJDX4m
         nX8o4wvAu+eP3KU2LWKh2WafXtROUU+0xRIRJJQ0X2JFg0ZHQRLxbi4+L+7T0Ze9zQ
         /FQ3vVZYV2QltNiW0Ebddk0SI3MLe8QI8Sut87VPOfibLFRKKxqln/k7n6ySgZHMSO
         ZmFBYCLT3PI4g==
Received: from [100.112.197.196] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 0B/BA-16187-EEDC11F5; Fri, 17 Jul 2020 16:12:30 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MRovvurGC
  8waTtrBbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjAdrGpgL
  HslX3Jns28B4TrqLkYtDSGAyo8SeWcdZIZzpjBJLrneydTFycrAJGEismHSfBSQhIrCGUWLln
  XnMIAlmAT2Jaf/WsYPYwgKuErPefGcCsVkEVCUOdC5nBbF5Bewk3m45zwhiSwjIS3QcmMwCYn
  MK2EvM/nYQLC4EVPNg3VvmCYzcCxgZVjFaJBVlpmeU5CZm5ugaGhjoGhoa6RpaWugamhvrJVb
  pJumlluqWpxaX6BrqJZYX6xVX5ibnpOjlpZZsYgSGSUrBsbU7GHvefNA7xCjJwaQkytu2SjBe
  iC8pP6UyI7E4I76oNCe1+BCjDAeHkgSv+CmgnGBRanpqRVpmDjBkYdISHDxKIrzGZ4DSvMUFi
  bnFmekQqVOMilLivGIgCQGQREZpHlwbLE4uMcpKCfMyMjAwCPEUpBblZpagyr9iFOdgVBLmDQ
  OZwpOZVwI3/RXQYiagxRs/84IsLklESEk1ME3k5y9c4u2xN3hBsdnWZ7J2dxcE5Owy2K3bdtd
  z9gLPm9PZZ2zf5ijMNk18K8/Mq66zzsqdenFe7tE8Fn6Xv3eN0qIcz1uGN7S0eP6+WnHbyMFk
  c2SpNXPUdQWpuS7bQv6rZetPitB2zblV/mVyg3kf302BE2+SfiixGhqZ39tiu/6o5qH8MieZR
  /t9dn10f90SfO1bPNOrq3MF1kXMuWSRvTDg/vtJegqHONUWPA//0LJizURjznVep6KmHcrjOZ
  X23iLuzMeEc5cOdl/9ez2wmF0+W0bY7tzEiq//p86eJncztiRq2qKXTL+M7veeL8mWKq4XuHR
  +6QQ3sR3/H14rk37ZoRorXb+da0bGxXNKLMUZiYZazEXFiQCbAK+BDgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-17.tower-287.messagelabs.com!1595002349!316577!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 24145 invoked from network); 17 Jul 2020 16:12:29 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-17.tower-287.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:29 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCNg3009778;
        Fri, 17 Jul 2020 17:12:23 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id F226C20489;
        Fri, 17 Jul 2020 18:12:20 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 2/8] scsi: target: Add tmr_notify backend function
Date:   Fri, 17 Jul 2020 18:12:06 +0200
Message-Id: <20200717161212.10731-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
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

