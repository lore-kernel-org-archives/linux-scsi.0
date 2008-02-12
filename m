From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Subject: [PATCH 1/3] Let scsi_cmnd->cmnd use request->cmd
	buffer
Date: Tue, 12 Feb 2008 13:41:13 -0600
Message-ID: <1202845273.3137.123.camel@localhost.localdomain>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc>
	 <200802100006.11086.bzolnier@gmail.com>
	 <20080210052621.GA22257@infradead.org>
	 <200802101438.46698.bzolnier@gmail.com>
	 <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com>
	 <47AF4974.9010200@panasas.com>  <47AF4AED.8080104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47AF4AED.8080104@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-02-10 at 21:05 +0200, Boaz Harrosh wrote:
> - struct scsi_cmnd had a 16 bytes command buffer of its own.
>   This is an unnecessary duplication and copy of request's
>   cmd. It is probably left overs from the time that scsi_cmnd
>   could function without a request attached. So clean that up.
> 
> - Once above is done, few places, apart from scsi-ml, needed
>   adjustments due to changing the data type of scsi_cmnd->cmnd.
> 
> - Lots of drivers still use MAX_COMMAND_SIZE. So I have left
>   that #define but equate it to BLK_MAX_CDB. The way I see it
>   and is reflected in the patch below is.
>   MAX_COMMAND_SIZE - means: The longest fixed-length (*) SCSI CDB
>                      as per the SCSI standard and is not related
>                      to the implementation.
>   BLK_MAX_CDB.     - The allocated space at the request level
> 
> (*)fixed-length here means commands that their size can be determined
>    by their opcode and the CDB does not carry a length specifier, like
>    the VARIABLE_LENGTH_CMD(0x7f) command. This is actually not exactly
>    true and the SCSI standard also defines extended commands and
>    vendor specific commands that can be bigger than 16 bytes. The kernel
>    will support these using the same infrastructure used for VARLEN CDB's.
>    So in effect MAX_COMMAND_SIZE means the maximum size command
>    scsi-ml supports without specifying a cmd_len by ULD's

When we do this, what happens to the minority of drivers that need the
command in DMAable memory ... or have you audited them all and we can
now dump the DMA pool allocation for SCSI commands?

James


