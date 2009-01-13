From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 15:17:46 +0100
Message-ID: <496CA28A.9050600@suse.de>
References: <496C9C26.9020106@suse.de> <20090113135856.GE29283@parisc-linux.org> <496C9EF3.2090409@suse.de> <20090113141141.GF29283@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:48466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZAMORt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 09:17:49 -0500
In-Reply-To: <20090113141141.GF29283@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Hi Matthew,

Matthew Wilcox wrote:
> On Tue, Jan 13, 2009 at 03:02:27PM +0100, Hannes Reinecke wrote:
>> Matthew Wilcox wrote:
>>> Backwards jumps are generally disapproved of.  How about:
>>>
>>> 	spin_lock_irqsave(shost->host_lock, flags);
>>> 	for (;;) {
>>> 		sdev =3D __scsi_device_lookup_by_target(starget, sdev, lun);
>>> 		if (!sdev || !scsi_device_get(sdev))
>>> 			break;
>>> 	}
>>> 	spin_unlock_irqrestore(shost->host_lock, flags);
>=20
>> I must say I don't really like the for(;;) construct.
>=20
> I'd be fine with:
>=20
> 	do {
> 		sdev =3D __scsi_device_lookup_by_target(starget, sdev, lun);
> 	} while (sdev && scsi_device_get(sdev));
>=20
> though I find that slightly less clear than the for (;;) construct.
>=20
Opinons differ.
Something for the maintainer to decide. James?

>> And it's really confusing as we want to find an sdev, so breaking
>> if it's _not_ found is ... weird.
>=20
> Those are the two conditions when we want to stop trying -- if there'=
s
> no device or if the device we've found is bad.  I can definitely see =
an
> argument for splitting the two conditions to make that more obvious. =
 I
> can also see an argument for not returning an sdev in the _DEL state
> from __scsi_device_lookup_by_target in the first place.
>=20
Not sure if that would work with esp_scsi.c (the other user of
__scsi_device_lookup_by_target()).
And don't have a device to try it with.

But modifying __scsi_device_lookup_by_target() would alter the behaviou=
r,
whereas this patch does not.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
