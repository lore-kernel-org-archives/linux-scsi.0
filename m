From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: add TRIM support
Date: Tue, 17 Nov 2009 16:59:38 -0500
Message-ID: <4B031CCA.1080409@pobox.com>
References: <20091116154343.GA6672@infradead.org> <4B0219CC.2060401@pobox.com> <20091117143249.GB588@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55624 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZKQV7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 16:59:43 -0500
In-Reply-To: <20091117143249.GB588@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>

On 11/17/2009 09:32 AM, Christoph Hellwig wrote:
> On Mon, Nov 16, 2009 at 10:34:36PM -0500, Jeff Garzik wrote:
>> args->id[] access should be via ata_id_* functions from include/linux/ata.h.
>>
>> Create new ata_id_* as needed.
>
> Fixed.
>
>>> +	tf->lbam = 0;
>>> +	tf->hob_lbah = 0;
>>> +	tf->lbah = 0;
>>
>> taskfile is pre-zeroed for you (ata_scsi_qc_new ->  ata_qc_new_init ->
>> ata_qc_reinit ->  ata_tf_init), so zap all those zeroing lines.
>
> Thanks, tried to figure out if it was but after going a few levels deep
> I gave up.

Understandable ;-)


>>> +	tf->device = ATA_LBA;
>>
>> __do not__ overwrite tf->device value.  It is already assigned a useful
>> value, which you just stomped.
>>
>>
>>> +	tf->device = dev->devno ?
>>> +		tf->device | ATA_DEV1 : tf->device&   ~ATA_DEV1;
>>
>> delete this; already done in ata_tf_init()
>>
>>
>>> +	qc->sect_size = ATA_SECT_SIZE;
>>
>> delete this; already done in ata_qc_reinit()
>
> All this is copy and paste from ata_scsi_pass_thru, but I'll happily fix
> it up.

Thanks.

ata_scsi_pass_thru() isn't the best model, since it assumes some 
registers -- notably Device -- are accurately filled in by userland. 
That is the purpose of the pass-through "command," after all.

Pretty much all other sources use the tf->device provided by 
ata_tf_init(), OR'd as appropriate with additional bits.

	Jeff


