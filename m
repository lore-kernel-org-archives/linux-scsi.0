From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Thu, 06 Nov 2008 11:00:50 -0500
Message-ID: <491314B2.9040902@redhat.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYKFQBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2008 11:01:21 -0500
In-Reply-To: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

David Woodhouse wrote:
> On Thu, 6 Nov 2008, James Bottomley wrote:
>> The way to do this properly would be to run a chequerboard of partials,
>> but this would effectively have trim region tracking done in the block
>> layer ... is this worth it?
>>
>> By the way, the latest (from 2 days ago) version of the Thin
>> Provisioning proposal is here:
>>
>> http://www.t10.org/ftp/t10/document.08/08-149r4.pdf
>>
>> I skimmed it but don't see any update implying that trim might be
>> ineffective if we align wrongly ... where is this?
>
> I think we should be content to declare such devices 'broken'.
>
> They have to keep track of individual sectors _anyway_, and dropping 
> information for small discard requests is just careless.
>

Big arrays have an internal "track" size that is much larger than 512 
bytes (Symm for example is 64k. Everything smaller than that is a 
read-modify-write. Effectively, they have few to no bits left to track 
this other bit of state at the smal level of granularity.

The thing that makes this even more twisted is that the erase/unmap 
chunk size is a multiple of the internal size (which would already be an 
issue :-))

Ric

