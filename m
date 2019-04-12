From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler
 bytes
Date: Fri, 12 Apr 2019 16:03:53 +0200
Message-ID: <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-3-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190410031720.11067-3-alastair@au1.ibm.com>
Sender: netdev-owner@vger.kernel.org
To: Alastair D'Silva <alastair@au1.ibm.com>
Cc: alastair@d-silva.org, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.>
List-Id: linux-scsi@vger.kernel.org

On Wed 2019-04-10 13:17:18, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> Some buffers may only be partially filled with useful data, while the rest
> is padded (typically with 0x00 or 0xff).
> 
> This patch introduces flags which allow lines of padding bytes to be
> suppressed, making the output easier to interpret: HEXDUMP_SUPPRESS_0X00,
> HEXDUMP_SUPPRESS_0XFF
> 
> The first and last lines are not suppressed by default, so the function
> always outputs something. This behaviour can be further controlled with
> the HEXDUMP_SUPPRESS_FIRST & HEXDUMP_SUPPRESS_LAST flags.
> 
> An inline wrapper function is provided for backwards compatibility with
> existing code, which maintains the original behaviour.
> 

> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index b8a164814744..2f3bafb55a44 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> +void print_hex_dump_ext(const char *level, const char *prefix_str,
> +			int prefix_type, int rowsize, int groupsize,
> +			const void *buf, size_t len, u64 flags)
>  {
>  	const u8 *ptr = buf;
> -	int i, linelen, remaining = len;
> +	int i, remaining = len;
>  	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
> +	bool first_line = true;
>  
>  	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
>  		rowsize = 16;
>  
>  	for (i = 0; i < len; i += rowsize) {
> -		linelen = min(remaining, rowsize);
> +		bool skip = false;
> +		int linelen = min(remaining, rowsize);
> +
>  		remaining -= rowsize;
>  
> +		if (flags & HEXDUMP_SUPPRESS_0X00)
> +			skip = buf_is_all(ptr + i, linelen, 0x00);
> +
> +		if (!skip && (flags & HEXDUMP_SUPPRESS_0XFF))
> +			skip = buf_is_all(ptr + i, linelen, 0xff);
> +
> +		if (first_line && !(flags & HEXDUMP_SUPPRESS_FIRST))
> +			skip = false;
> +
> +		if (remaining <= 0 && !(flags & HEXDUMP_SUPPRESS_LAST))
> +			skip = false;
> +
> +		if (skip)
> +			continue;

IMHO, quietly skipping lines could cause a lot of confusion,
espcially when the address is not printed.

I wonder how it would look like when we print something like:

    --- skipped XX lines full of 0x00 ---

Then we might even remove the SUPPRESS_FIRST, SUPPRESS_LAST
and the ambiguous QUIET flags.

> +
> +		first_line = false;

This should be above the if (skip).

> +
>  		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> -				   linebuf, sizeof(linebuf), ascii);
> +				   linebuf, sizeof(linebuf),
> +				   flags & HEXDUMP_ASCII);
>  
>  		switch (prefix_type) {
>  		case DUMP_PREFIX_ADDRESS:
> @@ -272,7 +316,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
>  		}
>  	}
>  }
> -EXPORT_SYMBOL(print_hex_dump);
> +EXPORT_SYMBOL(print_hex_dump_ext);

We should still export even the original function that
is still used everywhere.

Best Regards,
Petr
