From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libata: add TRIM support
Date: Tue, 17 Nov 2009 09:36:21 -0500
Message-ID: <20091117143621.GD588@infradead.org>
References: <20091116154343.GA6672@infradead.org> <4B0219CC.2060401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZKQOgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 09:36:17 -0500
Content-Disposition: inline
In-Reply-To: <4B0219CC.2060401@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>

On Mon, Nov 16, 2009 at 10:34:36PM -0500, Jeff Garzik wrote:
>
>
> Overall, OK.
>
> Needs minor revisions, including one bug fix (tf->device stomping).
>
>
>> +static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
>> +{
>> +	u32 min_io_sectors;
>> +
>> +	rbuf[1] = 0xb0;
>> +	rbuf[3] = 0x3c;		/* required VPD size with unmap support */
>> +
>> +	/*
>> +	 * Optimal transfer length granularity.
>> +	 *
>> +	 * This is always one physical block, but for disks with a smaller
>> +	 * logical than physical sector size we need to figure out what the
>> +	 * latter is.
>> +	 */
>> +	min_io_sectors = 1;
>> +	if ((args->id[106]&  0xc000) == 0x4000&&  (args->id[106]&  (1<<  13)))
>> +		min_io_sectors *= args->id[106]&  0xf;
>
> args->id[] access should be via ata_id_* functions from include/linux/ata.h.
>
> Create new ata_id_* as needed.
>
> Plus...  add some whitespace before all C operators, to be consistent  
> with the rest of libata.
>
>
>> +	buf = page_address(sg_page(scsi_sglist(scmd)));
>> +	size = ata_set_lba_range_entries(buf, 512 / 8, block, n_block);
>> +
>> +	tf->protocol = ATA_PROT_DMA;
>> +	tf->hob_feature = 0;
>> +	tf->feature = ATA_DSM_TRIM;
>> +	tf->hob_nsect = (size / 512)>>  8;
>
> needs whitespace before op

I wonder where this got corruped, my local copy doesn't have either
whitespace issue.  Let's hope mutt hasn't started to corrupt patches
lately.

