From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Mon, 12 Dec 2005 09:40:34 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0512120928110.15597@g5.osdl.org>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750791AbVLLRko@vger.kernel.org>
In-Reply-To: <20051212165443.GD17295@tau.solarneutrino.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Hugh Dickins <hugh@veritas.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Mon, 12 Dec 2005, Ryan Richter wrote:
>
> And yet another crash, this time during boot:

The instruction that crashes is

	testb  $0x80,0x1cd(%rdi)

with %rdi being 6b6b6b6b6b6b6b6b, which is the pattern that slab poisoning 
uses for free areas. 

I think it's the "sdev->single_lun" test at the very top of the function, 
where "sdev" was initialized with "q->queuedata". So it looks like 
somebody free'd the request_queue structure before the IO completed.

Definitely sounds like something screwy in SCSI.. I don't think this is VM 
related.

		Linus
