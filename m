From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: add TRIM support
Date: Mon, 16 Nov 2009 22:34:36 -0500
Message-ID: <4B0219CC.2060401@pobox.com>
References: <20091116154343.GA6672@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091116154343.GA6672@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org



Overall, OK.

Needs minor revisions, including one bug fix (tf->device stomping).


> +static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
> +{
> +	u32 min_io_sectors;
> +
> +	rbuf[1] = 0xb0;
> +	rbuf[3] = 0x3c;		/* required VPD size with unmap support */
> +
> +	/*
> +	 * Optimal transfer length granularity.
> +	 *
> +	 * This is always one physical block, but for disks with a smaller
> +	 * logical than physical sector size we need to figure out what the
> +	 * latter is.
> +	 */
> +	min_io_sectors = 1;
> +	if ((args->id[106]&  0xc000) == 0x4000&&  (args->id[106]&  (1<<  13)))
> +		min_io_sectors *= args->id[106]&  0xf;

args->id[] access should be via ata_id_* functions from include/linux/ata.h.

Create new ata_id_* as needed.

Plus...  add some whitespace before all C operators, to be consistent 
with the rest of libata.


> +	buf = page_address(sg_page(scsi_sglist(scmd)));
> +	size = ata_set_lba_range_entries(buf, 512 / 8, block, n_block);
> +
> +	tf->protocol = ATA_PROT_DMA;
> +	tf->hob_feature = 0;
> +	tf->feature = ATA_DSM_TRIM;
> +	tf->hob_nsect = (size / 512)>>  8;

needs whitespace before op


> +	tf->nsect = size / 512;
> +	tf->hob_lbal = 0;
> +	tf->lbal = 0;
> +	tf->hob_lbam = 0;
> +	tf->lbam = 0;
> +	tf->hob_lbah = 0;
> +	tf->lbah = 0;

taskfile is pre-zeroed for you (ata_scsi_qc_new -> ata_qc_new_init -> 
ata_qc_reinit -> ata_tf_init), so zap all those zeroing lines.


> +	tf->device = ATA_LBA;

__do not__ overwrite tf->device value.  It is already assigned a useful 
value, which you just stomped.


> +	tf->device = dev->devno ?
> +		tf->device | ATA_DEV1 : tf->device&  ~ATA_DEV1;

delete this; already done in ata_tf_init()


> +	qc->sect_size = ATA_SECT_SIZE;

delete this; already done in ata_qc_reinit()

