From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] iscsi iser: remove DMA restrictions
Date: Thu, 14 Feb 2008 11:56:41 -0600
Message-ID: <47B480D9.6080206@cs.wisc.edu>
References: <20080212205252.GB13643@osc.edu>	 <20080212205403.GC13643@osc.edu> <1202850645.3137.132.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43375 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYBNR5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 12:57:03 -0500
In-Reply-To: <1202850645.3137.132.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pete Wyckoff <pw@osc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2008-02-12 at 15:54 -0500, Pete Wyckoff wrote:
>> iscsi_iser does not have any hardware DMA restrictions.  Add a
>> slave_configure function to remove any DMA alignment restriction,
>> allowing the use of direct IO from arbitrary offsets within a page.
>> Also disable page bouncing; iser has no restrictions on which pages it
>> can address.
>>
>> Signed-off-by: Pete Wyckoff <pw@osc.edu>
>> ---
>>  drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> index be1b9fb..1b272a6 100644
>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> @@ -543,6 +543,13 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
>>  	iser_conn_terminate(ib_conn);
>>  }
>>  
>> +static int iscsi_iser_slave_configure(struct scsi_device *sdev)
>> +{
>> +	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
> 
> You really don't want to do this.  That signals to the block layer that
> we have an iommu, although it's practically the same thing as a 64 bit
> DMA mask ... but I'd just leave it to the DMA mask to set this up
> correctly.  Anything else is asking for a subtle bug to turn up years
> from now when something causes the mask and the limit to be mismatched.
> 

I thought BLK_BOUNCE_ANY just meant "don't bounce anything" (that was 
from the blkdev.h comments). We used it for iscsi_tcp because the 
network layer can take any type of page and will do the right thing for 
the hardware it eventually gets sent to.
