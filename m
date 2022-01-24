Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECACC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 13:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239985AbiAXNjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 08:39:47 -0500
Received: from verein.lst.de ([213.95.11.211]:55846 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbiAXNjq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 08:39:46 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0B02768BEB; Mon, 24 Jan 2022 14:39:43 +0100 (CET)
Date:   Mon, 24 Jan 2022 14:39:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 13/13] block: don't drain file system I/O on
 del_gendisk
Message-ID: <20220124133942.GB27997@lst.de>
References: <20220122111054.1126146-1-ming.lei@redhat.com> <20220122111054.1126146-14-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220122111054.1126146-14-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jan 22, 2022 at 07:10:54PM +0800, Ming Lei wrote:
> So not necessary to drain FS I/O in del_gendisk() any more.

But this changes a few other things as well.

For example the early set GD_DEAD flag is very useful to stop I/O
ASAP when entering del_gendisk.  Also some other work here is moved
later as well that really should be part of del_gendisk.
