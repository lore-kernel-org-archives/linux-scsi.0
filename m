From: Joe Eykholt <jeykholt@cisco.com>
Subject: [PATCH] scsi: fix duplicate host number
Date: Mon, 15 Jun 2009 23:22:14 -0700
Message-ID: <20090616062214.15969.55575.stgit@savbu-fcoe15.qa.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:4293 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbZFPGWM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 02:22:12 -0400
Received: from sj-core-5.cisco.com (sj-core-5.cisco.com [171.71.177.238])
	by sj-dkim-2.cisco.com (8.12.11/8.12.11) with ESMTP id n5G6MExu024223
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 23:22:14 -0700
Received: from savbu-fcoe15.qa.nuovasystems.com (savbu-savbu-fcoe15.cisco.com [10.193.164.35])
	by sj-core-5.cisco.com (8.13.8/8.13.8) with ESMTP id n5G6ME35002916
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2009 06:22:14 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Just once, two fcoe instances got the same host number
from scsi_add_host().

Use atomic_t and atomic_inc_return() to get next host number.
Subtract 1, so that scsi_host still starts with 0.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 drivers/scsi/hosts.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 89d41a4..e9aaba9 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -40,7 +40,7 @@
 #include "scsi_logging.h"
 
 
-static int scsi_host_next_hn;		/* host_no for next new host */
+static atomic_t scsi_host_next_hn;	/* host_no for next new host */
 
 
 static void scsi_host_cls_release(struct device *dev)
@@ -333,7 +333,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
 	mutex_init(&shost->scan_mutex);
 
-	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
+	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */


