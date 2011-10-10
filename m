From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] target: simplify target_parse_naa_6h_vendor_specific()
Date: Mon, 10 Oct 2011 12:30:17 +0300
Message-ID: <1318239017.13889.3.camel@smile>
References: <1316413492.3622.91.camel@haakon2.linux-iscsi.org>
	 <9d522de8482ec20816be2b68b2d37ab8406f6876.1316419814.git.andriy.shevchenko@linux.intel.com>
	 <CAHp75Vdp6MpUQKeg1LM3Gn+R21ZfV66dg9Q78QUj=BVLM0t1DQ@mail.gmail.com>
	 <1317243899.27352.238.camel@haakon2.linux-iscsi.org>
	 <1318114060.4978.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318114060.4978.41.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-10-08 at 15:47 -0700, Nicholas A. Bellinger wrote: 
> On Wed, 2011-09-28 at 14:04 -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2011-09-27 at 13:48 +0300, Andy Shevchenko wrote:
> > > On Mon, Sep 19, 2011 at 11:11 AM, Andy Shevchenko
> > > <andriy.shevchenko@linux.intel.com> wrote:
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > > Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > ---
> > > >  drivers/target/target_core_cdb.c |   30 +++++++++++++-----------------
> > > >  1 files changed, 13 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
> > > > index f04d4ef..b796115 100644
> > > > --- a/drivers/target/target_core_cdb.c
> > > > +++ b/drivers/target/target_core_cdb.c
> > > > @@ -24,7 +24,6 @@
> > > >  */
> > > >
> > > >  #include <linux/kernel.h>
> > > > -#include <linux/ctype.h>
> > > >  #include <asm/unaligned.h>
> > > >  #include <scsi/scsi.h>
> > > >
> > > > @@ -156,11 +155,12 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
> > > >  }
> > > >
> > > >  static void
> > > > -target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_off)
> > > > +target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf)
> > > >  {
> > > >        unsigned char *p = &dev->se_sub_dev->t10_wwn.unit_serial[0];
> > > > -       unsigned char *buf = buf_off;
> > > > -       int cnt = 0, next = 1;
> > > > +       int cnt;
> > > > +       bool next = true;
> > > > +
> > > >        /*
> > > >         * Generate up to 36 bits of VENDOR SPECIFIC IDENTIFIER starting on
> > > >         * byte 3 bit 3-0 for NAA IEEE Registered Extended DESIGNATOR field
> > > > @@ -169,20 +169,16 @@ target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_of
> > > >         * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
> > > >         * per device uniqeness.
> > > >         */
> > > > -       while (*p != '\0') {
> > > > -               if (cnt >= 13)
> > > > -                       break;
> > > > -               if (!isxdigit(*p)) {
> > > > -                       p++;
> > > > +       for (cnt = 0; *p && cnt < 13; next = !next) {
> > > > +               int val = hex_to_bin(*p++);
> > > > +
> > > > +               if (val < 0)
> > > >                        continue;
> > > > -               }
> > > > -               if (next != 0) {
> > > > -                       buf[cnt++] |= hex_to_bin(*p++);
> > > > -                       next = 0;
> > > > -               } else {
> > > > -                       buf[cnt] = hex_to_bin(*p++) << 4;
> > > > -                       next = 1;
> > > > -               }
> > > > +
> > > > +               if (next)
> > > > +                       buf[cnt++] |= val;
> > > > +               else
> > > > +                       buf[cnt] = val << 4;
> > > >        }
> > > >  }
> > > >
> > > 
> > > Nicholas, any comment on this?
> > > 
> > 
> > Hi Andy,
> > 
> > This simplification is fine with me, and will plan to queue this for
> > v3.2.
> > 
> 
> Hi Andy,
> 
> So I finally got around to testing this patch, but unfortunately it does
> not produce the same results as the original code.  The problem is due
> to the 'next = !next' assignment in the above for loop, which causes the
> value to be reset even when hex_to_bin() detects an non hex character..
Yeah, you right.

> 
> Here is an updated patch that I will be commiting into lio-core-2.6.git.
Actually one minor comment.

> @@ -169,19 +169,18 @@ target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_of
>          * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
>          * per device uniqeness.
>          */
> -       while (*p != '\0') {
> -               if (cnt >= 13)
> -                       break;
> -               if (!isxdigit(*p)) {
> -                       p++;
> +       for (cnt = 0; *p && cnt < 13; p++) {
> +               int val = hex_to_bin(*p);
> +
> +               if (val < 0)
>                         continue;
> -               }
> -               if (next != 0) {
> -                       buf[cnt++] |= hex_to_bin(*p++);
> -                       next = 0;
> +
> +               if (next) {
> +                       next = false;
(1) 
> +                       buf[cnt++] |= val;
>                 } else {
> -                       buf[cnt] = hex_to_bin(*p++) << 4;
> -                       next = 1;
> +                       next = true;
(2) 
> +                       buf[cnt] = val << 4;
>                 }

next = !next;
here instead of (1) and (2).

> }
>  }
> 
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
