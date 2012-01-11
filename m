From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 2/6] drivers/scsi/megaraid.c: fix sparse warnings
Date: Tue, 10 Jan 2012 20:25:38 -0500
Message-ID: <1326245138.3264.121.camel@dabdike.int.hansenpartnership.com>
References: <20120110234230.58C9F20012E@hpza10.eem.corp.google.com>
	 <CAHtARFFWhGpFDZ51JsSHQsXs02i4Pu4x4YUfM37JxvYLucH5Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58754 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971Ab2AKBZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2012 20:25:41 -0500
In-Reply-To: <CAHtARFFWhGpFDZ51JsSHQsXs02i4Pu4x4YUfM37JxvYLucH5Dg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, rdunlap@xenotime.net, megaraidlinux@lsi.com, viro@zeniv.linux.org.uk

On Tue, 2012-01-10 at 17:18 -0800, adam radford wrote:
> On Tue, Jan 10, 2012 at 3:42 PM,  <akpm@linux-foundation.org> wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > Subject: drivers/scsi/megaraid.c: fix sparse warnings
> >
> > Fix sparse warnings of right shift bigger than source value size:
> >
> > drivers/scsi/megaraid.c:311:65: warning: right shift by bigger than source value
> > drivers/scsi/megaraid.c:313:65: warning: right shift by bigger than source value
> > drivers/scsi/megaraid.c:317:67: warning: right shift by bigger than source value
> > drivers/scsi/megaraid.c:319:67: warning: right shift by bigger than source value
> >
> > Patch suggestion from email by Al Viro:
> >
> > "Since both are claimed to be strings, I really suspect that this >> 8 is
> > misspelled >> 4 and they have a character followed by pair of two-digit
> > packed decimals in there..."
> >
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > Cc: Al Viro <viro@ZenIV.linux.org.uk>
> > Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  drivers/scsi/megaraid.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings drivers/scsi/megaraid.c
> > --- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-fix-sparse-warnings
> > +++ a/drivers/scsi/megaraid.c
> > @@ -310,15 +310,15 @@ mega_query_adapter(adapter_t *adapter)
> >        if (adapter->product_info.subsysvid == HP_SUBSYS_VID) {
> >                sprintf (adapter->fw_version, "%c%d%d.%d%d",
> >                         adapter->product_info.fw_version[2],
> > -                        adapter->product_info.fw_version[1] >> 8,
> > +                        adapter->product_info.fw_version[1] >> 4,
> >                         adapter->product_info.fw_version[1] & 0x0f,
> > -                        adapter->product_info.fw_version[0] >> 8,
> > +                        adapter->product_info.fw_version[0] >> 4,
> >                         adapter->product_info.fw_version[0] & 0x0f);
> >                sprintf (adapter->bios_version, "%c%d%d.%d%d",
> >                         adapter->product_info.bios_version[2],
> > -                        adapter->product_info.bios_version[1] >> 8,
> > +                        adapter->product_info.bios_version[1] >> 4,
> >                         adapter->product_info.bios_version[1] & 0x0f,
> > -                        adapter->product_info.bios_version[0] >> 8,
> > +                        adapter->product_info.bios_version[0] >> 4,
> >                         adapter->product_info.bios_version[0] & 0x0f);
> >        } else {
> >                memcpy(adapter->fw_version,
> 
> After a huge hunt, I was able to locate a single parallel scsi board
> that this driver works with, however it has LSI firmware on it.  I am
> unable to find the HP firmware for my board, which this code change
> affects.  Additionally, checking hp.com for firmware for my controller
> was unsuccessful.
> 
> Changing the driver version string for HP firmware on this board in
> _any way_ other than what was intended will affect the following code
> in the driver that does firmware string matching:
> 
>         if ((subsysvid == HP_SUBSYS_VID) &&
>             ((subsysid == 0x60E7) || (subsysid == 0x60E8))) {
>                 /*
>                  * which firmware
>                  */
>                 if (!strcmp(adapter->fw_version, "H01.07") ||
>                     !strcmp(adapter->fw_version, "H01.08") ||
>                     !strcmp(adapter->fw_version, "H01.09") ) {
>                         printk(KERN_WARNING
>                                 "megaraid: Firmware H.01.07, "
>                                 "H.01.08, and H.01.09 on 1M/2M "
>                                 "controllers\n"
>                                 "megaraid: do not support 64 bit "
>                                 "addressing.\nmegaraid: DISABLING "
>                                 "64 bit support.\n");
>                         adapter->flag &= ~BOARD_64BIT;
>                 }
>         }
> 
> Since I have no HP firmware on one of these boards, and I can see that
> altering the firmware string will alter the behvior of the above code
> WRT setting/clearing BOARD_64BIT in the adapter->flag field, I have to
> NACK this patch.  I hope we can live with the sparse warning since I
> have no way to test this.

So I think the title of the patch is misleading.  The point is that 

adapter->product_info.fw_version[] >> 8

Always produces zero since adapter->product_info.fw_version is a char[].
It seems that the idea was 

If you want to supply an update that just making the zero explicit for
the firmware version (and thus fixes the sparse warning) is fine too ...
Al just thought that you meant to take the firmware version as BCD
nybbles.

James


