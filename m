From: <Stuart_Hayes@Dell.com>
Subject: RE: ide-scsi oops with ide tape drive
Date: Wed, 9 Mar 2005 10:14:19 -0600
Message-ID: <7A8F92187EF7A249BF847F1BF4903C04010EE99B@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:45152 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S262067AbVCIQOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2005 11:14:24 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org, Joshua_Giles@Dell.com

Jens Axboe wrote:
> On Tue, Mar 08 2005, Stuart_Hayes@Dell.com wrote:
>> 
>> Hello!
>> 
>> We're seeing a null pointer dereference with certain IDE tape drives
>> on 
>> 2.6.11 when we use it with ide-scsi (i686 architecture).  The
>> problem is that the scatter-gather pages aren't mapped to kernel
>> virtual address space in
>> idescsi_output_buffers()/idescsi_input_buffers(), so, if these pages
>> are in high memory, page_address() returns a null pointer. 
>> 
>> This patch fixes the problem.  I'll attach it as a file, too, just in
>> case it gets mangled.  Please let me know if there are any problems
>> with or questions regarding this patch.
>> 
>> Again, this patch is against 2.6.11.
>> 
>> Thanks!
>> Stuart Hayes
>> stuart_hayes@dell.com
>> 
>> 
>> 
>> --- ide-scsi.c.orig	2005-03-08 13:44:38.000000000 -0500
>> +++ ide-scsi.c	2005-03-08 14:02:43.000000000 -0500
>> @@ -151,8 +151,9 @@ static void idescsi_input_buffers (ide_d 
>>  		return; }
>>  		count = min(pc->sg->length - pc->b_count, bcount);
>> -		buf = page_address(pc->sg->page) + pc->sg->offset;
>> +		buf = kmap_atomic(pc->sg->page, KM_USER0) +
>> pc->sg->offset;
>>  		drive->hwif->atapi_input_bytes(drive, buf + pc->b_count,
>> count);
>> +		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
>>  		bcount -= count; pc->b_count += count;
>>  		if (pc->b_count == pc->sg->length) {
>>  			pc->sg++;
> 
> You need a local_irq_save(flags); ... local_irq_restore(flags); around
> the kmap(atomic), transfer, and kunmap_atomic() for this to be safe.
> Interrupts may not be disabled at this point, depends on drive
> settings. 
> 

Thanks for the quick response!  I'll look into this more carefully.
--Stuart

>> @@ -173,8 +174,9 @@ static void idescsi_output_buffers (ide_ 
>>  		return; }
>>  		count = min(pc->sg->length - pc->b_count, bcount);
>> -		buf = page_address(pc->sg->page) + pc->sg->offset;
>> +		buf = kmap_atomic(pc->sg->page, KM_USER0) +
>> pc->sg->offset;
>>  		drive->hwif->atapi_output_bytes(drive, buf +
>> pc->b_count, count);
>> +		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
>>  		bcount -= count; pc->b_count += count;
>>  		if (pc->b_count == pc->sg->length) {
>>  			pc->sg++;
> 
> Ditto.

