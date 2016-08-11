From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] libata-core: do not set dev->max_sectors for LBA48 devices
Date: Wed, 10 Aug 2016 23:37:25 -0400
Message-ID: <yq1twesq8lm.fsf@sermon.lab.mkp.net>
References: <5eceeb9ad825beb87db03b0989f746dfbe0cf3fe.1470753817.git.tom.ty89@gmail.com>
	<10c4d38005e24bb477b5182d4fc17879139f14d9.1470753817.git.tom.ty89@gmail.com>
	<20160810041042.GH25053@mtj.duckdns.org>
	<CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGnHSE=z78AjDC13XKk_WnkQcjFHWGcatciwoJJYW-97a0qWjQ@mail.gmail.com>
	(Tom Yan's message of "Wed, 10 Aug 2016 16:32:39 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, jmoyer@redhat.com, axboe@fb.com, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom,

Tom> Now let's just come back to libata. I've thought of reporting dev->
Tom> max_sectors as Optimal Transfer Length in the SATL. However, I am
Tom> not sure if it is a safe thing to do, because we set it as high as
Tom> 65535 for devices with LBA48 devices. Does such a high max_sectors
Tom> ever make sense in libata's case?

I don't agree with conflating the optimal transfer size and the maximum
supported ditto. Submitting the largest possible I/O to a device does
not guarantee that you get the best overall performance.

 - max_hw_sectors is gated by controller DMA constraints.

 - max_dev_sectors is set for devices that explicitly report a transfer
   length limit.

 - max_sectors, the soft limit for filesystem read/write requests,
   should be left at BLK_DEF_MAX_SECTORS unless the device explicitly
   requests transfers to be aligned multiples of a different value
   (typically the internal stripe size in large arrays).

The point of BLK_DEF_MAX_SECTORS is to offer a reasonable default for
common workloads unless otherwise instructed by the storage device.

We can have a discussion about what the right value for
BLK_DEF_MAX_SECTORS should be. It has gone up over time but it used to
be the case that permitting large transfers significantly impacted
interactive I/O performance. And finding a sweet spot that works for a
wide variety of hardware, interconnects and workloads is obviously
non-trivial.

-- 
Martin K. Petersen	Oracle Linux Engineering
