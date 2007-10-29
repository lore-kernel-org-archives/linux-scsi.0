From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v4 0/2] [SCSI] Asynchronous event notification infrastructure
Date: Mon, 29 Oct 2007 10:42:07 -0400 (EDT)
Message-ID: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:50492 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbXJ2OmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 10:42:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
Cc: akpm@linux-foundation.org

This is the next revision of the SCSI event notification infrastructure
patchset, enabling SATA Asynchronous Notification ("AN") for CD/DVD
devices that support it.

For devices that support SATA AN (only very recent ones do), this means
that HAL and other userspace utilities no longer need to repeatedly poll
the CD/DVD device to determine if the user has changed the media.

This revision takes into account James' comments from earlier today,
modulo the following notes:

* I think the various event attributes should always be present,
  for all devices at all times.  If various events are not supported,
  the attribute will of course return zero (false, not supported).

* I do not think this work should be blocked behind a revamp
  of the attribute group interface.

* I was slack and did not bother to implement the 'set' operation
  for the attributes.  This can easily be done at a later time in a
  separate patch.  It is not a merge stopper to have the driver
  exclusively control the event mask, rather than driver+sysfs.

