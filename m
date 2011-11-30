From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Wed, 30 Nov 2011 11:18:42 +0100
Message-ID: <4ED60302.7000304@kernel.dk>
References: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com> <1317183038.17578.9.camel@dabdike.hansenpartnership.com> <4E832A55.30709@kernel.dk> <1317219074.19034.4.camel@dabdike.hansenpartnership.com> <4E832BD2.50409@kernel.dk> <CA+55aFyFht3njKVep+aT_m5URxRxayZyb6K2ukW6+kazHf8EKA@mail.gmail.com> <1317224616.19034.41.camel@dabdike.hansenpartnership.com> <20110928174859.GA21628@redhat.com> <20110928175304.GA3985@infradead.org> <20110928180905.GB21628@redhat.com> <20110928181649.GA27441@infradead.org> <CADOQvuM2VP1TsLMAOL+NC-zEypDS2NJGmiN6RFCxmjUT6LqaPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADOQvuM2VP1TsLMAOL+NC-zEypDS2NJGmiN6RFCxmjUT6LqaPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Seppanen <eric@purestorage.com>
Cc: Christoph Hellwig <hch@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-09-28 21:05, Eric Seppanen wrote:
> On Wed, Sep 28, 2011 at 11:16 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> Right now on high iops device queue_lock is the major killer for
>> performance.  It's one major reason (*) why a lot of the high iops devices
>> are all moving to ->make_request, which has other issues.
>>
>> (*) others are struct request allocation and the pointless merge hash
> 
> I agree: queue lock is the worst performance killer when hw can do
>> 100K IOPS per block device.
> 
> Rather than just being chased away from the request queue due to
> performance issues, I could argue there's very little point to having
> a queue for devices that
> (a) have no seek penalty (and always use noop elevator)
> (b) have hardware queues at least as deep as the default request queue
> (c) don't benefit from merging
> 
> (c) is maybe debatable, but if a device can saturate its bus bandwidth
> on 4KB IO, the latency is probably not worth it.

I agree on a+b, but c is definitely more than debatable. I have yet to
see a device saturate its bandwidth on 4KB IOS. So merging on the write
side is always going to be a win.

-- 
Jens Axboe
