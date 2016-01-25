From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 34/78] atari_NCR5380: Use arbitration timeout
Date: Mon, 25 Jan 2016 09:05:09 +0100
Message-ID: <CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
References: <20160103050501.042035135@telegraphics.com.au>
	<20160103050510.031796194@telegraphics.com.au>
	<CAMuHMdXKDwfEE0J2xjan2vhO3gyfBwaeRMa3Vh4-ewUrW61pvA@mail.gmail.com>
	<alpine.LNX.2.00.1601251109090.24503@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:32806 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbcAYIFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2016 03:05:10 -0500
In-Reply-To: <alpine.LNX.2.00.1601251109090.24503@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Finn,

On Mon, Jan 25, 2016 at 3:45 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sun, 24 Jan 2016, Geert Uytterhoeven wrote:
>> On Sun, Jan 3, 2016 at 6:05 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> > Allow target selection to fail with a timeout instead of waiting in
>> > infinite loops. This gets rid of the unused NCR_TIMEOUT macro, it is more
>> > defensive and has proved helpful in debugging.
>> >
>> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>> > Reviewed-by: Hannes Reinecke <hare@suse.com>
>> > Tested-by: Ondrej Zary <linux@rainbow-software.org>
>> > Tested-by: Michael Schmitz <schmitzmic@gmail.com>
>>
>> This patch (commit 55500d9b08295e3b6016b53879dea1cb7787f1b0) causes a hang
>> on ARAnyM with atari_defconfig after:
>>
>>     scsi host0: Atari native SCSI, io_port 0x0, n_io_port 0, base 0x0,
>> irq 15, can_queue 8, cmd_per_lun 1, sg_tablesize 0, this_id 7, flags {
>> }, options { REAL_DMA SUPPORT_TAGS }
>>     blk_queue_max_segments: set to minimum 1
>>
>> > --- linux.orig/drivers/scsi/atari_NCR5380.c     2016-01-03 16:03:43.000000000 +1100
>> > +++ linux/drivers/scsi/atari_NCR5380.c  2016-01-03 16:03:44.000000000 +1100
>> > @@ -1436,42 +1437,28 @@ static int NCR5380_select(struct Scsi_Ho
>> >         NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
>> >         NCR5380_write(MODE_REG, MR_ARBITRATE);
>> >
>> > -       local_irq_restore(flags);
>> > +       /* The chip now waits for BUS FREE phase. Then after the 800 ns
>> > +        * Bus Free Delay, arbitration will begin.
>> > +        */
>> >
>> > -       /* Wait for arbitration logic to complete */
>> > -#if defined(NCR_TIMEOUT)
>> > -       {
>> > -               unsigned long timeout = jiffies + 2*NCR_TIMEOUT;
>> > -
>> > -               while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS) &&
>> > -                      time_before(jiffies, timeout) && !hostdata->connected)
>> > -                       ;
>> > -               if (time_after_eq(jiffies, timeout)) {
>> > -                       printk("scsi : arbitration timeout at %d\n", __LINE__);
>> > +       local_irq_restore(flags);
>> > +       timeout = jiffies + HZ;
>> > +       while (1) {
>> > +               if (time_is_before_jiffies(timeout)) {
>> >                         NCR5380_write(MODE_REG, MR_BASE);
>> > -                       NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>> > +                       shost_printk(KERN_ERR, instance,
>> > +                                    "select: arbitration timeout\n");
>> >                         return -1;
>> >                 }
>> > +               if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
>>
>> This newly added check always triggers, causing an infinite loop calling
>> NCR5380_select().
>
> If you bisected and got a failure here, it would not be surprising because
> some of the remaining patches fix bugs in the exception handlers.
>
> But if you test the entire patch series and get a hang (after waiting for
> the command to timeout and abort etc) it could be caused by a known bug in
> the abort handler. I will be sending a patch for that.

Yes, this was bisected. The issue was originally noticed after merging in
upstream, though.

Awaiting your patch for testing...

>> Perhaps this is an ARAnyM quirk?
>
> I'd say this is an ARAnyM bug. atari_scsi has been tested on an actual
> Atari Falcon, hence Michael's tested-by tag.
>
>> If not, does it trigger (on some hardware) with drivers/scsi/NCR5380.c,
>> too?
>
> For the arbitration and selection phases, there is no difference between
> NCR5380.c and atari_NCR5380.c. That's one of the benefits of my patches.
>
> That means this code was tested on silicon from NCR (53C400), Symbios
> Logic (53C400A), AMD (Am85C80), Domex Technology Corp (DTC-536, DTC-436)
> and LOGIC Devices (L5380).

> The MR_ARBITRATE bit should remain set until the driver clears it (or the
> reset logic clears it). But it looks like aranym simply discards writes to
> the mode register, such that reads always return 0.
>
> Compare
>   http://sourceforge.net/p/aranym/code/ci/master/tree/src/ncr5380.cpp
> with the MAME/MESS emulated device
>   https://github.com/mamedev/mame/blob/master/src/devices/machine/ncr5380.cpp
>
> I don't know what the Hatari emulator does.
>
> In principle I think that Linux drivers should not carry workarounds for
> emulators.

Please consider ARAnyM is the current m68k workhorse, so it would be
nice to handle this someway.

Alternatively, we need to fix ARAnyM, or can make the creation of the
atari_scsi platform device conditional on not running under ARAnyM.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
