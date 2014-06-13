From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/2] ibmvscsi: Abort init sequence during error recovery
Date: Fri, 13 Jun 2014 11:17:00 -0500
Message-ID: <539B23FC.1080104@linux.vnet.ibm.com>
References: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com> <53849960.60505@linux.vnet.ibm.com> <539B190D.2040509@linux.vnet.ibm.com> <1402674597.2224.20.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46444 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbaFMQRG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 12:17:06 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 13 Jun 2014 12:17:05 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 54C2CC90042
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2014 12:16:56 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22035.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s5DGH2Qm5767576
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2014 16:17:02 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s5DGH1AE021381
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2014 12:17:01 -0400
In-Reply-To: <1402674597.2224.20.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On 06/13/2014 10:49 AM, James Bottomley wrote:
> On Fri, 2014-06-13 at 10:30 -0500, Brian King wrote:
>> On 05/27/2014 08:55 AM, Nathan Fontenot wrote:
>>> On 05/23/2014 10:52 AM, Brian King wrote:
>>>> If a CRQ reset is triggered for some reason while in the middle
>>>> of performing VSCSI adapter initialization, we don't want to
>>>> call the done function for the initialization MAD commands as
>>>> this will only result in two threads attempting initialization
>>>> at the same time, resulting in failures.
>>>>
>>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>>
>>> Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>>>
>>>> ---
>>>>
>>>>  drivers/scsi/ibmvscsi/ibmvscsi.c |    3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix drivers/scsi/ibmvscsi/ibmvscsi.c
>>>> --- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix	2014-05-23 10:36:04.000000000 -0500
>>>> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:50:03.000000000 -0500
>>>> @@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
>>>>  				       evt->hostdata->dev);
>>>>  			if (evt->cmnd_done)
>>>>  				evt->cmnd_done(evt->cmnd);
>>>> -		} else if (evt->done)
>>>> +		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
>>>> +			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
>>>>  			evt->done(evt);
>>>>  		free_event_struct(&evt->hostdata->pool, evt);
>>>>  		spin_lock_irqsave(hostdata->host->host_lock, flags);
>>>> _
>>
>> Hi James,
>>
>> Are these two patches in your queue? They both fix rather nasty issues
>> that have caused kernel crashes in our testing.
> 
> Should they be cc'd to stable, or are they recently introduced bugs?

They should probably go to stable as well as they've been around a while.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


