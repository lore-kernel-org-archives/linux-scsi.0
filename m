From: David Miller <davem@davemloft.net>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Fri, 16 Jan 2009 11:10:59 -0800 (PST)
Message-ID: <20090116.111059.205876014.davem@davemloft.net>
References: <1232117771.3224.21.camel@localhost.localdomain>
	<20090116090928.e43c986e.akpm@linux-foundation.org>
	<da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S937183AbZAPTLq@vger.kernel.org>
In-Reply-To: <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: grundler@google.com
Cc: akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Grant Grundler <grundler@google.com>
Date: Fri, 16 Jan 2009 11:02:12 -0800

> On Fri, Jan 16, 2009 at 9:09 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> ...
> >> +             CHIPREG_WRITE32(&ioc->chip->Doorbell, 0xC0FFEE00);
> >> +             panic("%s: Firmware is halted due to command timeout\n",
> >> +                     ioc->name);
> >> +     }
> >> +}
> >> +EXPORT_SYMBOL(mpt_halt_firmware);
> >
> > Doing a panic() after we've already detected an error is plain nasty.
> > Is there no way in which we can allow the kernel to continue?
> 
> Basically what James said. It's not long though: only 6 emails.
> I started that thread thinking the same thing you did:
>     http://marc.info/?t=123123569200003&r=1&w=2
> 
> TBH, I still wouldn't implement it the way LSI maintainers did.
> I'm happy they are the maintainers and it's their call.

They are doing things which effect the entire system, not just
their driver.  So this doesn't fall under "maintainer's rights"

If they fail locally, that's fine and perfectly expected, but to take
the whole machine out is another matter altogether.
