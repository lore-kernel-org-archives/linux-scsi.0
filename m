From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] BUG_ON on kernel misbehavior on A100U2W driver
Date: Tue, 15 Jul 2008 17:18:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151717520.4356@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0807151011350.24544@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761054AbYGOVTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 17:19:11 -0400
In-Reply-To: <Pine.LNX.4.64.0807151012200.24544@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

With broken Sparc64 IOMMU accounting, the kernel submits larger requests then
allowed. Better to crash on BUG than corrupt memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/scsi/a100u2w.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.26-devel/drivers/scsi/a100u2w.c
===================================================================
--- linux-2.6.26-devel.orig/drivers/scsi/a100u2w.c	2008-07-14 20:03:43.000000000 +0200
+++ linux-2.6.26-devel/drivers/scsi/a100u2w.c	2008-07-15 00:46:02.000000000 +0200
@@ -866,6 +866,7 @@ static void inia100_build_scb(struct orc
 
 	count_sg = scsi_dma_map(cmd);
 	BUG_ON(count_sg < 0);
+	BUG_ON(count_sg > TOTAL_SG_ENTRY);
 
 	/* Build the scatter gather lists */
 	if (count_sg) {
