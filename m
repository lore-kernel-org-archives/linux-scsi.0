From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: 27 Dec 2003 09:54:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072540449.2030.45.camel@mulgrave>
References: <1051920000.1054684267@aslan.btc.adaptec.com>
	<3637050000.1054690456@aslan.s csiguy.com>
	<2113050000.1072285128@aslan.scsiguy.com>
	<1072288242.1906.35.camel@mulgrave >
	<2148850000.1072292121@aslan.scsiguy.com>
	<1072292714.2415.39.camel@mulgrave>
	<2304040000.1072326693@aslan.scsiguy.com>
	<1072463795.1873.127.camel@mulgrave>
	<1072538231.5494.12.camel@dhcp23.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:64656 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264484AbTL0PyM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 10:54:12 -0500
In-Reply-To: <1072538231.5494.12.camel@dhcp23.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Sat, 2003-12-27 at 09:17, Alan Cox wrote:
> Or install your own EH handler. You don't have to use the kernel eh at
> all, you can just opt out of it and for some cards like smart raid
> devices its precisely the right thing to do. I can believe the argument
> that for fast failover you want to do EH differently, and nothing in the
> architecture seems to make that hard providing a driver is willing to
> opt cleanly out of the scsi_eh handler.

Well, that's what the eh_strategy_handler hook is for.

It certainly makes sense to do this for pseudo-scsi devices, like RAID
cards.  But, for standard transports, like parallel SCSI and Fibre, I'd
much rather see a standardised error handling library as part of the
stack, with the mid-layer providing standard transport recovery
functions on a per-transport basis, and the Upper Layer Drivers
providing device specific handling.

> Similarly it would be nice to be able to revector the actual scsi eh
> timeouts via an optional handler. Something of the form

That's a good idea...do you want to send in the patches?

James


