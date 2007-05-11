From: akpm@linux-foundation.org
Subject: [patch 10/28] Fix |/|| confusion in fusion driver
Date: Thu, 10 May 2007 23:00:53 -0700
Message-ID: <200705110600.l4B60rGD008145@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758389AbXEKGBa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:01:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, dmueller@suse.de, James.Bottomley@steeleye.com, eric.moore@lsi.com

From: Dirk Mueller <dmueller@suse.de>

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
@@ -2463,9 +2463,9 @@ mptscsih_copy_sense_data(struct scsi_cmn
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
