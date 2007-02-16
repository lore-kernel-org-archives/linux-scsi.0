From: akpm@linux-foundation.org
Subject: [patch 29/30] Fix |/|| confusion in fusion driver
Date: Fri, 16 Feb 2007 01:46:47 -0800
Message-ID: <200702160946.l1G9klfZ026711@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36889 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423512AbXBPJq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:46:59 -0500
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
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c~fix--confusion-in-fusion-driver
+++ a/drivers/message/fusion/mptscsih.c
@@ -2474,9 +2474,9 @@ mptscsih_copy_sense_data(struct scsi_cmn
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
