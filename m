From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at iscsi_tcp_segment_done+0x20d/0x2e0
Date: Fri, 23 Dec 2016 07:53:50 +0800
Message-ID: <CACVXFVOGoh+AEGSSMsbxfdAjZQS5k_t+7uR-+qwusm0vfauHEA@mail.gmail.com>
References: <20161214222411.GH4326@dastard> <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard> <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
 <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
 <20161222051322.GF4758@dastard> <CA+55aFza=cv6TGYh+Be1xz2x-G-U=vruhbmfGpHSqY1ocZrBeg@mail.gmail.com>
 <20161222065012.GI4758@dastard> <20161222185030.so4btkuzzkih3owz@straylight.hirudinean.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161222185030.so4btkuzzkih3owz@straylight.hirudinean.org>
Sender: linux-block-owner@vger.kernel.org
To: Chris Leech <cleech@redhat.com>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2016 at 2:50 AM, Chris Leech <cleech@redhat.com> wrote:
> On Thu, Dec 22, 2016 at 05:50:12PM +1100, Dave Chinner wrote:
>> On Wed, Dec 21, 2016 at 09:46:37PM -0800, Linus Torvalds wrote:
>> > On Wed, Dec 21, 2016 at 9:13 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > >
>> > > There may be deeper issues. I just started running scalability tests
>> > > (e.g. 16-way fsmark create tests) and about a minute in I got a
>> > > directory corruption reported - something I hadn't seen in the dev
>> > > cycle at all.
>> >
>> > By "in the dev cycle", do you mean your XFS changes, or have you been
>> > tracking the merge cycle at least for some testing?
>>
>> I mean the three months leading up to the 4.10 merge, when all the
>> XFS changes were being tested against 4.9-rc kernels.
>>
>> The iscsi problem showed up when I updated the base kernel from
>> 4.9 to 4.10-current last week to test the pullreq I was going to
>> send you. I've been bust with other stuff until now, so I didn't
>> upgrade my working trees again until today in the hope the iscsi
>> problem had already been found and fixed.
>>
>> > > I unmounted the fs, mkfs'd it again, ran the
>> > > workload again and about a minute in this fired:
>> > >
>> > > [628867.607417] ------------[ cut here ]------------
>> > > [628867.608603] WARNING: CPU: 2 PID: 16925 at mm/workingset.c:461 shadow_lru_isolate+0x171/0x220
>> >
>> > Well, part of the changes during the merge window were the shadow
>> > entry tracking changes that came in through Andrew's tree. Adding
>> > Johannes Weiner to the participants.
>> >
>> > > Now, this workload does not touch the page cache at all - it's
>> > > entirely an XFS metadata workload, so it should not really be
>> > > affecting the working set code.
>> >
>> > Well, I suspect that anything that creates memory pressure will end up
>> > triggering the working set code, so ..
>> >
>> > That said, obviously memory corruption could be involved and result in
>> > random issues too, but I wouldn't really expect that in this code.
>> >
>> > It would probably be really useful to get more data points - is the
>> > problem reliably in this area, or is it going to be random and all
>> > over the place.
>>
>> The iscsi problem is 100% reproducable. create a pair of iscsi luns,
>> mkfs, run xfstests on them. iscsi fails a second after xfstests mounts
>> the filesystems.
>>
>> The test machine I'm having all these other problems on? stable and
>> steady as a rock using PMEM devices. Moment I go to use /dev/vdc
>> (i.e. run load/perf benchmarks) it starts falling over left, right
>> and center.
>
> I'm not reproducing any problems with xfstests running over iscsi_tcp
> right now.  Two 10G luns exported from an LIO target, attached directly
> to a test VM as sda/sdb and xfstests configured to use sda1/sdb1 as
> TEST_DEV and SCRATCH_DEV.
>
> The virtio scatterlist issue that popped right away for me is triggered
> by an hdparm ioctl, which is being run by tuned on Fedora.  And that
> actually seems to happen back on 4.9 as well :(

Could you share us what the specific hdparm cmd line is? I tried several
random cmds over virtio-blk/virito-scsi, looks not see this problem.


Thanks,
Ming Lei
