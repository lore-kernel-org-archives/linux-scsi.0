From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with
 sequenced flush
Date: Mon, 23 Aug 2010 14:30:33 +0200
Message-ID: <4C7269E9.9070304@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C6E9CAF.5010202@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/20/2010 05:18 PM, Ric Wheeler wrote:
> On 08/20/2010 09:22 AM, Christoph Hellwig wrote:
>> FYI: here's a little writeup to document the new cache flushing scheme,
>> intended to replace Documentation/block/barriers.txt.  Any good
>> suggestion for a filename in the kernel tree?
>>
> 
> I was thinking that we might be better off using the "durable
> writes" term more since it is well documented (at least in the
> database world, where it is the "D" in ACID properties).  Maybe
> "durable_writes_support.txt" ?

The term is very foreign to people outside of enterprise / database
loop.  writeback-cache.txt or write-cache-control.txt sounds good
enough to me.

>> The Linux block layer provides a two simple mechanism that lets filesystems
>> control the caching behavior of the storage device.  These mechanisms are
>> a forced cache flush, and the Force Unit Access (FUA) flag for requests.
>>
> 
> Should we mention that users can also disable the write cache on the
> target device?
> 
> It might also be worth mentioning that storage needs to be properly
> configured - i.e., an internal hardware RAID card with battery
> backing needs can expose itself as a writethrough cache *only if* it
> actually has control over all of the backend disks and can
> flush/disable their write caches.

It might be useful to give several example configurations with
different cache configurations.  I don't have much experience with
battery backed arrays but aren't they suppose to report write through
cache automatically?

Thanks.

-- 
tejun
