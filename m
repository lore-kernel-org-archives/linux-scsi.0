From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Date: Mon, 02 Apr 2012 09:19:05 +0800
Message-ID: <4F78FE89.2070707@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com> <20120330152606.GB28934@google.com> <20120330152808.GC28934@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20120330152808.GC28934@google.com>
Sender: kvm-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

  On 03/30/2012 11:28 PM, Tejun Heo wrote:
> On Fri, Mar 30, 2012 at 08:26:06AM -0700, Tejun Heo wrote:
>> On Fri, Mar 30, 2012 at 05:53:52PM +0800, Ren Mingxin wrote:
>>>   The current virtblk's naming algorithm only supports 263  disks.
>>> If there are mass of virtblks(exceeding 263), there will be disks
>>> with the same name.
>>>
>>> By renaming "sd_format_disk_name()" to "disk_name_format()"
>>> and moving it into block core, virtio_blk can use this function to
>>> support mass of disks.
>>>
>>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> I guess it's already way too late but why couldn't they have been
>> named vdD-P where both D and P are integers denoting disk number and
>> partition number?  [sh]dX's were created when there weren't supposed
>> to be too many disks, so we had to come up with the horrible alphabet
>> based numbering scheme but vd is new enough.  I mean, naming is one
>> thing but who wants to figure out which sequence is or guess what
>> comes next vdzz9?  :(
>>
>> If we're gonna move it to block layer, let's add big blinking red
>> comment saying "don't ever use it for any new driver".
> And also let's make that clear in the function name - say,
> format_legacy_disk_name() or something.

So, to legacy disks [sh]d, we'd name them as [sh]d[a-z]{1,}. To new devices
like vd, we'd name them as vd<index>(vd<index>p<partno> as partitions)?
And how about the rssd in the patch 3 then?

Besides, does anybody have comments?
Looking forward to your replies ;-)

-- 
Thanks,
Ren

