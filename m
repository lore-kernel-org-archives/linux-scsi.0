From: Hannes Reinecke <hare@suse.de>
Subject: Re: Handling multiple paths to enclosure devices?
Date: Fri, 29 Jul 2011 09:21:56 +0200
Message-ID: <4E325F94.6040104@suse.de>
References: <1311872730-4863-1-git-send-email-roland@kernel.org>	 <1311886653-14193-1-git-send-email-roland@kernel.org> <1311923380.8190.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab1G2HV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 03:21:58 -0400
In-Reply-To: <1311923380.8190.3.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, eric@purestorage.com

On 07/29/2011 09:09 AM, James Bottomley wrote:
> On Thu, 2011-07-28 at 13:57 -0700, Roland Dreier wrote:
>>   >  My initial thought is that in a multi-path situation, as above,=
 we get
>>   >  two enclosures appearing as well (one down each path).  If we
>>   >  incorporated the idea of topological subtrees into the identity=
 matching
>>   >  code, we'd end up filling each of the enclosures with the path =
connected
>>   >  devices.  That seems to be an easy situation for multi-path dri=
vers to
>>   >  sort out and one requiring no alteration of the existing enclos=
ure code
>>   >  (except to do the topological subtree search).
>>
>> Ah, good insight: we do have two copies of the expander device, and =
so
>> it would be natural to attach each disk to the expander device on th=
e
>> same path to that disk.
>>
>> I'm a bit confused by what you mean about multi-path drivers though =
--
>> it would seem we would need the enclosure stuff to handle this
>> somehow?  It seems that if I have this situation, my HBA driver (eg
>> mpt2sas) will discover the SCSI bus, hit an enclosure, trigger loadi=
ng
>> the ses driver (which pulls in the enclosure driver), and then
>> continue discovering disks.  And it seems this code needs to get the
>> topology sorted by itself -- how could a multi-path driver inject
>> itself into the symlink creation in enclosure.c?
>
> I merely meant that our current philosophy is to layer multi-path
> awareness in a separate driver: dm.  There's certainly no expander
> awareness in dm-mp at the moment, but there could be.  It should be
> quite simple:  match the expanders to something like a dm-exp and the=
n
> basically use the slot information in the expander to construct dm
> devices for each of the physicals (the rule for dm device creation wo=
uld
> be dm-exp slot matching).
>
Doesn't help as device-mapper is only concerned with block devices,
what with dm devices being essentially abstract block devices.

But yes, we should stick to our current philosophy of treating=20
multipath devices as separate trees underneath the accessing HBA.
We should not (and, in fact, cannot) try to map the external=20
topology in sysfs, rather should stick to a logical view as seen=20
from each HBA. So the enclosure class needs to be updated
int include the HBA number in there to avoid duplicate links.

The correct mapping and accessing these 'multipathed enclosures'
will then be left as an exercise to the reader :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
