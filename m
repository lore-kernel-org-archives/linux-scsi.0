From: Dave Jones <davej@redhat.com>
Subject: Re: [patch 10/28] Fix |/|| confusion in fusion driver
Date: Mon, 21 May 2007 20:59:47 -0400
Message-ID: <20070522005947.GC12157@redhat.com>
References: <200705110600.l4B60rGD008145@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbXEVBAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 21:00:35 -0400
Content-Disposition: inline
In-Reply-To: <200705110600.l4B60rGD008145@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dmueller@suse.de, eric.moore@lsi.com

On Thu, May 10, 2007 at 11:00:53PM -0700, Andrew Morton wrote:
 > From: Dirk Mueller <dmueller@suse.de>
 > 
 > This patch corrects a |/|| confusion in mptscsih_copy_sense_data.  Using ||
 > means that the data that ends up being written is (almost always) 1,
 > instead of being bit-wise or'ed.

Andrew, the last time this was posted, Eric picked up on some other
flaws in the same area. James asked him to followup with a patch, but
unless I'm mistaken, that never arrived.
This diff should replace the one in your tree until Eric has an
equivalent or better.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index d25d3be..165f81d 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -436,7 +436,7 @@ typedef struct _MPT_SAS_MGMT {
 typedef struct _mpt_ioctl_events {
 	u32	event;		/* Specified by define above */
 	u32	eventContext;	/* Index or counter */
-	int	data[2];	/* First 8 bytes of Event Data */
+	u32	data[2];	/* First 8 bytes of Event Data */
 } MPT_IOCTL_EVENTS;
 
 /*
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index fa0f776..3bd94f1 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2463,11 +2463,11 @@ mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR
 				ioc->events[idx].event = MPI_EVENT_SCSI_DEVICE_STATUS_CHANGE;
 				ioc->events[idx].eventContext = ioc->eventContext;
 
-				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) ||
-					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) ||
-					(sc->device->channel << 8) || sc->device->id;
+				ioc->events[idx].data[0] = (pReq->LUN[1] << 24) |
+					(MPI_EVENT_SCSI_DEV_STAT_RC_SMART_DATA << 16) |
+					(sc->device->channel << 8) | sc->device->id;
 
-				ioc->events[idx].data[1] = (sense_data[13] << 8) || sense_data[12];
+				ioc->events[idx].data[1] = (sense_data[13] << 8) | sense_data[12];
 
 				ioc->eventContext++;
 				if (hd->ioc->pcidev->vendor ==

-- 
http://www.codemonkey.org.uk
