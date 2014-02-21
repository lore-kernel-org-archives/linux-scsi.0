From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Fri, 21 Feb 2014 18:18:33 -0500
Message-ID: <20140221231833.GC12830@htj.dyndns.org>
References: <20140221015935.GF6897@htj.dyndns.org>
 <5306B4DF.4000901@hurleysoftware.com>
 <20140221021341.GG6897@htj.dyndns.org>
 <5306E06C.5020805@hurleysoftware.com>
 <20140221100301.GA14653@mtj.dyndns.org>
 <53074BE4.1020307@hurleysoftware.com>
 <20140221130614.GH6897@htj.dyndns.org>
 <5307849A.9050209@hurleysoftware.com>
 <20140221165730.GA10929@htj.dyndns.org>
 <5307DAC9.2020103@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5307DAC9.2020103@hurleysoftware.com>
Sender: target-devel-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2014 at 06:01:29PM -0500, Peter Hurley wrote:
> smp_mb__after_unlock_lock() is only for ordering memory operations
> between two spin-locked sections on either the same lock or by
> the same task/cpu. Like:
> 
>    i = 1
>    spin_unlock(lock1)
>    spin_lock(lock2)
>    smp_mb__after_unlock_lock()
>    j = 1
> 
> This guarantees that the store to j happens after the store to i.
> Without it, a cpu can
> 
>    spin_lock(lock2)
>    j = 1
>    i = 1
>    spin_unlock(lock1)

Hmmm?  I'm pretty sure that's a full barrier.  Local processor is
always in order (w.r.t. the compiler).

Thanks.

-- 
tejun
