From: Matthew Wilcox <willy@debian.org>
Subject: Re: softscsi patch
Date: Fri, 5 Jul 2002 16:41:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020705164121.B27706@parcelfarce.linux.theplanet.co.uk>
References: <20020630222043.B29045@parcelfarce.linux.theplanet.co.uk> <200207051453.SAA05954@sex.inr.ac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200207051453.SAA05954@sex.inr.ac.ru>; from kuznet@ms2.inr.ac.ru on Fri, Jul 05, 2002 at 06:53:07PM +0400
List-Id: linux-scsi@vger.kernel.org
To: kuznet@ms2.inr.ac.ru
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org, davem@redhat.com

On Fri, Jul 05, 2002 at 06:53:07PM +0400, kuznet@ms2.inr.ac.ru wrote:
> Well, it was difficult to make not introducing interaction between
> cpus (which was main goal of softirq core).

sure, but it's fine to synchronise all CPUs at subsystem unload...

> I think it is possible using ideas sort of brlock or using detection
> of quiescent intervals introduced with RCU. Anyway, I still do not see
> how to make this in clean way.

Hmm, I'll investigate.

> BTW are you sure that scsi layer really needs bare softirq?

No, but davem said we should ;-)

> Networking is very special in this sense, with local traffic
> the first spinlock is hit at socket level (very high granularity!).
> However, even in this case we are switching to tasklets (NAPI uses
> per-device tasklet in fact). Maybe, scsi will feel better with
> per-controller tasklets too.

I didn't know NAPI was doing that... we could embed a tasklet in each
Scsi_Host and trigger it at the end of scsi_done.  Might give better
performance than using a softirq.

If we have a controller finishing four requests in rapid succession,
each interrupt going to a different CPU then three CPUs will spin waiting
for that controller's lock... and then waste time pingponging the cache
lines between themselves as each gets its turn.  Would be more efficient
to use a tasklet for this case.  With multiple controllers it should
get even better as they can be handled on different CPUs.

Time for the third rewrite of the scsi completion handler in the last
month?  :-)

-- 
Revolutions do not require corporate support.
