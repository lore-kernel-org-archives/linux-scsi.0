From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Disable async aborts
Date: Tue, 28 Oct 2014 08:58:04 -0500
Message-ID: <544FA0EC.9030907@linux.vnet.ibm.com>
References: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com> <1414421403.6401.5.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46101 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbaJ1OB7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2014 10:01:59 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 28 Oct 2014 10:01:58 -0400
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 57A70C9006C
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2014 09:50:37 -0400 (EDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9SDtoYm28311702
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2014 14:55:50 +0100
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9SDw5BI029838
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2014 07:58:05 -0600
In-Reply-To: <1414421403.6401.5.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On 10/27/2014 09:50 AM, James Bottomley wrote:
> On Mon, 2014-10-27 at 09:37 -0500, Brian King wrote:
>> The ipr driver does not yet support async aborts, so disable this
>> for now.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> 
> By "does not yet support" do you mean doesn't work with or merely not
> tested with but seems to work OK?  if the former, then surely this
> should be a fixes patch with a cc to stable for all the kernels async
> abort is in (which is 3.14)

We were seeing some issues in our lab in abort paths with double completions.
This was the first change I made to help resolve this. Patch 2 is definitely
required and the first patch is more for sanity until we can do more abort
path regression testing. What I'd like to do is queue both of these patches
for fixes / stable, then run additional regression testing with async aborts
and re-enable it in a future kernel once I'm more comfortable with it.

If it simplifies things, I can resend the series and cc stable.

Thanks,

Brian


> 
> James
> 
>> ---
>>
>>  drivers/scsi/ipr.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff -puN drivers/scsi/ipr.c~ipr_no_async_eh drivers/scsi/ipr.c
>> --- linux/drivers/scsi/ipr.c~ipr_no_async_eh	2014-10-24 08:57:53.169169509 -0500
>> +++ linux-bjking1/drivers/scsi/ipr.c	2014-10-24 08:57:53.175169579 -0500
>> @@ -6357,6 +6357,7 @@ static struct scsi_host_template driver_
>>  	.sdev_attrs = ipr_dev_attrs,
>>  	.proc_name = IPR_NAME,
>>  	.no_write_same = 1,
>> +	.no_async_abort = 1,
>>  };
>>  
>>  /**
>> _
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


