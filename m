From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [6/5]  qla2xxx: update version :)
Date: Sun, 24 Apr 2005 11:53:38 +0100
Message-ID: <20050424105338.GA22699@infradead.org>
References: <20050413205007.GA14857@plap.qlogic.org> <1113425828.4933.39.camel@mulgrave> <20050413212436.GC14857@plap.qlogic.org> <20050419211519.GB20234@infradead.org> <20050422072200.GD5069@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36994 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262308AbVDXKxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 06:53:39 -0400
Content-Disposition: inline
In-Reply-To: <20050422072200.GD5069@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 22, 2005 at 12:22:00AM -0700, Andrew Vasquez wrote:
> > Btw, any plans to do proper FCIP support integrated with the transport
> > class code?
> >
> 
> Ok, I'll bite (since this is the second time I've heard about FCIP
> being 'integrated' with the transport classes) -- what did you have in
> mind?  There's already a clear set of mature networking interface with
> which a networking card's driver uses to interface with the stack.
> 
> Are you looking to generalize those interfaces
> (open/hard_xmit/stop/etc.) into helpers transport helpers?

First we have a little bit of FC networking common code that's unfortunately
not used a lot in net/802/fc.c.  Some of may need a little updating as it's
been without love for more than five years.  Note that this means the
network device is presented as native fibre channel devices and not like
a fake ethernet device as in the current Qlogic IP driver.  Not faking
ethernet also makes the send and receive code quite a bit simpler.

Putting ->open/->stop into common code doesn't make a lot of sense as
there's very little non-trivial things in there besides poking the hardware.
Of the net_device methods only the noop stubs should go into common code
(net/802/fc.c).

Other candidates for common code are things like qla2x00_convert_to_arp and
qla2x00_get_ip_loopid.  In general I'd prefer the actual FC over IP drivers
to not have to poke into higherlevel (SNAP, ARP, IP) protocol headers at
all, or having to iterate over fc remote port structures themselves.

Actual transport class integration is very little.  First a proper interface
for the IP over FC driver to get called back on IP remote ports instead of
various odd hand crafted methods, second a link in sysfs from the FC remote
to the netdevice to make managment easier.  Also some of the ethtool methods
could probably be implemented ontop of the information we already have in
the transport class.
