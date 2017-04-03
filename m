From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: scsi-mq - tag# and can_queue, performance.
Date: Mon, 3 Apr 2017 15:20:49 +0000
Message-ID: <1491232832.2661.1.camel@sandisk.com>
References: <alpine.LRH.2.00.1704022326190.727@mvluser05.qlc.com>
         <3fd1ca57-3b0a-9405-0ec8-3be15ba33caf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:30981 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753341AbdDCPVI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 11:21:08 -0400
In-Reply-To: <3fd1ca57-3b0a-9405-0ec8-3be15ba33caf@suse.de>
Content-Language: en-US
Content-ID: <B6806DF6C14B5848860E9F19E87CCE69@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "arun.easi@cavium.com" <arun.easi@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>

On Mon, 2017-04-03 at 09:29 +0200, Hannes Reinecke wrote:
> On 04/03/2017 08:37 AM, Arun Easi wrote:
> > If the above is true, then for a LLD to get tag# within it's max-tasks=
=20
> > range, it has to report max-tasks / number-of-hw-queues in can_queue, a=
nd=20
> > in the I/O path, use the tag and hwq# to arrive at a index# to use. Thi=
s,=20
> > though, leads to a poor use of tag resources -- queue reaching it's=20
> > capacity while LLD can still take it.
>
> Shared tag sets continue to dog the block-mq on 'legacy' (ie non-NVMe)
> HBAs. ATM the only 'real' solution to this problem is indeed have a
> static split of the entire tag space by the number of hardware queues.
> With the mentioned tag-starvation problem.

Hello Arun and Hannes,

Apparently the current blk_mq_alloc_tag_set() implementation is well suited
for drivers like NVMe and ib_srp but not for traditional SCSI HBA drivers.
How about adding a BLK_MQ_F_* flag that tells __blk_mq_alloc_rq_maps() to
allocate a single set of tags for all hardware queues and also to add a fla=
g
to=A0struct scsi_host_template such that SCSI LLDs can enable this behavior=
?

Bart.=
