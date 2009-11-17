From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libata: add TRIM support
Date: Tue, 17 Nov 2009 09:32:50 -0500
Message-ID: <20091117143249.GB588@infradead.org>
References: <20091116154343.GA6672@infradead.org> <4B0219CC.2060401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B0219CC.2060401@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2009 at 10:34:36PM -0500, Jeff Garzik wrote:
> args->id[] access should be via ata_id_* functions from include/linux/ata.h.
>
> Create new ata_id_* as needed.

Fixed.

>> +	tf->lbam = 0;
>> +	tf->hob_lbah = 0;
>> +	tf->lbah = 0;
>
> taskfile is pre-zeroed for you (ata_scsi_qc_new -> ata_qc_new_init ->  
> ata_qc_reinit -> ata_tf_init), so zap all those zeroing lines.

Thanks, tried to figure out if it was but after going a few levels deep
I gave up.

>> +	tf->device = ATA_LBA;
>
> __do not__ overwrite tf->device value.  It is already assigned a useful  
> value, which you just stomped.
>
>
>> +	tf->device = dev->devno ?
>> +		tf->device | ATA_DEV1 : tf->device&  ~ATA_DEV1;
>
> delete this; already done in ata_tf_init()
>
>
>> +	qc->sect_size = ATA_SECT_SIZE;
>
> delete this; already done in ata_qc_reinit()

All this is copy and paste from ata_scsi_pass_thru, but I'll happily fix
it up.

