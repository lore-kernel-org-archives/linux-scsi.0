From: Hannes Reinecke <hare@suse.de>
Subject: Re: Locking scheme of /proc/scsi/scsi
Date: Tue, 22 Nov 2011 09:59:35 +0100
Message-ID: <4ECB6477.4050703@suse.de>
References: <201111211832.35865.ptesarik@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1KVI7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2011 03:59:37 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 41A898D167
	for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2011 09:59:36 +0100 (CET)
In-Reply-To: <201111211832.35865.ptesarik@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-scsi@vger.kernel.org

On 11/21/2011 06:32 PM, Petr Tesarik wrote:
> Hi folks,
>=20
> I've been working on a kernel crash dump of an ancient kernel recentl=
y, and I=20
> have come to the conculsion that walking the scsi devices via=20
> bus_find_device() is completely flawed. While looking for an upstream=
 fix, I=20
> didn't find any, so the same flaw is probably still there. However, l=
et me ask=20
> here to check how this is supposed to work.
>=20
> First, this is how I understand the issue. The "/proc/scsi/scsi" file=
 is=20
> handled as a pretty standard seqfile, iterating over the devices with=
 the=20
> following function:
>=20
> static inline struct device *next_scsi_device(struct device *start)
> {
> 	struct device *next =3D bus_find_device(&scsi_bus_type, start, NULL,
> 					      always_match);
> 	put_device(start);
> 	return next;
> }
>=20
> The returned value is used for the next iteration. Now, bus_find_devi=
ce()=20
> assumes that the device is still attached to the knode_bus klist, bec=
ause=20
> that's how it initializes the klist iterator. When it finds the next =
device,=20
> it increments the reference count on the device with get_device(), bu=
t it=20
> doesn't do anything about the knode_bus field. So, when somebody call=
s=20
> scsi_remove_device() on the current device between two calls to=20
> next_scsi_device, then it does:
>=20
> 	if (sdev->is_visible) {
> [...]
> 		device_del(dev);
>=20
> which in turn calls:
>=20
> 	bus_remove_device(dev);
>=20
> which does:
>=20
> 		if (klist_node_attached(&dev->p->knode_bus))
> 			klist_del(&dev->p->knode_bus);
>=20
> So, even though the struct device has a non-zero refcount, the code i=
n=20
> next_scsi_device cannot continue, because it only has a stale pointer=
 to an=20
> already detached klist, right?
>=20
> At least that's what I saw in 2.6.16, and I can still see the same th=
ing=20
> possible in 3.1.
>=20
Hmm. Looks like we need to increase the refcount to knode_bus when
we iterate devices.
Let me check ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
