From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: simplify target_parse_naa_6h_vendor_specific()
Date: Wed, 28 Sep 2011 14:04:59 -0700
Message-ID: <1317243899.27352.238.camel@haakon2.linux-iscsi.org>
References: <1316413492.3622.91.camel@haakon2.linux-iscsi.org>
	 <9d522de8482ec20816be2b68b2d37ab8406f6876.1316419814.git.andriy.shevchenko@linux.intel.com>
	 <CAHp75Vdp6MpUQKeg1LM3Gn+R21ZfV66dg9Q78QUj=BVLM0t1DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48559 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1I1VFE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2011 17:05:04 -0400
In-Reply-To: <CAHp75Vdp6MpUQKeg1LM3Gn+R21ZfV66dg9Q78QUj=BVLM0t1DQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-09-27 at 13:48 +0300, Andy Shevchenko wrote:
> On Mon, Sep 19, 2011 at 11:11 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_cdb.c |   30 +++++++++++++-----------------
> >  1 files changed, 13 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
> > index f04d4ef..b796115 100644
> > --- a/drivers/target/target_core_cdb.c
> > +++ b/drivers/target/target_core_cdb.c
> > @@ -24,7 +24,6 @@
> >  */
> >
> >  #include <linux/kernel.h>
> > -#include <linux/ctype.h>
> >  #include <asm/unaligned.h>
> >  #include <scsi/scsi.h>
> >
> > @@ -156,11 +155,12 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
> >  }
> >
> >  static void
> > -target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_off)
> > +target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf)
> >  {
> >        unsigned char *p = &dev->se_sub_dev->t10_wwn.unit_serial[0];
> > -       unsigned char *buf = buf_off;
> > -       int cnt = 0, next = 1;
> > +       int cnt;
> > +       bool next = true;
> > +
> >        /*
> >         * Generate up to 36 bits of VENDOR SPECIFIC IDENTIFIER starting on
> >         * byte 3 bit 3-0 for NAA IEEE Registered Extended DESIGNATOR field
> > @@ -169,20 +169,16 @@ target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_of
> >         * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
> >         * per device uniqeness.
> >         */
> > -       while (*p != '\0') {
> > -               if (cnt >= 13)
> > -                       break;
> > -               if (!isxdigit(*p)) {
> > -                       p++;
> > +       for (cnt = 0; *p && cnt < 13; next = !next) {
> > +               int val = hex_to_bin(*p++);
> > +
> > +               if (val < 0)
> >                        continue;
> > -               }
> > -               if (next != 0) {
> > -                       buf[cnt++] |= hex_to_bin(*p++);
> > -                       next = 0;
> > -               } else {
> > -                       buf[cnt] = hex_to_bin(*p++) << 4;
> > -                       next = 1;
> > -               }
> > +
> > +               if (next)
> > +                       buf[cnt++] |= val;
> > +               else
> > +                       buf[cnt] = val << 4;
> >        }
> >  }
> >
> 
> Nicholas, any comment on this?
> 

Hi Andy,

This simplification is fine with me, and will plan to queue this for
v3.2.

Thanks again!

--nab

