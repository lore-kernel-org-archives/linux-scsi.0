From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 07:14:58 -0500
Message-ID: <49143142.4010809@redhat.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55022 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYKGMRJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2008 07:17:09 -0500
In-Reply-To: <20081107120534.GO21867@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>

Jens Axboe wrote:
> On Thu, Nov 06 2008, David Woodhouse wrote:
>   
>> On Thu, 6 Nov 2008, James Bottomley wrote:
>>     
>>> The way to do this properly would be to run a chequerboard of partials,
>>> but this would effectively have trim region tracking done in the block
>>> layer ... is this worth it?
>>>
>>> By the way, the latest (from 2 days ago) version of the Thin
>>> Provisioning proposal is here:
>>>
>>> http://www.t10.org/ftp/t10/document.08/08-149r4.pdf
>>>
>>> I skimmed it but don't see any update implying that trim might be
>>> ineffective if we align wrongly ... where is this?
>>>       
>> I think we should be content to declare such devices 'broken'.
>>
>> They have to keep track of individual sectors _anyway_, and dropping 
>> information for small discard requests is just careless.
>>     
>
> I agree, seems pretty pointless. Lets let evolution take care of this
> issue. I have to say I'm surprised that it really IS an issue to begin
> with, are array firmwares really that silly?
>
> It's not that it would be hard to support (and it would eliminate the
> need to do discard merging in the block layer), but it seems like one of
> those things that will be of little use in even in the near future.
> Discard merging should be useful, I have no problem merging something
> like that.
>
>   
I think that discard merging would be helpful (especially for devices 
with more reasonable sized unmap chunks).

Ric

