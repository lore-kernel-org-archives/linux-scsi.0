Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C584C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbiAXNF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:05:59 -0500
Received: from verein.lst.de ([213.95.11.211]:55685 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242617AbiAXNF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:05:58 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4116668C4E; Mon, 24 Jan 2022 14:05:55 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:05:55 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <20220124130555.GD27269@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-6-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:46PM +0800, Ming Lei wrote:
> Passthrough request from userspace has one active block_device/disk
> associated, so they can be accounted via rq->q->disk. For other
> passthrough request, there may not be disk/block_device for the queue,
> since either the queue has not a disk or the disk may be deleted
> already.
> 
> Add flag of BLK_MQ_REQ_USER_IO for only accounting passthrough request
> from userspace.

Please explain why you want to change this.

Also this is missing I/O from /dev/sg, CDROM CDDA BPC reading, the tape
drivers and bsg-lib.
