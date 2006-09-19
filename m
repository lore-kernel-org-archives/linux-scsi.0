From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] sg: SG_IO 64k page fix
Date: Tue, 19 Sep 2006 10:47:38 -0500
Message-ID: <4510111A.6040706@us.ibm.com>
References: <200609191445.k8JEjZv0030677@d01av03.pok.ibm.com> <45100E21.3070604@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:15244 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964989AbWISPrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 11:47:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8JFle3C005612
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 11:47:40 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8JFledc241408
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 11:47:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8JFldGJ006682
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 11:47:40 -0400
In-Reply-To: <45100E21.3070604@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Brian King wrote:
>> The problem appears to be in the definition of SG_SCATTER_SZ. The comment
>> states that it must be a power of 2, must be less than PAGE_SIZE * 32,
>> and must be at least as large as PAGE_SIZE. For 64k pages, this is not
>> true. Increasing SG_SCATTER_SZ to 64k fixed the oops in my configuration.
>>
>> Signed-off-by: Brian King <brking@us.ibm.com>
>> ---
>>
>>  linux-2.6-bjking1/include/scsi/sg.h |    2 +-
>>  1 files changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -puN include/scsi/sg.h~sg_large_page_support include/scsi/sg.h
>> --- linux-2.6/include/scsi/sg.h~sg_large_page_support	2006-09-19 09:24:06.000000000 -0500
>> +++ linux-2.6-bjking1/include/scsi/sg.h	2006-09-19 09:27:00.000000000 -0500
>> @@ -238,7 +238,7 @@ typedef struct sg_req_info { /* used by 
>>  #define SG_GET_ACCESS_COUNT 0x2289  
>>  
>>  
>> -#define SG_SCATTER_SZ (8 * 4096)  /* PAGE_SIZE not available to user */
>> +#define SG_SCATTER_SZ (16 * 4096)  /* PAGE_SIZE not available to user */
>>  /* Largest size (in bytes) a single scatter-gather list element can have.
>>     The value must be a power of 2 and <= (PAGE_SIZE * 32) [131072 bytes on
>>     i386]. The minimum value is PAGE_SIZE. If scatter-gather not supported
>> _
> 
> Brian,
> Yes that obviously needs to be fixed. However the patch
> is a bit fragile, for example if some architecture decides
> to have an option for 128 KB page size or larger.

I agree. 

> I've got a patch to add a sysfs/boottime attribute for
> setting max_scatter_elem_sz. If that logic made an additional
> check, adjusting max_scatter_elem_sz up to PAGE_SIZE if
> necessary. The SG_SCATTER_SZ define could stay as is,
> apart from an additional note that it will be forced to
> PAGE_SIZE if necessary.

You forgot to attach the patch ;) Is this something you plan
to be submitting soon?

Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
