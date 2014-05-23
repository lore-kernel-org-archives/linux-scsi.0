From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/2] ibmvscsi: Abort init sequence during error recovery
Date: Fri, 23 May 2014 11:33:07 -0500
Message-ID: <537F7843.5080005@linux.vnet.ibm.com>
References: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com> <537F7160.7080403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47140 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWQdO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2014 12:33:14 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 23 May 2014 10:33:13 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 012173E4004F
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 10:33:10 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4NGWFC310748258
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 18:32:15 +0200
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4NGX9fu005087
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 10:33:09 -0600
In-Reply-To: <537F7160.7080403@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, nfont@linux.vnet.ibm.com

On 05/23/2014 11:03 AM, Bart Van Assche wrote:
> On 05/23/14 17:52, Brian King wrote:
>> If a CRQ reset is triggered for some reason while in the middle
>> of performing VSCSI adapter initialization, we don't want to
>> call the done function for the initialization MAD commands as
>> this will only result in two threads attempting initialization
>> at the same time, resulting in failures.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/scsi/ibmvscsi/ibmvscsi.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix drivers/scsi/ibmvscsi/ibmvscsi.c
>> --- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix	2014-05-23 10:36:04.000000000 -0500
>> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:50:03.000000000 -0500
>> @@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
>>  				       evt->hostdata->dev);
>>  			if (evt->cmnd_done)
>>  				evt->cmnd_done(evt->cmnd);
>> -		} else if (evt->done)
>> +		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
>> +			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
>>  			evt->done(evt);
>>  		free_event_struct(&evt->hostdata->pool, evt);
>>  		spin_lock_irqsave(hostdata->host->host_lock, flags);
> 
> Hello Brian,
> 
> Does this mean that the SRP-over-CRQ protocol is still in use for
> communication between partitions ? Had you already noticed the "tgt
> infrastructure removal" patch series
> (http://thread.gmane.org/gmane.linux.scsi/90119) ? Feedback would be
> appreciated.

It is indeed still supported. I've sent a response on that other thread with
clarification.

-Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


