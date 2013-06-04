From: Willy Tarreau <w@1wt.eu>
Subject: [ 078/184] scsi: Silence unnecessary warnings about ioctl to
Date: Tue, 04 Jun 2013 19:22:48 +0200
Message-ID: <20130604172133.538760934@1wt.eu>
References: <58df134a4b98edf5b0073e2e1e988fe6@local>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Ben Hutchings <ben@decadent.org.uk>, Thomas Bork <tom@eisfair.net>, Willy Tarreau <w@1wt.eu>
List-Id: linux-scsi@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 partition

From: Jan Kara <jack@suse.cz>

commit 6d9359280753d2955f86d6411047516a9431eb51 upstream.

Sometimes, warnings about ioctls to partition happen often enough that they
form majority of the warnings in the kernel log and users complain. In some
cases warnings are about ioctls such as SG_IO so it's not good to get rid of
the warnings completely as they can ease debugging of userspace problems
when ioctl is refused.

Since I have seen warnings from lots of commands, including some proprietary
userspace applications, I don't think disallowing the ioctls for processes
with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: James Bottomley <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[bwh: Backported to 3.2: use ENOTTY, not ENOIOCTLCMD]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
(cherry picked from commit f45c9a6eec20cd712421c442785e7a4e9215a230)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 block/scsi_ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2be0a97..123eb17 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -720,11 +720,14 @@ int scsi_verify_blk_ioctl(struct block_device *bd, unsigned int cmd)
 		break;
 	}
 
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
 	/* In particular, rule out all resets and host-specific ioctls.  */
 	printk_ratelimited(KERN_WARNING
 			   "%s: sending ioctl %x to a partition!\n", current->comm, cmd);
 
-	return capable(CAP_SYS_RAWIO) ? 0 : -ENOTTY;
+	return -ENOTTY;
 }
 EXPORT_SYMBOL(scsi_verify_blk_ioctl);
 
-- 
1.7.12.2.21.g234cd45.dirty
