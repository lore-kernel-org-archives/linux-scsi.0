From: "Alastair D'Silva" <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 3/7] lib/hexdump.c: Optionally suppress lines of
 repeated bytes
Date: Mon, 17 Jun 2019 14:07:12 +1000
Message-ID: <da2ff58290c4b6f08eb5ac25c288bdd03b5688f7.camel@d-silva.org>
References: <20190617020430.8708-1-alastair@au1.ibm.com>
         <20190617020430.8708-4-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190617020430.8708-4-alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jose Abreu <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benson Leung <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Enric Balletbo i Serra <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Petr
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-06-17 at 12:04 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
> 
> Some buffers may only be partially filled with useful data, while the
> rest
> is padded (typically with 0x00 or 0xff).
> 
> This patch introduces a flag to allow the supression of lines of
> repeated
> bytes, which are replaced with '** Skipped %u bytes of value 0x%x **'
> 
> An inline wrapper function is provided for backwards compatibility
> with
> existing code, which maintains the original behaviour.
> 
> Signed-off-by: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
> ---
>  include/linux/printk.h | 25 +++++++++---
>  lib/hexdump.c          | 91 ++++++++++++++++++++++++++++++++++++--
> ----
>  2 files changed, 99 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index cefd374c47b1..d7754799cfe0 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -481,13 +481,18 @@ enum {
>  	DUMP_PREFIX_ADDRESS,
>  	DUMP_PREFIX_OFFSET
>  };
> +
>  extern int hex_dump_to_buffer(const void *buf, size_t len, int
> rowsize,
>  			      int groupsize, char *linebuf, size_t
> linebuflen,
>  			      bool ascii);
> +
> +#define HEXDUMP_ASCII			BIT(0)
> +#define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
> +

This is missing the include of linux/bits.h, I'll fix this in the next
version.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org
