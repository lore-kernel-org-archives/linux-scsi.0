From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v5 0/2] SCSI asynchronous event notification API
Date: Mon, 29 Oct 2007 17:31:55 -0400 (EDT)
Message-ID: <1e0190fe71e148eb044c16b805738908ae2fe0bc.1193692827.git.jeff@garzik.org>
References: <1193677315.3383.59.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:35909 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXJ2Vb4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 17:31:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

This is the next revision of the SCSI event notification infrastructure
patchset, enabling SATA Asynchronous Notification ("AN") for CD/DVD
devices that support it.

For devices that support SATA AN (only very recent ones do), this means
that HAL and other userspace utilities no longer need to repeatedly poll
the CD/DVD device to determine if the user has changed the media.

This revision takes into account James' comments from earlier today,
up to patchset revision #4 (this one is revision 5).

Changes since last revision:

1) sysfs 'store' operation is implemented, to eliminate any confusion
   about how it should work.

2) if we are going to emit events more complex than a single "I'm
   asserted" bit, then we cannot use the nifty bitmap.h stuff.

a) struct scsi_event is created.

b) sdev_evt_send() -- send an event.  event intentionally and
   silently dropped, if not in supported_events mask.

c) sdev_evt_alloc() -- allocate an event.  structured such that
   future event types can be added easily.

d) sdev_evt_send_simple() -- for simple events where we only need
   to know the event type, we can use this simple interface (libata uses
   this).

e) Events are sent one-at-a-time.  Unlike the bitmap, complex events
   should not be merged together.

