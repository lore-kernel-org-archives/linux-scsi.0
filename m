From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] sd: Fix a disk probing hang
Date: Wed, 8 Nov 2017 09:12:53 +0100
Message-ID: <cf1f170e-3cf4-bed2-e6a9-2354748e0078@suse.com>
References: <20171107173807.14396-1-bart.vanassche@wdc.com>
 <1510078140.3118.18.camel@linux.vnet.ibm.com>
 <1510094539.2656.44.camel@wdc.com>
 <1510095425.3118.62.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:33399 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdKHIM4 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 8 Nov 2017 03:12:56 -0500
In-Reply-To: <1510095425.3118.62.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>

On 11/07/2017 11:57 PM, James Bottomley wrote:
> On Tue, 2017-11-07 at 22:42 +0000, Bart Van Assche wrote:
>> On Tue, 2017-11-07 at 10:09 -0800, James Bottomley wrote:
>>>
>>> but can you investigate the root cause rather than trying this
>>> bandaid?
>>
>> Hello James,
>>
>> Thanks for your reply. I think that the root cause is that SCSI
>> scanning activity can continue to submit I/O even after
>> scsi_remove_host() has unlocked scan_mutex but that
>> scsi_remove_host() removes some of the infrastructure that is
>> essential to process SCSI requests.
> 
> That's not really a useful answer: how does it submit I/O after the
> device goes into DEL?  In theory every I/O submitted after this is
> returned with an immediate error.  I could buy the fact that we have
> pending I/O submitted before we go into DEL, which would argue for some
> sort of quiesce wait, but I don't see how I/O submitted after DEL
> causes a hang.
> 
>>  Are you OK with
>> e.g. moving a significant part of scsi_remove_host() into
>> scsi_host_dev_release()?
> 
> Well not really without seeing the root cause.  Before scsi_forget_host
> ()it's all about state and after it's just removing some user visible
> host attributes, so I can't see how either matters much.
>  scsi_forget_host() must be executed from scsi_remove_host() because
> that's how the devices go into the DEL state and how we error the
> requests without troubling the device driver, so that can't be moved to
> release
> 
You know, this actually looks like the same issue I'm chasing with iser;
we have a customer who regularly sees lockups during scanning.
As it turns out, iser is calling scsi_device_del() from the RX thread.
Which in turn needs to call async_synchronize().
If a disk scan is running at the same time we have a nice deadlock, as
the RX thread can't move forward before aynch_synchronize() returns,
which it'll never do as the scan cannot complete.
I've tried to fix that by having the async probing only waiting for that
particular instance (look for patch 'sd: use async_probe cookie to avoid
deadlocks'), but this wasn't greeted with much enthusiasm.

So maybe it's time to investigate this properly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
