From: Damien Le Moal <Damien.LeMoal@hgst.com>
Subject: Re: [PATCH 1/3] block: add flag for single-threaded submission
Date: Thu, 21 Jul 2016 07:10:10 +0000
Message-ID: <BAF33352-8318-4F44-B8F5-3FA7F41DDCC1@hgst.com>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
 <1468936978-9124-2-git-send-email-hare@suse.de>
 <20160721055431.GB14568@infradead.org>
 <2cef3971-54cc-73d6-dbff-acd1379d19d5@suse.de>
 <0030fdc3-bd7d-2e91-56ae-c20086a55d22@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <0030fdc3-bd7d-2e91-56ae-c20086a55d22@suse.de>
Content-Language: en-US
Content-ID: <C326BAFFDCF5114F865F0E7E71FD7157@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, "dm-devel-redhat.com@suse.de" <dm-devel-redhat.com@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

Hannes,

> On Jul 21, 2016, at 15:37, Hannes Reinecke <hare@suse.de> wrote:
> 
> On 07/21/2016 08:01 AM, Hannes Reinecke wrote:
>> On 07/21/2016 07:54 AM, Christoph Hellwig wrote:
>>> On Tue, Jul 19, 2016 at 04:02:56PM +0200, Hannes Reinecke wrote:
>>>> Some devices (most notably SMR drives) support only
>>>> one I/O stream eg for ensuring ordered I/O submission.
>>>> This patch adds a new block queue flag
>>>> 'BLK_QUEUE_SINGLE' to support these devices.
>>> 
>>> We'll need a blk-mq implementation of this flag as well before it can
>>> be merged.
>>> 
>> Yes, indeed. Will be fixed for the next round of submissions.
>> 
> Hmm.
> Looking closer do I _really_ need that for blk-mq?
> From my understanding any hctx can only run on one dedicated cpu, to
> which the hctx is bound.
> So if we only have one CPU serving that hctx how can we have several
> concurrent calls to queue_rq() here?

Ex: an application with 2 threads running on different CPUs, with both
threads writing to the same sequential zone with a proper mutual exclusion
to ensure sequential write order at the application level.

For this example, each thread requests will end up in a different hw queue
(hctx), and a single CPU serving each hctx may not result in an overall
in-order delivery to the disk.

So we need to ensure that all requests for a sequential zone end up in the
same hctx, which I think means simply that we need to allow only a single
queue for a ZBC device. If one day we get a fast SSD supporting ZBC/ZAC
commands, this may impact performance though...

I may be completely wrong about this though.

Cheers.

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

