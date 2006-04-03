From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Retry INQUIRY on power-on
Date: Mon, 03 Apr 2006 12:37:08 -0500
Message-ID: <44315D44.6080508@cs.wisc.edu>
References: <442D2AA1.3070909@suse.de> <1143818178.3375.3.camel@mulgrave.il.steeleye.com> <4430C4EA.8070609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34451 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S964808AbWDCRhe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 13:37:34 -0400
In-Reply-To: <4430C4EA.8070609@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> James Bottomley wrote:
>> On Fri, 2006-03-31 at 15:12 +0200, Hannes Reinecke wrote:
>>> So we really should loosen that statement to do retry for all ASC 0x29
>>> values as a power-on might well have occured without a reset.
>> Actually, there's probably no reason to qualify the UNIT_ATTENTION at
>> all.  Any device that replies UNIT_ATTENTION to INQUIRY is out of spec,
>> so it's reasonable to assume that the ASC/ASCQ responses aren't in spec
>> either.  There doesn't seem to be a disadvantage to just retrying three
>> times in all unit attention cases.
>>
> Well, after looking through the trace I discovered it's not actually a
> broken device, but rather more a driver issue:
> 
> - SCSI ML sends inquiry
> - HBA cannot send message as transport parameters are invalid
> - HBA requests sense
> - HBA sets the sense code and returns command with code 'ADD_TO_MLQUEUE'
>   to inform ML to retry the command
> 
> Only the ML fails to honour the ADD_TO_MLQUEUE code as this is
> scsi_scan(), which doesn't check for it.
> So if anything then rather the code in scsi_scan should been fixed to
> retry the command if so advised from the LLD.
> 

Normally, a request from the scsi scan code should go through 
scsi_softirq_done which checks for scsi_decide_disposition returning 
ADD_TO_MLQUEUE. Is aic7xxx setting the host byte to DID_REQUEUE?
