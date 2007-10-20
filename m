From: michaelc@cs.wisc.edu
Subject: reserve mem for REQ_TYPE_BLOCK_PC reqs and covert sg to
	block/bio helpers
Date: Sat, 20 Oct 2007 00:44:34 -0500
Message-ID: <11928590843394-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

This patchset has to goals. The first is to be able to reserve
memory (bio, bio vec and pages), for REQ_TYPE_BLOCK_PC commands.
This is needed for multipath where we need to make forward
progress when failing over the device. And it is needed if all
the paths are failed and we need userspace or the scsi layer
to send IO. Userspace multipathd does path testing and
userspace and the scsi layer send commands that are needed to setup
new devices (if dev_loss_tmo fires and devices are removed, we need to
be able to readd them).

The second goal is to convert sg, st and osst to the blk and bio
layer helpers to map and copy data.

I am not done testing the patchset. The first two patches are ok
and are pretty safe since they only add biosets to the bio layer.

0005-have-block-scsi_ioctl-user-GFP_NOIO.patch,
0006-use-GFP_NOIO-in-dm-rdac.patch and
0007-fix-blk_rq_map_user_iov-bounce-code.patch
are also pretty safe, but they are built on other patches since
I noticed them while testing my patches and I can rediff them.

Since the last time I sent the patches, I killed the bio_reserve_buffer
junk and replaced it with biosets and a mempool. And before I finish up
testing and start on st, I wanted to get comments since I am pretty happy
overall with the patches. I want to figure out better names for the
functions and maybe merge some other functions like the blk_rq_map_iov
with the old blk_map_user, but I can at least do the latter in another patch.

My only major bug concern is if blk_copy_user_iov only works for request
that go to the scsi layer. In the original code, bio_copy_user
copied the bv_len to a second struct, but for requests going
to the scsi layer this is not needed because we always complete
the whole request in one call (__end_that request will never
modify bv_len and do a recalc). I am not done grepping through
the other possble users like IDE.
