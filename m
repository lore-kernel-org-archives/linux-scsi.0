Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B782C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB3561058
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhKCSW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:22:59 -0400
Received: from verein.lst.de ([213.95.11.211]:60744 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhKCSW4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Nov 2021 14:22:56 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1D09F68AA6; Wed,  3 Nov 2021 19:20:17 +0100 (CET)
Date:   Wed, 3 Nov 2021 19:20:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] ataflop: address add_disk() error handling on
 probe
Message-ID: <20211103182016.GB7745@lst.de>
References: <20211103181258.1462704-1-mcgrof@kernel.org> <20211103181258.1462704-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103181258.1462704-3-mcgrof@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 11:12:56AM -0700, Luis Chamberlain wrote:
> We need to cleanup resources on the probe() callback registered
> with __register_blkdev(), now that add_disk() error handling is
> supported. Address this.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/block/ataflop.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
> index 170dd193cef6..e981b351f37e 100644
> --- a/drivers/block/ataflop.c
> +++ b/drivers/block/ataflop.c
> @@ -2012,6 +2012,7 @@ static void ataflop_probe(dev_t dev)
>  {
>  	int drive = MINOR(dev) & 3;
>  	int type  = MINOR(dev) >> 2;
> +	int err = 0;
>  
>  	if (type)
>  		type--;
> @@ -2019,11 +2020,20 @@ static void ataflop_probe(dev_t dev)
>  	if (drive >= FD_MAX_UNITS || type >= NUM_DISK_MINORS)
>  		return;
>  	if (!unit[drive].disk[type]) {
> +		err = ataflop_alloc_disk(drive, type);
> +		if (err == 0) {
> +			err = add_disk(unit[drive].disk[type]);
> +			if (err)
> +				goto err_out;
> +			else
> +				unit[drive].registered[type] = true;

This looks weird.  Why not:

 	if (unit[drive].disk[type])
		return;

	if (ataflop_alloc_disk(drive, type))
		return;
	if (add_disk(unit[drive].disk[type]))
		goto cleanup_disk;
	unit[drive].registered[type] = true;
	return;

cleanup_disk:
	blk_cleanup_disk(unit[drive].disk[type]);
	unit[drive].disk[type] = NULL;
