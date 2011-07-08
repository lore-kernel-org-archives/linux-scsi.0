From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Fri, 8 Jul 2011 15:43:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107081537260.2208-100000@iolanthe.rowland.org>
References: <1310144667.3282.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33391 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752168Ab1GHTnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 15:43:33 -0400
In-Reply-To: <1310144667.3282.94.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <roland@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Fri, 8 Jul 2011, James Bottomley wrote:

> However, that does beg the question of why sr is using the device after
> sr_remove() has completed.  That seems to be because of the block ops
> being the dominant structure, so we try to do cleanup when we get the
> block release rather than the driver release ... that looks to be the
> root cause to me.

Hmmm.  What happens if I use sysfs to unbind the scsi_device from sr
while it is still mounted, and then quickly rebind it again?  Until the
filesystem is unmounted and the block release is complete, would both
instances end up sending commands to the device concurrently?

Alan Stern

