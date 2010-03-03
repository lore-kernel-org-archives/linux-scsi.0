From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Wed, 3 Mar 2010 15:25:47 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003031524110.1485-100000@iolanthe.rowland.org>
References: <233671224A0FED4688218FFDBED26E1A517AC38AB8@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40986 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756590Ab0CCUZs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 15:25:48 -0500
In-Reply-To: <233671224A0FED4688218FFDBED26E1A517AC38AB8@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>

On Wed, 3 Mar 2010, Hugh Daschbach wrote:

> > Can't we just protect the list?  What is wanting to write to the list
> > while shutdown is happening?
> 
> Indeed, Alan suggested holding the kset spinlock while iterating the
> list.  Unfortunately, the device shutdown routines may sleep.  At least
> the SCSI sd_shutdown routine issues I/O to the device as part of
> flushing device caches.  I would guess other subsystems sleep as well.

What I meant was that you should hold the spinlock while finding and 
unlinking the last device on the list.  Clearly you shouldn't hold it 
while calling the device shutdown routine.

> I'll try klist.  That looks like a good mediator between traversal and
> removal.

Yes, it removes a lot of difficulties.

Alan Stern

