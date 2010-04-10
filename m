From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] RFC: scsi transport: add bsg timeout callout
Date: Sat, 10 Apr 2010 05:17:38 -0500
Message-ID: <1270894661-28402-2-git-send-email-michaelc@cs.wisc.edu>
References: <1270894661-28402-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0DJKRw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 06:17:52 -0400
In-Reply-To: <1270894661-28402-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This adds a callout to the transport template to handle
bsg request timeouts. It is needed by the scsi bsg lib,
so that transport classes can set their own timeout
handlers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 include/scsi/scsi_transport.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 0de32cd..fdaee9e 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -68,6 +68,14 @@ struct scsi_transport_template {
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
 
 	/*
+	 * This is an optional routine that allows the transport to become
+	 * involved when a bsg req timer fires. 0 should be returned on
+	 * success and a -Exyz code should be returned on a error.
+	 * If -EAGAIN is returned we give the request more time.
+	 */
+	int (*eh_bsg_timed_out)(struct request *);
+
+	/*
 	 * Used as callback for the completion of i_t_nexus request
 	 * for target drivers.
 	 */
-- 
1.6.6.1

