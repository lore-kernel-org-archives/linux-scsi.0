From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [dm-devel] RE: [RFC PATCH 4/4] convert scsi to blkerr error values
Date: Sat, 17 Sep 2005 10:35:57 -0500
Message-ID: <432C37DD.3080208@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321ACB8@SRMANNING.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34768 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751170AbVIQRge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 13:36:34 -0400
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACB8@SRMANNING.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "goggin, edward" <egoggin@emc.com>, axboe@suse.de, linux-scsi@vger.kernel.org

goggin, edward wrote:
>>-----Original Message-----
>>From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
>>Sent: Friday, September 16, 2005 4:54 PM
>>To: goggin, edward
>>Cc: axboe@suse.de; linux-scsi@vger.kernel.org; dm-devel@redhat.com
>>Subject: Re: [RFC PATCH 4/4] convert scsi to blkerr error values
>>
>>Mike Christie wrote:
>>
>>>goggin, edward wrote:
>>>
>>>
>>>>Mike,
>>>>
>>>>I don't think it is reasonably possible to anticipate
>>>>all possible parsing requirements for the asc and ascq
>>>>portions of SCSI sense information across all device
>>>>models.  I'm in favor of having a "small" framework in
>>>>SCSI where a SCSI sense interpreter module (per
>>>>vendor & model possibly) could be registered
>>>>dynamically, by dm-emc.c for instance.
>>>
>>>
>>>Yeah I agree, I mentioned this before in some other mails. 
>>
>>I think a 
>>
>>>module versus some table that userspace could write to were 
>>
>>discussed.
>>
>>>The BLKERR values were meant to be able to tell upper layer 
>>
>>code whether 
>>
>>>a transport or device or driver error occured and whether the lower 
>>>level thought it was retryable. But then I thought I could 
>>
>>also wedge in 
>>
>>>the handling of the vendor specifcs by adding a vendor 
>>
>>specific SCSI 
>>
>>>module that would map the their specific value to a 
>>
>>BLKERR_* one. And as 
>>
>>>I said offlist it is not working perfectly becuase we are 
>>
>>losing some 
>>
>>>information in the translations.
>>>
>>
>>Oh yeah so the problem I am having is emc boxes may return "LUN Not 
>>Ready - Manual Intervention Required". When dm-emc.c sees 
>>this error it 
>>wants to bypass a group of paths and retry the IO but under ceratin 
>>conditions not fail those paths. So I am not sure what to return for 
>>this error. I thought if I redo my BLKERR so they describe 
>>the error like
>>
>>BLKERR_DEV_NOT_READY
>>BLKERR_MANUAL_INTERVENTION_REQ
>>BLKERR_NOT_CONN
>>
>>... and set them up as a bitmap like suggested by JamesB. I 
>>could return
>>BLKERR_MANUAL_INTERVENTION_REQ from a scsi module then have dm-emc.c 
>>evaluate that value to a dm-mpaths return value of "MP_BYPASS_PG | 
>>MP_RETRY_IO" which means bypass the priority group (group of 
>>paths) and 
>>retry the IO.
>>
>>But as more vendors use dm and they cannot use existing 
>>BLKERR values I 
>>have to add more and more.
> 
> 
> I was hoping we could avoid the need to do this by having the framework
> described in my email -- the idea for which I heard about from you in
> the first place :))
> 

umm, yeah I understand this. I was writing it becuase for some reason 
multipath people do not post on lists and instead email me offlist, so I 
put this out there so I do not have to write multiple emails to people 
about why I do not like my original idea. :)
