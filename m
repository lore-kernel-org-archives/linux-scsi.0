From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler
 bytes
Date: Wed, 10 Apr 2019 13:32:46 +1000
Message-ID: <646b3b03b2c9a2612d3bbc6f1e00d4f9fa79769f.camel@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
         <20190410031720.11067-3-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410031720.11067-3-alastair@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Petr Mladek <pmladek@suse.com>, Sergey
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-04-10 at 13:17 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> Some buffers may only be partially filled with useful data, while the
> rest
> is padded (typically with 0x00 or 0xff).
> 
This patch introduces flags which allow lines of padding bytes to be
> suppressed, making the output easier to interpret:
> HEXDUMP_SUPPRESS_0X00,
> HEXDUMP_SUPPRESS_0XFF
> 
> The first and last lines are not suppressed by default, so the
> function
> always outputs something. This behaviour can be further controlled
> with
> the HEXDUMP_SUPPRESS_FIRST & HEXDUMP_SUPPRESS_LAST flags.
> 
> An inline wrapper function is provided for backwards compatibility
> with
> existing code, which maintains the original behaviour.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
> 
<snip>

> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index b8a164814744..2f3bafb55a44 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -209,8 +209,21 @@ int hex_dump_to_buffer(const void *buf, size_t
> len, int rowsize, int groupsize,
>  EXPORT_SYMBOL(hex_dump_to_buffer);
>  
>  #ifdef CONFIG_PRINTK
> +
> +static bool buf_is_all(const u8 *buf, size_t len, u8 val)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < len; i++) {
> +		if (buf[i] != val)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /**
> - * print_hex_dump - print a text hex dump to syslog for a binary
> blob of data
> + * print_hex_dump_ext: dump a binary blob of data to syslog in
> hexadecimal
>   * @level: kernel log level (e.g. KERN_DEBUG)
>   * @prefix_str: string to prefix each line with;
>   *  caller supplies trailing spaces for alignment if desired
> @@ -221,42 +234,73 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
>   * @buf: data blob to dump
>   * @len: number of bytes in the @buf
>   * @ascii: include ASCII after the hex output
This line should have been removed. I'll address it in V2.

> + * @flags: A bitwise OR of the following flags:
> + *	HEXDUMP_ASCII:		include ASCII after the hex output
> + *	HEXDUMP_SUPPRESS_0X00:	suppress lines that are all 0x00
> + *				(other than first or last)
> + *	HEXDUMP_SUPPRESS_0XFF:	suppress lines that are all 0xff
> + *				(other than first or last)
> + *	HEXDUMP_SUPPRESS_FIRST:	allows the first line to be
> suppressed
> + *	HEXDUMP_SUPPRESS_LAST:	allows the last line to be suppressed
> + *				If the first and last line may be
> suppressed,
> + *				an empty buffer will not produce any
> output
>   *
>   * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII
> dump
>   * to the kernel log at the specified kernel log level, with an
> optional
>   * leading prefix.
>   *
> - * print_hex_dump() works on one "line" of output at a time, i.e.,
> + * print_hex_dump_ext() works on one "line" of output at a time,
> i.e.,
>   * 16, 32 or 64 bytes of input data converted to hex + ASCII output.
> - * print_hex_dump() iterates over the entire input @buf, breaking it
> into
> + * print_hex_dump_ext() iterates over the entire input @buf,
> breaking it into
>   * "line size" chunks to format and print.
>   *
>   * E.g.:
> - *   print_hex_dump(KERN_DEBUG, "raw data: ", DUMP_PREFIX_ADDRESS,
> - *		    16, 1, frame->data, frame->len, true);
> + *   print_hex_dump_ext(KERN_DEBUG, "raw data: ",
> DUMP_PREFIX_ADDRESS,
> + *		    16, 1, frame->data, frame->len, HEXDUMP_ASCII);
>   *
>   * Example output using %DUMP_PREFIX_OFFSET and 1-byte mode:
>   * 0009ab42: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e
> 4f  @ABCDEFGHIJKLMNO
>   * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
>   * ffffffff88089af0: 73727170 77767574 7b7a7978
> 7f7e7d7c  pqrstuvwxyz{|}~.
>   */

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
