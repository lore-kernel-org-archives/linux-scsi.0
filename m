From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Sat, 27 Dec 2003 09:02:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3334920000.1072540932@aslan.btc.adaptec.com>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	 <3637050000.1054690456@aslan.s csiguy.com>	 <2113050000.1072285128@aslan.scsiguy.com>	 <1072288242.1906.35.camel@mulgrave >	 <2148850000.1072292121@aslan.scsiguy.com>	 <1072292714.2415.39.camel@mulgrave>	 <2304040000.1072326693@aslan.scsiguy.com>	 <1072463795.1873.127.camel@mulgrave> <1072538231.5494.12.camel@dhcp23.swansea.linux.org.uk>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:48817 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264488AbTL0P4m
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 10:56:42 -0500
In-Reply-To: <1072538231.5494.12.camel@dhcp23.swansea.linux.org.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

> Or install your own EH handler.

This was something I considered, but is sadly not enough.  You need
at least two other changes to make it work:

1) scsi_done needs to complete commands regardless of the timer
   state.  The implied race condition commented about in scsi_done()
   doesn't exist.  The HBA driver knows whether a command is in flight
   or not.  Attempting to abort a command that is not active can just
   return immediately with whatever status is agreed upon for the API.
   Without this change, a driver must reschedule bogus timers to get
   a completion to take effect.

2) The driver's must be notified of timeouts immediately.  Your idea
   of re-vectoring the timeout handler would do this just fine.

--
Justin

