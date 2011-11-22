From: Petr Tesarik <ptesarik@suse.cz>
Subject: Re: Locking scheme of /proc/scsi/scsi
Date: Tue, 22 Nov 2011 11:57:19 +0100
Message-ID: <201111221157.20099.ptesarik@suse.cz>
References: <201111211832.35865.ptesarik@suse.cz> <4ECB6477.4050703@suse.de> <4ECB6867.8020509@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab1KVK5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2011 05:57:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id E04D090B49
	for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2011 11:57:20 +0100 (CET)
In-Reply-To: <4ECB6867.8020509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Dne =DAt 22. listopadu 2011 10:16:23 Hannes Reinecke napsal(a):
> On 11/22/2011 09:59 AM, Hannes Reinecke wrote:
> > On 11/21/2011 06:32 PM, Petr Tesarik wrote:
> >> Hi folks,
> >>=20
> >> I've been working on a kernel crash dump of an ancient kernel rece=
ntly,
> >> and I have come to the conculsion that walking the scsi devices vi=
a
> >> bus_find_device() is completely flawed. While looking for an upstr=
eam
> >> fix, I didn't find any, so the same flaw is probably still there.
> >> However, let me ask here to check how this is supposed to work.
> >>=20
> >> First, this is how I understand the issue. The "/proc/scsi/scsi" f=
ile is
> >> handled as a pretty standard seqfile, iterating over the devices w=
ith
> >> the following function:
> >>=20
> >> static inline struct device *next_scsi_device(struct device *start=
)
> >> {
> >>=20
> >> 	struct device *next =3D bus_find_device(&scsi_bus_type, start, NU=
LL,
> >> =09
> >> 					      always_match);
> >> =09
> >> 	put_device(start);
> >> 	return next;
> >>=20
> >> }
> >>=20
> >> The returned value is used for the next iteration. Now,
> >> bus_find_device() assumes that the device is still attached to the
> >> knode_bus klist, because that's how it initializes the klist itera=
tor.
> >> When it finds the next device, it increments the reference count o=
n the
> >> device with get_device(), but it doesn't do anything about the
> >> knode_bus field. So, when somebody calls scsi_remove_device() on t=
he
> >> current device between two calls to
> >>=20
> >> next_scsi_device, then it does:
> >> 	if (sdev->is_visible) {
> >>=20
> >> [...]
> >>=20
> >> 		device_del(dev);
> >>=20
> >> which in turn calls:
> >> 	bus_remove_device(dev);
> >>=20
> >> which does:
> >> 		if (klist_node_attached(&dev->p->knode_bus))
> >> 	=09
> >> 			klist_del(&dev->p->knode_bus);
> >>=20
> >> So, even though the struct device has a non-zero refcount, the cod=
e in
> >> next_scsi_device cannot continue, because it only has a stale poin=
ter to
> >> an already detached klist, right?
> >>=20
> >> At least that's what I saw in 2.6.16, and I can still see the same=
 thing
> >> possible in 3.1.
> >=20
> > Hmm. Looks like we need to increase the refcount to knode_bus when
> > we iterate devices.
> > Let me check ...
>=20
> No, this seems to be okay. klists are protected by their own
> refcounting in ->n_ref (via klist_dec_and_del()), so the list
> processing can continue.

Of course it has its own refcounting, and that's exactly my point! The =
last=20
reference can be dropped with klist_del() in bus_remove_device(). The s=
eqfile=20
doesn't hold any reference to the knode_bus klist node. The obvious fix=
 is to=20
add the extra reference somehow before it is dropped in bus_find_device=
() with

	klist_iter_exit(&it);

> However, seeing that you're working with 2.6.16 there has been a
> rather serious issue with scsi device scanning, which has been fixed
> by 32aeef605aa01e1fee45e052eceffb00e72ba2b0.

Thank you for the pointer. This is patches.fixes/scsi-restart-lookup-by=
-target=20
in the SLES kernel, and you added it yourself. ;-)

Cheers,
Petr Tesarik
SUSE LINUX
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
