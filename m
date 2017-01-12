From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: RFC: 512e ZBC host-managed disks
Date: Thu, 12 Jan 2017 17:13:52 +0900
Message-ID: <38404478-7b9a-35ed-8148-81a05bd01ac8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Regular block devices are always accessible in units of logical block
sizes, regardless of the actual physical block size that the device has.
For hard disks, the common cases are:

512n: 512 B logical and physical blocks
512e: 512B logical blocks and 4096B physical blocks
4Kn: 4096B logical and physical blocks

and the sd.c in the kernel checks requests 512B "sectors" position and
size alignment against the disk declared logical block size. All is fine
with this, nothing new.

However, for host-managed zoned block devices (ZBC), the 512e case
breaks this model: the standard allows for 512B logical block reads,
*but* writes MUST be aligned on 4KB boundaries within sequential zones
(still using the 512B logical block size addressing). This is a problem
for users of the disk, e.g. an FS, who may wrongly believe that writing
512B units is possible (and so that it can use 512B FS block size).
Host-aware devices do not have this restriction. Nor does the
restriction apply to writes in conventional zones of host-managed devices.

Summary: for HM 512e block devices, reads are 512e compliant, but writes
in sequential zones are 4Kn compliant.

I would like an opinion on if we should do something about this. I see
the following possible options:

(1) Do nothing and let the disk user deal with the write alignment
problem. It already has to do so anyway as writes must be sequential.
But this would force in-kernel users to go and look at the device
physical block size, which is not something usually done by layers above
the block layer (FS, device mappers etc).

(2) For 512e host-managed devices, always report to the block layer
(device queue) a larger logical block size of 4096B to allow for disk
users to seamlessly adjust to the disk type without having to deal with
the physical sector size. I do not think that this would actually not
require changing the scsi_disk->sector_size field to that incorrect
value so that command addressing does not break. But I wonder if this
may not break a lot of things because of the difference introduced.

(3) Any other idea ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
