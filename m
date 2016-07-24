From: Damien Le Moal <Damien.LeMoal@hgst.com>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Sun, 24 Jul 2016 23:16:47 +0000
Message-ID: <94DE32E6-4D08-44D6-B8CA-566FA1BDEBFB@hgst.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
 <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
 <13b63331-f920-0904-b8f7-c3a2ea8270d6@suse.de>
 <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
Content-Language: en-US
Content-ID: <64C63B485E2AEC48AD6D1E82ACB37DA9@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Bart,


> On Jul 24, 2016, at 22:37, Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> If there are 10K zones and since queue_zoned_show() is limited to one page then only a very small fraction of the zone information will be available through sysfs. I remember from your presentations that reading the zone information is slow. Is 10K zones a typical value or a worst case value?

Our 10 TB drive with 256 MB zones has 37256 zones. A drive with the same capacity
and 128 MB zones will double that (there are some out there with 128 MB zones).
And higher capacities are coming. So 100K+ zones is not unrealistic in the very
near future.

I think that what Hannes proposed, i.e. to have the zoned file only specify the
zone size (so only one value), is OK as long as we also add an ioctl to get the
detailed zone information, which would be much faster for applications than using
something like libzbc which will be sending SG_IOs to retrieve the zone information
from the disk.

Best regards.

------------------------
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com 
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

