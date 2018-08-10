From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 10 Aug 2018 12:23:06 -0700
Message-ID: <9b5b906f42dfab78f382c90f66851717d258a15d.camel@perches.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Lien <jeff.lien@wdc.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-08-10 at 14:12 -0500, Jeff Lien wrote:
> This patch provides a performance improvement for the CRC16 calculations done in read/write
> workloads using the T10 Type 1/2/3 guard field.  For example, today with sequential write
> workloads (one thread/CPU of IO) we consume 100% of the CPU because of the CRC16 computation
> bottleneck.  Today's block devices are considerably faster, but the CRC16 calculation prevents
> folks from utilizing the throughput of such devices.  To speed up this calculation and expose
> the block device throughput, we slice the old single byte for loop into a 16 byte for loop,
> with a larger CRC table to match.  The result has shown 5x performance improvements on various
> big endian and little endian systems running the 4.18.0 kernel version.

Thanks.

This seems a sensible tradeoff for the 4k text size increase.

> diff --git a/crypto/crct10dif_common.c b/crypto/crct10dif_common.c

[]

trivia:

> +static const __u16 t10_dif_crc_table[16][256] = {
> +	{
> +	0x0000u, 0x8BB7u, 0x9CD9u, 0x176Eu, 0xB205u, 0x39B2u, 0x2EDCu, 0xA56Bu,

All the 'u's are unnecessary visual noise.
