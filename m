From: kuznet@ms2.inr.ac.ru
Subject: Re: softscsi patch
Date: Fri, 5 Jul 2002 19:58:43 +0400 (MSD)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207051558.TAA06460@sex.inr.ac.ru>
References: <20020705164121.B27706@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020705164121.B27706@parcelfarce.linux.theplanet.co.uk> from "Matthew Wilcox" at Jul 5, 2 04:41:21 pm
List-Id: linux-scsi@vger.kernel.org
Cc: willy@debian.org, linux-scsi@vger.kernel.org, davem@redhat.com

Hello!

> sure, but it's fine to synchronise all CPUs at subsystem unload...

Of course. If this become necessary, this is ... necessary. :-)

> If we have a controller finishing four requests in rapid succession,
> each interrupt going to a different CPU then three CPUs will spin waiting
> for that controller's lock... and then waste time pingponging the cache
> lines between themselves as each gets its turn.  Would be more efficient
> to use a tasklet for this case.  With multiple controllers it should
> get even better as they can be handled on different CPUs.

Exactly. With networking the things are even worse:
we used to grab requests completed by device at irq, to queue them
and to raise softirq. The result is that they reach final consumer
(f.e. socket) in _different_ order, which creates lots of troubles.
If SCSI is also sensitive to order, stronger serialization may be required too.

Alexey
