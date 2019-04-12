From: "Alastair D'Silva" <alastair@d-silva.org>
Subject: RE: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in hex_dump_to_buffer with flags
Date: Sat, 13 Apr 2019 09:31:27 +1000
Message-ID: <093301d4f187$da0756a0$8e1603e0$@d-silva.org>
References: <20190410031720.11067-1-alastair@au1.ibm.com> <20190410031720.11067-4-alastair@au1.ibm.com> <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412141211.lvnz6wb7mwkykmxf@pathway.suse.cz>
Content-Language: en-au
Sender: linux-kernel-owner@vger.kernel.org
To: 'Petr Mladek' <pmladek@suse.com>, 'Alastair D'Silva' <alastair@au1.ibm.com>
Cc: 'Jani Nikula' <jani.nikula@linux.intel.com>, 'Joonas Lahtinen' <joonas.lahtinen@linux.intel.com>, 'Rodrigo Vivi' <rodrigo.vivi@intel.com>, 'David Airlie' <airlied@linux.ie>, 'Daniel Vetter' <daniel@ffwll.ch>, 'Karsten Keil' <isdn@linux-pingi.de>, 'Jassi Brar' <jassisinghbrar@gmail.com>, 'Tom Lendacky' <thomas.lendacky@amd.com>, "'David S. Miller'" <davem@davemloft.net>, 'Jose Abreu' <Jose.Abreu@synopsys.com>, 'Kalle Valo' <kvalo@codeaurora.org>, 'Stanislaw Gruszka' <sgruszka@redhat.com>, 'Benson Leung' <bleung@chromium.org>, 'Enric Balletbo i Serra' <enric.balletbo@collabora.com>, "'James E.J. Bottomley'" <jejb@linux.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Petr Mladek <pmladek@suse.com>
> Sent: Saturday, 13 April 2019 12:12 AM
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
> Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
> hex_dump_to_buffer with flags
> 
> On Wed 2019-04-10 13:17:19, Alastair D'Silva wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > In order to support additional features in hex_dump_to_buffer, replace
> > the ascii bool parameter with flags.
> >
> > Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> > ---
> >  drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
> >  drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
> >  drivers/mailbox/mailbox-test.c                    |  2 +-
> >  drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
> >  drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
> >  drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
> >  drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
> >  drivers/platform/chrome/wilco_ec/debugfs.c        |  3 ++-
> >  drivers/scsi/scsi_logging.c                       |  8 +++-----
> >  drivers/staging/fbtft/fbtft-core.c                |  2 +-
> >  fs/seq_file.c                                     |  3 ++-
> >  include/linux/printk.h                            |  2 +-
> >  lib/hexdump.c                                     | 15 ++++++++-------
> >  lib/test_hexdump.c                                |  5 +++--
> >  14 files changed, 31 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c
> > b/drivers/gpu/drm/i915/intel_engine_cs.c
> > index 49fa43ff02ba..fb133e729f9a 100644
> > --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> > +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> > @@ -1318,7 +1318,7 @@ static void hexdump(struct drm_printer *m, const
> void *buf, size_t len)
> >  		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len -
> pos,
> >  						rowsize, sizeof(u32),
> >  						line, sizeof(line),
> > -						false) >= sizeof(line));
> > +						0) >= sizeof(line));
> 
> It might be more clear when we define:
> 
> #define HEXDUMP_BINARY 0

This feels unnecessary, and weird. Omitting the flag won't disable the hex
output (as expected), and if you don't want hex output, why call hexdump in
the first place?

> >  		drm_printf(m, "[%04zx] %s\n", pos, line);
> >
> >  		prev = buf + pos;
> > diff --git a/include/linux/printk.h b/include/linux/printk.h index
> > c014e5573665..82975853c400 100644
> > --- a/include/linux/printk.h
> > +++ b/include/linux/printk.h
> > @@ -493,7 +493,7 @@ enum {
> >
> >  extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
> >  			      int groupsize, char *linebuf, size_t
linebuflen,
> > -			      bool ascii);
> > +			      u64 flags);
> 
> I wonder how fancy hex_dump could be. IMHO, u32 should be enough.
> The last famous words ;-)
> 
> Best Regards,
> Petr
> 
> 
> ---
> This email has been checked for viruses by AVG.
> https://www.avg.com
