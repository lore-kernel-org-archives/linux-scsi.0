From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 12:24:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087316640.3556.147.camel@compaq.xsintricity.com>
References: <40CF0F9F.4050902@adaptec.com>
	 <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com>
	 <20040615154313.GA25397@devserv.devel.redhat.com>
	 <40CF1A5D.30908@adaptec.com>  <20040615155716.GA14017@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:31679 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265755AbUFOQYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 12:24:54 -0400
In-Reply-To: <20040615155716.GA14017@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Arjan Van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-06-15 at 11:57, Christoph Hellwig wrote:
> On Tue, Jun 15, 2004 at 11:48:45AM -0400, Luben Tuikov wrote:
> > This really isn't anything new or paramount.  It's just a simple
> > extension, marked OPTIONAL, that only *capable* drivers should use.
> > (i.e. the aic7xxx drivers, maybe some FC and USB).
> > 
> > So it's not really that big of a deal, but does wonders to
> > SCSI Core in terms of recovery time and *uninterruptible*
> > IO.
> 
> Well, the question is always what is so special about your driver that
> it doesn't benefit from beeing in a common library.

Well, pretty much the fact that the hardware determines what level of
recovery is possible, not the transport.  Even between different SPI
hardware, aka aic7xxx vs. sym53c8xx, you have different levels of
ability to perform recovery as dictated by how much of the adapter's
operation is handled by firmware you can control and how much isn't. 
Thinking that you can make a single SPI class recovery thread that's
actually elegant in relation to the particular hardware is wrong.  The
*only* place that will ever be able to do elegant error recovery is the
hardware driver.  It's the only code with the knowledge to be able to
discern a stuck device from a stuck bus from a missing transport from a
hung host, etc.  You can make a so-so generic layer if you want, like we
have now, but that shouldn't be a reason to stop a good driver from
doing the right thing if it wants to.  And that's what Luben's patch
does.  It doesn't force *any* driver to write any new eh code, it only
*allows* a driver to do so, and to fall back on the generic code if it
wants.  That would actually solve a lot of the reasons that drivers
currently do things like kill the timer on commands and set their own
timer on the command internally, stuff like that.  To me, the ability to
tell the eh thread to chill out, this command doesn't really have a
problem (and in my experience, the first command to timeout is not the
problem command 95% of the time) is a major benefit.

>   I've pulled more crap
> out of individual drivers than I'd ever want to imagine, and because of
> that I'm pretty much allergic against giving driver writers more control
> then nessecary.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


