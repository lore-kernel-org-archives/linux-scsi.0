From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for December 29 (cxgb3i)
Date: Mon, 29 Dec 2008 15:51:07 -0600
Message-ID: <1230587467.3302.67.camel@localhost.localdomain>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229123517.23fd6169.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081229123517.23fd6169.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kxie@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-12-29 at 12:35 -0800, Randy Dunlap wrote:
> On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20081219:
> > 
> > Undropped tree:
> > 	scci
> > 	mtd
> > 
> > Dropped trees (temporarily):
> > 	nfs (akpm request due to 2.6.30 features)
> > 	kvm (build problem)
> > 	rr (build poblem)
> > 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> > 	cpu_alloc (build problem)
> > 	audit (difficult conflicts)
> > 
> > Linus' tree had three build failures requiring patches and one requiring
> > a revert.
> 
> 
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:499: error: 'struct sk_buff' has no member named 'sp'
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:512: error: 'struct sk_buff' has no member named 'sp'
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:532: error: 'struct sk_buff' has no member named 'sp'
> linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:533: error: 'struct sk_buff' has no member named 'sp'

In the config 20 questions, my guess for this is CONFIG_XFRM=n

I'm not at all sure why this driver is playing with the secure path ...
I suspect the use needs to be enclosed in #ifdef CONFIG_XFRM pairs, but
I'd like the maintainers to verify.

James
