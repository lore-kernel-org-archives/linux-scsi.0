From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/4] block: check for GENHD_FL_UP in del_gendisk()
Date: Wed, 13 Dec 2017 08:36:54 +0100
Message-ID: <b06f503b-c420-fe32-5464-eaaa52732340@suse.com>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
 <1513069072-32514-2-git-send-email-hare@suse.de>
 <1513097821.2999.12.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:56690 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdLMHg5 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 13 Dec 2017 02:36:57 -0500
In-Reply-To: <1513097821.2999.12.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12/12/2017 05:57 PM, Bart Van Assche wrote:
> On Tue, 2017-12-12 at 09:57 +0100, Hannes Reinecke wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> When a device is probed asynchronously del_gendisk() might be called
>> before the async probing was run, causing del_gendisk() to crash
>> due to uninitialized sysfs objects.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  block/genhd.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/block/genhd.c b/block/genhd.c
>> index c2223f1..cc40d95 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -697,6 +697,9 @@ void del_gendisk(struct gendisk *disk)
>>  	struct disk_part_iter piter;
>>  	struct hd_struct *part;
>>  
>> +	if (!(disk->flags & GENHD_FL_UP))
>> +		return;
>> +
>>  	blk_integrity_del(disk);
>>  	disk_del_events(disk);
> 
> Hello Hannes,
> 
> Thank you for having published your approach for increasing disk probing
> concurrency. Your approach looks interesting to me. However, I don't think
> that patches 1/4..3/4 are sufficient to avoid races between e.g.
> device_add_disk() and del_gendisk(). As far as I know no locks are held
> around the device_add_disk() and del_gendisk() calls. Does that mean that
> del_gendisk() can call e.g. blk_integrity_del() before device_add_disk() has
> called blk_integrity_add()?
> 
In principle, yes.
However, the overall idea here is that  device_add_disk() and
del_gendisk() are enclosed within upper layer procedures, which
themselves provide additional locking.
In our case the sd driver provided synchronisation guarantees ensuring
that device_add_disk() and del_gendisk() doesn't run concurrently.

if one is really concerned we could convert disk->flags to a bitmask,
and use atomic bitmask modification; that should avoid any concurrency
issues.
However, I'm not sure if it's worth it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
