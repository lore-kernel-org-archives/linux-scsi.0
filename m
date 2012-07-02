From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Mon, 2 Jul 2012 15:23:18 -0700
Message-ID: <CA+55aFymdk8Sn8CVXRZgRvR96jCZG3LQRNU3U0dMkS3Ut2CemQ@mail.gmail.com>
References: <20120701172012.078559139@decadent.org.uk> <4FF14957.3040007@redhat.com>
 <CA+55aFyRTXqSvf9m08gbHCB0WhVF14Y6J2-AiFGiuTStq0Jr6Q@mail.gmail.com> <1341261568.3319.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51859 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2GBWXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jul 2012 18:23:40 -0400
In-Reply-To: <1341261568.3319.7.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 2, 2012 at 1:39 PM, James Bottomley
<jbottomley@parallels.com> wrote:
>
> It's not idiotic.  It's, unfortunately, required by the standard to
> check for protection capable devices.
 [.. dleted ]
>  Martin Petersen did extensive testing of devices when we
> changed it and doing RC16 first is hedged around by claiming support not
> only for SCSI_3 but also for SBC_2 in your INQUIRY data.

Umm. That just smells like BS to me.

The "extensive testing" part was clearly not true, and it seems that
SCSI people sometimes forget that the biggest user (by *far*) is the
USB storage layer.

Also, your protection claim seems to be invalidated by the actual
code. Yes, it checks if the device claims to support protection. But
it *also* says "let's do that 16b command if "scsi_level >
SCSI_SPC_2". So your claim that it hedges around it by looking at the
inquiry data is pure crap. It's simply not true. Just look at the
code:

        if (sdp->host->max_cmd_len < 16)
                return 0;
        if (sdp->try_rc_10_first)
                return 0;
        if (sdp->scsi_level > SCSI_SPC_2)
                return 1;
        if (scsi_device_protection(sdp))
                return 1;
        return 0;

Notice how for high enough scsi_levels, it never even gets to that
scsi_device_protection() check, which does indeed look into protection
data.

So no, I simply don't see the careful testing or the checking that you
claim exists.

                 Linus
