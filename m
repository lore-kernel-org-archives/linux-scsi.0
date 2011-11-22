From: Hannes Reinecke <hare@suse.de>
Subject: Re: Locking scheme of /proc/scsi/scsi
Date: Tue, 22 Nov 2011 10:16:23 +0100
Message-ID: <4ECB6867.8020509@suse.de>
References: <201111211832.35865.ptesarik@suse.cz> <4ECB6477.4050703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab1KVJQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Nov 2011 04:16:25 -0500
Received: from relay2.suse.de (nat.nue.novell.com [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 6DB8E8980B
	for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2011 10:16:24 +0100 (CET)
In-Reply-To: <4ECB6477.4050703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-scsi@vger.kernel.org

On 11/22/2011 09:59 AM, Hannes Reinecke wrote:
> On 11/21/2011 06:32 PM, Petr Tesarik wrote:
>> Hi folks,
>>
>> I've been working on a kernel crash dump of an ancient kernel recent=
ly, and I=20
>> have come to the conculsion that walking the scsi devices via=20
>> bus_find_device() is completely flawed. While looking for an upstrea=
m fix, I=20
>> didn't find any, so the same flaw is probably still there. However, =
let me ask=20
>> here to check how this is supposed to work.
>>
>> First, this is how I understand the issue. The "/proc/scsi/scsi" fil=
e is=20
>> handled as a pretty standard seqfile, iterating over the devices wit=
h the=20
>> following function:
>>
>> static inline struct device *next_scsi_device(struct device *start)
>> {
>> 	struct device *next =3D bus_find_device(&scsi_bus_type, start, NULL=
,
>> 					      always_match);
>> 	put_device(start);
>> 	return next;
>> }
>>
>> The returned value is used for the next iteration. Now, bus_find_dev=
ice()=20
>> assumes that the device is still attached to the knode_bus klist, be=
cause=20
>> that's how it initializes the klist iterator. When it finds the next=
 device,=20
>> it increments the reference count on the device with get_device(), b=
ut it=20
>> doesn't do anything about the knode_bus field. So, when somebody cal=
ls=20
>> scsi_remove_device() on the current device between two calls to=20
>> next_scsi_device, then it does:
>>
>> 	if (sdev->is_visible) {
>> [...]
>> 		device_del(dev);
>>
>> which in turn calls:
>>
>> 	bus_remove_device(dev);
>>
>> which does:
>>
>> 		if (klist_node_attached(&dev->p->knode_bus))
>> 			klist_del(&dev->p->knode_bus);
>>
>> So, even though the struct device has a non-zero refcount, the code =
in=20
>> next_scsi_device cannot continue, because it only has a stale pointe=
r to an=20
>> already detached klist, right?
>>
>> At least that's what I saw in 2.6.16, and I can still see the same t=
hing=20
>> possible in 3.1.
>>
> Hmm. Looks like we need to increase the refcount to knode_bus when
> we iterate devices.
> Let me check ...
>=20
No, this seems to be okay. klists are protected by their own
refcounting in ->n_ref (via klist_dec_and_del()), so the list
processing can continue.
However, seeing that you're working with 2.6.16 there has been a
rather serious issue with scsi device scanning, which has been fixed
by 32aeef605aa01e1fee45e052eceffb00e72ba2b0.
Please to check whether that patch is included.

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
