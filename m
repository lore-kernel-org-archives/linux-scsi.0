From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH v8 1/2 RESEND] Add bio/request flags to issue ZBC/ZAC
 commands
Date: Fri, 26 Aug 2016 11:31:46 +0900
Message-ID: <5b710eda-6445-f42a-72f0-4a1bf843d501@hgst.com>
References: <20160822042010.32416-2-shaun@tancheff.com>
 <20160824202409.30345-1-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160824202409.30345-1-shaun@tancheff.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, "David S . Miller" <davem@davemloft.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Ming Lei <ming.lei@canonical.com>, Mike Christie <michaelc@cs.wisc.edu>, Keith Busch <keith.busch@intel.com>, Mike Snitzer <snitzer@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Shaohua Li <shli@fb.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org


Shaun,

On 8/25/16 05:24, Shaun Tancheff wrote:
> (RESENDING to include f2fs, fs-devel and dm-devel)
>
> Add op flags to access to zone information as well as open, close
> and reset zones:
>   - REQ_OP_ZONE_REPORT - Query zone information (Report zones)
>   - REQ_OP_ZONE_OPEN - Explicitly open a zone for writing
>   - REQ_OP_ZONE_CLOSE - Explicitly close a zone
>   - REQ_OP_ZONE_FINISH - Explicitly finish a zone
>   - REQ_OP_ZONE_RESET - Reset Write Pointer to start of zone
>
> These op flags can be used to create bio's to control zoned devices
> through the block layer.

I still have a hard time seeing the need for the REQ_OP_ZONE_REPORT 
operation assuming that the device queue will hold a zone information 
cache, Hannes RB-tree or your array type, whichever.

Let's try to think simply here: if the disk user (and FS, a device 
mapper or an application doing raw disk accesses) wants to access the 
disk zone information, why would it need to issue a BIO when calling 
blkdev_lookup_zone would exactly give that information straight out of 
memory (so much faster) ? I thought hard about this, but cannot think of 
any value for the BIO-to-disk option. It seems to me to be equivalent to 
systematically doing a page cache read even if the page cache tells us 
that the page is up-to-date...

Moreover, issuing a report zone to the disk may return information that 
is in fact incorrect, as that would not take into account the eventual 
set of write requests that was dispatched but not yet processed by the 
disk (some zone write pointer may be reported with a value lower than 
what the zone cache maintains).

Dealing (and fixing) these inconsistencies would force an update of the 
report zone result using the information of the zone cache, which in 
itself sounds like a good justification of not doing a report zones in 
the first place.

I am fine with the other operations, and in fact having a BIO interface 
for them to send down to the SCSI layer is better than any other method. 
It will causes them to be seen in sd_init_command, which is the path 
taken for read and write commands too. So all zone cache information 
checking and updating can be done in that single place and serialized 
with a spinlock. Maintenance of the zone cache information becomes very 
easy.

Any divergence of the zone cache information with the actual state of 
the disk will likely cause an error (unaligned write or other). Having a 
specific report zone BIO option will not help the disk user recover from 
those. Hannes current implementation make sure that the information of 
the zone for the failed request is automatically updated. That is enough 
to maintain the zone cache information uptodate, and a zone information 
can be marked as "in update" for the user to notice and wait for the 
refreshed information.

The ioctl code for reporting zones does not need the specific request op 
code either. Again, blkdev_lookup_zone can provide zone information, and 
an emulation of the reporting options filtering is also trivial to 
implement on top of that, if really required (I do not think that is 
strongly needed though).

Without the report zone operation, your patch set size would 
significantly shrink and merging with Hannes work becomes very easy too.

Please let me know what you think. If we drop this, we can get a clean 
and full ZBC support patch set ready in no time at all.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.hgst.com
