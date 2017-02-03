From: Johannes Thumshirn <jth@kernel.org>
Subject: Re: [PATCHv3 3/6] sg: protect accesses to 'reserved' page array
Date: Fri, 3 Feb 2017 19:06:03 +0100
Message-ID: <1d212ffc-d1c2-f743-151d-b8f48ea94f30@kernel.org>
References: <1486127531-13716-1-git-send-email-hare@suse.de>
 <1486127531-13716-4-git-send-email-hare@suse.de>
 <20170203133140.GC646@lst.de> <b75d63b6-ae38-6c69-ec16-430e2bd351f7@suse.de>
 <20170203161910.GA4339@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36617 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbdBCSGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 13:06:12 -0500
Received: by mail-wm0-f65.google.com with SMTP id r18so5973162wmd.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2017 10:06:12 -0800 (PST)
In-Reply-To: <20170203161910.GA4339@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>



On 02/03/2017 05:19 PM, Christoph Hellwig wrote:
> On Fri, Feb 03, 2017 at 02:38:35PM +0100, Hannes Reinecke wrote:
>> On 02/03/2017 02:31 PM, Christoph Hellwig wrote:
>>>> -		if (sg_res_in_use(sfp)) {
>>>> +		mutex_lock(&sfp->f_mutex);
>>>> +		if (sfp->res_in_use) {
>>>> +			mutex_unlock(&sfp->f_mutex);
>>>>   			sg_remove_request(sfp, srp);
>>>>   			return -EBUSY;	/* reserve buffer already being used */
>>>>   		}
>>>> +		mutex_unlock(&sfp->f_mutex);
>>> Holding a mutex over a the check of a single scalar doesn't make sense.
>>>
>> It's adds a synchronisation point, doesn't it?
> It does, but it doesn't actually protect anything..

But all the other mutex_{un,}locks() do (for instance guarding 
sg_build_indirect()) and this one provides a synchronization point.

Sorry but I really don't get your point here.

The sole purpose is to guard the reserved list from being altered while 
blk_rq_map_* or similar functions are in progess (that's what the 
syzcaller reproducer was doing).

Byte,
     Johannes
