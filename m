From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] sd: Increase SCSI disk probing concurrency
Date: Tue, 12 Dec 2017 08:59:21 +0100
Message-ID: <de0305d8-d1d7-39c2-2a55-898a13e76ee1@suse.com>
References: <20171208172124.32685-1-bart.vanassche@wdc.com>
 <c3116e4b-bd48-d72c-52ff-972b9e03fc9a@suse.com>
 <1513037811.2747.42.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:51892 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdLLH7Y (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:59:24 -0500
In-Reply-To: <1513037811.2747.42.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>

On 12/12/2017 01:16 AM, Bart Van Assche wrote:
> On Sun, 2017-12-10 at 15:44 +0100, Hannes Reinecke wrote:
>> You know what, I have been working on a similar patch for quite some
>> time now; [ ... ]
> 
> That's very interesting :-)
> 
>> However, in doing so I have encountered several issues which have been
>> exposed by that; the most trivial one being that del_gendisk() doesn't
>> check if GENHD_FL_UP is set, so it'll crash if sd_remove is called
>> before sd_async_probe() is run.
> 
> Have you noticed that my patch adds a call to sd_wait_for_probing() before
> the call to del_gendisk()? That should be sufficient to prevent the crash you
> described.
> 
Not necessarily; see below.

>> The other one is an imbalance between sd_probe and sd_remove;
>> when sd_probe_async() is called _after_ scsi_device_remove_device()
>> (which it will as the synchronization is only after device_del() has
>> been called) it will trip over non-existent sysfs directories in add_disk().
>> So one need to short-circuit sd_probe_async() for devices in SDEV_CANCEL
>> or SDEV_DEL.
> 
> Same comment here - I think the sd_wait_for_probing() call I inserted in
> sd_remove() should prevent this scenario.
> 
No, it doesn't.
sd_remove is called via

__scsi_device_remove_device()
-> device_del()
   -> sd_remove()

with this piece of code:

		bsg_unregister_queue(sdev->request_queue);
		device_unregister(&sdev->sdev_dev);
		transport_remove_device(dev);
		device_del(dev);

ie by the time device_del() we've already called device_unregister(),
which unfortunately is the sysfs parent kobj for the gendisk.
So when you're calling sd_wait_for_probing() in sd_remove() it'll call
sd_async_probe(), and add_disk() will be called with a NULL parent object.

>> However, I'm still waiting for a final confirmation on the latter issue,
>> hence I haven't posted the patchset.
>> If there's interest I can post them, though.
> 
> The big question here is how you would like to proceed - should we start from
> your patch series or start from my patch? Since I have not encountered any of
> the issues you described with my patch, does that mean that the approach I
> followed results in more reliable operation?
> 
Not necessarily.
The issues I've described got reported by a big CDN provider after
several days worth of hammering.
It's not something I could reproduce here in my puny lab.
So just because you haven't seen the race doesn't mean there is none :-)

I'll be posting the patches shortly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
