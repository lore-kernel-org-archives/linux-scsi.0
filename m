Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67E6C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D5B2074B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 16:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="E6gCXV+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgGQQMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 12:12:40 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.1]:49573 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgGQQMi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 12:12:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595002355; i=@ts.fujitsu.com;
        bh=2Frq/UoMo2ZmRBbp04/5Qkl6kYBSP2A4sdzcLM8oql8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=E6gCXV+RoFX34k0r5E0ItfiRwKlaTqgSNlzjlin3g62m2cII8CS5nswV/OVacXOCu
         n2hzactIesX2HkG8vfBEamHQB0sci5twF7I9xUgdpDdI5mAeilM7o5+avXxfxGLPGa
         2HI68HVwzYvsHUTUiq8QHQmZXIr4ByPaN7qA/LXaJXT1M9Mc+7S2eT2M+FdT8ffjWQ
         hroCYlnK3kOO1qv3zr25G+Ah33I/sf2ginhggw9KRA5tS4NLtMKd6sWy/wvqpQrpQo
         b3uO8PmdBh+Bbdf3yLbv+/TTQZ19idgzWTc82WAnATHOVEaW79utkXtG0ed9Ub9g1l
         9146/jdswsVIw==
Received: from [100.112.192.94] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-1.bemta.az-a.eu-west-1.aws.symcld.net id 39/CB-19802-3FDC11F5; Fri, 17 Jul 2020 16:12:35 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRWlGSWpSXmKPExsViZ8MxVffzWcF
  4g8c3ZC26r+9gs1h+/B+Txd9JN1gtWpe+ZXJg8fj49BaLx+dNcgFMUayZeUn5FQmsGRt/LGYr
  +CVU8bD1AmsD41aBLkYuDiGByYwSh17PZIRwpjNKHJ3+ga2LkZODTcBAYsWk+ywgCRGBNYwSK
  +/MYwZJMAvoSUz7t44dxBYWcJKYs2MjC4jNIqAqcWbqVVYQm1fATuLu8ZNggyQE5CU6DkwGq+
  EUsJeY/e0gI4gtBFTzYN1b5gmM3AsYGVYxWiQVZaZnlOQmZuboGhoY6BoaGukaWhrpGhmY6CV
  W6SbqpZbqlqcWl+ga6iWWF+sVV+Ym56To5aWWbGIEBkpKwYEzOxhPvf6gd4hRkoNJSZS3bZVg
  vBBfUn5KZUZicUZ8UWlOavEhRhkODiUJXvFTQDnBotT01Iq0zBxg0MKkJTh4lER4W4GBK8RbX
  JCYW5yZDpE6xagoJc7bA5IQAElklObBtcEi5RKjrJQwLyMDA4MQT0FqUW5mCar8K0ZxDkYlYd
  69IFN4MvNK4Ka/AlrMBLR442dekMUliQgpqQamIBfN9puC1tM8z0q8cxJeu7/RRNa3eOHsh1M
  u9fdmPKljkmT5+W1fPfO/+KPdTybxXtnuvefSO/Ebfg/nRZxjNf+fN2nP5nhZ7szdTb8jTYru
  i0rcMf8XOHt32Bf9B5IHzwZ/OHR0tVYBB5vRhY7/ByM3qMhuu2txvf2/7qOSW/4irQemxM4Pn
  1W++p/cqvz3He4PNsWsv9QtdeaiUf3R6xM4+UQcs5Nj/iesvrioNpTb5MuXqddaDhs4ichbBR
  38kOG0NTIt6nGh1v/uafJ3vnjYnZxTUz95fuXbixpBW+QZ5HkDvnx/KFZydvYuUV3nohcSgSG
  /RBcbaR2wX7ciXWyRhNFMRoO9vTPuLMq0VGIpzkg01GIuKk4EAPcYxQcPAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-28.tower-265.messagelabs.com!1595002354!89497!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 28885 invoked from network); 17 Jul 2020 16:12:35 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-28.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Jul 2020 16:12:35 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06HGCQFD010041;
        Fri, 17 Jul 2020 17:12:26 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id E545520468;
        Fri, 17 Jul 2020 18:12:20 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v2 1/8] scsi: target: Modify core_tmr_abort_task()
Date:   Fri, 17 Jul 2020 18:12:05 +0200
Message-Id: <20200717161212.10731-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
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

