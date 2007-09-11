From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH ver2 2/5] scsi_error: Refactoring scsi_error to facilitate
 in synchronous REQUEST_SENSE
Date: Tue, 11 Sep 2007 11:00:31 +0300
Message-ID: <46E64B1F.9040306@panasas.com>
References: <46E59760.9020705@panasas.com> <46E59C7D.4040701@panasas.com> <20070910211549.GA14439@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26285 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723AbXIKIBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 04:01:15 -0400
In-Reply-To: <20070910211549.GA14439@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Tue, Sep 11 2007 at 0:15 +0300, Matthew Dharm <mdharm-scsi@one-eyed-alien.net> wrote:
> On Mon, Sep 10, 2007 at 10:35:25PM +0300, Boaz Harrosh wrote:
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 20a72aa..a02400c 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -590,42 +590,23 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>>  }
>>  
>>  /**
>> - * scsi_send_eh_cmnd  - submit a scsi command as part of error recory
>> + * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recory
>>   * @scmd:       SCSI command structure to hijack
>> - * @cmnd:       CDB to send
>> + * @ses:        structure to save restore information
>> + * @cmnd:       CDB to send. Can be NULL if no new cmnd is needed
>>   * @cmnd_size:  size in bytes of @cmnd
>> - * @timeout:    timeout for this request
>> - * @copy_sense: request sense data if set to 1
>> + * @copy_sense: size of sense data to copy. or 0
>>   *
>> - * This function is used to send a scsi command down to a target device
>> - * as part of the error recovery process.  If @copy_sense is 0 the command
>> - * sent must be one that does not transfer any data.  If @copy_sense is 1
>> - * the command must be REQUEST_SENSE and this functions copies out the
>> - * sense buffer it got into @scmd->sense_buffer.
>> - *
>> - * Return value:
>> - *    SUCCESS or FAILED or NEEDS_RETRY
>> + * This function is used to save a scsi command information before re-execution
>> + * as part of an error recovery process.  If @copy_sense is 0 the command
>> + * given must be one that does not transfer any data.  If @copy_sense != 0
>> + * the command should be NULL and this functions sets up the cmnd and
>> + * command buffers to be read into @scmd->sense_buffer.
>>   **/
>> -static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>> -			     int cmnd_size, int timeout, unsigned copy_sense)
>> +void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
>> +			unsigned char *cmnd, int cmnd_size, unsigned copy_sense)
> 
> I'm not terribly keen on the naming of copy_sense, tho I see what you're
> trying to do.  A better name and better comments about what it means when
> != 0 would fix this.
> 
> Matt
> 
When you're right you're right. This is what happens when you try to
write comprehensible comments at 22:45 ;)

I will send first two patches as replays to the original patches

Thanks
