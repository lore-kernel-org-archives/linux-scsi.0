Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD85C433E5
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A9D20759
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="T+sfNelz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgGZPfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:35:51 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.67]:49807 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727850AbgGZPfu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jul 2020 11:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1595777748; i=@ts.fujitsu.com;
        bh=gMojHj+95hLqvtbTkDDjDCt2R6tZDFvbUuJbvcOIVYc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=T+sfNelzBNUXVBhqzOnVGpUVjroJMPf57Aqk4teXV9xHrDbjLGXQZTrRzlWuCCG2G
         xK4KrdFPtFVwYukDtAUTXmEj9pyA+zhYenqZXC70pepZH8olw7g0gfMcpulWurGvfO
         c2267c+lgaqOnxSRoy+HJO2P+bPhqK2eubBMyc7KksQ6QXsb9xGtpZh2jyYzgh9Djv
         LZAPOwZR0cH75VFoyd/m4KNbJr3uljk9zLrC+KyvevkkZVOVbc/2S/YU1XfEJmtUPR
         Il9WZkz/v91sSGneKKmTDCyP8HZPwEOXrFE/Id/umGvLDu8r8IQb5kyHaK2MOgy5eV
         lLSSLc+dP3vng==
Received: from [100.112.197.40] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-b.eu-west-1.aws.symcld.net id E4/44-60645-3D2AD1F5; Sun, 26 Jul 2020 15:35:47 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRWlGSWpSXmKPExsViZ8MRqntpkWy
  8weI1Nhbd13ewWSw//o/J4u+kG6wWrUvfMjmweHx8eovF4/MmuQCmKNbMvKT8igTWjOaGC+wF
  N4Uqdj6fy9TAOE2gi5GLQ0hgMqPEvm+L2CCc6YwSu19fY+pi5ORgEzCQWDHpPgtIQkRgDaPEy
  jvzmEESzAJ6EtP+rWMHsYUFnCTWXNgE1sAioCrROeUGWJxXwE6iYeI3sLiEgLxEx4HJLCA2p4
  C9xMa5H8DmCAHVLNt0gH0CI/cCRoZVjOZJRZnpGSW5iZk5uoYGBrqGhka6hpaWuoYWeolVukl
  6qaW65anFJbqGeonlxXrFlbnJOSl6eaklmxiBYZJScFxoB+Ob1x/0DjFKcjApifIaTJGNF+JL
  yk+pzEgszogvKs1JLT7EKMPBoSTBe3UhUE6wKDU9tSItMwcYsjBpCQ4eJRHeOSBp3uKCxNziz
  HSI1ClGRSlx3n6QhABIIqM0D64NFieXGGWlhHkZGRgYhHgKUotyM0tQ5V8xinMwKgnzWoFM4c
  nMK4Gb/gpoMRPQYvdLkiCLSxIRUlINTLc3JcY4nHqydvtt/50taTZVAZM1I2VYPIvqNLYaHLl
  ivFd/9fJtHuzKETIMgjMz9or8fc9eZDPX5ezf6ysu5PCYZFspV/5+s6Bo1qPHar/v7/d9sl76
  l6F2/sMTm9U5n2/LZd8YXC8yfw3P/c9PCzIc3v7O4tg0OcNq7YXce3mt11r+CzzTmVU69879e
  8k1cg+f3f+rnLI56cBMFcNoyw+LGIwzAt8riLEabPpiMIHj2RJjng8rPEJSc3zf5F+K1p3Fz7
  oxdd5WgYR4tcPe0btlNVp0Z0h3+4q3ZvaqF/tbz9ix8nNmwoPXfvfrIrP0m+NXp75aMvlOwZJ
  JIa9K3vU1+GQuZquST8qLe7KiTImlOCPRUIu5qDgRAMI5pF4OAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-28.tower-291.messagelabs.com!1595777746!937084!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 7545 invoked from network); 26 Jul 2020 15:35:46 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-28.tower-291.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 26 Jul 2020 15:35:46 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06QFZdmc006421;
        Sun, 26 Jul 2020 16:35:40 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 27CCC204CE;
        Sun, 26 Jul 2020 17:35:37 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH v3 1/8] scsi: target: Modify core_tmr_abort_task()
Date:   Sun, 26 Jul 2020 17:35:03 +0200
Message-Id: <20200726153510.13077-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
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
index 89c84d472cd7..73c4155f3c1e 100644
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
+		spin_lock(&se_sess->sess_cmd_lock);
+		rc = __target_check_io_state(se_cmd, se_sess, 0);
+		spin_unlock(&se_sess->sess_cmd_lock);
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

