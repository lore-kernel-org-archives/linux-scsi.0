From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of filler
 bytes
Date: Sat, 13 Apr 2019 09:28:03 +1000
Message-ID: <093101d4f187$612f0f20$238d2d60$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-3-alastair@au1.ibm.com>
 <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190412140353.mgvksn3yk6n65hbk@pathway.suse.cz>
Content-Language: en-au
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: 'Petr Mladek' <pmladek@suse.com>, 'Alastair D'Silva' <alastair@au1.ibm.com>
Cc: linux-fbdev@vger.kernel.org, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'David Airlie' <airlied@linux.ie>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, 'Jassi Brar' <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, 'Jani Nikula' <jani.nikula@linux.intel.com>, linux-fsdevel@vger.kernel.org, 'Steven Rostedt' <rostedt@goodmis.org>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'Benson Leung' <bleung@chromium.org>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Karsten Keil' <isdn@linux-pingi.de>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>, linux-wireless@vger.kernel.
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Saturday, 13 April 2019 12:04 AM
> To: Alastair D'Silva <alastair@au1.ibm.com>
> Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>;
Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel Vetter
> <daniel@ffwll.ch>; Karsten Keil <isdn@linux-pingi.de>; Jassi Brar
> <jassisinghbrar@gmail.com>; Tom Lendacky <thomas.lendacky@amd.com>;
> David S. Miller <davem@davemloft.net>; Jose Abreu
> <Jose.Abreu@synopsys.com>; Kalle Valo <kvalo@codeaurora.org>;
> Stanislaw Gruszka <sgruszka@redhat.com>; Benson Leung
> <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com>; Steven Rostedt <rostedt@goodmis.org>;
> Andrew Morton <akpm@linux-foundation.org>; intel-
> gfx@lists.freedesktop.org; dri-devel@lists.freedesktop.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org;
> ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; linux-
> scsi@vger.kernel.org; linux-fbdev@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 2/4] lib/hexdump.c: Optionally suppress lines of
filler
> bytes
> 
> On Wed 2019-04-10 13:17:18, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > Some buffers may only be partially filled with useful data, while the
> > rest is padded (typically with 0x00 or 0xff).
> >
> > This patch introduces flags which allow lines of padding bytes to be
> > suppressed, making the output easier to interpret:
> > HEXDUMP_SUPPRESS_0X00, HEXDUMP_SUPPRESS_0XFF
> >
> > The first and last lines are not suppressed by default, so the
> > function always outputs something. This behaviour can be further
> > controlled with the HEXDUMP_SUPPRESS_FIRST &
> HEXDUMP_SUPPRESS_LAST flags.
> >
> > An inline wrapper function is provided for backwards compatibility
> > with existing code, which maintains the original behaviour.
> >
> 
> > diff --git a/lib/hexdump.c b/lib/hexdump.c index
> > b8a164814744..2f3bafb55a44 100644
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > +void print_hex_dump_ext(const char *level, const char *prefix_str,
> > +			int prefix_type, int rowsize, int groupsize,
> > +			const void *buf, size_t len, u64 flags)
> >  {
> >  	const u8 *ptr = buf;
> > -	int i, linelen, remaining = len;
> > +	int i, remaining = len;
> >  	unsigned char linebuf[64 * 3 + 2 + 64 + 1];
> > +	bool first_line = true;
> >
> >  	if (rowsize != 16 && rowsize != 32 && rowsize != 64)
> >  		rowsize = 16;
> >
> >  	for (i = 0; i < len; i += rowsize) {
> > -		linelen = min(remaining, rowsize);
> > +		bool skip = false;
> > +		int linelen = min(remaining, rowsize);
> > +
> >  		remaining -= rowsize;
> >
> > +		if (flags & HEXDUMP_SUPPRESS_0X00)
> > +			skip = buf_is_all(ptr + i, linelen, 0x00);
> > +
> > +		if (!skip && (flags & HEXDUMP_SUPPRESS_0XFF))
> > +			skip = buf_is_all(ptr + i, linelen, 0xff);
> > +
> > +		if (first_line && !(flags & HEXDUMP_SUPPRESS_FIRST))
> > +			skip = false;
> > +
> > +		if (remaining <= 0 && !(flags & HEXDUMP_SUPPRESS_LAST))
> > +			skip = false;
> > +
> > +		if (skip)
> > +			continue;
> 
> IMHO, quietly skipping lines could cause a lot of confusion, espcially
when
> the address is not printed.
>
It's up to the caller to decide how they want it displayed.

> I wonder how it would look like when we print something like:
> 
>     --- skipped XX lines full of 0x00 ---

This could be added as a later enhancement, with a new flag (eg.
HEXDUMP_SUPPRESS_VERBOSE).

> 
> Then we might even remove the SUPPRESS_FIRST, SUPPRESS_LAST and the
> ambiguous QUIET flags.
> 
> > +
> > +		first_line = false;
> 
> This should be above the if (skip).
> 
> > +
> >  		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> > -				   linebuf, sizeof(linebuf), ascii);
> > +				   linebuf, sizeof(linebuf),
> > +				   flags & HEXDUMP_ASCII);
> >
> >  		switch (prefix_type) {
> >  		case DUMP_PREFIX_ADDRESS:
> > @@ -272,7 +316,7 @@ void print_hex_dump(const char *level, const char
> *prefix_str, int prefix_type,
> >  		}
> >  	}
> >  }
> > -EXPORT_SYMBOL(print_hex_dump);
> > +EXPORT_SYMBOL(print_hex_dump_ext);
> 
> We should still export even the original function that is still used
everywhere.

It's replaced with an inline wrapper function, there's no need to export it.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
