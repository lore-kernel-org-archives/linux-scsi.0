From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Fri, 31 Oct 2003 19:08:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067645285.3112.538.camel@compaq.xsintricity.com>
References: <1067447221.3112.336.camel@compaq.xsintricity.com>
	 <1067447490.1829.30.camel@mulgrave>
	 <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk>
	 <1067450547.3112.363.camel@compaq.xsintricity.com>
	 <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk>
	 <1067453148.3112.369.camel@compaq.xsintricity.com>
	 <4159000000.1067644546@aslan.btc.adaptec.com>
	 <1067644902.1782.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54535 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261871AbTKAAJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 19:09:31 -0500
In-Reply-To: <1067644902.1782.20.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2003-10-31 at 18:55, James Bottomley wrote:
> On Fri, 2003-10-31 at 17:55, Justin T. Gibbs wrote:
> > BTW, slave_destroy() doesn't seem to be called after a probe
> > for a target fails due to a selection timeout.  Is this the
> > expected behavior?  I only keep persistent allocations after
> > slave_configure() is called, so this doesn't affect my drivers,
> > but the behavior isn't what I expected.  This is 2.6.0-test9.
> 
> Yes.
> 
> slave_configure is only called if the mid-layer decides there's
> something worth attaching to there (i.e. if the initial inquiry
> succeeds); otherwise it just calls slave_destroy to signal loss of
> interest in the target.

That's exactly what Justin was saying *isn't* happening (aka, no target
is there, we *don't* call slave_destroy is what Justin said).


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


