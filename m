From: Baruch Even <baruch@ev-en.org>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Tue, 28 May 2013 19:22:41 +0300
Message-ID: <CAC9+anKabmKCb929Ypqkf1mP-sPK0UKhHQdFfRfacdY68ZqgtA@mail.gmail.com>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
 <1369608242.1904.7.camel@dabdike> <51A37019.3050604@suse.de>
 <1369687319.1950.11.camel@dabdike.int.hansenpartnership.com>
 <CAC9+an+6iLGfJ9htCnW0xoD=0M1JCObwwMPgYGtTZELEwkYC2w@mail.gmail.com> <51A4C179.5000205@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35916 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab3E1QXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 12:23:03 -0400
Received: by mail-ea0-f174.google.com with SMTP id z7so4559836eaf.19
        for <linux-scsi@vger.kernel.org>; Tue, 28 May 2013 09:23:01 -0700 (PDT)
In-Reply-To: <51A4C179.5000205@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 28, 2013 at 5:38 PM, Jeremy Linton <jlinton@tributary.com> wrote:
>         This is another part of what formed my opinions about error isolation. If one
> of your devices goes out to lunch and isn't recovering via abort/lun reset.
> Its done! Wrecking the rest of the SAN doing "bus resets" and HBA resets is a
> good way to take a serious problem and turn it into a full blown catastrophe.

This is the gist of the issue, once you got to an abort you are screwed already.
You need the abort but anything else should be reserved to when things
are really
dead (the HBA might still recover on a host reset, but only do it if the host is
really unresponsive).

That's why I prefer to have a long timeout for the command and a long
timeout for
the abort. The application above should handle itself with its own
timeout once the
abort was sent (the buffer remains locked until the abort returns).
The device itself
is likely stuck in error recovery and it will come out of it when its
own internal
timeouts are exhausted which can be infinite and will generally be very large.

Baruch
