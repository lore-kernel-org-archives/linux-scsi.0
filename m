From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] bsg: fix shadow warning in bsg_ioctl()
Date: Thu, 23 Oct 2014 18:53:47 +0200
Message-ID: <1414083227-9922-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

directly call scsi_cmd_ioctl() with (void __user *)arg instead
of uarg redeclaration.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/bsg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 276e869..c2f90bd 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -921,10 +921,9 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
-	case SCSI_IOCTL_SEND_COMMAND: {
-		void __user *uarg = (void __user *) arg;
-		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd, uarg);
-	}
+	case SCSI_IOCTL_SEND_COMMAND:
+		return scsi_cmd_ioctl(bd->queue, NULL, file->f_mode, cmd,
+				      (void __user *)arg);
 	case SG_IO: {
 		struct request *rq;
 		struct bio *bio, *bidi_bio = NULL;
-- 
1.9.3
