From: Dmitry Yusupov <dmitry_yus@yahoo.com>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance
	Initiator
Date: Sat, 30 Jul 2005 14:25:28 -0700
Message-ID: <1122758728.13559.4.camel@mylaptop>
References: <429E15CD.2090202@yahoo.com> <1122744762.5055.10.camel@mulgrave>
	 <20050730.125312.78734701.davem@davemloft.net>
	 <1122755000.5055.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.mail.sc5.yahoo.com ([66.163.169.225]:63672 "HELO
	smtp105.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261516AbVG3VZz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 17:25:55 -0400
In-Reply-To: <1122755000.5055.31.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, itn780@yahoo.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Sat, 2005-07-30 at 15:23 -0500, James Bottomley wrote:
> On Sat, 2005-07-30 at 12:53 -0700, David S. Miller wrote:
> > From: James Bottomley <James.Bottomley@SteelEye.com>
> > Date: Sat, 30 Jul 2005 12:32:42 -0500
> > 
> > > FIB has taken your netlink number, so I changed it to 32
> > 
> > MAX_LINKS is 32, so there is no way this reassignment would
> > work.
> 
> Actually, I saw this and increased MAX_LINKS as well.  I was going to
> query all of this on the net-dev mailing list if we'd managed to get the
> code compileable.
> 
> > You have to pick something in the range 0 --> 32, and as is
> > no surprise, there are no numbers available :-)
> > 
> > Since ethertap has been deleted, 16-->31 could be made allocatable
> > once more, but I simply do not want to do that and have the flood
> > gates open up for folks allocating random netlink numbers.
> > 
> > Instead, we need to take one of those netlink numbers, and turn
> > it into a multiplexable layer that can support an arbitrary
> > number of sub-netlink types.  Said protocol would need some
> > shim header that just says the "sub-netlink" protocol number,
> > something as simple as just a "u32", this gets pulled off the
> > front of the netlink packet and then it's passed on down to the
> > real protocol.
> 
> I'll let the iSCSI people try this ...
> 
> Alternatively, if they don't fancy it, I think the kobject_uevent
> mechanism (which already has a netlink number) looks like it might be
> amenable for use for most of the things they want to do.

In fact, during design phase we've considered to use kobject_uevent() as
well but (if i recall correctly), it didn't fit for the simple reason
that if we want to have that much code in user-space, than we need to
have more control on netlink socket and need to pass binary data back
and forth.

It would be nice to set MAX_LINKS to 64 and close this issue for now,
since I'm pretty sure some other apps might find out kobject_uevent()
not suitable for their needs too.

Dima

