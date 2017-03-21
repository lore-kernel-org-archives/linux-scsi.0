From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 16:32:23 +0100
Message-ID: <1d91c7fa-5b63-f92f-e285-06aae73d93f0@suse.de>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
 <1490101519.2412.13.camel@HansenPartnership.com>
 <1490103027.2602.5.camel@sandisk.com>
 <1490103238.2412.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757281AbdCUPcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 11:32:41 -0400
In-Reply-To: <1490103238.2412.17.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hck@suse.de" <hck@suse.de>, "hare@suse.com" <hare@suse.com>

On 03/21/2017 02:33 PM, James Bottomley wrote:
> On Tue, 2017-03-21 at 13:30 +0000, Bart Van Assche wrote:
>> On Tue, 2017-03-21 at 09:05 -0400, James Bottomley wrote:
>>> How does this preserve ordering?  It looks like you have one cookie 
>>> per sdkp ... is there some sort of ordering guarantee I'm not
>>> seeing?
>>
>> Hello James,
>>
>> Since the probe order depends on the order in which __async_probe() 
>> adds entries to the "pending" list, and since the order of the
>> __async_probe() calls is not changed by this patch, shouldn't the 
>> probe order be preserved by this patch?
> 
> I don't know: that's what I'm asking.  I believe they complete in order
> for a single domain.  I thought ordering isn't preserved between
> domains?  So moving to multiple domains loses us ordering of disk
> appearance.
> 
Ah.
But we don't move to multiple domains, now do we?
We're just terminating the wait until _our_ probe is completed.
It's not that we're having a individual probe domain per device...

Unless I'm misunderstanding something...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
