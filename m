From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Warning - running *really* short on DMA buffers while doingfile
   transfers
Date: Fri, 27 Sep 2002 13:16:16 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <2561606224.1033154176@aslan.btc.adaptec.com>
References: <200209271721.g8RHLTn05231@localhost.localdomain>
 <2543856224.1033153019@aslan.btc.adaptec.com> <3D94AC8B.4AB6EB09@digeo.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3D94AC8B.4AB6EB09@digeo.com>
Content-Disposition: inline
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> Which unfortunately characterizes only a single symptom without breaking
>> it down on a transaction by transaction basis.  We need to understand
>> how many writes were queued by the OS to the drive between each read to
>> know if the drive is actually allowing writes to pass reads or not.
>> 
> 
> Given that I measured a two-second read latency with four tags,
> that would be about 60 megabytes of write traffic after the
> read was submitted.  Say, 120 requests.  That's with a tag
> depth of four.

I still don't follow your reasoning.  Your benchmark indicates the
latency for several reads (cat kernel/*.c), not the per-read latency.
The two are quite different and unless you know the per-read latency and
whether it was affected by filling the drive's entire cache with
pent up writes (again these are writes that are above and beyond
those still assigned tags) you are still speculating that writes
are passing reads.

If you can tell me exactly how you ran your benchmark, I'll find the
information I want by using a SCSI bus analyzer to sniff the traffic
on the bus.

--
Justin
