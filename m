From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] virtio_scsi: Implement 'native LUN' feature
Date: Fri, 26 Jan 2018 16:22:46 +0100
Message-ID: <ec79dfd7-2702-fbed-9131-495d4817cc2f@suse.de>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-4-git-send-email-hare@suse.de>
 <8b0a2527-7fe1-1475-49e4-0f34c753baaf@linux.vnet.ibm.com>
 <c17da627-3228-07c3-fdde-628949ac3053@suse.de>
 <7ce4e7ad-3f01-87e3-8710-953e1708a50b@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58567 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751437AbeA0D2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jan 2018 22:28:04 -0500
In-Reply-To: <7ce4e7ad-3f01-87e3-8710-953e1708a50b@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 01/26/2018 03:15 PM, Steffen Maier wrote:
> On 12/18/2017 08:48 AM, Hannes Reinecke wrote:
>> On 12/15/2017 07:17 PM, Steffen Maier wrote:
>>> On 12/14/2017 11:11 AM, Hannes Reinecke wrote:
>>>> The 'native LUN' feature allows virtio-scsi to pass in the LUN
>>>> numbers from the underlying storage directly, without having
>>>> to modify the LUN number itself.
>>>> It works by shifting the existing LUN number down by 8 bytes,
>>>> and add the virtio-specific 8-byte LUN steering header.
>>>> With that virtio doesn't have to mangle the LUN number, allowing
>>>> us to pass the 'real' LUN number to the guest.
>>>
>>> I only see shifts by 16 bits in the code below which would be 2 bytes.
>>> I had a quick look at the corresponding qemu code which looked the same
>>> to me.
>>> What's the relation to 8 byte shifting, which would be 64 bit shift and
>>> thus odd for a 64 bit LUN, mentioned in the description here?
>>>
>>> If the code keeps the LUN level 1 and 2 (dropping level 3 and 4) and I
>>> just don't understand it, it would be fine, I guess.
>>>
>> Yeah, messed that one up. It should be 8 _bits_, obviously.
> 
> Isn't it 16 bits or 2 bytes corresponding to one LUN level?
> See also below.
> 
Indeed, correct.

>>>> Of course, we do cut off the last 8 bytes of the 'real' LUN number,
>>>> but I'm not aware of any array utilizing that, so the impact should
>>>> be negligible.
>>>
>>> Why did we do v3.17 commit 9cb78c16f5da ("scsi: use 64-bit LUNs")? ;-)
>>>
>> Because that patch just lifts the internal code to use 64-bit LUNs
>> without any changes to the behaviour.
>> This one uses the internal 64-bit LUNs and actually changes the
>> behaviour.
> 
> Sure, I was just being ironic, because your description sounded a bit as
> if all the LUN range extension is not even required because no storage
> array uses it.
> 
>>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>>> ---
>>>>    drivers/scsi/virtio_scsi.c       | 62
>>>> ++++++++++++++++++++++++++++++----------
>>>>    include/uapi/linux/virtio_scsi.h |  1 +
>>>>    2 files changed, 48 insertions(+), 15 deletions(-)
> 
>>>> @@ -524,10 +532,16 @@ static void virtio_scsi_init_hdr(struct
>>>> virtio_device *vdev,
>>>>                     int target_id,
>>>>                     struct scsi_cmnd *sc)
>>>>    {
>>>> -    cmd->lun[0] = 1;
>>>> -    cmd->lun[1] = target_id;
>>>> -    cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
>>>> -    cmd->lun[3] = sc->device->lun & 0xff;
>>>> +    if (virtio_has_feature(vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
>>>> +        u64 lun = sc->device->lun << 16;
>>>> +        lun |= ((u64)1 << 8) | (u64)target_id;
>>>> +        int_to_scsilun(lun, (struct scsi_lun *)&cmd->lun);
>>>> +    } else {
>>>> +        cmd->lun[0] = 1;
>>>> +        cmd->lun[1] = target_id;
>>>> +        cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
>>>> +        cmd->lun[3] = sc->device->lun & 0xff;
>>>> +    }
>>>
>>> Above 2 patterns seem to repeat. Have helper functions (similar to
>>> int_to_scsilun()) now that it's more than just 4 lines of filling in the
>>> virtio lun?
>>>
>> Yes, can do.
> 
> Meanwhile I think I realized why I had trouble understanding what the
> code does. I guess, I expected a conversion with int_to_scsilun() first,
> and then we would fill in the virtio-specific parts of magic-one and
> target-ID.
> You do it just the other way round, which is OK.
> 
> Say we have a 4 level 64-bit LUN and represent it in hex using
> placeholder hexdigits for the 4 levels like this:
> 0xL1L1L2L2L3L3L4L4
> Its decimal SCSI LUN representation (in hex) is:
> 0xL4L4L3L3L2L2L1L1
> Then you shift left by 16 bits (2 bytes, 1 LUN level), basically
> dropping the 4th level:
> 0xL3L3L2L2L1L10000
> The steering header is 0x01TT where TT is the target ID.
> You bitwise or the virtio-specific parts into the SCSI LUN representation:
> 0xL3L3L2L2L1L101TT
> Finally you convert it into the 64-bit LUN representation:
> 0x01TTL1L1L2L2L3L3
>   0123456789abcdef [char array indexes]
> So we nicely have the virtio-specific parts at those array indexes where
> the virtio-scsi protocol expects them.
> The usage of the other bytes is now of course different from the
> original LUN encoding: It allows more than just peripheral and flat
> space addressing for the 1st level; and it now also uses levels 2 and 3
> which were previously always zero. The 3rd level really requires 64-bit
> support in the kvm host kernel.
> This also means that a 4-level LUN is not supported unless we would
> create a new virtio-scsi protocol version that would transfer the target
> ID in a separate field not as part of the LUN field.
> 
> Did I get that right?
> 
I couldn't have it phrased better.
Essentially we're moving the original LUN down by two bytes, and
stuffing the original virtio target and LUN addressing onto it.
With that we can keep (most) of the original LUN, _and_ keep compability
with virtio (of sorts).

And with that we have to rely on no-one using 4-level LUNs; but so far
I've yet to see an array even using 3-level LUNs.

> A similar explanation in a kernel doc comment for the helper conversion
> function(s) might be helpful.
> 
Okay, I can update it.

However, I'm waiting for some life signals from Paolo; a review would be
pretty much appreciated...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
