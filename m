From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: new interfaces
Date: Sun, 23 May 2004 06:37:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040523103729.GA23804@infradead.org>
References: <1085240593.2006.8.camel@mulgrave> <Pine.LNX.4.44.0405222127200.2781-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.217.7]:27923 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S262020AbUEWKhe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 May 2004 06:37:34 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0405222127200.2781-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Sat, May 22, 2004 at 09:34:47PM +0200, Guennadi Liakhovetski wrote:
> Ok, here comes the risky (and, so far, the last) one. It updates the
> driver to use the "new" pci, scsi, and module interfaces. It is risky,
> because it changes quite a bit, and I, unfortunatly, can only test it in
> one configuration - compiled in (not as a module), and I don't have any
> devices, that support tagged command queues, and it is just an onboard
> AM53C974 chip without EEPROM.

Looks mostly goo to me, one thing I worry about is the complete
removal of the scan_device flag, I don't fully understand what it's
supposed to do, but we should be able to always set in ->slave_alloc
and then clear it in ->slave_configure when we know probing is over
for this device.

The other thing is that most calls to dc390_findDCB could probably be
replaced with stroing the pDCB in scsi_device->hostdata on slave_alloc,
but that could aswell be done in an incremental patch.

In dc390_init_one you don't call pci_disable_device on failure,
best switch to goto for a single shared error path to avoid all
these leaks.  Maybe also  merge dc390_init and dc390_init_one?

Similarly I think DC390_release should be merged into dc390_remove_one.

