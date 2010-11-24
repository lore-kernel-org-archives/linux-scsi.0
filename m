From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 24 Nov 2010 01:02:28 -0800 (PST)
Message-ID: <549123.75632.qm@web31809.mail.mud.yahoo.com>
References: <20101123143026.GM20296@one-eyed-alien.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101123143026.GM20296@one-eyed-alien.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

--- On Tue, 11/23/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> =
wrote:

> Not really.=A0 In your example case of the write-protect
> bit, either the
> device would be improperly marked as write-protected when
> it is not, or we
> would improperly send write commands to a protected
> device.=A0 Neither is a
> great tradgedy; commands will fail, errors will be
> generated, and life will
> go on.

Yes, indeed.

> However, I don't know what is in the Caching Mode
> Page.

It's described in SBC-3.

> I don't know how
> those bits are used to determine the behavior of the rest
> of the kernel.

I see.

> Maybe one of those bits means "only store data in Japanese"
> or something
> equally disturbing.

I doubt it. (And I don't find that disturbing.)

> The old code used to make a "safe" default choice if the
> caching mode page
> was not available (for whatever
> reason).=A0=A0=A0What are the implications of not
> making the "safe" choice improperly (due to mode page
> corruption)?

Let's see... the old code made the ``"safe" default choice'' of believi=
ng that the write cache is disabled and will thus never synchronize the=
 cache, i.e. send SYNCHRONIZE CACHE command, reading drivers/scsi/sd.c.=
 It also believes that the read cache is enabled, harmless as it is not=
 used by the kernel. It also assumes that DPOFUA is not supported and w=
ill thus never set FUA in the CDB, in sd_revalidate_disk() (blk dev ops=
).

Quoting you, s/write commands/cdbs with FUA set or SYNCHRONIZE CACHE co=
mmand/g:

> we
> would improperly send write commands to a protected
> device.  Neither is a
> great tradgedy; commands will fail, errors will be
> generated, and life will
> go on.

But I believe the discussion has gone astray. Bringing it back to the o=
riginal topic:

I doubt this as very unlikely. Has anyone actually seen a device that s=
ends mode parameter data with faux Caching mode page or corrupted data =
that is in fact interpreted as a Caching mode page? Is such a device fu=
lly operational sans the faux Caching mode page, or does it just not wo=
rk? Is it common to have devices having a faux Caching mode page or cor=
rupted mode parameter data resulting in a Caching mode page with random=
 data?

Undoubtedly, as the usb-storage maintainer, you must have variety of de=
vices, some broken some not. Could you apply this patch to your tree an=
d test some of the devices you have? My tests indicate a stable behavio=
r.

    Luben
