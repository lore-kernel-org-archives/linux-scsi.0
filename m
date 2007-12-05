From: Matthew Wilcox <matthew@wil.cx>
Subject: Another use for block-layer timeouts
Date: Wed, 5 Dec 2007 14:06:23 -0700
Message-ID: <20071205210623.GB27526@parisc-linux.org>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40252 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbXLEVGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 16:06:24 -0500
Content-Disposition: inline
In-Reply-To: <20071107132256.GG5525@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: malahal@us.ibm.com, linux-scsi@vger.kernel.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, sarah.a.sharp@intel.com

On Wed, Nov 07, 2007 at 02:22:57PM +0100, Jens Axboe wrote:
> On Tue, Nov 06 2007, malahal@us.ibm.com wrote:
> > gdth driver is modified NOT to use scp->eh_timeout. Now, it has
> > eh_timed_out (gdth_timed_out) to handle command timeouts for locked
> > I/O's. Have not tested as I don't have needed hardware! Patch is
> > against 2.6.23-mm1.
> 
> I updated the timeout patch to current kernel and fixed some fallout. I
> included your gdth patch.
> 
> Completely untested, patch is below. It's also in the #timeout branch of
> the block git repo, to keep track of it.

Hi Jens,

Kristen, Sarah and I were talking over lunch today, and discovered that
they each have a problem that I think can be solved by using the block
layer timeout functionality.  One problem is a software-controlled drive
activity LED.  The other is wanting to save power by suspending the link
to an idle USB Storage device.

What these both have in common is the desire to find out when the queue
is empty (with a bit of hysteresis to avoid flickering the LED off for
too long, or powering down the USB link when there's a command about
to arrive).

I think this could be done with the timer you're adding here, by adding
a driver callback to be called once the timer fires and there's no
commands in the queue.  Alternatively, we could add another timer.
While each driver could have its own timer to detect these cases, if
we have two drivers that want this information, chances are there are
others that could also make use of it.

What do you think?  Shall I try knocking up a patch to (ab)use the timer
in this way?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
