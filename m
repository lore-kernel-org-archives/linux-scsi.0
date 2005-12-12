From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Mon, 12 Dec 2005 12:24:42 -0600
Message-ID: <1134411882.9994.18.camel@mulgrave>
References: <20051201195657.GB7236@tau.solarneutrino.net>
	 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
	 <20051202180326.GB7634@tau.solarneutrino.net>
	 <Pine.LNX.4.61.0512021856170.4940@goblin.wat.veritas.com>
	 <20051202194447.GA7679@tau.solarneutrino.net>
	 <Pine.LNX.4.61.0512022037230.6058@goblin.wat.veritas.com>
	 <20051206160815.GC11560@tau.solarneutrino.net>
	 <Pine.LNX.4.61.0512062025230.28217@goblin.wat.veritas.com>
	 <20051206204336.GA12248@tau.solarneutrino.net>
	 <Pine.LNX.4.61.0512071803300.2975@goblin.wat.veritas.com>
	 <20051212165443.GD17295@tau.solarneutrino.net>
	 <Pine.LNX.4.64.0512120928110.15597@g5.osdl.org>
	 <1134409531.9994.13.camel@mulgrave>
	 <Pine.LNX.4.64.0512121007220.15597@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932117AbVLLSZi@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0512121007220.15597@g5.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Ryan Richter <ryan@tau.solarneutrino.net>, Hugh Dickins <hugh@veritas.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2005-12-12 at 10:09 -0800, Linus Torvalds wrote:
> Well, that patch is definitely broken.

No, it's not; all it's doing is deferring the device_put() from the
scsi_put_command() to after the scsi_run_queue(), which doesn't fix the
sleep while atomic problem of the device release method.  In both cases
we still get the semaphore in atomic context problem which is caused by
scsi_reap_target() doing a device_del(), which I assumed (wrongly) was
valid from atomic context.

I'll fix the scsi_reap_target(), but it's nothing to do with the patch
you reversed.

> You say that it just causes a warning about sleeping in interrupt context, 
> while I say that the warning is a serious error. If that semaphore _ever_ 
> is write-locked, the whole machine will crash from trying to sleep when it 
> cannot sleep.
> 
> So I can certainly undo the undo, but the fact is, the code is CRAP. I'd 
> much rather get a real fix instead of having to select between two known 
> bugs.

I'll find a fix for the real problem, but this patch isn't the cause.

James
