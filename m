From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Wed, 23 Mar 2011 10:55:05 -0700 (PDT)
Message-ID: <480032.5780.qm@web31811.mail.mud.yahoo.com>
References: <Pine.LNX.4.44L0.1103231314130.2211-100000@iolanthe.rowland.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.230]:24160 "HELO
	nm8-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754946Ab1CWSAx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 14:00:53 -0400
In-Reply-To: <Pine.LNX.4.44L0.1103231314130.2211-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Richard Senior <richard@r-senior.demon.co.uk>, SCSI development list <linux-scsi@vger.kernel.org>

--- On Wed, 3/23/11, Alan Stern <stern@rowland.harvard.edu> wrote:
>=20
> No.=A0 It means I'll submit a new version of the
> $SUBJECT patch (which in=20
> fact I have already done),

I just saw it and acked it.

> and leave it up to James to
> decide the best=20
> way to merge it with your original patch.

Yes, I'm curious to see what Bottomley does too, now that he's (apparen=
tly?) decided to revert my topic patch, on top of which yours applies.

> Even though the merge window is now nearly over, my revised
> patch could
> still be sent on to Linus as a bug fix for 2.6.39-rc2 (and
> also queued
> for 2.6.38.1 or .2, of course).

Yes, that'd be the smart thing to do.

> > > It's possible that some wierd USB device will
> report that
> > > more than 192
> > > bytes of mode-sense data is available and then
> fail when
> > > the host asks
> > > for the reported amount.=A0 You'd think no device
> could
> > > be that stupid,
> >=20
> > If by "fail" you mean "crash", then yes, that's bad.
> However, the device may return less data. The while loop of
> my patch, 24d720b726c1a85f1962831ac30ad4d2ef8276b1, will
> correctly parse the returned
> > less data.
>=20
> True; my patches catch that case.=A0 They prevent a
> second MODE SENSE=20
> command from being sent if it would ask for less data than
> the first=20
> command has already asked for.

By "that" case you mean asking for less data than already asked for. Yo=
u don't mean "parsing the MOSE SENSE data for any len correctly".

Indeed, there is no point in asking for _less_ data than already asked =
for, as the loop I included in my topic patch, 24d720b726c1a85f1962831a=
c30ad4d2ef8276b1, will parse that data correctly.

  Luben


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
