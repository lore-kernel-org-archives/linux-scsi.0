From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: 26 Dec 2003 21:20:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072495231.1873.363.camel@mulgrave>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s
			csiguy.com>
	<2113050000.1072285128@aslan.scsiguy.com>	<1072288242.1906.35.camel@mulgrave
		>
	<2148850000.1072292121@aslan.scsiguy.com>	<1072292714.2415.39.camel@mulgrave
	> 	<2304040000.1072326693@aslan.scsiguy.com>
	<1072463795.1873.127.camel@mulgrave>
	<2832150000.1072484024@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20105 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265301AbTL0DUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Dec 2003 22:20:36 -0500
In-Reply-To: <2832150000.1072484024@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Fri, 2003-12-26 at 18:13, Justin T. Gibbs wrote:
> Recovery is critical.  Why have failover controllers if it takes several
> minutes for that failover to succeed.  The whole point of these controllers
> is to allow a critical service to continue to operate almost uninterrupted.

Recovery for failover controllers will be done at a higher level using
the fastfail mechanism.

> > The successive t10
> > committees charged with rewriting it have never successfully produced a
> > draft standard that has been published on the t10 site.
> 
> This is because no-one wanted to rewrite their SCSI layers to be in
> complete compliance with the letter and verse of CAM (i.e. the actual
> CCB structure definitions listed in the CAM spec).  I was at the last
> meeting of the CAM subcommittee so I know why it was disbanded.

OK, we have differing views about CAM.  However, regardless of why it
happened, CAM is dead and the committee disbanded.  SCSI development
will go on without reference to CAM.

> In general, the peripheral driver should get the first crack at any
> status returned by an HBA driver.  Until that occurs, the Linux SCSI
> layer is critically flawed.  If you are interested, you can look at
> how the FreeBSD SCSI layer deals with these issues.  The peripheral
> driver "filters" all errors and defaults to using a common, generic
> error handler for errors that do not need special handling.  Right
> now, the Linux mid-layer hides information and performs actions that
> are not necessarilly what the peripheral driver wants.  Other than
> perhaps statistics gathering, and other actions that are not visible
> to the end device, this should not be the case.

That's not true.  For a fatal transport error in a multi-path device all
you'll do is delay the inevitable switchover.  That's why trying to
second guess error recovery like this is counter productive.

> I'm not pulling all error recovery into my driver.  I'm pulling transport
> specific *watchdog recovery* into my driver.  It is the HBA's job to ensure
> that it can access the devices attached to it.  The peripheral driver's
> job is to inform the HBA of a drop-dead time for a command.  Recovering
> from a timeout is actually very straight forward if you have the information
> you need to do it correctly.  This can only be done at the HBA where HBA
> specific state can be referenced to pick the correct type of action.  This,
> to my mind, is just a minor extention to the transport validation and
> recovery that HBAs also must do in order to be robust.  Protocol and device
> specific recovery (related to SCSI status, residuals, etc.) will continue to
> be performed by the peripheral driver (or as in the case of Linux, by
> the mid-layer).  I have no interest in *doing it all*, only what I have
> to for the drivers I maintain to be robust.

By stopping the timers and redirecting to an internal thread in your
driver, you are subverting all of the error recovery for your driver.

I appreciate its a hard thing to be dependent on code outside your
control.  However, duplicating functionality solely to bring code under
your control is not the correct approach.  The open source philosophy is
to encourage people to get involved in areas of code outside their
direct responsibility when this happens and, inevitably, to try to reach
an amicable compromise about fixing it.  This is one of the reasons why
good open source developers tend to have a strong record of
contributions outside their perceived fields of expertise.

I'm prepared to allow driver writers a considerable amount of slack in
terms of deviation from the coding standards, useless and obfuscating
compatibility layers and #ifdef'd code that can never be compiled in
2.6; however, this attempt to hijack the basic SCSI APIs within the
adaptec driver is unacceptable.  Please take it out and resubmit the
patch without it.

Thanks,

James


