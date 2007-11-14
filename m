From: Tore Anderson <tore@linpro.no>
Subject: Re: Disabling dev_loss_tmo?
Date: Wed, 14 Nov 2007 09:10:48 +0100
Message-ID: <473AAD88.307@linpro.no>
References: <47396A5B.5040001@linpro.no> <4739CE69.3040602@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:53417 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXKNIKu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Nov 2007 03:10:50 -0500
In-Reply-To: <4739CE69.3040602@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>, Christoph Hellwig <hch@infradead.org>, MLOEHR@de.ibm.com

* James Smart

> We had a lot of conversations on what to have the transport do after=20
> connectivity was lost to a device. Suffice to say - the answer was to
> remove the device.  The dev_loss_tmo value was the compromise
> between the kernel architectural position, and what FC drivers had
> always managed and hidden from the kernel in the past.
>=20
> Unfortunately, even though DM has known of this behavior for a long
> time (it's existed since 2.6.<early teens>, no-one has bothered to
> update DM to support it. One train of thought is : fixing it for FC
> doesn't address the issue, as other transports may still encounter
> it. It's a DM thing, and should stay this way to ensure that DM fixes
> it.

So basically you're forcing breakage on users to corece the DM folks to
fix their end?  Maybe it's time to re-think that strategy, seeing that
it hasn't been fixed in such a long time it seems unlikely that they
would start bothering now.  SuSE and RH works around it anyway, so
everyone who's obedient enough to run the enterprise distros their
storage vendor tells them to won't have any problems.  Many of the DM
folks are employed by SuSE, RH, and various storage vendors - go figure=
=2E

> You noted that the FC transport, in SLES10 and RHEL5, added a patch=20
> that allowed for the scsi targets not to be torn down when
> dev_loss_tmo timed out. This had little to do with DM, and everything
> to do with reuse-after-free issues on mid-layer data structures that
> were released as part of the teardown, as well as the timing of the
> upstream reuse patches vs what the distro kernels could accept. But
> DM certainly benefited from its behavior.
>=20
> I'd rather that DM got fixed so that it supports the necessary=20
> architectural behavior. But, we've lived with the disto-specific=20
> behavior as well, so it's not a strong sentiment.

I'm just a simple user.  To me the most important ting is that it - and
by =C2=ABit=C2=BB I'm referring to the whole bundle of DM, SCSI, HBA dr=
iver, and
the rest of the system - actually works.

With no way of disabling dev_loss_tmo, it doesn't.  It will break after
intermittent failures, exactly the time where you need it to work the
most.  Knowing that the SCSI FC transport does the Right Thing isn't
really any consolation.

The patch seems like a rather simple fix.  Quick and dirty, sure, but i=
t
would actually help out the likes of me who are putting this stuff in
production.  And if it defaulted to remove_on_dev_loss=3D0, it wouldn't
really be intrusive either.  It seems that it will take a while to get
this properly fixed (both in DM and the -EEXIST issue), so what I'm
asking is just a way to make it work in the interim.

Regards
--=20
Tore Anderson
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
