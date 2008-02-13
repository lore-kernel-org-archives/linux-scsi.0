From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Subject: [PATCH 1/3] Let scsi_cmnd->cmnd use request->cmd	buffer
Date: Wed, 13 Feb 2008 11:24:16 +0200
Message-ID: <47B2B740.1070105@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc>	 <200802100006.11086.bzolnier@gmail.com>	 <20080210052621.GA22257@infradead.org>	 <200802101438.46698.bzolnier@gmail.com>	 <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com>	 <47AF4974.9010200@panasas.com>  <47AF4AED.8080104@panasas.com> <1202845273.3137.123.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9499 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932416AbYBMJ07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 04:26:59 -0500
In-Reply-To: <1202845273.3137.123.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 12 2008 at 21:41 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-02-10 at 21:05 +0200, Boaz Harrosh wrote:
>> - struct scsi_cmnd had a 16 bytes command buffer of its own.
>>   This is an unnecessary duplication and copy of request's
>>   cmd. It is probably left overs from the time that scsi_cmnd
>>   could function without a request attached. So clean that up.
>>
>> - Once above is done, few places, apart from scsi-ml, needed
>>   adjustments due to changing the data type of scsi_cmnd->cmnd.
>>
>> - Lots of drivers still use MAX_COMMAND_SIZE. So I have left
>>   that #define but equate it to BLK_MAX_CDB. The way I see it
>>   and is reflected in the patch below is.
>>   MAX_COMMAND_SIZE - means: The longest fixed-length (*) SCSI CDB
>>                      as per the SCSI standard and is not related
>>                      to the implementation.
>>   BLK_MAX_CDB.     - The allocated space at the request level
>>
>> (*)fixed-length here means commands that their size can be determined
>>    by their opcode and the CDB does not carry a length specifier, like
>>    the VARIABLE_LENGTH_CMD(0x7f) command. This is actually not exactly
>>    true and the SCSI standard also defines extended commands and
>>    vendor specific commands that can be bigger than 16 bytes. The kernel
>>    will support these using the same infrastructure used for VARLEN CDB's.
>>    So in effect MAX_COMMAND_SIZE means the maximum size command
>>    scsi-ml supports without specifying a cmd_len by ULD's
> 
> When we do this, what happens to the minority of drivers that need the
> command in DMAable memory ... or have you audited them all and we can
> now dump the DMA pool allocation for SCSI commands?
> 
> James
> 
> 

Am I right in assuming that I only need to audited the drivers that
have .unchecked_isa_dma set? I will redo this audit again, and report
back.

Boaz
