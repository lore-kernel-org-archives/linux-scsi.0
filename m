From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] sd: retry READ CAPACITY for ALUA state transition
Date: Tue, 07 Jul 2015 08:18:12 +0200
Message-ID: <559B6F24.6020804@suse.de>
References: <1436181130-82905-1-git-send-email-hare@suse.de>	 <559A9B23.4020705@sandisk.com> <1436216244.6241.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbbGGGSP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jul 2015 02:18:15 -0400
In-Reply-To: <1436216244.6241.7.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/06/2015 10:57 PM, James Bottomley wrote:
> On Mon, 2015-07-06 at 08:13 -0700, Bart Van Assche wrote:
>> On 07/06/2015 04:12 AM, Hannes Reinecke wrote:
>>> During ALUA state transitions the device might return
>>> a sense code 02/04/0a (Logical unit not accessible, asymmetric
>>> access state transition). As this is a transient error
>>> we should just retry the READ CAPACITY call after 1 second
>>> until the state transition finishes and the correct
>>> capacity can be returned.
>>> At the same time we should break out of the loop after
>>> 2 minutes to avoid unbounded retries.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/scsi/sd.c | 21 +++++++++++++++++++++
>>>   1 file changed, 21 insertions(+)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index 3b2fcb4..f45b8fe 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -1934,6 +1934,7 @@ static void read_capacity_error(struct scsi_d=
isk *sdkp, struct scsi_device *sdp,
>>>   #endif
>>>
>>>   #define READ_CAPACITY_RETRIES_ON_RESET	10
>>> +#define READ_CAPACITY_RETRIES_ON_TRANSITION 120
>>>
>>>   static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_d=
evice *sdp,
>>>   						unsigned char *buffer)
>>> @@ -1943,6 +1944,7 @@ static int read_capacity_16(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
>>>   	int sense_valid =3D 0;
>>>   	int the_result;
>>>   	int retries =3D 3, reset_retries =3D READ_CAPACITY_RETRIES_ON_RE=
SET;
>>> +	int transition_retries =3D READ_CAPACITY_RETRIES_ON_TRANSITION;
>>>   	unsigned int alignment;
>>>   	unsigned long long lba;
>>>   	unsigned sector_size;
>>> @@ -1981,6 +1983,15 @@ static int read_capacity_16(struct scsi_disk=
 *sdkp, struct scsi_device *sdp,
>>>   				 * give it one more chance */
>>>   				if (--reset_retries > 0)
>>>   					continue;
>>> +			if (sense_valid &&
>>> +			    sshdr.sense_key =3D=3D NOT_READY &&
>>> +			    sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x0A) {
>>> +				/* ALUA state transition; retry after delay */
>>> +				if (--transition_retries > 0) {
>>> +					msleep(1000);
>>> +					continue;
>>> +				}
>>> +			}
>>>   		}
>>>   		retries--;
>>>
>>> @@ -2039,6 +2050,7 @@ static int read_capacity_10(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
>>>   	int sense_valid =3D 0;
>>>   	int the_result;
>>>   	int retries =3D 3, reset_retries =3D READ_CAPACITY_RETRIES_ON_RE=
SET;
>>> +	int transition_retries =3D READ_CAPACITY_RETRIES_ON_TRANSITION;
>>>   	sector_t lba;
>>>   	unsigned sector_size;
>>>
>>> @@ -2063,6 +2075,15 @@ static int read_capacity_10(struct scsi_disk=
 *sdkp, struct scsi_device *sdp,
>>>   				 * give it one more chance */
>>>   				if (--reset_retries > 0)
>>>   					continue;
>>> +			if (sense_valid &&
>>> +			    sshdr.sense_key =3D=3D NOT_READY &&
>>> +			    sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x0A) {
>>> +				/* ALUA state transition; retry after delay */
>>> +				if (--transition_retries > 0) {
>>> +					msleep(1000);
>>> +					continue;
>>> +				}
>>> +			}
>>>   		}
>>>   		retries--;
>>
>> Hello Hannes,
>>
>> Although I agree that multipathd should handle arrays correctly that=
=20
>> fail READ CAPACITY commands while transitioning, seeing that a new=20
>> hard-coded timeout is added in the SCSI initiator code does not make=
 me=20
>> enthusiast. The READ_CAPACITY_RETRIES_ON_TRANSITION timeout added=20
>> through this patch is independent of the IMPLICIT TRANSITION TIME in=
 the=20
>> REPORT TARGET PORT GROUPS response. Has the following already been=20
>> considered ?
>> - If the capacity is not known, let the scsi_dh_alua handler submit =
a=20
>> READ CAPACITY command asynchronously after certain target port group=
=20
>> state transitions. Also let the scsi_dh_alua handler submit a=20
>> notification to user space after the capacity changes from "unknown"=
 to=20
>> "known".
I'd rather prefer to have this handled with the existing 'rescan'
functionality. IE if the path becomes available (ie returns a state
of 'optimal' or 'non-optimal' scsi_dh_alua will be invoking 'rescan'
on that device, which should cause the capacity to be updated.

>> - Let multipathd ignore paths for which READ CAPACITY failed until t=
he=20
>> capacity becomes known.

I've already sent patches to multipath to simply ignore the results
from a READ CAPACITY; so this is not an issue.
Paths with a capacity of '0' will be happily accepted as multipath
devices with path status 'standby'.

>=20
> Yes, I'm with something like this.  The patch you propose will be a b=
usy
> wait for userspace which they may not want.
>=20
I'm fully aware that this patch will induce a busy wait if the
device happens to be in transitioning at that time.
This patch is just a simple solution to this problem.
The 'correct' solution is actually a bit more involved, as it would
require the device handler to keep track of the multipath topology:

Currently the device handler are per ITL nexus, and invoked on
activation only (ie for explicit ALUA), so the ALUA state only
reflect the state after the last call to 'activate'.

I have a patchset for moving scsi_dh_alua onto a workqueue, so that
it'll be able to keep track of the ALUA state per TL nexus (note the
missing 'I'). This will not only reduce the number of RTPGs send to
the target (scsi_dh_rdac already does this), but will also allow
scsi_dh_alua to keep track of the ALUA state of the relative target
port of the target port group.

However, to handle the above case correctly we would need to keep
track of the entire multipath topology, to figure out which devices
belong to that relative target port and might need to be updated
(there might be several paths in standby, and we will have sent the
RTPG only for one of them).
Patches for that are not done yet, so I thought the above patch
would be a simple stop-gap measure.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
