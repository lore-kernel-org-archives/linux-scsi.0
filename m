From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Thu, 26 Sep 2002 23:50:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209262344250.17672-100000@beppo>
References: <20020927063616.GO5646@suse.de>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20020927063616.GO5646@suse.de>
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> > > scsi_dma crap. That said, 253 default depth is a bit over the top, no?
> > 
> > Why? Something like a large Hitachi 9*** storage system can take ~1000
> > tags w/o wincing.
> 
> Yeah, I bet that most of the devices attached to aic7xxx controllers are
> exactly such beasts.
> 
> I didn't say that 253 is a silly default for _everything_, I think it's
> a silly default for most users.
> 

Well, no, I'm not sure I agree. In the expected life time of this
particular set of software that gets shipped out, the next generation of
100GB or better disk drives will be attached, and they'll likely eat all
of that many tags too, and usefully, considering the speed and bit
density of drives. For example, the current U160 Fujitsu drives will
take ~130 tags before sending back a QFULL.

On the other hand, we can also find a large class of existing devices
and situations where anything over 4 tags is overload too.

With some perspective on this, I'd have to say that in the last 25 years
I've seen more errors on the side of 'too conservative' for limits
rather than the opposite.

That said, the only problem with allowing such generous limits is the
impact on the system, which allows you to saturate as it does. Getting
that fixed is more important than saying a driver writer's choice for
limits is 'over the top'.
