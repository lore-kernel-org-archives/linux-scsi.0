From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: SG_IO problem on tape devices
Date: Tue, 03 Jun 2008 20:37:50 +0300
Message-ID: <4845816E.50104@panasas.com>
References: <1212479982.5079.58.camel@pcitfio23.cern.ch> <alpine.LSU.1.10.0806031937410.7948@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4643 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753666AbYFCRiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 13:38:19 -0400
In-Reply-To: <alpine.LSU.1.10.0806031937410.7948@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Arne Wiebalck <arne.wiebalck@cern.ch>, linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Tue, 3 Jun 2008, Arne Wiebalck wrote:
> 
>> Hi all,
>>
>> I got a problem using the SG_IO ioctl with our tape drives. 
>> In order to examine errors on our drives in more detail, I 
>> would like to make the sense bytes available to the 
>> application using the REQUEST_SENSE command.
>>
>> However, there's a discrepancy between the kernel output in
>> /var/log/messages and what I see using SG_IO within my 
>> application: while the kernel sees
>>
>> kernel: st0: Error with sense data: scsi1 : destination target 0, lun 0
>> kernel:         command = Space 01 00 0d d5 00
>> kernel: Info fld=0x1, Current st0: sense key Medium Error
>> kernel: Additional sense: Read retries exhausted
>> kernel: Raw sense data:0xf0 0x00 0x03 0x00 0x00 0x00 0x01 0x12 0x00 0x00
>> 0x00 0x00 0x11 0x01 0x00 0x00 0x00 0x00 0x37 0xf7 0x10 0x01 0x00 0x00
>> 0xf7 0x37
>>
>> (which is realistic) the ioctl reports something like
>>
>> 70 00 00 00 00 00 00 12  00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00  10 02
>>
>> (since the first bit is not set, the sense bytes are not even valid,
>> as far as I understand).
>>
>> So, could it be that the sense bytes are already cleared when I request
>> them? They cleared/set by the next SCSI cmd, I assume? But shouldn't
>> they be valid even then?
>>
> Yes, the standard says that the sense data after CHECK CONDITION shall be 
> preserved until it is transferred and cleared after that. This means that, 
> in this case, the st driver only sees the sense data. The subsequent 
> REQUEST SENSE commands receive the NO SENSE key, which is what you get.
> 
> The st driver should return more error information that fits into struct 
> mtget. The problem is what should be there? I don't have a clear idea what 
> kind of definition would be general enough for the future but not too 
> complicated. User input here is needed.
> 
> One of the ideas I have had has been to provide the sense data from the 
> latest command that provided it. This would be easy to implement and could 
> use a sysfs file. (But should this be a general SCSI feature and not a st 
> feature?)
> 

You might want to look into using bsg ULD, if it is at all possible for you,
as it has a facility to return the actual sense information of the executed
command, into a user supplied buffer. But that means redoing st in user mode.

($0.017)
Boaz

