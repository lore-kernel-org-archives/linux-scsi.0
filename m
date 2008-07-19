From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Sat, 19 Jul 2008 11:12:17 +0900
Message-ID: <48814D81.8060001@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com> <20080719033050.552f9b49@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080719033050.552f9b49-OhHrUh4vRMSnewYJFaQfwJ5kstrrjoWp@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pierre Ossman <drzeus-p3sGCRWkH8CeZLLa646FqQ@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-ide <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, tino.keitel-Mmb7MZpHnFY@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Pierre Ossman wrote:
>> Well, I don't know how often such usages would be necessary.  If it's a
>> very common ops, you can add a param to the next function but frankly I
>> think it's better to build a inside control structure for that.  There's
>> no need for external buffer, just an inner loop is sufficient.
>>
> 
> I'm not sure how this can be solved by an inner loop. My primary use
> case is:
> 
> 1. Wait for interrupt
> 2. Write n bytes
> 3. goto 1
> 
> n has no guarantee of being aligned to any page boundaries, so state
> needs to be kept between each invokation of writing a chunk of data. I
> doubt I'm alone in this use pattern (in fact, most device drivers using
> PIO should do something similar).

Oh... I see.  How about adding sg_miter_consume(@miter, @bytes)?  If the
function is never called, the whole chunk is assumed to be consumed.  If
the function is called only @bytes are consumed.

-- 
tejun
