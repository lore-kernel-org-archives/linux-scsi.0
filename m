Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AC9C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4264720780
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 10:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Au12siZ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbgF3Krt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 06:47:49 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.1]:39493 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732646AbgF3Kro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 06:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593514060; i=@ts.fujitsu.com;
        bh=2Frq/UoMo2ZmRBbp04/5Qkl6kYBSP2A4sdzcLM8oql8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=Au12siZ4349DOc/1jbL71c0AY+J/NfEK4Dtt3ngk/jZ32Oica8Kg61cj4wtymLs0B
         DZOsclbFnswcfurRlk2U7/YnzFK35LkCoAJBhw9OB3lFkhPGyOeDxGUhQNBEghtar7
         qeU9vZJLe+xdOZbLAj+bDjl9JJXBH0aT2J3DWaJ4jb/s1Y5nz7VIw0Ma6/zWPds34W
         ZPRmuRaqBQiZMz7eQwajqAuxLBjdgoqv7PrgsIclpvK8VRqjBt8yKxpCLQZ/A0Pnos
         UYlkjFJ45XrYPMQ2AnRCPd9Bgl7q9DGo/YsMx8btzq/wBReBNqY8ZhIRcb9wc9RE2x
         VwnxeVwO9HtYQ==
Received: from [100.113.1.80] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-central-1.aws.symcld.net id F3/E4-07993-C481BFE5; Tue, 30 Jun 2020 10:47:40 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MRqusj8Tv
  O4EyfrEX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE1Y+OPxWwF
  v4QqHrZeYG1g3CrQxcjFISQwmVHi7fzn7BDOdEaJ2W8vsHUxcnKwCRhIrJh0nwUkISKwhlFi5
  Z15zCAJZgE9iWn/1rGD2MICzhLf5t9jBLFZBFQl7hx6zQJi8wrYSRxZ8AmsXkJAXqLjwGSwOK
  eAvcTaw6fBbCGgmrWbZ7JNYORewMiwitEyqSgzPaMkNzEzR9fQwEDX0NBYF0gaG+glVukm6qW
  W6ian5pUUJQJl9RLLi/WKK3OTc1L08lJLNjECQyWlkKFpB+O7Vx/0DjFKcjApifLe+/crTogv
  KT+lMiOxOCO+qDQntfgQowwHh5IE71Px33FCgkWp6akVaZk5wLCFSUtw8CiJ8O4HSfMWFyTmF
  memQ6ROMSpKifOuFANKCIAkMkrz4NpgsXKJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAejkjBvAs
  h4nsy8Erjpr4AWMwEtvqb1C2RxSSJCSqqBaZ3jy/MxLhtY9RPdDa/E2e7ni1n8Yi//yXWFAhf
  TGl61b3l32ON/kmPk/zRJ3+8ub3mdNz2aHLzjbUxM3tS2xdYLb97+XSqiyJHk/OuNo4gf14r2
  NU9enYjLdps694Ha/hS1ui3165r52rY9WGnw9t/exIUXUz1rtqf1bNKamRo5M09yowmbTZb3t
  fOBH0VOFriy3hI3rzhzdGrZjqt9fx/VMTJzBxwsOlSmu3ifz9+7zLk38k6vfC+6YKLcj8fP32
  zjzPBkn6DbnTUpMNLqQdfUrCDN+9dvfL0b+/3Xm7Cm+C0qlSV6Fu4KJkwZexSluzcnnl5to7v
  V7ehtV/vm59POR2fMn/t1WcHKhs6V/UosxRmJhlrMRcWJAIl4Z94QAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-32.tower-228.messagelabs.com!1593514059!1397082!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 7440 invoked from network); 30 Jun 2020 10:47:40 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-32.tower-228.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 10:47:40 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UAlVgw003349;
        Tue, 30 Jun 2020 11:47:31 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 35A85205E2;
        Tue, 30 Jun 2020 12:47:27 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
Date:   Tue, 30 Jun 2020 12:47:02 +0200
Message-Id: <20200630104709.23066-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch modifies core_tmr_abort_task() to use same looping
and locking scheme as core_tmr_drain_state_list() does.

This frees the state_list element in se_cmd for later use
by tmr notification handling.

Note: __target_check_io_state() now is called with param 0
instead of dev->dev_attrib.emulate_tas, because tas is not
relevant since we always get ABRT on same session like the
aborted command.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_tmr.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 89c84d472cd7..b65d7a0a5df1 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -116,14 +116,15 @@ void core_tmr_abort_task(
 	struct se_tmr_req *tmr,
 	struct se_session *se_sess)
 {
-	struct se_cmd *se_cmd;
+	struct se_cmd *se_cmd, *next;
 	unsigned long flags;
+	bool rc;
 	u64 ref_tag;
 
-	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
+	spin_lock_irqsave(&dev->execute_task_lock, flags);
+	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
 
-		if (dev != se_cmd->se_dev)
+		if (se_sess != se_cmd->se_sess)
 			continue;
 
 		/* skip task management functions, including tmr->task_cmd */
@@ -137,11 +138,16 @@ void core_tmr_abort_task(
 		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
 			se_cmd->se_tfo->fabric_name, ref_tag);
 
-		if (!__target_check_io_state(se_cmd, se_sess,
-					     dev->dev_attrib.emulate_tas))
+		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+		rc = __target_check_io_state(se_cmd, se_sess, 0);
+		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		if (!rc)
 			continue;
 
-		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		list_del_init(&se_cmd->state_list);
+		se_cmd->state_active = false;
+
+		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		/*
 		 * Ensure that this ABORT request is visible to the LU RESET
@@ -159,7 +165,7 @@ void core_tmr_abort_task(
 		atomic_long_inc(&dev->aborts_complete);
 		return;
 	}
-	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
 			tmr->ref_task_tag);
-- 
2.12.3

