From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
  sequenced flush
Date: Mon, 23 Aug 2010 11:19:13 -0400
Message-ID: <4C729171.3030605@redhat.com>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de> <4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C727F2B.6060501@fusionio.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "tytso@mit.edu" <tytso@mit.edu>, "chris.mason@oracle.com" <chris.mason@oracle.com>, "swhiteho@redhat.com" <swhiteho@redhat.com>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "vst@vlnb.net" <vst@vlnb.net>, "jack@suse.cz" <jack@suse.cz>, "hare@suse.de" <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 08/23/2010 10:01 AM, Jens Axboe wrote:
> On 2010-08-23 15:58, Ric Wheeler wrote:
>> On 08/23/2010 08:48 AM, Christoph Hellwig wrote:
>>> On Mon, Aug 23, 2010 at 02:30:33PM +0200, Tejun Heo wrote:
>>>> It might be useful to give several example configurations with
>>>> different cache configurations.  I don't have much experience with
>>>> battery backed arrays but aren't they suppose to report write through
>>>> cache automatically?
>>>
>>> They usually do.  I have one that doesn't, but SYNCHRONIZE CACHE on
>>> it is so fast that it effectively must be a no-op.
>>>
>>
>> Arrays are not a problem in general - they normally have internally, redundant
>> batteries to hold up the cache.
>>
>> The issue is when you have an internal hardware RAID card with a large cache.
>> Those cards sit in your server and the batteries on the card protect its
>> internal cache, but do not have the capacity to hold up the drives behind it.
>>
>> Normally, those drives should have their write cache disabled, but sometimes
>> (especially with S-ATA disks) this is not done.
>
> The problem purely exists on arrays that report write back cache enabled
> AND don't implement SYNC_CACHE as a noop. Do any of them exist, or are
> they purely urban legend?
>


Hi Jens,

There are actually two distinct problems:

(1) arrays with a non-volatile write cache (battery backed, navram, whatever) 
that do not NOOP a SYNC_CACHE command. I know of one brand that seems to do 
this, but it is not a common brand. If we do not issue flushes for write through 
caches, I think that we will avoid this in any case.

(2) hardware raid cards with internal buffer memory and on-card battery backup 
(they sit in your server, disks sit in jbod like expansion shelves). These are 
fine if the drives in those shelves have write cache disabled.

ric
