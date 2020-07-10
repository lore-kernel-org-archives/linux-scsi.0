Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A713C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D19820767
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 10:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="OxVNNl2b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgGJKsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:48:52 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.3]:16956 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbgGJKss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1594378124; i=@ts.fujitsu.com;
        bh=2Frq/UoMo2ZmRBbp04/5Qkl6kYBSP2A4sdzcLM8oql8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=OxVNNl2bquUTNPlrkm4Nqt1HWVjaTHeKr9YwTLVI6BrJyphmpKgGFRxsjDASu+xkQ
         NUVoJK2Y05nsS2c9U31afUAELgaFHeT/595/HsPBINMI/qN4kiF5GwDiTM+dgrtSim
         23a7wJvtOBgwzXNCjQc58PXDRkRbUlyAyjjdoxGRJjhHMKm4AxhKcd/TPyebx/r48Q
         OBXZ1C0iYA9oZlGzhcHNO7Tpvjk4IVkQv4rylg8qJBB7wd+Wc5ikiqapARW0jqg6FF
         Cl7CnaP70Ff2EmiZ+OaWdknE7pvHmcPtPIWUURcwfFTQ7jjqOYfzZie5OGW0A87HVn
         yFQHySmP/fVeg==
Received: from [100.113.3.12] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-central-1.aws.symcld.net id 6B/27-21639-C87480F5; Fri, 10 Jul 2020 10:48:44 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MRqtvtzhF
  v8GyHtkX39R1sFsuP/2Oy+DvpBqtF69K3TA4sHh+f3mLx+LxJLoApijUzLym/IoE1Y+OPxWwF
  v4QqHrZeYG1g3CrQxcjFISQwmVHizdNPrBDOdEaJLe2f2bsYOTnYBAwkVky6zwKSEBFYwyix8
  s48ZpAEs4CexLR/68CKhAXsJZ73PmQEsVkEVCVefTzLAmLzCthJbHo5lRXElhCQl+g4MBkszg
  lUv7/rH5gtBFSzq+8h6wRG7gWMDKsYLZOKMtMzSnITM3N0DQ0MdA0NjXUNgaS5XmKVbqJeaql
  ucmpeSVEiUFYvsbxYr7gyNzknRS8vtWQTIzBUUgoZS3cwTnvzQe8QoyQHk5Io77SP7PFCfEn5
  KZUZicUZ8UWlOanFhxhlODiUJHgdXDnihQSLUtNTK9Iyc4BhC5OW4OBREuGd7wKU5i0uSMwtz
  kyHSJ1iVJQS5/3nDJQQAElklObBtcFi5RKjrJQwLyMDA4MQT0FqUW5mCar8K0ZxDkYloAqQ7T
  yZeSVw018BLWYCWnyUgw1kcUkiQkqqganc+axc+nWnF5dXWJXoz9u4lENApu6/fLTf/7O5SlN
  OyM1LfnX6W8SaM9dUmVxfOJ2uTch0FpyuoPGUP36qlWTQ5F86x0p4z1VtnFXzJ/Dg5ulTV146
  vK724KGOwKsxLr2PQ3dN9tl76fe6mVpWcnOKb626eZRlXUZZ1X6x9iUK0lmzy19atui11/4My
  TCfZRccFW3kVxKw4spX0Qm7Tr8K3XYqNO9LkLrN189hk57yTH1bJnuLvVnirYDTS+2Z7ulNUp
  aSGT9eRpUZbNnvYtiw58es+nDGtVVfX7u+9Bd1v5IrLzw5Jl1ERFCTv7L9nl/un/XT/IVOT+S
  fMmNqttW/8gzvOXsfXrC39f2f1KfEUpyRaKjFXFScCAAsxy5vEAMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-35.tower-232.messagelabs.com!1594378122!519954!1
X-Originating-IP: [62.60.8.85]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5457 invoked from network); 10 Jul 2020 10:48:43 -0000
Received: from unknown (HELO mailhost4.uk.fujitsu.com) (62.60.8.85)
  by server-35.tower-232.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 10 Jul 2020 10:48:43 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost4.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 06AAmgAO025753;
        Fri, 10 Jul 2020 11:48:42 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 580EB20285;
        Fri, 10 Jul 2020 12:48:42 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 1/8] scsi: target: Modify core_tmr_abort_task()
Date:   Fri, 10 Jul 2020 12:48:10 +0200
Message-Id: <20200710104817.19462-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
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

