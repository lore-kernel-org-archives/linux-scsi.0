From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 11/11] scsi: Silence unnecessary warnings about ioctl to partition
Date: Thu,  6 Dec 2012 16:57:07 -0800
Message-ID: <20121207005616.809919764@linuxfoundation.org>
References: <20121207005613.189054768@linuxfoundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61767 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423263Ab2LGA5v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 19:57:51 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so4882375pbc.19
        for <linux-scsi@vger.kernel.org>; Thu, 06 Dec 2012 16:57:51 -0800 (PST)
In-Reply-To: <20121207005613.189054768@linuxfoundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-scsi@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

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

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
CC: James Bottomley <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/scsi_ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -722,11 +722,14 @@ int scsi_verify_blk_ioctl(struct block_d
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
 


