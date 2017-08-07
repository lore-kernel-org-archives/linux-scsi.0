From: Hannes Reinecke <hare@suse.de>
Subject: Re: nvmf question - synchronization between target/initiator
 regarding partitions
Date: Mon, 7 Aug 2017 16:20:35 +0200
Message-ID: <c382184a-1621-c6b2-2a20-bd16498be998@suse.de>
References: <82c4d1d8-ffa9-fa99-df58-05e2945eafdc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <82c4d1d8-ffa9-fa99-df58-05e2945eafdc@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
Cc: Mauricio pIO <mauricfo@linux.vnet.ibm.com>, Brian J King <bjking1@us.ibm.com>, Murali N Iyer <mniyer@us.ibm.com>, vnarasimhan@in.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 08/07/2017 03:42 PM, Guilherme G. Piccoli wrote:
> We observed that it's possible to perform partition operations in both
> nvmf target and initiator block devices, like creating and deleting
> partitions.
> 
> But there is no sync mechanism between target and initiator regarding
> the partitions operations. After creating a partition on initiator, for
> example, we don't see it on target side. We could format it like ext4 on
> initiator, and still target cannot see it. It's possible to trigger a
> BLKRRPART ioctl on target, which end up calling revalidate_disk() on
> nvme driver and then partitions are perceived.
> 
> So, question: is this behavior expected/acceptable? Is it completely up
> to userspace to deal with the synchronization between host/target?
> I think answer might be yes since partitions are a higher level of
> abstraction than nvmf (which is purely block device aware).
> 
Yes, this is to be expected.
After all, one could argue that no partition information should ever be
visible on the target seeing that the device is exported.
As the initiator has exclusive access, the target has no business
looking at the contents; in fact, this might lead to unexpected
corruptions if things like udev jump in on the target side and try to
'correct' things with journal replay etc.

> But if kernel could/should jump in, we possibly could try to issue a
> revalidate_disk on target whenever this operation is performed on
> initiator side (and vice-versa). I confess I couldn't find such sync
> idea in NVMe over fabrics spec, though.
> Also, reading NVMe spec 1.3, we do have the optional feature
> "reservations", but seems it doesn't mention target (only multiple hosts).
> 
See above.
Never try this :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
