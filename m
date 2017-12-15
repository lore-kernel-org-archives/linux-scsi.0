From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] sd: use async_probe cookie to avoid deadlocks
Date: Fri, 15 Dec 2017 15:08:31 +0100
Message-ID: <c86e052f-06b7-3e8f-2a0a-9d670c0b68c5@suse.de>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
 <1513069072-32514-5-git-send-email-hare@suse.de>
 <1513289597.2475.86.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51057 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755739AbdLOOId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Dec 2017 09:08:33 -0500
In-Reply-To: <1513289597.2475.86.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 12/14/2017 11:13 PM, Bart Van Assche wrote:
> On Tue, 2017-12-12 at 09:57 +0100, Hannes Reinecke wrote:
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
> From async_synchronize_cookie_domain():
> 
> 	wait_event(async_done, lowest_in_progress(domain) >= cookie);
> 
> So async_synchronize_cookie_domain() also waits for multiple asynchronous
> probes to finish. Does this patch have any advantages over the patch I
> posted (https://marc.info/?l=linux-scsi&m=151275368714540)?
> 
Correct, it waits for all _previous_ entries to complete.
But this was precisely the point; previous entries (should) have all
necessary information to complete (they probably only have been
scheduled out for some reason), so a

The main advantage is that the change to make it work is relatively simple.
(And doesn't change the interface; something we as poor distribution
developer have to worry about...)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
