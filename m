From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 6/7] sym53c8xx: use a queue depth of 1 for untagged devices
Date: Thu, 08 Jan 2009 12:58:04 -0500
Message-ID: <49663EAC.3090300@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([98.174.209.230]:1432 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZAHR6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 12:58:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

sym53c8xx uses a command queue depth of 2 for untagged devices,
without good reason.  This _mostly_ seems to work ok, but it has
caused me some subtle problems.  For example, I have an application
where one thread sends write commands to a tape drive, and another
thread sends log sense polling commands.  With a queue depth of
2, the polling commands end up being starved for long periods of
time while multiple write commands are serviced (this may also be
related to the fact the the sg driver queues commands in LIFO order).
This problem is fixed by changing the queue depth to 1 for untagged
devices.  I have tested this change extensively with many different
tape drives, medium changers, and disk drives (disk drives of course
use tagged commands and are therefore unaffected by this patch).

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c.orig	2009-01-08 10:53:39.000000000 -0500
+++ linux-2.6.28/drivers/scsi/sym53c8xx_2/sym_glue.c	2009-01-08 11:03:40.000000000 -0500
@@ -792,9 +792,9 @@ static int sym53c8xx_slave_configure(str
 
 	/*
 	 *  Select queue depth from driver setup.
-	 *  Donnot use more than configured by user.
-	 *  Use at least 2.
-	 *  Donnot use more than our maximum.
+	 *  Do not use more than configured by user.
+	 *  Use at least 1.
+	 *  Do not use more than our maximum.
 	 */
 	reqtags = sym_driver_setup.max_tag;
 	if (reqtags > tp->usrtags)
@@ -803,7 +803,7 @@ static int sym53c8xx_slave_configure(str
 		reqtags = 0;
 	if (reqtags > SYM_CONF_MAX_TAG)
 		reqtags = SYM_CONF_MAX_TAG;
-	depth_to_use = reqtags ? reqtags : 2;
+	depth_to_use = reqtags ? reqtags : 1;
 	scsi_adjust_queue_depth(sdev,
 				sdev->tagged_supported ? MSG_SIMPLE_TAG : 0,
 				depth_to_use);


