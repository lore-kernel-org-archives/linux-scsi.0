From: Christoph Hellwig <hch@infradead.org>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Sat, 17 Jan 2004 20:54:50 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040117205450.A7305@infradead.org>
References: <20040112194829.A7078@infradead.org> <1073937102.3114.300.camel@compaq.xsintricity.com> <Pine.LNX.4.58L.0401131843390.6737@logos.cnet> <1074345000.13198.25.camel@compaq.xsintricity.com> <20040117165828.A4977@infradead.org> <1074366452.13198.48.camel@compaq.xsintricity.com> <20040117191704.A6344@infradead.org> <1074367303.13198.52.camel@compaq.xsintricity.com> <20040117192946.A6479@infradead.org> <1074371793.13198.58.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:60175 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266145AbUAQUyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 15:54:51 -0500
Content-Disposition: inline
In-Reply-To: <1074371793.13198.58.camel@compaq.xsintricity.com>; from dledford@redhat.com on Sat, Jan 17, 2004 at 03:36:33PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Sat, Jan 17, 2004 at 03:36:33PM -0500, Doug Ledford wrote:
> I'm exactly the opposite.  In my opinion, the mid layer should be using
> the device locks for its internal operations

well, I strongly disagree with that.

> and calling into the low
> level drivers with no locks held.  The fact that the mid layer still
> tries to lock drivers for the drivers is a bug IMO.  Every time I see a
> driver do spin_unlock_irq(host->host_lock); do driver work;
> spin_lock_irq(host->host_lock); return; it really points out that the
> mid layer has no business locking down drivers for them.

I completely agree with that, though.  I didn't have time fixing up
all drivers before we got 2.6, though so this won't happen before 2.7.

Btw, I just noticed how little this has to do with the original discussion,
Cc list thus cut down quite a lot.

