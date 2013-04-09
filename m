From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Tue, 09 Apr 2013 16:52:18 +0200
Message-ID: <51642B22.3080801@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org> <5152A19C.7010500@suse.de> <5155C235.40807@redhat.com> <515718A3.1080302@suse.de> <51587619.1060208@redhat.com> <515D533C.1070809@suse.de> <e585e906-5ada-4fe6-a21d-b735c42a51c1@CMEXHTCAS1.ad.emulex.com> <5162E426.40202@redhat.com> <5163C55C.3020909@suse.de> <94D0CD8314A33A4D9D801C0FE68B402950DDBBF2@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760806Ab3DIOwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Apr 2013 10:52:22 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950DDBBF2@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "James.Smart@emulex.com" <James.Smart@emulex.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Bart Van Assche <bvanassche@acm.org>, Bud Brown <bubrown@redhat.com>

On 04/09/2013 04:27 PM, Elliott, Robert (Server Storage) wrote:
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Tuesday, 09 April, 2013 2:38 AM
>> To: Tomas Henzl
>> Cc: James.Smart@emulex.com; Chad Dupuis; linux-scsi@vger.kernel.org;=
 James
>> Bottomley; Jeremy Linton; Elliott, Robert (Server Storage); Bart Van=
 Assche;
>> Bud Brown
>> Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
>>
>> On 04/08/2013 05:37 PM, Tomas Henzl wrote:
>>> On 04/05/2013 05:24 PM, James Smart wrote:
>>>>
>>>> On 4/4/2013 6:17 AM, Hannes Reinecke wrote:
>>>>> On 03/31/2013 07:44 PM, Tomas Henzl wrote:
>>>
>> You are right in the sense that 'max_lun' actually has a double mean=
ing.
>>
>> First it's being used as the upper limit for sequential scan, where
>> is has a strictly sequential meaning. So any internal LUN structure
>> doesn't come into play here are we're just 'counting'.
>>
>> Secondly it's being used as a simple validation for any LUN numbers
>> reported via REPORT LUNS.
>> Here it the max_lun value actually refers to the amount of _bits_ in
>> a LUN number the HBA can transfer. Again, the internal LUN structure
>> doesn't come into play here; this is purely a hardware limitation on
>> the HBA. Whether a LUN is valid or not is none of our concern; if
>> the target accepts the LUN is has to be valid. If it doesn't then we
>> don't care whether the LUN structure is valid or not; there is no
>> device to be had anyway.
>>
>> However, after consulting SAM it is true that a plain 'max_lun' is
>> incorrect for any LUN value higher than 255.
>> LUN values higher than 255 should be represented with the 'flat
>> space addressing' model, ie bit 6 should be set.
>> Sadly, the various SAM revisions differ on how LUNs lower than
>> 255 should be treated; they might or might not have set the flat
>> space addressing model.
>=20
> If you treat the LUN as an 8-byte single big-endian value, then=20
> every LUN using an address method other than the peripheral
> device addressing method (00b) is greater than 255; in fact,
> they're all greater than 4,611,686,018,427,387,904
> (0x4000_0000_0000_0000).
>=20
Yes. I know.

> One "LUN value" is not represented by different addressing models.
> For example, these are four different LUNs, not multiple ways to=20
> express the same "LUN 0":
> a) LUN 0x0000_0000_0000_0000=20
> 	address method 00b
> 	target or lun =3D 0000_0000b
> b) LUN 0x4000_0000_0000_0000=20
> 	address method 01b
> 	flat space lun =3D 00_0000_0000_0000b
> c) LUN 0xD200_0000_0000_0000=20
> 	address method 11b
> 	length 01b
> 	extended address method 0x2
> 	extended flat space lun =3D 0x00_0000
> d) LUN 0xE200_0000_0000_0000=20
> 	address method 11b
> 	length 10b
> 	extended address method 0x2
> 	long extended flat space lun =3D 0x00_00000000
>=20
Yes.

> Sequential scanning should be an exception for very old devices
> that don't support REPORT LUNS; a small maximum scan value
> would be safer than scanning to max_luns, which could be huge.
>=20
Or, to be more precise, for modern devices claiming SCSI-2 or SCSI-3
conformance.
Some storage arrays have the habit of doing so.

> Three plausible lower scan limits:
> a) address method 00b with TARGET OR LUN set to 0..7: the=20
> number of LUNs supported by SCSI-1, which had a 3-bit LUN field=20
> in the CDBs themselves (long since obsolete)
>=20
> b) address method 00b with TARGET OR LUN set to 0..255: the=20
> number of LUNs supported by devices that only support address=20
> method 00b; the 8-bit TARGET OR LUN field portion of the first two=20
> bytes of the LUN.
>=20
> c) first two bytes set to 0..65535: the possible LUNs supported by=20
> devices with protocols with 2-byte LUN fields.  I think scanning this=
=20
> many would take too long, though, and might trigger bugs in=20
> devices that don't decode the LUN correctly.
>=20
>=20
My current thinking is to restrict sequential LUN scan to 255 LUNs
(ie address method 00b) and adding a BLIST flag if someone
wants/needs to scan more than that.

I thought of decoding the address method for LUNs higher than
255, but then we might run into the differences between the various
SAM versions:
- SAM / SPC (ie SCSI-3) does _not_ define an internal LUN structure,
  so in theory any LUN is valid
- SAM-2 / SPC-3 states that peripheral addressing should be used
  for LUNs less than 255, and flat space addressing for LUNs
  between 256 and 16383
- SAM-3 / SPC-4 and beyound states that peripheral _or_ flat
  space addressing can be used for LUNs less then 255, and
  flat space addressing should be used for LUNs between 256
  and 16383

So any decoding we do would fail for SCSI-3 devices. And
the amount of devices supporting more than 255 LUNs and _NOT_
supporting REPORT_LUN should be relatively small.
Hence I think decoding LUNs is not worth the trouble and
the BLIST approach should work just nicely here.

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
