From: Joshua Kwan <joshk@triplehelix.org>
Subject: Re: [PATCH] updated version of Jens' SATA suspend-to-ram patch
Date: Fri, 23 Sep 2005 14:21:45 -0700
Message-ID: <433471E9.2040307@triplehelix.org>
References: <20050923163334.GA13567@triplehelix.org>
 <20050923180711.GH22655@suse.de> <433469DF.1060900@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <433469DF.1060900@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jens Axboe <axboe@suse.de>, torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Very strange.  I cannot find this patch at all in my email folders.
> 
> Can someone resend it to me?

The original is at
http://seclists.org/lists/linux-kernel/2005/May/0447.html, as indicated
by the footnote in my original message.

That said, it's identical in content to the one I've just sent (attached
as a text/plain MIME attachment.)

> Worried now!
> 
> If this patch is needed, something VERY VERY WRONG is going on.  This
> patch indicates that the queueing state machine has been violated, and
> something is trying to IGNORE the command synchronization :(
> 
> Further, you cannot always assume that msleep() is valid in that
> context.  It should be the caller that waits (libata suspend code), not
> ata_do_simple_cmd() itself.
> 
> Does anyone have a link to James Bottomley's proposed patch?  That one
> seemed to do what was necessary -- send a SYNCHRONIZE_CACHE command then
> turn it over to the LLD for further suspend.

I don't think James sent any patch in the original thread with Jens'
patch. But that sounds somewhat cleaner than msleep().

At any rate, the current patch (with or without Jens' new addition)
works for me on Thinkpad T43. So the net result is better anyway, IMO.

>> Ok. Can we have this in -mm for a few days just to shake out anything
>> interesting, and then merge it into mainline?
> 
> Once we get a decent patch, I can merge it into my libata-dev.git
> repository, which is automatically propagated to -mm.

Is the kludginess of Jens' addition the only problem you have with the
current patch? (If it is, then fixing this is out of the range of my
current ability...)

Thanks for responding.

-- 
Joshua Kwan
