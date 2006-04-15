From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] megaraid_{mm,mbox}: fix a bug in reset handler
Date: Sat, 15 Apr 2006 09:00:23 -0500
Message-ID: <1145109623.3573.7.camel@mulgrave.il.steeleye.com>
References: <890BF3111FB9484E9526987D912B261901BCC2@NAMAIL3.ad.lsil.com>
	 <20060412220011.2ddd6f63.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:30612 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030250AbWDOOAm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 10:00:42 -0400
In-Reply-To: <20060412220011.2ddd6f63.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>, Seokmann.Ju@engenio.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2006-04-12 at 22:00 -0700, Andrew Morton wrote:
> Oh my.  That's an awfully long interrupts-off spin.  1.7e7 operations with
> an NMI watchdog timeout of five seconds - I'm surprised it doesn't trigger.
> 
> Is that reading from a PCI register there?   Or main memory?

It's a "mailbox" region, which is a piece of main memory shared between
the driver and the card (allocated using dma_alloc_coherent).

> I'm somewhat surprised that the compiler never "optimises" this into a
> lockup, actually.  That's what `volatile' is for.

The rmb(); below ensures the compiler can't optimise.  However, I do
agree; tagging the mailbox as volatile would show the compiler better
what the intent is.

> Is it not possible to do this with an interrupt?

I'd guess not.  A lot of these types of driver have what's called a
doorbell/mailbox interface which means that as long as there's a command
slot you get access to the device (or wait for an interrupt to tell you
one's free) but you have to post the command to the device, so you wait
at the mailbox to see that it's taken (usually because the device has to
assign things like tracking numbers or indexes).  The intent is for
there to be a fairly instantaneous response however firmware doesn't
always see it that way ...

> A `cpu_relax()' in that loop would help cool things down a bit.

Actually, I think a simple udelay(25) might help in a lot of these
loops.

James


