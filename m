From: Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 10 Aug 2018 16:00:12 -0400 (EDT)
Message-ID: <nycvar.YSQ.7.76.1808101550460.13885@knanqh.ubzr>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Lien <jeff.lien@wdc.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 10 Aug 2018, Jeff Lien wrote:

> This patch provides a performance improvement for the CRC16 calculations done in read/write
> workloads using the T10 Type 1/2/3 guard field.  For example, today with sequential write
> workloads (one thread/CPU of IO) we consume 100% of the CPU because of the CRC16 computation
> bottleneck.  Today's block devices are considerably faster, but the CRC16 calculation prevents
> folks from utilizing the throughput of such devices.  To speed up this calculation and expose
> the block device throughput, we slice the old single byte for loop into a 16 byte for loop,
> with a larger CRC table to match.  The result has shown 5x performance improvements on various
> big endian and little endian systems running the 4.18.0 kernel version.

You are nevertheless increasing the kernel size by 7.5 KB.

Could the small table still be preserved with a config option for those 
who require small more than fast?

That could look like:

static const __u16 t10_dif_crc_table[][256] = {
	{
	[...]
	},
#ifndef CONFIG_CRC16_SMALL
	{
	[...]
	[...]
	},
#endif
};

and the code to suit.


Nicolas
