From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the
 bio/request structs
Date: Wed, 4 May 2016 12:51:59 -0500
Message-ID: <572A36BF.3070208@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
 <x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 05/03/2016 03:44 PM, Jeff Moyer wrote:
> mchristi@redhat.com writes:
> 
>> The following patches begin to cleanup the request->cmd_flags and
>> bio->bi_rw mess. We currently use cmd_flags to specify the operation,
>> attributes and state of the request. For bi_rw we use it for similar
>> info and also the priority but then also have another bi_flags field
>> for state. At some point, we abused them so much we just made cmd_flags
>> 64 bits, so we could add more.
>>
>> The following patches seperate the operation (read, write discard,
>> flush, etc) from cmd_flags/bi_rw.
>>
>> This patchset was made against linux-next from today April 15
>> (git tag next-20160415).
>>
>> I put a git tree here:
>> https://github.com/mikechristie/linux-kernel.git
>> The patches are in the op branch.
> 
> Hi, Mike,
> 
> That git tree doesn't seem to exist.  I did manage to apply your patch
> set on top of next-20160415, though.
> 
> So... what testing did you do? ;-) I ran into the following problems

I normally run xfstests and run it on my daily workstation and laptop. I
did not do this for every FS this time and hit a regression.

What FS were you using?

> - git clone fails
> - yum segfaults


In v7/v6, I missed a new submit_bio call, so I hit issues like the two
above. I have this fixed in the next version.

> - many blktrace/blkparse issues, including incorrect cpu recorded in
>   traces, null task names, and blkparse outputting nothing for a trace
>   file several gigabytes in size.

I will double check for these issues.
