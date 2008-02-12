From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Subject: [PATCH 1/3] Let scsi_cmnd->cmnd use request->cmd	buffer
Date: Tue, 12 Feb 2008 20:10:51 +0200
Message-ID: <47B1E12B.6060900@panasas.com>
References: <20080209193224.GA21448@Chamillionaire.breakpoint.cc> <200802100006.11086.bzolnier@gmail.com> <20080210052621.GA22257@infradead.org> <200802101438.46698.bzolnier@gmail.com> <20080210144352.GA3537@infradead.org> <47AF1321.7000107@panasas.com> <47AF4974.9010200@panasas.com> <47AF4AED.8080104@panasas.com> <20080212174522.GA26316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30367 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764306AbYBLSNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 13:13:23 -0500
In-Reply-To: <20080212174522.GA26316@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Sebastian Siewior <ide+bug@ml.breakpoint.cc>, Tejun Heo <htejun@gmail.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Feb 12 2008 at 19:45 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Feb 10, 2008 at 09:05:17PM +0200, Boaz Harrosh wrote:
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
> A comment like this should be near the declaration of MAX_COMMAND_SIZE
> 
>> +#define MAX_COMMAND_SIZE 16
>> +#if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
>> +#	error MAX_COMMAND_SIZE can not be smaller than BLK_MAX_CDB
>> +#endif
> 
> No tabs between the # and the rest of the cpp command, please.  Either
> nothing or a single space as indentation instead.
> 
> Except for those two small nitpicks this looks very good to me.  Nice
> memory saving aswel.
Agree with both comments. Thanks for the review, will fix in the next
submission.

Boaz
