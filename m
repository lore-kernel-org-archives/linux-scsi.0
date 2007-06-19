From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Mon, 18 Jun 2007 23:03:57 -0700 (PDT)
Message-ID: <20070618.230357.08341020.davem@davemloft.net>
References: <20070615171545.316dfac7@the-village.bc.nu>
	<20070615.141917.85409547.davem@davemloft.net>
	<20070619055358.GD18542@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbXFSGDj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jun 2007 02:03:39 -0400
In-Reply-To: <20070619055358.GD18542@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: alan@lxorguk.ukuu.org.uk, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 19 Jun 2007 07:53:58 +0200

> On Fri, Jun 15, 2007 at 02:19:17PM -0700, David Miller wrote:
> > Another quirk I have to deal with is that under LDOMs you
> > can export full disks and also just slices.  So I'll have
> > to get down into the partition machinery to support that
> > somehow.
> 
> What's the problem with that?  Partition machinery is perfectly
> fine with just getting a raw disk without a partition table,
> and it obviously doesn't care if the raw disk it sees is part
> of a partition on the storage server.

Applications care :-)

One way of managing the partition table is by asking the storage
server for it.  It supports giving back something that looks
like the Sun partition table layout, and also something that's
EFI based.

But the client can ignore that and read/write the partition
table itself.

What I really care about is what will work transparently for existing
userspace.  In particular, distribution installers and existing tools
like fdisk.

When a slice it being exported, it's not being exported like that so
that the client can just spam a disk label into it, it's for exporting
one slice.  So we might want (using the scsi naming as an arbitrary
example case) /dev/sda1 to be created but not /dev/sda

How exactly do you envision this kind of thing working?

Supporting the disk-server-provided partition table management
means providing ioctls() or whatever interface to get/set
the table.  I had one idea to intercept reads/writes to the
first block(s) and translating those into partition management
commands to the disk server, but that is just too ugly to live. :-)
