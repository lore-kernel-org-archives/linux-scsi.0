From: Andi Kleen <ak@suse.de>
Subject: Re: generating a Linux WWN?
Date: Mon, 1 Oct 2007 12:56:36 +0200
Message-ID: <200710011256.36708.ak@suse.de>
References: <46FB8024.8040807@garzik.org> <20070927144649.GV3899@parisc-linux.org> <46FC332E.2040001@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXJAK4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2007 06:56:44 -0400
In-Reply-To: <46FC332E.2040001@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Patrick_Boyd@dell.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org


> The popular solutions I've seen are:
> 
> 1) Random bytes, or fixed id + random bytes.  Even on a worldwide net, 
> collisions are highly unlikely.

The problem is that the random bytes are not necessarily random; especially
not at boot:

get_random_bytes gets its randomness from the entropy pool. The pool starts with the 
time of the day and some always the same data and then gets feed by time 
stamps from a few interrupts. This doesn't include network interrupts
(or rather only a small handfull of network drivers set the flag -- but
at early boot you don't have any network anyways), but is primarily keyboard/mouse 
and storage interrupts. On headless systems typically only storage interrupts.

Now do you see the problem with using get_random_bytes() to get your
storage working? In many cases the time of the day in the pool
will prevent the worst, but if you have a cluster where all boxes boot 
at the same time it's quite likely your early randomness will
be all the same.(ok cluster boots are usually staggered, but you
still have a large number of systems booting at the same time) 

The whole thing would probably work if you could mix something 
machine unique into the entropy pool at boot (e.g. a network
mac address); but Linux can't do that do to boot strap ordering
issues.

I agree with the people who say this is a highly dangerous
thing to do. It is much better to fail clearly that to create a hard
to debug subtle problem in a storage network.

If you have prototype hardware that doesn't supply an unique ID then
I would suggest you add some module parameter to allow choosing a unique 
(or even random) one. But don't make it default.

-Andi

