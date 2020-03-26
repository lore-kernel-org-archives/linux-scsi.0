Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AE9C43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 00:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0053C20737
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 00:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCZAkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 20:40:24 -0400
Received: from mx.sdf.org ([205.166.94.20]:64235 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbgCZAkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 20:40:24 -0400
Received: from sdf.org (IDENT:lkml@faeroes.freeshell.org [205.166.94.9])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02Q0eGLb017052
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Thu, 26 Mar 2020 00:40:16 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02Q0eDmr014871;
        Thu, 26 Mar 2020 00:40:13 GMT
Date:   Thu, 26 Mar 2020 00:40:13 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     linux-scsi@vger.kernel.org
Cc:     Ching Huang <ching2048@areca.com.tw>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>, lkml@sdf.org
Subject: [PATCH] drivers/scsi/arcmsr/armsr_hba.c: fix "msecs_to_jiffies(6 *
Message-ID: <20200326004013.GA15115@SDF.ORG>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

That's a nonsensical thing, because HZ is already in jiffies.

Presumably it's meant to be a 6s timeout, not a 0.6/1.5/1.8/6 second
timeout (depending on HZ).

Because this is a behaviour change, it needs testing by someone with the
relevant hardware.

There's a second, minor fix: in arcmsr_set_iop_datetime(), let
msecs_to_jiffies() be evaluated at compile time.

That section of code deserves two levels of attention from someone
who understands what it's doing.  First, you might might want to
reword that whole thing in terms of HZ.  And the constant names
are confusing.  ARCMSR_MINUTES is 1 hour, while ARCMSR_HOURS is
4 hours.  E.g.

	next_time = HZ * 60 * 60;	/* 1 hour */
	if (sys_tz.tz_minuteswest)
		next_time *= 4;
	mod_timer(&pacb->refresh_timer, jiffies + next_time);)

Level two would be considering why there are two different timeouts
depending on whether the time zone is GMT or not and whether that's
really justified.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Ching Huang <ching2048@areca.com.tw>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index db687ef8a99ec..c3a8dbe51b75b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -916,14 +916,14 @@ static void arcmsr_init_get_devmap_timer(struct AdapterControlBlock *pacb)
 	atomic_set(&pacb->ante_token_value, 16);
 	pacb->fw_flag = FW_NORMAL;
 	timer_setup(&pacb->eternal_timer, arcmsr_request_device_map, 0);
-	pacb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+	pacb->eternal_timer.expires = jiffies + 6 * HZ;
 	add_timer(&pacb->eternal_timer);
 }
 
 static void arcmsr_init_set_datetime_timer(struct AdapterControlBlock *pacb)
 {
 	timer_setup(&pacb->refresh_timer, arcmsr_set_iop_datetime, 0);
-	pacb->refresh_timer.expires = jiffies + msecs_to_jiffies(60 * 1000);
+	pacb->refresh_timer.expires = jiffies + 60 * HZ;
 	add_timer(&pacb->refresh_timer);
 }
 
@@ -3746,10 +3746,10 @@ static void arcmsr_set_iop_datetime(struct timer_list *t)
 		}
 	}
 	if (sys_tz.tz_minuteswest)
-		next_time = ARCMSR_HOURS;
+		next_time = msecs_to_jiffies(ARCMSR_HOURS);
 	else
-		next_time = ARCMSR_MINUTES;
-	mod_timer(&pacb->refresh_timer, jiffies + msecs_to_jiffies(next_time));
+		next_time = msecs_to_jiffies(ARCMSR_MINUTES);
+	mod_timer(&pacb->refresh_timer, jiffies + next_time);
 }
 
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
@@ -3968,8 +3968,7 @@ static void arcmsr_request_device_map(struct timer_list *t)
 	if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
 		(acb->acb_flags & ACB_F_BUS_RESET) ||
 		(acb->acb_flags & ACB_F_ABORT)) {
-		mod_timer(&acb->eternal_timer,
-			jiffies + msecs_to_jiffies(6 * HZ));
+		mod_timer(&acb->eternal_timer, jiffies + 6 * HZ);
 	} else {
 		acb->fw_flag = FW_NORMAL;
 		if (atomic_read(&acb->ante_token_value) ==
@@ -3979,8 +3978,7 @@ static void arcmsr_request_device_map(struct timer_list *t)
 		atomic_set(&acb->ante_token_value,
 			atomic_read(&acb->rq_map_token));
 		if (atomic_dec_and_test(&acb->rq_map_token)) {
-			mod_timer(&acb->eternal_timer, jiffies +
-				msecs_to_jiffies(6 * HZ));
+			mod_timer(&acb->eternal_timer, jiffies + 6 * HZ);
 			return;
 		}
 		switch (acb->adapter_type) {
@@ -4016,7 +4014,7 @@ static void arcmsr_request_device_map(struct timer_list *t)
 			return;
 		}
 		acb->acb_flags |= ACB_F_MSG_GET_CONFIG;
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+		mod_timer(&acb->eternal_timer, jiffies + 6 * HZ);
 	}
 }
 
@@ -4405,8 +4403,7 @@ static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 		atomic_set(&acb->rq_map_token, 16);
 		atomic_set(&acb->ante_token_value, 16);
 		acb->fw_flag = FW_NORMAL;
-		mod_timer(&acb->eternal_timer, jiffies +
-			msecs_to_jiffies(6 * HZ));
+		mod_timer(&acb->eternal_timer, jiffies + 6 * HZ);
 		acb->acb_flags &= ~ACB_F_BUS_RESET;
 		rtn = SUCCESS;
 		pr_notice("arcmsr: scsi bus reset eh returns with success\n");
@@ -4415,8 +4412,7 @@ static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
 		atomic_set(&acb->rq_map_token, 16);
 		atomic_set(&acb->ante_token_value, 16);
 		acb->fw_flag = FW_NORMAL;
-		mod_timer(&acb->eternal_timer, jiffies +
-			msecs_to_jiffies(6 * HZ));
+		mod_timer(&acb->eternal_timer, jiffies + 6 * HZ);
 		rtn = SUCCESS;
 	}
 	return rtn;
-- 
2.26.0
