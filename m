From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Problem with external USB2.0 case and LG GSA
	4040-B
Date: 16 Dec 2003 13:36:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071599762.2080.116.camel@mulgrave>
References: <Pine.LNX.4.44L0.0312151529160.895-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44506 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262009AbTLPSg4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2003 13:36:56 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312151529160.895-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelius Claussen <cornelius.claussen@gmx.de>, Patrick Mansfield <patmans@us.ibm.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

I've been thinking some more about this.  Although the driver is
apparently at fault here by issuing a reset without telling the
mid-layer, it might be useful to filter out other common ASC/ASCQ codes
in scsi_io_completion() we retry on "in the process of becoming ready",
then for any other UNIT_ATTENTION, we assume it was a disc change for
removable (this is what causes the I/O error in this case) or a reset
for non-removable.

Perhaps we should do a more dilligent check for the reset case?  ASC
0x29 and ASCQ <= 4 seems to identify all the reset cases.  Since the
tape case doesn't come through here, there's no danger of doing an
incorrect retry for it.

There is, however, one danger to the removable case: a power cycle could
still be accompanied by a medium change, which would now be missed.

On the whole, I'm inclined to leave everything the way it is, but was
wondering if there were any other comments?

James


