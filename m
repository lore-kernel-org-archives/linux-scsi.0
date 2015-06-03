From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Patch "sd: Disable support for 256 byte/sector disks" has been
 added to the 4.0-stable tree
Date: Wed, 3 Jun 2015 16:37:46 +0200
Message-ID: <CAMuHMdXxH4KhZbHXDBzTSc8Pu3AYS9RrrCH1w77LU=Q6bFzaJQ@mail.gmail.com>
References: <14333133244847@kroah.com>
	<556EC8F4.7030507@suse.cz>
	<1433338620.2251.57.camel@Odin.com>
	<1433339669.2251.61.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36036 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbbFCOhr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2015 10:37:47 -0400
In-Reply-To: <1433339669.2251.61.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "jslaby@suse.cz" <jslaby@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>, "hare@suse.de" <hare@suse.de>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>

On Wed, Jun 3, 2015 at 3:54 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2015-06-03 at 13:37 +0000, James Bottomley wrote:
>> On Wed, 2015-06-03 at 11:29 +0200, Jiri Slaby wrote:
>> > On 06/03/2015, 08:35 AM, gregkh@linuxfoundation.org wrote:
>> > > From 74856fbf441929918c49ff262ace9835048e4e6a Mon Sep 17 00:00:00 2001
>> > > From: Mark Hounschell <dmarkh@cfl.rr.com>
>> > > Date: Wed, 13 May 2015 10:49:09 +0200
>> > > Subject: sd: Disable support for 256 byte/sector disks
>> > >
>> > > From: Mark Hounschell <dmarkh@cfl.rr.com>
>> > >
>> > > commit 74856fbf441929918c49ff262ace9835048e4e6a upstream.
>> > >
>> > > 256 bytes per sector support has been broken since 2.6.X,
>> > > and no-one stepped up to fix this.
>> > > So disable support for it.
>> > >
>> > > Signed-off-by: Mark Hounschell <dmarkh@cfl.rr.com>
>> > > Signed-off-by: Hannes Reinecke <hare@suse.de>
>> > > Signed-off-by: James Bottomley <JBottomley@Odin.com>
>> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > >
>> > > ---
>> > >  drivers/scsi/sd.c |   19 +++++--------------
>> > >  1 file changed, 5 insertions(+), 14 deletions(-)
>> > >
>> > > --- a/drivers/scsi/sd.c
>> > > +++ b/drivers/scsi/sd.c
>> > > @@ -1624,6 +1624,7 @@ static unsigned int sd_completed_bytes(s
>> > >  {
>> > >   u64 start_lba = blk_rq_pos(scmd->request);
>> > >   u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
>> > > + u64 factor = scmd->device->sector_size / 512;
>> > >   u64 bad_lba;
>> > >   int info_valid;
>> > >   /*
>> > > @@ -1645,16 +1646,9 @@ static unsigned int sd_completed_bytes(s
>> > >   if (scsi_bufflen(scmd) <= scmd->device->sector_size)
>> > >           return 0;
>> > >
>> > > - if (scmd->device->sector_size < 512) {
>> > > -         /* only legitimate sector_size here is 256 */
>> > > -         start_lba <<= 1;
>> > > -         end_lba <<= 1;
>> > > - } else {
>> > > -         /* be careful ... don't want any overflows */
>> > > -         unsigned int factor = scmd->device->sector_size / 512;
>> > > -         do_div(start_lba, factor);
>> > > -         do_div(end_lba, factor);
>> > > - }
>> >
>> > Hmm, you do 'unsigned int' -> 'u64' switch of factor type here. But this
>> > commit:
>> > commit ef80d1e18b014af08741cf688e3fdda1fb71363f
>> > Author: Geert Uytterhoeven <geert@linux-m68k.org>
>> > Date:   Mon Nov 4 10:21:05 2013 +0100
>> >
>> >     [SCSI] sd: Do not call do_div() with a 64-bit divisor
>> >
>> > did the switch in the opposite direction deliberately.
>> >
>> > So why did you do the change, given sector_size is uint?
>>
>> Primarily because no-one spotted the reversal and none of the static
>> checkers warns about it.
>>
>> This is the trivial fix, but we should do something about the checkers.
>
> Actually, I think there's no problem: all the architectures now have the
> correct conversion of the base argument.
>
> Author: Andreas Schwab <schwab@linux-m68k.org>
> Date:   Fri Aug 9 15:14:08 2013 +0200
>
>     m68k: Truncate base in do_div()
>
> Fixed this in m68k, which was the last one, so it looks like there's no
> issue and ef80d1e18b014af08741cf688e3fdda1fb71363f was pointless.

FWIW, "[PATCH] mn10300: Truncate base in do_div()"
(http://lkml.iu.edu/hypermail/linux/kernel/1308.2/03544.html)
hasn't been applied yet. But as mn10300 is little endian, it shouldn't
suffer from the bug like m68k did.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
