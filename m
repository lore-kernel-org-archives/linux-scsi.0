From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH] ips driver for 2.4.23-pre4
Date: 08 Jan 2004 16:16:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073596589.2915.276.camel@mulgrave>
References: <A121ABA5B472B74EB59076B8E3C8F0190129F3@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:39133 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266312AbUAHVQi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 16:16:38 -0500
In-Reply-To: <A121ABA5B472B74EB59076B8E3C8F0190129F3@rtpe2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, Tosatti <marcelo.tosatti@cyclades.com>

On Thu, 2004-01-08 at 15:18, Hammer, Jack wrote:
> The reason this compiler warning exists is that these are the only hardware
> platforms that support this adapter.  Use of this adapter is any other box
> can cause serious problems and is not supported by anyone.  Removal of this
> warning has no effect on the executable code and would not improve the
> driver in my opinion.  If I was including a module in my system that is not
> going to work, I'd like to know about it.
[...]
> > -#if !defined(__i386__) && !defined(__ia64__) -#error "This driver has 
> > only been tested on the x86/ia64 platforms"
> > +#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__) 
> > +#error "This driver has only been tested on the x86/ia64/x86_64
> platforms"
> >  #endif

This is actually an #error though, not a #warning...could we at least
downgrade it to #warning (like has already been done for ips) so I don't
get spurious compile failure reports from people doing make allyes
configurations on non-x86 boxes?

Thanks,

James


