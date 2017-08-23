From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 14:55:17 +0900
Message-ID: <20170823055517.GB728@jagdpanzerIV.localdomain>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
 <20170823043813.GH11771@tardis>
 <20170823044648.GE10329@jagdpanzerIV.localdomain>
 <20170823053501.GJ11771@tardis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823053501.GJ11771@tardis>
Sender: linux-block-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Byungchul Park <byungchul.park@lge.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org

On (08/23/17 13:35), Boqun Feng wrote:
> > KERN_CONT and "\n" should not be together. "\n" flushes the cont
> > buffer immediately.
> > 
> 
> Hmm.. Not quite familiar with printk() stuffs, but I could see several
> usages of printk(KERN_CONT "...\n") in kernel.
> 
> Did a bit research myself, and I now think the inappropriate use is to
> use a KERN_CONT printk *after* another printk ending with a "\n".

ah... I didn't check __print_lock_name(): it leaves unflushed cont buffer
upon the return. sorry, your code is correct.

	-ss

> > >  		printk("\n *** DEADLOCK ***\n\n");
> > > +	} else if (cross_lock(src->instance)) {
> > > +		printk(" Possible unsafe locking scenario by crosslock:\n\n");
> > > +		printk("       CPU0                    CPU1\n");
> > > +		printk("       ----                    ----\n");
> > > +		printk("  lock(");
> > > +		__print_lock_name(target);
> > > +		printk(KERN_CONT ");\n");
> > > +		printk("  lock(");
> > > +		__print_lock_name(source);
> > > +		printk(KERN_CONT ");\n");
> > > +		printk("                               lock(");
> > > +		__print_lock_name(parent == source ? target : parent);
> > > +		printk(KERN_CONT ");\n");
> > > +		printk("                               unlock(");
> > > +		__print_lock_name(source);
> > > +		printk(KERN_CONT ");\n");
> > > +		printk("\n *** DEADLOCK ***\n\n");
> > >  	} else {
> > >  		printk(" Possible unsafe locking scenario:\n\n");
> > >  		printk("       CPU0                    CPU1\n");
> > > -- 
> > > 2.14.1
> > > 
