From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [BUG] Yet another scsi_cmnd leak?
Date: Thu, 29 Sep 2005 15:31:43 -0500
Message-ID: <433C4F2F.2050805@cs.wisc.edu>
References: <Pine.LNX.4.44L0.0509291538520.6137-100000@iolanthe.rowland.org> <433C4E7A.7010205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37279 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750815AbVI2Ubw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 16:31:52 -0400
In-Reply-To: <433C4E7A.7010205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Mike Christie wrote:
> Alan Stern wrote:
> 
>> James:
>>
>> This report is based on 2.6.14-rc2-git6.  The code in your 
>> scsi-misc-2.6 git tree is somewhat different (and I don't know which 
>> is more current), but it still contains the same bug.
>>
>>
>> In scsi_prep_fn, a request can get deferred if scsi_init_io fails to 
>> allocate an sg table.  When this happens, the scsi_cmnd isn't released 
>> and the request is not marked DONTPREP.
>>
>> Then when scsi_prep_fn is called again, the request may be killed for 
>> a number of reasons.  The code branches to the kill: label near the 
>> end of the routine, which returns BLKPREP_KILL.
>>
>> Isn't it true that when this happens, the scsi_cmnd allocated during the
>> original prep will never be released?
>>
>> It appears that scsi_prep_fn is undecided about whether or not the 
>> request
>> is allowed to have a scsi_cmnd already.  The jumps to kill: seem to 
>> assume
>> that it isn't, but the code for allocating a new scsi_cmnd tests for an
>> existing one first.
>>
> 
> The gotos used to be just a return BLKPREP* and were added so I did not 
> have to write DID_NO_CONNECT or unplug multiple times :) I think you are 
> right and we need to further unwind what a previous prep had done 
> becuase when we return with BLKPREP_KILL we only hear about this command 

I did not mean command as in struct scsi_cmnd command. I think only the 
scsi_request or REQ_BLOCK_PC code sets the end_io or waiting fields so I 
really meant request or scsi_request.

> again if it's request has a end_io function or waiting completion.
> 

