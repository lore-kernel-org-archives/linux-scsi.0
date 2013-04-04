From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Thu, 04 Apr 2013 12:17:32 +0200
Message-ID: <515D533C.1070809@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org> <5152A19C.7010500@suse.de> <5155C235.40807@redhat.com> <515718A3.1080302@suse.de> <51587619.1060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab3DDKRf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Apr 2013 06:17:35 -0400
In-Reply-To: <51587619.1060208@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>, Bud Brown <bubrown@redhat.com>

On 03/31/2013 07:44 PM, Tomas Henzl wrote:
> On 03/30/2013 05:53 PM, Hannes Reinecke wrote:
>> On 03/29/2013 05:32 PM, Tomas Henzl wrote:
[ .. ]
>>>
>>> in scsi_report_lun_scan is max_lun compared with the result of scsi=
lun_to_int,
>>> but in that value is also stored the address method. This means, th=
at we compare
>>> the max_lun to a LUN 'handle' which doesn't seem to make much sense=
=2E
>>> This makes that test dependent on which address method is used and =
not
>>> only to the LUN number which is I think expected.
>>> The solution is to have a new function 'scsilun_to_num', (I can sen=
d a patch)
>>> or let the individual drivers set the max_lun to -1 and test for th=
e allowed LUNs
>>> in the driver.
>>>
>> You sure this is necessary?
>=20
> This is not directly related to your 64bit patch, I just 'used' this =
thread
> to discuss another issue - sorry.
>=20
Yeah, and thereby decreasing the chance of getting my patchset in :-(

>>
>> I would like to avoid having to parse the LUN number for validity as=
 we=20
>> cannot guarantee this check has any meaning for the target.
>> The only authoritative check can be made by the target.
>=20
> What we can do is to decode the LUN and compare it to max_lun provide=
d by the driver,
> I think that sg_luns is able to do that, so what is needed is just to=
 follow the SAM.=20
>=20
> I have seen reports of problem on three different drivers connected t=
o various=20
> external storage, all of them having the same basic reason - the driv=
er sets a max_lun
> and then LUN comes encoded with a newer addressing method and somethi=
ng like this is shown
> 'kernel: scsi: host 2 channel 0 id 2 lun16643 has a LUN larger than a=
llowed by the host adapter'
>=20
> Decoding the real LUN value would fix this problem, by decoding is on=
ly meant the use in=20
> scsi_report_lun_scan. The LUN would be stored exactly the same way as=
 it is now.
> I know we can patch the certain drivers too, but when max_lun were  w=
hat the name says=20
> - max LU number, it would fix my problem very easy.
>=20
Errm.

No. Decoding LUNs is _evil_. It has only a relevance on the target,
and even then it might choose to ignore it.
So we cannot try to out-guess the target here.

The error you're reporting is that lpfc is setting max_luns to
'255', which of course is less than 16643. Increasing max_luns on
lpfc to '0xFFFF' will fix your problem; nothing to do with 64-bit
LUNs ...

>>
>> In the 64-bit context the max_luns should rather be interpreted as a
>> 'max bits' setting, ie the number of _bits_ per LUN number the HBA i=
s=20
>> able to transport.
>> But renaming 'max_luns' to 'max_bits' is a bit pointless, as it woul=
d=20
>> break backwards compability for no real gain.
>>
>> So with my patchset we have a two-step LUN validation:
>> - max_luns controls the max LUN number
>>    (read: max number of bits per LUN) which can be transported
>>    to the target
>=20
> This means in fact only 32 or 64 bit - so a single bit flag is enough=
?
>=20
No, it is not.

We have SPI narrow with max_luns =3D 8, SPI wide with max_luns =3D 16,
some (older) FC HBAs supporting only 8 or 16 bits LUNs, some RAID
arrays supporting 32-bit LUNs etc.

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
