From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Mon, 21 Aug 2017 17:33:51 +0200
Message-ID: <20170821153351.GB20205@lst.de>
References: <20170817024550.9845-1-damien.lemoal@wdc.com> <20170817075916.GA28379@infradead.org> <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com> <1502982108.2615.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34426 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754186AbdHUPdx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Aug 2017 11:33:53 -0400
Content-Disposition: inline
In-Reply-To: <1502982108.2615.1.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, Aug 17, 2017 at 03:01:51PM +0000, Bart Van Assche wrote:
> Another possible approach is to fix the ipr driver and to resubmit the
> "scsi-mq: Always unprepare before requeuing a request" and "scsi: sd_zbc:
> Write unlock zone from sd_uninit_cmnd()" patches.

We should absolutely take that broader approach.

But it seems like we need to refne the always unprepare patch first,
to make sure we only release resources, but don't clear the
scmd->retries field.  The NVMe driver already works that way, so
we have an example to follow.
