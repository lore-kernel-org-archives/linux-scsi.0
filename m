From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: fix compile-time divide-by-zero in scsi_ioctl
Date: Wed, 27 Sep 2006 20:40:27 -0600
Message-ID: <20060928024027.GW5017@parisc-linux.org>
References: <20060926154848.CFDC63DAF7@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20060927202710.GV5017@parisc-linux.org> <200609271628.27120.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41662 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1031344AbWI1Ck2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 22:40:28 -0400
Content-Disposition: inline
In-Reply-To: <200609271628.27120.david-b@pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 27, 2006 at 04:28:26PM -0700, David Brownell wrote:
> On Wednesday 27 September 2006 1:27 pm, Matthew Wilcox wrote:
> > On Tue, Sep 26, 2006 at 08:48:48AM -0700, David Brownell wrote:
> > > This fixes a compiler-reported divide-by-zero when HZ < 100.
> > 
> > Shouldn't we instead be using jiffies_to_clock_t?  Thus:
> 
> Could be ... the units in that function unclear to me though.

Me too, tbh.  But the function looks right.

static inline clock_t jiffies_to_clock_t(long x)
{
#if (TICK_NSEC % (NSEC_PER_SEC / USER_HZ)) == 0
        return x / (HZ / USER_HZ);
#else
        u64 tmp = (u64)x * TICK_NSEC;
        do_div(tmp, (NSEC_PER_SEC / USER_HZ));
        return (long)tmp;
#endif
}

