From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers
Date: Thu, 01 May 2008 14:50:17 -0700
Message-ID: <20080501215017.27759.37314.sendpatchset@chandra-ubuntu>
References: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34511 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762179AbYEAVtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 17:49:16 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m41LnFMg022720
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 17:49:15 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m41LnF02205136
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 15:49:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m423nFOi017941
	for <linux-scsi@vger.kernel.org>; Thu, 1 May 2008 21:49:15 -0600
In-Reply-To: <20080501214941.27759.95121.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, andmike@us.ibm.com, michaelc@cs.wisc.edu, agk@redhat.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dwysocha@redhat.com, Benoit_Arthur@emc.com, asson_ronald@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>

Subject: [PATCH 06/10] scsi_dh: Do not allow arguments for hardware handlers

From: Chandra Seetharaman <sekharan@us.ibm.com>

The new implementation does not use the arguments provided with the
hardware handler. This patch makes the change visible to the user by
failing table load when arguments are provided with the hardware handler.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
Index: linux-2.6.25/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.25.orig/drivers/md/dm-mpath.c
+++ linux-2.6.25/drivers/md/dm-mpath.c
@@ -653,11 +653,15 @@ static int parse_hw_handler(struct arg_s
 	struct dm_target *ti = m->ti;
 
 	static struct param _params[] = {
-		{0, 1024, "invalid number of hardware handler args"},
+		{0, 1, "invalid number of hardware handler args"},
 	};
 
-	if (read_param(_params, shift(as), &hw_argc, &ti->error))
+	if (read_param(_params, shift(as), &hw_argc, &ti->error)) {
+		if (hw_argc > 1)
+			ti->error = "no arguments accepted for hardware"
+					" handler";
 		return -EINVAL;
+	}
 
 	if (!hw_argc)
 		return 0;
