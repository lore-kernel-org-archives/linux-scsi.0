From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2] target: Skip non hex characters for VPD=0x83 NAA
 IEEE Registered Extended
Date: Sun, 18 Sep 2011 23:24:52 -0700
Message-ID: <1316413492.3622.91.camel@haakon2.linux-iscsi.org>
References: <1316202082-17974-1-git-send-email-nab@linux-iscsi.org>
	 <CAHp75VdOjKV_1fBzEsdbmgjo2X-18aKJrMx8ak9+7So1-SLyzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdOjKV_1fBzEsdbmgjo2X-18aKJrMx8ak9+7So1-SLyzQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-09-17 at 13:13 +0300, Andy Shevchenko wrote:
> On Fri, Sep 16, 2011 at 10:41 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds target_parse_naa_6h_vendor_specific() to address a bug where the
> > conversion of PRODUCT SERIAL NUMBER to use hex2bin() in target_emulate_evpd_83()
> > was not doing proper isxdigit() checking.  This conversion of the vpd_unit_serial
> > configifs attribute is done while generating a VPD=0x83 NAA IEEE Registered
> > Extended DESIGNATOR format's 100 bits of unique VENDOR SPECIFIC IDENTIFIER +
> > VENDOR SPECIFIC IDENTIFIER EXTENSION area.
> >
> > This patch allows vpd_unit_serial (VPD=0x80) and the T10 Vendor ID DESIGNATOR
> > format (VPD=0x83) to continue to use free-form variable length ASCII values,
> > and now skips any non hex characters for fixed length NAA IEEE Registered Extended
> > DESIGNATOR format (VPD=0x83) requring the binary conversion.
> >
> > This was originally reported by Martin after the v3.1-rc1 change to use hex2bin()
> > in commit 11650b859681e03fdbf26277fcfc5f1f62186703 where the use of non hex
> > characters in vpd_unit_serial generated different values than the original
> > v3.0 internal hex -> binary code.  This v3.1 change caused a problem with
> > filesystems who write a NAA DESIGNATOR onto it's ondisk metadata, and this patch
> > will (again) change existing values to ensure that non hex characters are not
> > included in the fixed length NAA DESIGNATOR.
> >
> > Note this patch still expects vpd_unit_serial to be set via existing userspace
> > methods of uuid generation, and does not do strict formatting via configfs input.
> >
> > The original bug report and thread can be found here:
> >
> > NAA breakage
> > http://www.spinics.net/lists/target-devel/msg00477.html
> >
> > The v3.1-rc1 formatting of VPD=0x83 w/o this patch:
> >
> > VPD INQUIRY: Device Identification page
> >  Designation descriptor number 1, descriptor length: 20
> >    designator_type: NAA,  code_set: Binary
> >    associated with the addressed logical unit
> >      NAA 6, IEEE Company_id: 0x1405
> >      Vendor Specific Identifier: 0xffde35ebf
> >      Vendor Specific Identifier Extension: 0x3092f498ffa820f9
> >      [0x6001405ffde35ebf3092f498ffa820f9]
> >  Designation descriptor number 2, descriptor length: 56
> >    designator_type: T10 vendor identification,  code_set: ASCII
> >    associated with the addressed logical unit
> >      vendor id: LIO-ORG
> >      vendor specific: IBLOCK:ffde35ec-3092-4980-a820-917636ca54f1
> >
> > The v3.1-final formatting of VPD=0x83 w/ this patch:
> >
> > VPD INQUIRY: Device Identification page
> >  Designation descriptor number 1, descriptor length: 20
> >    designator_type: NAA,  code_set: Binary
> >    associated with the addressed logical unit
> >      NAA 6, IEEE Company_id: 0x1405
> >      Vendor Specific Identifier: 0xffde35ec3
> >      Vendor Specific Identifier Extension: 0x924980a82091763
> >      [0x6001405ffde35ec30924980a82091763]
> >  Designation descriptor number 2, descriptor length: 56
> >    designator_type: T10 vendor identification,  code_set: ASCII
> >    associated with the addressed logical unit
> >      vendor id: LIO-ORG
> >      vendor specific: IBLOCK:ffde35ec-3092-4980-a820-917636ca54f1
> >
> > (v2: Fix parsing code to dereference + check for string terminator instead
> >     of null pointer to ensure a zeroed payload for vpd_unit_serial less
> >     than 100 bits of NAA DESIGNATOR VENDOR SPECIFIC area.  Also, remove
> >     the unnecessary bitwise assignment)
> >
> > Reported-by: Martin Svec <martin.svec@zoner.cz>
> > Cc: Martin Svec <martin.svec@zoner.cz>
> > Cc: Douglas Gilbert <dgilbert@interlog.com>
> > Cc: James Bottomley <jbottomley@parallels.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_cdb.c |   35 +++++++++++++++++++++++++++++++++--
> >  1 files changed, 33 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
> > index 89ae923..f04d4ef 100644
> > --- a/drivers/target/target_core_cdb.c
> > +++ b/drivers/target/target_core_cdb.c
> > @@ -24,6 +24,7 @@
> >  */
> >
> >  #include <linux/kernel.h>
> > +#include <linux/ctype.h>
> >  #include <asm/unaligned.h>
> >  #include <scsi/scsi.h>
> >
> > @@ -154,6 +155,37 @@ target_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
> >        return 0;
> >  }
> >
> > +static void
> > +target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf_off)
> > +{
> > +       unsigned char *p = &dev->se_sub_dev->t10_wwn.unit_serial[0];
> > +       unsigned char *buf = buf_off;
> > +       int cnt = 0, next = 1;
> > +       /*
> > +        * Generate up to 36 bits of VENDOR SPECIFIC IDENTIFIER starting on
> > +        * byte 3 bit 3-0 for NAA IEEE Registered Extended DESIGNATOR field
> > +        * format, followed by 64 bits of VENDOR SPECIFIC IDENTIFIER EXTENSION
> > +        * to complete the payload.  These are based from VPD=0x80 PRODUCT SERIAL
> > +        * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
> > +        * per device uniqeness.
> > +        */
> > +       while (*p != '\0') {
> > +               if (cnt >= 13)
> > +                       break;
> > +               if (!isxdigit(*p)) {
> > +                       p++;
> > +                       continue;
> > +               }
> > +               if (next != 0) {
> > +                       buf[cnt++] |= hex_to_bin(*p++);
> > +                       next = 0;
> > +               } else {
> > +                       buf[cnt] = hex_to_bin(*p++) << 4;
> > +                       next = 1;
> > +               }
> > +       }
> > +}
> > +
> May be I am late, but I think the above code looks a bit complicated.
> 
> Why not do the function like this:
> 
> static void
> target_parse_naa_6h_vendor_specific(struct se_device *dev, unsigned char *buf)
> {
>        unsigned char *p = &dev->se_sub_dev->t10_wwn.unit_serial[0];
>        int cnt;
>        bool next = true;
> 
>        for (cnt = 0; *p && cnt < 13; next = !next) {
>                int val = hex_to_bin(*p++);
> 
>                if (val < 0)
>                        continue;
> 
>                if (next)
>                        buf[cnt++] |= val;
>                else
>                        buf[cnt] = val << 4;
>        }
> }
> 
> 

Hi Andy,

Linus already pulled in the set of target-pending.git/3.1-rc-fixes for
-rc7 on saturday, and respinning the series over the weekend for a minor
simplification this late is something I tend to avoid..

Of course, i'm happy to take this as a v3.2 simplification instead.

--nab 


