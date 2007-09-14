From: Alan Stern <stern@rowland.harvard.edu>
Subject: Power management for SCSI transports
Date: Fri, 14 Sep 2007 15:02:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709141452170.3782-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45268 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752519AbXINTCO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 15:02:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Kristen:

You've been doing a lot of work on link power management for SCSI
buses.  It would be good if we could integrate this with the USB
power-management implementation in the usb-storage driver -- but I'm
not sure whether our requirements and feature sets really match up.

I'm not at all familiar with what you've already done.  From my point
of view, what's needed is a way for the SCSI core to tell a lower-level
driver that all the devices on its bus are safely quiescent and it's
okay to put the HBA & transport into a power-saving state.  (For
example, the higher layers would have to insure that disk heads are
parked and drives spun down, if needed.)  It might be nice to have a
callback for the converse situation also, but this doesn't seem
necessary since the LLD can go back to full power on demand.

(The same approach ought to work with non-USB transports, but I'll
stick to what I know about.)

Does this mesh well with your current designs?

Alan Stern

