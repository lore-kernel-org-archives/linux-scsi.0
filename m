From: Erez Zilber <erezz@Voltaire.COM>
Subject: Re: [PATCH 2/3] iscsi iser: increase max_sectors
Date: Mon, 12 May 2008 15:10:26 +0300
Message-ID: <482833B2.4000208@Voltaire.COM>
References: <20080212205252.GB13643@osc.edu> <20080212205420.GD13643@osc.edu> <481F48A4.3060701@cs.wisc.edu> <20080507155308.GE9975@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:19447 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbYELMJa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 08:09:30 -0400
In-Reply-To: <20080507155308.GE9975@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>, Roland Dreier <rolandd@cisco.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Eli Dorfman <elid@voltaire.com>

Pete Wyckoff wrote:
> michaelc@cs.wisc.edu wrote on Mon, 05 May 2008 12:49 -0500:
>   
>> Pete Wyckoff wrote:
>>     
>>> iser has no limit on max sectors.  This lets iscsi iser support
>>> large pass through commands just like iscsi TCP.
>>>
>>> Signed-off-by: Pete Wyckoff <pw@osc.edu>
>>> ---
>>>  drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> index 1b272a6..78f3242 100644
>>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>>> @@ -557,7 +557,7 @@ static struct scsi_host_template iscsi_iser_sht = {
>>>  	.change_queue_depth	= iscsi_change_queue_depth,
>>>  	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
>>>  	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
>>> -	.max_sectors		= 1024,
>>> +	.max_sectors		= 0xffff,
>>>  	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
>>>  	.eh_abort_handler       = iscsi_eh_abort,
>>>  	.eh_device_reset_handler= iscsi_eh_device_reset,
>>>       
>> Do we need to modify sg_tablesize and the related preallocations to take 
>> advantage of this? iser sets the sg_tablesize to ISCSI_ISER_SG_TABLESIZE 
>> and disables clustering, scsi-ml/block will only send commands up to 
>> ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE.
>>     
>
> Yes.  I run with another patch to change ISCSI_ISER_SG_TABLESIZE to
> 1 MB / 4kB + 1, allowing up to 1 MB transfers.  (I think that was
> 3/3 way back when.)  That's because iser limits the fmr code like
> this:
>
>         params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE;
>
> The plus 1 handles the case that the 1 MB transfer doesn't start on
> a page boundary.
>
> But you point out that this sg_tablesize setting is also used to
> limit the maximum number of pages when building bios to send to the
> device.  So these numbers should all agree.
>
> rdreier@cisco.com wrote on Mon, 05 May 2008 13:43 -0700:
>   
>>  > This could be problematic because, AFAIK, some HCAs (memfree, I think)
>>  > don't support FMRs of more than 2MB. Roland, am I right?
>>
>> Mem-free HCAs don't support FMRs where the list of pages is bigger than
>> a page itself.  So yes, with 4 KB pages, you get 512 * 4 KB that way.
>>
>> Of course the current iSER driver has much bigger FMR problems, since
>> some adapters don't support FMRs at all...
>>     
>
> And certain current hardware is 2 MB tops anyway, but not all.  Iser
> cannot place a limit on the SCSI queue until it knows on which
> device it will use to communicate.
>
>   

Do you suggest that iSER should get these limits from the HW and set
max_sectors accordingly? I don't know if it's possible. Roland - do the
HCA drivers publish this limitation somehow? If not, maybe they should.


> The goal with these patches is to increase througphut for big
> transfers.
>   

Are you interested in transfers > 2MB?

Erez
> What's the right thing to do then?  Maybe punt to the user.  How
> about a module parameter like SRP, then we calculate the right
> limits for each of these three related settigns:  max_sectors,
> sg_tablesize, max_pages_per_fmr.
>
> Erez, is this something you're interested in figuring out?  I'll be
> offline for a couple of weeks at least.
>   

Currently, we don't need transfers > 2MB. BTW - I will be offline for
more than a couple of weeks  :-) (see my other e-mail in
openfabrics-general). I'm adding Eli Dorfman from Voltaire to the
discussion. He will replace me in iSER related tasks.

Erez

