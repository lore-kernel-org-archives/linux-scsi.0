From: akpm@linux-foundation.org
Subject: [patch 25/29] Fix |/|| confusion in fusion driver
Date: Tue, 06 Mar 2007 02:46:50 -0800
Message-ID: <200703061046.l26Akox5020073@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828AbXCFKrX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2007 05:47:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, dmueller@osuse.de, James.Bottomley@steeleye.com, eric.moore@lsi.com

From: Dirk Mueller <dmueller@osuse.de>

This patch corrects a |/|| confusion in mptscsih_copy_sense_data.  Using ||
means that the data that ends up being written is (almost always) 1,
instead of being bit-wise or'ed.

Cc: Eric Moore <eric.moore@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptscsih.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver
+++ a/drivers/message/fusion/mptscsih.c
@@ -2477,9 +2477,9 @@ mptscsih_copy_sense_data(struct scsi_cmn
 				ioc->events[idx].event = MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE;
 				ioc->events[idx].eventContext = ioc->eventContext;
 
-				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) ||
-					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||
-					(sc->device->channel << 8) || sc->device->id;
+				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) |
+					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) |
+					(sc->device->channel << 8) | sc->device->id;
 
 				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
 
_
