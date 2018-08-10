From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 10 Aug 2018 16:56:15 -0400
Message-ID: <04670610-3a33-f9cb-ecac-6cb2967a1ae5@interlog.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Lien <jeff.lien@wdc.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

On 2018-08-10 03:12 PM, Jeff Lien wrote:
> This patch provides a performance improvement for the CRC16 calculations done in read/write
> workloads using the T10 Type 1/2/3 guard field.  For example, today with sequential write
> workloads (one thread/CPU of IO) we consume 100% of the CPU because of the CRC16 computation
> bottleneck.  Today's block devices are considerably faster, but the CRC16 calculation prevents
> folks from utilizing the throughput of such devices.  To speed up this calculation and expose
> the block device throughput, we slice the old single byte for loop into a 16 byte for loop,
> with a larger CRC table to match.  The result has shown 5x performance improvements on various
> big endian and little endian systems running the 4.18.0 kernel version.
> 
> FIO Sequential Write, 64K Block Size, Queue Depth 64
> BE Base Kernel:        bw=201.5 MiB/s
> BE Modified CRC Calc:  bw=968.1 MiB/s
> 4.80x performance improvement
> 
> LE Base Kernel:        bw=357 MiB/s
> LE Modified CRC Calc:  bw=1964 MiB/s
> 5.51x performance improvement
> 
> FIO Sequential Read, 64K Block Size, Queue Depth 64
> BE Base Kernel:        bw=611.2 MiB/s
> BE Modified CRC calc:  bw=684.9 MiB/s
> 1.12x performance improvement
> 
> LE Base Kernel:        bw=797 MiB/s
> LE Modified CRC Calc:  bw=2730 MiB/s
> 3.42x performance improvement
> 
> Reviewed-by: Dave Darrington <david.darrington@wdc.com>
> Reviewed-by: Jeff Furlong <jeff.furlong@wdc.com>
> Signed-off-by: Jeff Lien <jeff.lien@wdc.com>
> ---
>   crypto/crct10dif_common.c | 605 +++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 569 insertions(+), 36 deletions(-)
> 
> diff --git a/crypto/crct10dif_common.c b/crypto/crct10dif_common.c
> index b2fab36..40e1d6c 100644
> --- a/crypto/crct10dif_common.c
> +++ b/crypto/crct10dif_common.c
> @@ -32,47 +32,580 @@
>    * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
>    * gt: 0x8bb7
>    */
> -static const __u16 t10_dif_crc_table[256] = {

    <snip table>
>   
>   __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
>   {
> -	unsigned int i;
> +	const __u8 *i = (const __u8 *)buffer;
> +	const __u8 *i_end = i + len;
> +	const __u8 *i_last16 = i + (len / 16 * 16) >
> -	for (i = 0 ; i < len ; i++)
> -		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
> +	for (; i < i_last16; i += 16) {
> +		crc = t10_dif_crc_table[15][i[0] ^ (__u8)(crc >>  8)] ^

The bswap_16() macro may be faster than crc >> 8 .

> +		t10_dif_crc_table[14][i[1] ^ (__u8)(crc >>  0)] ^

How is (crc >> 0) different from crc?

> +		t10_dif_crc_table[13][i[2]] ^
> +		t10_dif_crc_table[12][i[3]] ^
> +		t10_dif_crc_table[11][i[4]] ^
> +		t10_dif_crc_table[10][i[5]] ^
> +		t10_dif_crc_table[9][i[6]] ^
> +		t10_dif_crc_table[8][i[7]] ^
> +		t10_dif_crc_table[7][i[8]] ^
> +		t10_dif_crc_table[6][i[9]] ^
> +		t10_dif_crc_table[5][i[10]] ^
> +		t10_dif_crc_table[4][i[11]] ^
> +		t10_dif_crc_table[3][i[12]] ^
> +		t10_dif_crc_table[2][i[13]] ^
> +		t10_dif_crc_table[1][i[14]] ^
> +		t10_dif_crc_table[0][i[15]];

Since n in i[n] is marching from 0 to 15 then all but the first (i.e. i[0])
could be replaced by *(++i) . The first for loop statement would then
become:
     for (; i < i_last16; ++i) {

The two dimensional indexing could be flattened to further (ugly) pointer
manipulations, perhaps gaining some cycles, at the expense of clarity.
If so you could keep some of the two dimensional indexing lines commented
for documentation of the intent.

Doug Gilbert

> +	}
> +
> +	for (; i < i_end; i++)
> +		crc = t10_dif_crc_table[0][*i ^ (__u8)(crc >>  8)] ^ (crc << 8);
>   
>   	return crc;
>   }
> 
