From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Always retry internal target error
Date: Wed, 18 Oct 2017 09:27:57 +0200
Message-ID: <95501c64-247c-4392-1771-19d5bacb6c15@suse.de>
References: <1508224263-130302-1-git-send-email-hare@suse.de>
 <yq18tg9upqf.fsf@oracle.com> <51f905cd-6907-438e-396f-a6efe610370f@suse.de>
 <20171018063439.GA11109@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52402 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966537AbdJRH2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Oct 2017 03:28:00 -0400
In-Reply-To: <20171018063439.GA11109@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 10/18/2017 08:34 AM, Christoph Hellwig wrote:
> On Wed, Oct 18, 2017 at 08:15:46AM +0200, Hannes Reinecke wrote:
>>> It's decidedly awful to have vendor/model-specific triggers in
>>> scsi_error.
>>>
>>> What are the drawbacks of just always refiring on AC/0x44/ITF?
>>>
>> Hmm. 'Internal target failure' is not very descriptive, so it could mean
>> anything. Hence the rather awkward approach.
>> But I just checked with the qemu code, and that returns 0x44/0x00 only
>> if some (internal) call returned with -ENOMEM.
>> So I guess we're safe to always retry here.
> 
> And even if not we should add a quirk so that we can just check a
> bit instead of doing two string compares in the I/O completion path..
> 
Yeah, you are right.
Will be adding a blacklist entry for this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
