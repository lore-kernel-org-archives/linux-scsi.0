From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problems with the block-layer timeouts
Date: Mon, 3 Nov 2008 18:23:50 +0100
Message-ID: <20081103172350.GV31673@kernel.dk>
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org> <20081103085247.GO31673@kernel.dk> <490F0822.6010406@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:49435 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYKCRZK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 12:25:10 -0500
Content-Disposition: inline
In-Reply-To: <490F0822.6010406@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Mon, Nov 03 2008, James Smart wrote:
> Jens Axboe wrote:
> >>While I'm on the subject, there are a few related items that could be
> >>improved.  In my tests, I was generating I/O requests simply by doing
> >>
> >>      dd if=/dev/sda ...
> >>
> >>I don't know where the timeouts for these requests are determined, but
> >>they were set to 60 seconds.  That seems much too long.
> >
> >Fully agreed, as Mike mentioned this actually looks like a dumb udev
> >rule that didn't have any effect until this generic timeout work. For
> >normal IO, something in the 10 second range is a lot more appropriate.
> 
> Yes and no. For direct-attach storage with no other initiators, ok.
> But for larger arrays, potentially with multiple initiators - no.  I
> can name several arrays that depend on a 30 second timeout, and a few
> that, underload, require 60 seconds.  I assume that there's usually
> "best practices" guides for the integrators to ensure the defaults are
> set right.

Sure I agree, it depends on what kind of storage you have. What I mean
is that for a normal disk you want something like 10 seconds.

-- 
Jens Axboe

