From: michaelc@cs.wisc.edu
Subject: [RFC PATCH 01/10] scsi transport: add bsg callouts
Date: Fri, 22 Jul 2011 05:04:51 -0500
Message-ID: <1311329100-2982-2-git-send-email-michaelc@cs.wisc.edu>
References: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1GVKCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2011 06:02:11 -0400
In-Reply-To: <1311329100-2982-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds a bsg queueing and timeout function
callout to the scsi host transport template. In the
next patches the transport classes will use this along
with the scsi_bsg lib.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 include/scsi/scsi_transport.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 0de32cd..2167b8c 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -25,6 +25,8 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 
+struct scsi_bsg_job;
+
 struct scsi_transport_template {
 	/* the attribute containers */
 	struct transport_container host_attrs;
@@ -68,6 +70,27 @@ struct scsi_transport_template {
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
 	/*
+	 * This is an optional routine that allows the transport to become
+	 * involved when a bsg req timer fires. 0 should be returned on
+	 * success and a -Exyz code should be returned on a error.
+	 * If -EAGAIN is returned we give the request more time.
+	 */
+	int (*eh_bsg_job_timed_out)(struct scsi_bsg_job *);
+
+	/*
+	 * This is optional. LLDDs should set this to the amount of space
+	 * it needs for a bsg_job that is queued to @queue_bsg_job.
+	 */
+	int bsg_job_size;
+
+	/*
+	 * This is a an optional routine that is used to queue a bsg job
+	 * to the LLDD. The LLDD should return 0 for success and a -Exyz
+	 * error code for a failure.
+	 */
+	int (*queue_bsg_job)(struct scsi_bsg_job *);
+
+	/*
 	 * Used as callback for the completion of i_t_nexus request
 	 * for target drivers.
 	 */
-- 
1.7.2.3

