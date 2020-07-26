Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49D9C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2CAD2070B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="TZlFpxNL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgGZPf7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:59 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.84]:25175 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbgGZPfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777750; i=@ts.fujitsu.com;
        bh=3mMSBbyuFhlgnc6RB4JBw6uOJpLIuiWRS6pGnKAuZ/M=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=TZlFpxNLu9FariYc7TIYhitUXrMT3ZvzwobvrIQzhMmqR0nROU9O08brnNUuhSy4x
         IPezrs5oKncNwgNP4sHvkEgwPieUaTLmM3Up/jR+lqg70Uebu5he7NuUIinpJZtacs
         53nJqxF0EPeEZoNVGljs0GP7OG4IRtNDt31GGdFPyrED+3Iupf/4DakBm/VHePVAFv
         c0G1YuL9DtSTK0uo5C0jFDMciiluwDR5Mm5cXgLaC7IHZx9JYEm/qOIuvIxLLFa713
         SvDPQJcGl9GjECZlknp69hErBGg9PrCOUZW6JFYEpwap4JNJZTshXnfHHwrh9nJDbL
         +Qw2Qjmx96NFQ==
Received: from [100.112.197.40] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-b.eu-west-1.aws.symcld.net id 37/F9-16187-6D2AD1F5; Sun, 26 Jul 2020 15:35:50 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MxRffaItl
  4gwspFt3Xd7BZLD/+j8ni76QbrBatS98yObB4fHx6i8Xj8ya5AKYo1sy8pPyKBNaMz7ueshc8
  kq94M/MeWwPjOekuRi4OIYHJjBJ7P/5hg3CmM0q8+dLO2MXIycEmYCCxYtJ9FpCEiMAaRomVd
  +YxgySYBfQkpv1bxw5iCwu4Sizd/BKsgUVAVaKj8xWYzStgJ3HvzhSwGgkBeYmOA5NZQGxOAX
  uJjXM/gM0RAqpZtukA+wRG7gWMDKsYLZKKMtMzSnITM3N0DQ0MdA0NjXQNLc11DY3N9RKrdJP
  0Ukt1y1OLS3QN9RLLi/WKK3OTc1L08lJLNjECwySl4GjnDsZfrz7oHWKU5GBSEuU1mCIbL8SX
  lJ9SmZFYnBFfVJqTWnyIUYaDQ0mC9+pCoJxgUWp6akVaZg4wZGHSEhw8SiK8c0DSvMUFibnFm
  ekQqVOMilLivP0gCQGQREZpHlwbLE4uMcpKCfMyMjAwCPEUpBblZpagyr9iFOdgVBLmtQKZwp
  OZVwI3/RXQYiagxe6XJEEWlyQipKQamCz6ryatXjP7SERiup4440SZ28tEV+9Z4/wnIrW/eXr
  lohfXReJKWd38Tx68wRs7neuQ+LUUXTOfpdOu32H+d8Z3vc2eiXsWZajaL5lQscDgYY7jz4gY
  2ftLZBveT9SSZflULcBwe8ZPtfaAWXbsjmI2X2/cZdPv+DBxZYJpfLHSgp/BTLqWdgrbzPb5s
  p+YdPninYhpaQ0qD15mrD0btOr+pPdcFzl+eM3uuu/Ps/Oo6ufeFVcn5zJWsBZ4LF+72/8MW/
  XCrztlGSWD65yuvbkcxrRwueOjFfXudxWO+phfaeotPHJs8XKVc0ftFnxPvZFzJdpV4Oeycvt
  liTsbj5rzrypc/ktQ4NC+pDZjph9KLMUZiYZazEXFiQBD0GKbDgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-16.tower-285.messagelabs.com!1595777749!1020530!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 6099 invoked from network); 26 Jul 2020 15:35:49 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-16.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:49 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZf1U009374;
        Sun, 26 Jul 2020 16:35:41 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 349452060A;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 2/8] scsi: target: Add tmr_notify backend function
Date:   Sun, 26 Jul 2020 17:35:04 +0200
Message-Id: <20200726153510.13077-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
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
index 73c4155f3c1e..e4513ef09159 100644
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

