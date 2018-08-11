From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 10 Aug 2018 20:34:25 -0400 (EDT)
Message-ID: <nycvar.YSQ.7.76.1808102027220.13885@knanqh.ubzr>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com> <9b5b906f42dfab78f382c90f66851717d258a15d.camel@perches.com> <nycvar.YSQ.7.76.1808101601110.13885@knanqh.ubzr> <b3c86ddd67a73c09e09f3e51d7fc70036f00fb7b.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b3c86ddd67a73c09e09f3e51d7fc70036f00fb7b.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Jeff Lien <jeff.lien@wdc.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 10 Aug 2018, Joe Perches wrote:

> On Fri, 2018-08-10 at 16:02 -0400, Nicolas Pitre wrote:
> > On Fri, 10 Aug 2018, Joe Perches wrote:
> > 
> > > On Fri, 2018-08-10 at 14:12 -0500, Jeff Lien wrote:
> > > > This patch provides a performance improvement for the CRC16 calculations done in read/write
> > > > workloads using the T10 Type 1/2/3 guard field.  For example, today with sequential write
> > > > workloads (one thread/CPU of IO) we consume 100% of the CPU because of the CRC16 computation
> > > > bottleneck.  Today's block devices are considerably faster, but the CRC16 calculation prevents
> > > > folks from utilizing the throughput of such devices.  To speed up this calculation and expose
> > > > the block device throughput, we slice the old single byte for loop into a 16 byte for loop,
> > > > with a larger CRC table to match.  The result has shown 5x performance improvements on various
> > > > big endian and little endian systems running the 4.18.0 kernel version.
> > > 
> > > Thanks.
> > > 
> > > This seems a sensible tradeoff for the 4k text size increase.
> > 
> > More like 7.5KB.  Would be best if this was configurable so the small 
> > version remained available.
> 
> Maybe something like: (compiled, untested)
> ---
>  crypto/Kconfig            |  10 +
>  crypto/crct10dif_common.c | 543 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 549 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f3e40ac56d93..88d9d17bb18a 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -618,6 +618,16 @@ config CRYPTO_CRCT10DIF
>  	  a crypto transform.  This allows for faster crc t10 diff
>  	  transforms to be used if they are available.
>  
> +config CRYPTO_CRCT10DIF_TABLE_SIZE
> +	int "Size of CRCT10DIF crc tables (as a power of 2)"
> +	depends on CRYPTO_CRCT10DIF
> +	range 1 5
> +	default 1 if EMBEDDED
> +	default 5

You could even make the prompt depend on EXPERT.

I like it!

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
