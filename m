From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] 2.5.51 SCSI_IOCTL_GET_IDLUN + _GET_BUS_NUMBER
Date: Fri, 13 Dec 2002 09:40:14 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DF9104E.4090509@torque.net>
References: <3DF83E4F.8000704@torque.net> <200212121427.gBCERG502453@localhost.localdomain> <20021212174241.GB6481@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Dec 12 2002, James Bottomley wrote:
> 
>>dougg@torque.net said:
>>
>>>For disks both the SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER
>>>ioctls return the value 0 (type: int) in all cases. The attachment
>>>removes the dummy definitions of these ioctls in driver/block/
>>>scsi_ioctl.c so they fall through to the scsi mid level which
>>>correctly implements them (at least in terms of lk 2.4). 
>>
>>I'm not sure this is the correct thing to do.  These ioctls may be there 
>>because cdrecord is using them.  In the new scheme, you can record a CD 
>>without ever troubling the scsi mid-layer, so if cdrecord wants them, they 
>>have to be provided in some fashion without relying on a fall through.
>>
>>I've copied Jens on this mail, since he's the one that knows this stuff and 
>>should be able to confirm or deny this suspicion.  Jens?
> 
> 
> Hmm, I _may_ be wrong but I think the main reason for GET_IDLUN and
> GET_BUS_NUMBER in the generic block layer is to stop them from failing
> in libscg and thus fooling it into believing we are scsi. You would need
> to check libscg/scsi-linux-sg.c to be sure.

One reason libscg/scsi-linux-sg.c (cdrecord) would use
them is to differentiate between multiple "pseudo" scsi
devices when it is doing a scd to sg mapping. [This is the area
where I saw my sg_utils break.]

So defining them and always yielding 0 is going to confuse
it when there are two or more devices (e.g. 2 cd writers).

cdrecord uses the <host, target_id, lun> triple to enumerate
cd writers (rather than linux's <host, channel, target_id, lun>).
It is not clear to me how trying to define a correct
SCSI_IOCTL_GET_IDLUN ioctl in the block level can cope with
the strange combination of one scsi cdwriter and one atapi
cdrwiter in the same box. [That is, will they have distinct
host numbers?]

There are also applications like cdparanoia to consider.

> For one thing, we need to maintain the behaviour we have now of _not_
> failing them for ata devices. If you want to pass them down to SCSI as
> well and get the right id/lun and bus, fine, but don't break the ata
> one.

There is also the meaning of these ioctls in lk 2.4
to consider.

How to define these ioctls properly for scsi block devices
and return "0" for other types of block devices??
Well sd and sr could be patched to route these two ioctls
to the scsi mid level and let other ioctls be diverted
through drivers/block/scsi_ioctl.c . Is that ugly enough :-)



BTW SCSI_IOCTL_GET_IDLUN ioctl in lk 2.4 and earlier yields
2 integer values (not 1).

Doug Gilbert




