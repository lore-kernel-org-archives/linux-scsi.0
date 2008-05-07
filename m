From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 2/3] iscsi iser: increase max_sectors
Date: Wed, 7 May 2008 11:53:08 -0400
Message-ID: <20080507155308.GE9975@osc.edu>
References: <20080212205252.GB13643@osc.edu> <20080212205420.GD13643@osc.edu> <481F48A4.3060701@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:50043 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYEGPxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 11:53:09 -0400
Content-Disposition: inline
In-Reply-To: <481F48A4.3060701@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

michaelc@cs.wisc.edu wrote on Mon, 05 May 2008 12:49 -0500:
> Pete Wyckoff wrote:
>> iser has no limit on max sectors.  This lets iscsi iser support
>> large pass through commands just like iscsi TCP.
>>
>> Signed-off-by: Pete Wyckoff <pw@osc.edu>
>> ---
>>  drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> index 1b272a6..78f3242 100644
>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> @@ -557,7 +557,7 @@ static struct scsi_host_template iscsi_iser_sht = {
>>  	.change_queue_depth	= iscsi_change_queue_depth,
>>  	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
>>  	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
>> -	.max_sectors		= 1024,
>> +	.max_sectors		= 0xffff,
>>  	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
>>  	.eh_abort_handler       = iscsi_eh_abort,
>>  	.eh_device_reset_handler= iscsi_eh_device_reset,
>
> Do we need to modify sg_tablesize and the related preallocations to take 
> advantage of this? iser sets the sg_tablesize to ISCSI_ISER_SG_TABLESIZE 
> and disables clustering, scsi-ml/block will only send commands up to 
> ISCSI_ISER_SG_TABLESIZE * PAGE_SIZE.

Yes.  I run with another patch to change ISCSI_ISER_SG_TABLESIZE to
1 MB / 4kB + 1, allowing up to 1 MB transfers.  (I think that was
3/3 way back when.)  That's because iser limits the fmr code like
this:

        params.max_pages_per_fmr = ISCSI_ISER_SG_TABLESIZE;

The plus 1 handles the case that the 1 MB transfer doesn't start on
a page boundary.

But you point out that this sg_tablesize setting is also used to
limit the maximum number of pages when building bios to send to the
device.  So these numbers should all agree.

rdreier@cisco.com wrote on Mon, 05 May 2008 13:43 -0700:
>  > This could be problematic because, AFAIK, some HCAs (memfree, I think)
>  > don't support FMRs of more than 2MB. Roland, am I right?
> 
> Mem-free HCAs don't support FMRs where the list of pages is bigger than
> a page itself.  So yes, with 4 KB pages, you get 512 * 4 KB that way.
> 
> Of course the current iSER driver has much bigger FMR problems, since
> some adapters don't support FMRs at all...

And certain current hardware is 2 MB tops anyway, but not all.  Iser
cannot place a limit on the SCSI queue until it knows on which
device it will use to communicate.

The goal with these patches is to increase througphut for big
transfers.

What's the right thing to do then?  Maybe punt to the user.  How
about a module parameter like SRP, then we calculate the right
limits for each of these three related settigns:  max_sectors,
sg_tablesize, max_pages_per_fmr.

Erez, is this something you're interested in figuring out?  I'll be
offline for a couple of weeks at least.

		-- Pete
