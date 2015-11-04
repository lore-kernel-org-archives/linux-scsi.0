From: mchristi@redhat.com
Subject: [RESEND RFC PATCH 00/32] separate operations from flags in the bio/request structs
Date: Wed,  4 Nov 2015 16:07:57 -0600
Message-ID: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

This is just a resend of the patchset from earlier today. There was
a error in the middle of sending the set, so it looks like 10 - 32 got
dropped.

There are a couple new block layer commands we are trying to add support
for in the near term:

compare and write
http://www.spinics.net/lists/target-devel/msg07826.html

copy offload/extended copy/xcopy
https://www.redhat.com/archives/dm-devel/2014-July/msg00070.html

The problem is if we contine to add more commands we will have to one day
extend the cmd_flags/bi_rw fields again. To prevent that, this patchset
separates the operation (REQ_WRITE, REQ_DISCARD, REQ_WRITE_SAME, etc) from
the flags (REQ_SYNC, REQ_QUIET, etc) in the bio and request structs. In the
end of this set, we will have two fields bio->bi_op/request->op and
bio->bi_rw/request->cmd_flags.

The patches were made against Jens's linux-block tree's for-linus branch:
https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git/log/?h=for-linus
(last commit a22c4d7e34402ccdf3414f64c50365436eba7b93).

I have done some basic testing for a lot of the drivers and filesystems,
but I wanted to get comments before trying to track down more hardware/
systems for testing.


Known issues:
- REQ_FLUSH is still a flag, but should probably be a operation.
 For lower level drivers like SCSI where we only get a flush, it makes
more sense to be a operation. However, upper layers like filesystems
can send down flushes with writes, so it is more of a flag for them.
I am still working on this.

- There is a regression with the dm flakey target. It currently
cannot corrupt the operation values.

- The patchset is a little awkward. It touches so much code,
but I wanted to maintain git bisectibility, so there is lots of compat code
left around until the last patches where everyting is cleaned up.
