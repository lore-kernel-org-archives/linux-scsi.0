From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Sat, 27 Dec 2003 15:17:12 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072538231.5494.12.camel@dhcp23.swansea.linux.org.uk>
References: <1051920000.1054684267@aslan.btc.adaptec.com>
	 <3637050000.1054690456@aslan.s csiguy.com>
	 <2113050000.1072285128@aslan.scsiguy.com>
	 <1072288242.1906.35.camel@mulgrave >
	 <2148850000.1072292121@aslan.scsiguy.com>
	 <1072292714.2415.39.camel@mulgrave>
	 <2304040000.1072326693@aslan.scsiguy.com>
	 <1072463795.1873.127.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from crosslink-village-512-1.bc.nu ([81.2.110.254]:20389 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S264481AbTL0PVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 10:21:34 -0500
In-Reply-To: <1072463795.1873.127.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Gwe, 2003-12-26 at 18:36, James Bottomley wrote:
> >From a technical perspective, the way you try to thwart mid-layer error
> recovery: intercept all the SCSI timers and substitute your own, is
> extremely ugly (and leads to quite a bit of code duplication) but it's
> surely going to cause a conflict with the evolving stackable error
> handling.

Or install your own EH handler. You don't have to use the kernel eh at
all, you can just opt out of it and for some cards like smart raid
devices its precisely the right thing to do. I can believe the argument
that for fast failover you want to do EH differently, and nothing in the
architecture seems to make that hard providing a driver is willing to
opt cleanly out of the scsi_eh handler.

Similarly it would be nice to be able to revector the actual scsi eh
timeouts via an optional handler. Something of the form


int myscsi_timeout_handler(Scsi_Cmd *cmd, int reason, void *.. whatever)
{
	...

	if(reason == SCSI_TIMEOUT && host->bus_state == FIBRE_DOWN && 
		priv->retry_count < 5)
		return SCSI_RETRY(60);
	return SCSI_DEFAULT;
}


