From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Make scsi_vpd_lun_id() able to use T10 vendor ID
 based designators
Date: Fri, 6 May 2016 11:46:09 +0200
Message-ID: <572C67E1.9090904@suse.de>
References: <20160504065830.GB19436@oak.ozlabs.ibm.com>
 <5729C920.1040206@suse.de> <20160505035010.GA4635@oak.ozlabs.ibm.com>
 <572AFDC9.1000607@suse.de> <20160505124136.GA8374@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbcEFJqL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 05:46:11 -0400
In-Reply-To: <20160505124136.GA8374@fergus.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>
Cc: linux-scsi@vger.kernel.org

On 05/05/2016 02:41 PM, Paul Mackerras wrote:
> On Thu, May 05, 2016 at 10:01:13AM +0200, Hannes Reinecke wrote:
>> On 05/05/2016 05:50 AM, Paul Mackerras wrote:
>>> On Wed, May 04, 2016 at 12:04:16PM +0200, Hannes Reinecke wrote:
> ...
>>>> Nearly.
>>>> The thing is, a T-10 vendor specific ID is _supposed_ to be an ASC=
II
>>>> string. So I'd rather have it decoded as such.
>>>
>>> Do we need to defend against non-printing characters in the string?
>>>
>> I really would like to stick to ASCII output here, as most vendors p=
ut a
>> meaningful string in here.
>> Those who don't we should be going with the '.' normal method and pr=
int
>> a dot '.' instead.
>> (Can't we fix up snprintf do do it for us? Would be soo cool ...)
>>
>>>> And we're missing decoding for 'vendor-specific' ID, too.
>>>
>>> There's no guarantee that this would be ASCII, right?  So would you
>>> print it in hex?
>>>
>> Yes, that's the plan here.
>>
>>> Also, is there a preference between these types?  For example, is a=
n
>>> 8-byte EUI-64 preferable to a vendor-specific ID of any length?
>>>
>> Yes. I'd treat T10 vendor ID descriptors with the lowest preference
>> (irrespective of the length), eclipsed (sic) only by the truly vendo=
r
>> specific ones.
>=20
> Well, the disks on my system all have the same vendor-specific ID,
> unfortunately -- a '0' followed by 19 spaces.  Here are the
> designators for all the disks on my system:
>=20
> scsi 0:2:0:0: 02 01 00 20 'IBM     IPR-0   5EC4AB0000000020'
> scsi 0:2:0:0: 02 00 00 14 '0                   '
> scsi 0:2:1:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000080'
> scsi 0:2:1:0: 02 00 00 14 '0                   '
> scsi 0:2:2:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000060'
> scsi 0:2:2:0: 02 00 00 14 '0                   '
> scsi 0:2:3:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000040'
> scsi 0:2:3:0: 02 00 00 14 '0                   '
> scsi 0:2:4:0: 02 01 00 20 'IBM     IPR-0   5EC28C0000000020'
> scsi 0:2:4:0: 02 00 00 14 '0                   '
> scsi 0:2:5:0: 02 01 00 20 'IBM     IPR-0   5EC28C00000000C0'
> scsi 0:2:5:0: 02 00 00 14 '0                   '
> scsi 0:2:6:0: 02 01 00 20 'IBM     IPR-0   5EC28C00000000A0'
> scsi 0:2:6:0: 02 00 00 14 '0                   '
>=20
My all time favourite here is HP SmartArray, which has this id:

01 03 00 10 600508b1001cc041769dcf27a752f8c2
01 00 00 04 00000000

Hence the logic to select the 'best' ID; any of the NAA or EUI
variants are (more-or-less) guaranteed to give you a valid result.
T-10 and Vendor-specific variants, OTOH, do not have a guarantee to
be even parseable; I've seen a very wide interpretation area of them
meaning of 'ASCII'...

>> And actually I would make the vendor-specific decoding the default
>> entry, too, as we might come across some other descriptors which we
>> cannot decode (yet). And by having a default method for decoding we
>> ensure to always be able to come up with an ALUA identification.
>> Otherwise we might end up in the same situation as we're in now.
>=20
> What would happen if we pick a designator which is not unique across
> different disks?  Would we think that they were all the same disk?
>=20
This is why I've implemented the selection mechanism.
Any of the NAA or EUI variants are guaranteed to the unique; I've
yet to see a vendor to get this wrong.
T-10 and vendor-specific variants, however, have a habit to be _not_
unique, without us being able to tell if they are.
(Which was the reason why I've omitted decoding for these).

Meanwhile I've posted two patches, one for not failing ALUA when no
VPD identifaction could be retrieved, and another one for properly
decoding T-10 vendor identifications.

Can you please test them and see if you issue is resolved?

Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
