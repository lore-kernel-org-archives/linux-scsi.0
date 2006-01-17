From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] sg: Remove aha1542 hack
Date: Tue, 17 Jan 2006 17:43:52 -0600
Message-ID: <43CD8138.3000308@us.ibm.com>
References: <200601172304.k0HN46YN013092@d01av04.pok.ibm.com> <43CD7F1E.8010908@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49026 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932279AbWAQXny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 18:43:54 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0HNhr3p030786
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 18:43:53 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0HNhslI068096
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 18:43:54 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k0HNhrQL030419
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 18:43:53 -0500
In-Reply-To: <43CD7F1E.8010908@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> brking@us.ibm.com wrote:
>> Remove a hack in the sg driver that alters the total buffer
>> length for SG_IO commands to ensure buffers are not odd byte
>> lengths. This breaks on the ipr driver since it requires the
>> request_bufflen to equal the length specified in the cdb.
>> The block layer SG_IO code does not appear to have this hack.
> 
> Brian,
> Yes, that is ok with me. The aha1542 may not be
> the only adapter sensitive to odd data transfer
> lengths. In the spirit of a pass through we can
> let the user round up to even if it is needed.
> 
> The _original_ block layer SG_IO code didn't have
> a "hack" called error processing either :-)
> 
> The ipr driver looking inside the cdb to determine
> data transfer length is a dangerous procedure. Does
> the ipr driver support vendor specific commands?
> Even the ubiquitous INQUIRY cdb is tricky since byte 3
> became the upper 8 bits of the allocation length in
> SPC-3 (it was reserved before that). So does the
> driver interpret it as active depending on the age
> of the lu?

Let me clarify... The ipr driver does not do any cdb
cracking to determine data transfer lengths. The virtual
scsi devices that get reported by the ipr adapter firmware
are the devices that are rather strict about allocation
lengths matching buffer lengths. For regular JBOD attached
disks via ipr, even the adapter firmware avoids cracking
cdbs. Its really only an issue for ipr's disk array devices
and the ipr firmware generated logical scsi device used
by userspace to send configuration commands to the ipr adapter.

Brian

> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>
> 
>> Signed-off-by: Brian King <brking@us.ibm.com>
>> ---
>>
>>  linux-2.6-bjking1/drivers/scsi/sg.c |    2 +-
>>  1 files changed, 1 insertion(+), 1 deletion(-)
>>
>> diff -puN drivers/scsi/sg.c~sg_remove_aha1542_hack drivers/scsi/sg.c
>> --- linux-2.6/drivers/scsi/sg.c~sg_remove_aha1542_hack	2006-01-17 16:50:16.000000000 -0600
>> +++ linux-2.6-bjking1/drivers/scsi/sg.c	2006-01-17 16:50:29.000000000 -0600
>> @@ -2162,7 +2162,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request 
>>  
>>  	srp->res_used = 1;
>>  	SCSI_LOG_TIMEOUT(4, printk("sg_link_reserve: size=%d\n", size));
>> -	rem = size = (size + 1) & (~1);	/* round to even for aha1542 */
>> +	rem = size;
>>  
>>  	for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
>>  		num = sg->length;
>> _
>>
> 
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
