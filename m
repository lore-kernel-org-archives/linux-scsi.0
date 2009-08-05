From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: BUG in dma-mapping.h:218 // MESH SCSI driver not working
Date: Wed, 05 Aug 2009 11:11:50 +1000
Message-ID: <1249434710.18245.48.camel@pasglop>
References: <1248915149.1509.29.camel@pasglop> <4A7553E7.6030804@scarlet.be>
	<1249254817.18245.1.camel@pasglop>
	<20090805100424U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20090805100424U.fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org, stef.simoens@scarlet.be
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-08-05 at 10:04 +0900, FUJITA Tomonori wrote:
> 
> Looks like that READ CAPACITY fails. We use kmalloc'ed buffer for READ
> CAPACITY so I'm not sure about an alignment issue that you mentioned
> in this thread earlier.
> 
> You said your machine with a MESH appears to work. Did you confirm it?
> 
Not yet. It's a fishy machine that needs other patches to get back to
working condition, I haven't had time yet (everybody's sick at home so
I've been mostly off the office and the machine is there).

I'm pretty sure the MESH will have issues though if the DMA buffers
aren't at least 16 (or maybe it's 32) bytes aligned. I don't think it's
a cache alignment issue, I suspect it's an issue with the DBDMA engine
queue on those chips though (it -could- be cache coherency bugs too,
never know with those old Apple home made chipsets).

I remember we had problems in the past with IDENTIFY iirc, which would
work normally as kmalloc() would return something cache line aligned...
until one enabled SLAB debugging.

Cheers,
Ben.
