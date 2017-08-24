From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Thu, 24 Aug 2017 13:49:12 +0900
Message-ID: <20170824044912.GB3569@jagdpanzerIV.localdomain>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
 <20170823043813.GH11771@tardis>
 <20170823044648.GE10329@jagdpanzerIV.localdomain>
 <20170823053501.GJ11771@tardis>
 <20170823055517.GB728@jagdpanzerIV.localdomain>
 <20170824043909.GL11771@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824043909.GL11771@tardis>
Sender: linux-next-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Byungchul Park <byungchul.park@lge.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

Hi,

On (08/24/17 12:39), Boqun Feng wrote:
> On Wed, Aug 23, 2017 at 02:55:17PM +0900, Sergey Senozhatsky wrote:
> > On (08/23/17 13:35), Boqun Feng wrote:
> > > > KERN_CONT and "\n" should not be together. "\n" flushes the cont
> > > > buffer immediately.
> > > > 
> > > 
> > > Hmm.. Not quite familiar with printk() stuffs, but I could see several
> > > usages of printk(KERN_CONT "...\n") in kernel.
> > > 
> > > Did a bit research myself, and I now think the inappropriate use is to
> > > use a KERN_CONT printk *after* another printk ending with a "\n".
> > 
> > ah... I didn't check __print_lock_name(): it leaves unflushed cont buffer
> > upon the return. sorry, your code is correct.
> > 
> 
> So means printk(KERN_CON "..."); + printk(KERN_CONT "...\n") is a
> correct usage, right?

well, yes. with one precondition - there should be no printk-s from other
CPUs/tasks in between

	printk(KERN_CON "...");  +  printk(KERN_CONT "...\n")
                               ^^^^^
			here we can have a preliminary flush and broken
			cont line. but it's been this way forever.

	-ss
