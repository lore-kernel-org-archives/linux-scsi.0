From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Tue, 11 Aug 2009 18:18:20 +0300
Message-ID: <4A818BBC.8090705@panasas.com>
References: <Pine.LNX.4.44L0.0908111048570.2562-100000@iolanthe.rowland.org> <1250003601.4301.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:14961
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755289AbZHKPSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2009 11:18:23 -0400
In-Reply-To: <1250003601.4301.29.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/11/2009 06:13 PM, James Bottomley wrote:
> On Tue, 2009-08-11 at 10:53 -0400, Alan Stern wrote:
>> On Tue, 11 Aug 2009, Boaz Harrosh wrote:
>>
>>> This is certainly a bug. Otherwise I would get all my pages 4 bytes short
>>> and wonder why.
>>>
>>> I wish the bug would explain that stupid USB device Martin was fixing.
>>> "I die if evpd page=0 is read" is a very brain dead thing. But there
>>> is no overflow in current code, only underflow.
>>>
>>> If you are at it could you please fix all the bugs in this code: ;-)
>>
>> The USB problem shouldn't affect anything thanks to Martin's other
>> changes (sd won't read VPD for devices with scsi_level <= SCSI_2).  So
>> how does this revised patch look?
>>
>> Alan Stern
>>
>>
>> Index: usb-2.6/drivers/scsi/scsi.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/scsi/scsi.c
>> +++ usb-2.6/drivers/scsi/scsi.c
>> @@ -969,7 +969,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
>>   * @sdev: The device to ask
>>   * @buffer: Where to put the result
>>   * @page: Which Vital Product Data to return
>> - * @len: The length of the buffer
>> + * @len: The length of the data (= buffer length - 4)
> 
> Really, no.  The former is the correct (and universally used
> definition).  This one you propose is asking for confusion and misuse.
> 

This is what is done today Only documented

If you want to fix it to be the full buffer size the user code
should be fixed

>>   *
>>   * This is an internal helper function.  You probably want to use
>>   * scsi_get_vpd_page instead.
>> @@ -980,7 +980,10 @@ static int scsi_vpd_inquiry(struct scsi_
>>  							u8 page, unsigned len)
>>  {
>>  	int result;
>> -	unsigned char cmd[16];
>> +	int resid;
>> +	unsigned char cmd[6];
>> +
>> +	len += 4;		/* Include room for the header bytes */
>>  
>>  	cmd[0] = INQUIRY;
>>  	cmd[1] = 1;		/* EVPD */
>> @@ -989,17 +992,19 @@ static int scsi_vpd_inquiry(struct scsi_
>>  	cmd[4] = len & 0xff;
>>  	cmd[5] = 0;		/* Control byte */
>>  
>> +	buffer[1] = ~page;
> 
> This is pointless and dangerous:  Some architectures will invalidate
> caches for DMA not flush them, so it might not do what you think it
> does.
> 

Then you can't do that "after check" either. It's a simple minefield.
What do you suggest?

> James
> 
> 

Boaz
