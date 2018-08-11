From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] Performance Improvement in CRC16 Calculations.
Date: Fri, 10 Aug 2018 22:39:19 -0400
Message-ID: <75d66dfa-688b-f941-04fd-5a39cf882b21@interlog.com>
References: <1533928331-21303-1-git-send-email-jeff.lien@wdc.com>
 <9b5b906f42dfab78f382c90f66851717d258a15d.camel@perches.com>
 <nycvar.YSQ.7.76.1808101601110.13885@knanqh.ubzr>
 <b3c86ddd67a73c09e09f3e51d7fc70036f00fb7b.camel@perches.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b3c86ddd67a73c09e09f3e51d7fc70036f00fb7b.camel@perches.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Jeff Lien <jeff.lien@wdc.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, herbert@gondor.apana.org.au, tim.c.chen@linux.intel.com, martin.petersen@oracle.com, david.darrington@wdc.com, jeff.furlong@wdc.com
List-Id: linux-scsi@vger.kernel.org

On 2018-08-10 08:11 PM, Joe Perches wrote:
> On Fri, 2018-08-10 at 16:02 -0400, Nicolas Pitre wrote:
>> On Fri, 10 Aug 2018, Joe Perches wrote:
>>
>>> On Fri, 2018-08-10 at 14:12 -0500, Jeff Lien wrote:
>>>> This patch provides a performance improvement for the CRC16 calculations done in read/write
>>>> workloads using the T10 Type 1/2/3 guard field.  For example, today with sequential write
>>>> workloads (one thread/CPU of IO) we consume 100% of the CPU because of the CRC16 computation
>>>> bottleneck.  Today's block devices are considerably faster, but the CRC16 calculation prevents
>>>> folks from utilizing the throughput of such devices.  To speed up this calculation and expose
>>>> the block device throughput, we slice the old single byte for loop into a 16 byte for loop,
>>>> with a larger CRC table to match.  The result has shown 5x performance improvements on various
>>>> big endian and little endian systems running the 4.18.0 kernel version.
>>>
>>> Thanks.
>>>
>>> This seems a sensible tradeoff for the 4k text size increase.
>>
>> More like 7.5KB.  Would be best if this was configurable so the small
>> version remained available.
> 
> Maybe something like: (compiled, untested)
> ---
>   crypto/Kconfig            |  10 +
>   crypto/crct10dif_common.c | 543 +++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 549 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f3e40ac56d93..88d9d17bb18a 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -618,6 +618,16 @@ config CRYPTO_CRCT10DIF
>   	  a crypto transform.  This allows for faster crc t10 diff
>   	  transforms to be used if they are available.
>   
> +config CRYPTO_CRCT10DIF_TABLE_SIZE
> +	int "Size of CRCT10DIF crc tables (as a power of 2)"
> +	depends on CRYPTO_CRCT10DIF
> +	range 1 5
> +	default 1 if EMBEDDED
> +	default 5
> +	help
> +	  Set the table size used by the CRYPTO_CRCT10DIF crc calculation
> +	  Larger values use more memory and are faster.
> +
>   config CRYPTO_CRCT10DIF_PCLMUL
>   	tristate "CRCT10DIF PCLMULQDQ hardware acceleration"
>   	depends on X86 && 64BIT && CRC_T10DIF
> diff --git a/crypto/crct10dif_common.c b/crypto/crct10dif_common.c
> index b2fab366f518..4eb1c50c3688 100644
> --- a/crypto/crct10dif_common.c
> +++ b/crypto/crct10dif_common.c
> @@ -32,7 +32,8 @@
>    * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
>    * gt: 0x8bb7
>    */
> -static const __u16 t10_dif_crc_table[256] = {
> +static const __u16 t10dif_crc_table[][256] = {
> +	{

<snip data table>

> +	},
> +#endif
>   };
>   
>   __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
>   {
> -	unsigned int i;
> +	const u8 *ptr = (const __u8 *)buffer;
> +	const u8 *ptr_end = ptr + len;
> +#if CONFIG_CRYPTO_CRCT10DIF_TABLE_SIZE > 1
> +	size_t tablesize = 1 << (CONFIG_CRYPTO_CRCT10DIF_TABLE_SIZE - 1);
> +	const u8 *ptr_last = ptr + (len / tablesize * tablesize);
>   
> -	for (i = 0 ; i < len ; i++)
> -		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
> +	while (ptr < ptr_last) {
> +		size_t index = tablesize;
> +		__u16 t;
> +
> +		t = t10dif_crc_table[--index][*ptr++ ^ (u8)(crc >> 8)];
> +		t ^= t10dif_crc_table[--index][*ptr++ ^ (u8)crc];
> +		crc = t;
> +		while (index > 0)
> +			crc ^= t10dif_crc_table[--index][*ptr++];
> +	}
> +#endif
> +	while (ptr < ptr_end)
> +		crc = t10dif_crc_table[0][*ptr++ ^ (u8)(crc >> 8)] ^ (crc << 8);
>   
>   	return crc;
>   }
> 
> 

It is a bit messy but below is a copy and paste of a table 27 from draft SBC-4
revision 15 in chapter 4.22.4.4 on page 87.

Table 27 — CRC test cases
Pattern
32 bytes each set to 00h             CRC=0000h
32 bytes each set to FFh             CRC=A293h
32 bytes of an incrementing pattern from 00h to 1Fh   CRC=0224h
2 bytes each set to FFh followed by 30 bytes set to 00h   CRC=21B8h
32 bytes of a decrementing pattern from FFh to E0h    CRC=A0B7h

There is also example C code for its calculation in Annex C on pages
375 and 376.

Doug Gilbert
