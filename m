From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Add VPD support to aacraid
Date: Fri, 26 Jan 2007 09:04:46 +0100
Message-ID: <45B9B61E.7040000@suse.de>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0141A067@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:51049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030812AbXAZIEw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 03:04:52 -0500
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0141A067@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mark Haverkamp <markh@linux-foundation.org>

Salyzyn, Mark wrote:
> Hannes, I am working the firmware and management software folks to fi=
nd out how
> to mine for this information. In your patch, the controller serial
number may be
> helpful, but not necessarily compliant?
>
Well, the information in page 0x80 is 'vendor specific'. So anything we
put in there is compliant :-)

> Besides persistent device id, what else is gained? The controller ens=
ures persistent
> device id for the arrays through the meta-data, only migrating if it
happens to be a
> foreign (from another controller) array that collides with a native
array at the same
> ID. Plug the constituent drives into totally different IDs in the SAS
infrastructure,
> the ID remains the same as presented by the controller. Plug those
drives into another
> controller, and if not taken by an existing array, the ID will again
remain the same.
>
Yes, that's what I thought would happen. Main reason for adding page
0x80 support is to get it to work with the current persistent device ID
setup from udev. There we're using the scsi_id program which doesn't
return a serial number if neither page 0x83 nor page 0x80 are supported=
=2E
So just hacking them into the driver was the easiest way to get it fixe=
d.

And there is actually a second reason for adding page 0x80 support:
If there were something like a build uuid for the array (either a prope=
r
uuid or maybe even the build date) we would be able to detect an array
re-initialisation. Currently we won't be able to deal with this as the
array will have the same ID, so we would try to mount a drive with a
totally different content.

That was actually what I was aiming for with that patch, but after two
days of hacking I gave up and settled for the easy way out.
I know that at least the array build date is somewhere, as the
management software displays them :-). So it should be relatively easy
to use that as the serial number.

> If this is all of your concerns, adding the baggage to the driver
> will be redundant.
>=20
Actually, not quite. In not supporting EVPD page any compliant software
must assume that there is not way of reliably distinguish between two
drives from the same vendor/model.
And, incidentally, it should be possible to hook in two controllers, an=
d
creating two arrays with the same name, right?
So we _don't_ have a reliable way for doing so.
And this is where EVPD page 0x80 support comes in.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
