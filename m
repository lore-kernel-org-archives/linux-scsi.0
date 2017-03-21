From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 16:25:34 +0100
Message-ID: <27545016-e3a6-e425-cdfb-42c3ac7128df@suse.de>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
 <1490101519.2412.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757180AbdCUPZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 11:25:38 -0400
In-Reply-To: <1490101519.2412.13.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hck@suse.de, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 03/21/2017 02:05 PM, James Bottomley wrote:
> On Tue, 2017-03-21 at 13:14 +0100, Hannes Reinecke wrote:
>> With the current design we're waiting for all async probes to
>> finish when removing any sd device.
>> This might lead to a livelock where the 'remove' call is blocking
>> for any probe calls to finish, and the probe calls are waiting for
>> a response, which will never be processes as the thread handling
>> the responses is waiting for the remove call to finish.
>> Which is completely pointless as we only _really_ care for the
>> probe on _this_ device to be completed; any other probing can
>> happily continue for all we care.
>> So save the async probing cookie in the structure and only wait
>> if this specific probe is still active.
> 
> How does this preserve ordering?  It looks like you have one cookie per
> sdkp ... is there some sort of ordering guarantee I'm not seeing?
> 
Do we need one?
The only thing we care here is that probing for _this_ device has finished.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
