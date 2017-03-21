From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 17:21:49 +0100
Message-ID: <ef1d9658-9645-d9fc-a209-3c59846115f6@suse.de>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
 <1490101519.2412.13.camel@HansenPartnership.com>
 <27545016-e3a6-e425-cdfb-42c3ac7128df@suse.de>
 <1490110420.11580.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35983 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757872AbdCUQWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 12:22:30 -0400
In-Reply-To: <1490110420.11580.12.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hck@suse.de, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 03/21/2017 04:33 PM, James Bottomley wrote:
> On Tue, 2017-03-21 at 16:25 +0100, Hannes Reinecke wrote:
>> On 03/21/2017 02:05 PM, James Bottomley wrote:
>>> On Tue, 2017-03-21 at 13:14 +0100, Hannes Reinecke wrote:
>>>> With the current design we're waiting for all async probes to
>>>> finish when removing any sd device.
>>>> This might lead to a livelock where the 'remove' call is blocking
>>>> for any probe calls to finish, and the probe calls are waiting
>>>> for
>>>> a response, which will never be processes as the thread handling
>>>> the responses is waiting for the remove call to finish.
>>>> Which is completely pointless as we only _really_ care for the
>>>> probe on _this_ device to be completed; any other probing can
>>>> happily continue for all we care.
>>>> So save the async probing cookie in the structure and only wait
>>>> if this specific probe is still active.
>>>
>>> How does this preserve ordering?  It looks like you have one cookie 
>>> per sdkp ... is there some sort of ordering guarantee I'm not
>>> seeing?
>>>
>> Do we need one?
>> The only thing we care here is that probing for _this_ device has 
>> finished.
> 
> OK, so currently we guarantee the linear ordering luns for individual
> hbas.  We also guarantee no interleaving of sdX letters for individual
> hbas.  We don't guarantee the scan order of the hbas themselves. 
>  Preserve those guarantees and I'm happy with the patch.  If you can't
> preserve them I think we need further discussion.
> 
Which is actually not true.
If just some devices are removed from the hba (eg if they belong to the
same remote port) and we're rescanning devices once the port comes back
there is no guarantee that the devices will be getting the same device
letters. Nor that the device letters will be consecutive; just starting
'scsi_debug' with just one device before rescanning will mess up the
ordering. Even now.

So I don't see how we can be worse off than we are today.

Plus we (what with me now speaking for SUSE) never promised our
customers anything regardind sdX stability :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
