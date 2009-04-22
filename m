From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] RFC: have dm-mpath use already attached scsi_dh
Date: Wed, 22 Apr 2009 16:15:49 +0200
Message-ID: <49EF2695.7070701@suse.de>
References: <1240374806-6043-1-git-send-email-michaelc@cs.wisc.edu> <49EEE071.9060902@suse.de> <49EF2137.80708@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZDVOPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 10:15:51 -0400
In-Reply-To: <49EF2137.80708@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Levy_Jerome@emc.com, berthiaume_wayne@emc.com

Hi Mike,

Mike Christie wrote:
> Hannes Reinecke wrote:
>> Hi Mike,
>>
>> michaelc@cs.wisc.edu wrote:
>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>
>>> If you have a mixed environment of clarriions, where some
>>> support ALAU and some support PNR, what do you put in
>>> your multipath.conf? With this patch you do not have to worry about
>>> it. If those modules are loaded before dm-mpath, then they
>>> will have attached to the correct devices based on inquiry, alua
>>> commands
>>> and parsing of data buffers (for example in scsi_dh_emc's alua chec=
k).
>>> There is no need for the user to set that info in the multipath.con=
f.
>>> And in general since all scsi_dh_modules will attach to the devices
>>> they work for, we do not need to have users specific this.
>>>
>> No. The problem here is the hardware table from scsi_dh is compiled
>> in and cannot be changed from userland. The multipath.conf OTOH
>> is purely user-defined and, what's more, the user might have a valid
>> reason for modifying it.
>> (EG EMC Clariion can well be run in PNR mode even though ALUA is
>> active, or the user might want to try ALUA on any as-of-yet unknown
>> devices)
>=20
> Ah. I misread the code and misunderstood the compat mode. I thought
> scsi_dh_emc was failing the attach when ALUA support was detected.
>=20
>>
>> So _not_ allowing multipath to override the device handler setting
>> will just add to the confusion and makes error tracking even more
>> difficult.
>>
>> So I would prefer the attached patch, it even save to touch
>> device handler code at all.
>>
>=20
> Thanks. I think this will work for me.
>=20
> Are you going to push this for 2.6.30?
Well, yes, I could.

However, I'm still waiting for agk to push the request-based
multipath patches; I've got quite some updates here for multipathing
which are done with request-based multipath in place;
disentangling them will be quite time consuming (and pointless).

But this one, sure.

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
