From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 0/3] Separate zone requests from medium access requests
Date: Tue, 28 Feb 2017 16:16:46 +0000
Message-ID: <1488298588.2370.1.camel@sandisk.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
         <20170228160259.GA22755@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:35154 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdB1QpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 11:45:18 -0500
In-Reply-To: <20170228160259.GA22755@lst.de>
Content-Language: en-US
Content-ID: <2D5DCAF7E905BC4F8AB20C4D09ED5C91@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On Tue, 2017-02-28 at 17:02 +0100, Christoph Hellwig wrote:
> I don't really like this too much - this is too many SCSI specifics
> for the block layer to care.  Maybe using bios for the zone ops was a
> mistake after all, and we should just have operations in struct block_dev=
ice
> instead..

blk_rq_accesses_medium() has nothing to do with SCSI. It is a reintroductio=
n
of what REQ_TYPE_FS stood for before ZBC was introduced but with another na=
me.
BTW, I think that all blk_rq_is_passthrough() callers have to be reviewed t=
o
see whether or not !blk_rq_accesses_medium() is perhaps what was intended.

Bart.=
