From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/6] scsi tgt: add partial mappings support to bio_map_user
Date: Thu, 16 Feb 2006 14:00:34 -0600
Message-ID: <43F4D9E2.5030703@cs.wisc.edu>
References: <1140119620.20193.51.camel@max> <20060216195917.GY4203@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54688 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964889AbWBPUAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 15:00:41 -0500
In-Reply-To: <20060216195917.GY4203@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Feb 16 2006, Mike Christie wrote:
> 
>>Subject: [PATCH] block layer: add partial mappings support to bio_map_user
>>
>>For target mode we could end up with the case where we get very large
>>request from the initiator. The request could be so large that we
>>cannot transfer all the data in one operation. For example the
>>HBA's segment or max_sector limits might limit us to a 1 MB transfer.
>>To send a 5 MB command then we need to transfer the command chunk by chunk.
>>
>>To do this, tgt core will map in as much data as possible into a bio,
>>send this off, then when that transfer is completed we send off another
>>request/bio. To be able to pack as much data into a bio as possible
>>we need bio_map_user to support partially mapped bios. The attached patch
>>just adds a new argument to the those functions and if set will not
>>return a failure if the bio is partially mapped.
> 
> 
> Drop the partial flag and just always allow it, fixing up the few
> in-kernel users we have.
> 

ok will do.
