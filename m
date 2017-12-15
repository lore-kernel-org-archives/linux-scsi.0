From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: add missing get_device() return value checks
Date: Fri, 15 Dec 2017 13:08:04 +0100
Message-ID: <067e9181-009f-e2a4-e2bc-e9acb90f467d@suse.de>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
 <1513069072-32514-4-git-send-email-hare@suse.de>
 <1513289025.2475.82.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754924AbdLOMIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Dec 2017 07:08:09 -0500
In-Reply-To: <1513289025.2475.82.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 12/14/2017 11:03 PM, Bart Van Assche wrote:
> On Tue, 2017-12-12 at 09:57 +0100, Hannes Reinecke wrote:
>>  	sdev->sdev_gendev.parent = get_device(&starget->dev);
>> +	if (!sdev->sdev_gendev.parent) {
>> +		kfree(sdev);
>> +		return NULL;
>> +	}
> 
> Are you sure that get_device() can return NULL?
> 
If it can't return NULL, why bother having a return value at all?
And this is not the only place where get_device() is checked for a NULL
return value.

We _really_ need to come up with a consistent view here.
If get_device() can never return NULL I would strongly argue for making
it a void function.
If it _can_ return NULL we need to check for it.

Either way I don't mind; but please stay consistent.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
