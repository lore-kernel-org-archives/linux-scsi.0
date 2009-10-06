From: Alan Stern <stern@rowland.harvard.edu>
Subject: Toward eliminating the scan_mutex
Date: Tue, 6 Oct 2009 13:49:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0910061330410.3002-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35696 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757333AbZJFRu2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2009 13:50:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

What do you think of removing shost->scan_mutex and replacing it with a
"visibility mutex" in each scsi_target and scsi_device?  This new mutex
would be held whenever the target/device was undergoing a change of
visibility or was gaining a new child (reap_ref would be protected by 
the new mutex instead of by the host lock).  Those are the actions 
which really need to be serialized.

The same general scheme would work for both targets and devices, since
they employ the same "allocate and initialize a new structure, see if
an older one already exists, then either use the old one or link in and
use the new one" approach.

I'm not sure if this really addresses all your misgivings about the 
scan_mutex.  It does have the advantage of not forcing all activities 
below a given host through a single funnel.

Alan Stern

