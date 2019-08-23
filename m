Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525D6C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 14:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F0BE2173E
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 14:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390532AbfHWOI4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 10:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390154AbfHWOI4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 10:08:56 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E5E818C8925;
        Fri, 23 Aug 2019 14:08:56 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-122-133.rdu2.redhat.com [10.10.122.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB4075D6B2;
        Fri, 23 Aug 2019 14:08:55 +0000 (UTC)
From:   John Pittman <jpittman@redhat.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, satishkh@cisco.com, linux-scsi@vger.kernel.org,
        John Pittman <jpittman@redhat.com>
Subject: [PATCH] scsi: fnic: print port speed only at driver init or speed change
Date:   Fri, 23 Aug 2019 10:08:52 -0400
Message-Id: <20190823140852.1852-1-jpittman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Fri, 23 Aug 2019 14:08:56 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Port speed printing was added by commit d948e6383ec3 ("scsi: fnic:
Add port speed stat to fnic debug stats"). As currently configured,
this will cause the port speed to be printed to syslog every
2 seconds. To prevent log spamming, only print the vnic port speed
at driver initialization and if the speed changes. Also clean up a
small typo in fnic_trace.c.

Fixes: commit d948e6383ec3 ("scsi: fnic: Add port speed stat to fnic debug stats")
Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/scsi/fnic/fnic_fcs.c   | 14 ++++++++++----
 drivers/scsi/fnic/fnic_trace.c |  2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 911a5adc289c..673887e383cc 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -52,6 +52,7 @@ void fnic_handle_link(struct work_struct *work)
 	unsigned long flags;
 	int old_link_status;
 	u32 old_link_down_cnt;
+	u64 old_port_speed, new_port_speed;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
@@ -62,14 +63,19 @@ void fnic_handle_link(struct work_struct *work)
 
 	old_link_down_cnt = fnic->link_down_cnt;
 	old_link_status = fnic->link_status;
+	old_port_speed = atomic64_read(
+			&fnic->fnic_stats.misc_stats.current_port_speed);
+
 	fnic->link_status = vnic_dev_link_status(fnic->vdev);
 	fnic->link_down_cnt = vnic_dev_link_down_cnt(fnic->vdev);
 
+	new_port_speed = vnic_dev_port_speed(fnic->vdev);
 	atomic64_set(&fnic->fnic_stats.misc_stats.current_port_speed,
-			vnic_dev_port_speed(fnic->vdev));
-	shost_printk(KERN_INFO, fnic->lport->host, "Current vnic speed set to :  %llu\n",
-			(u64)atomic64_read(
-			&fnic->fnic_stats.misc_stats.current_port_speed));
+			new_port_speed);
+	if (old_port_speed != new_port_speed)
+		shost_printk(KERN_INFO, fnic->lport->host,
+				"Current vnic speed set to :  %llu\n",
+				new_port_speed);
 
 	switch (vnic_dev_port_speed(fnic->vdev)) {
 	case DCEM_PORTSPEED_10G:
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 9621831e17ba..a0d01aea28f7 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -453,7 +453,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->misc_stats.frame_errors));
 
 	len += snprintf(debug->debug_buffer + len, buf_size - len,
-			"Firmware reported port seed: %llu\n",
+			"Firmware reported port speed: %llu\n",
 			(u64)atomic64_read(
 				&stats->misc_stats.current_port_speed));
 
-- 
2.17.2

