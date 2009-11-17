From: akpm@linux-foundation.org
Subject: [patch for 2.6.32? 1/3] scsi_lib.c: avoid calling scsi_device_put() from under ->host_lock
Date: Tue, 17 Nov 2009 14:10:10 -0800
Message-ID: <200911172210.nAHMAAYJ014147@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbZKQWKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:10:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, strakh@ispras.ru, jens.axboe@oracle.com

From: Alexander Strakh <strakh@ispras.ru>

Driver scsi_lib.c might sleep in atomic context, because it calls
scsi_device_put under spin_lock_irqsave.

drivers/scsi/scsi_lib.c:356:
	spin_lock_irqsave(shost->host_lock, flags);
	scsi_device_put(sdev);
Path to might_sleep macro from scsi_device_put:
1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111
2. put_device calls kobject_put at ./drivers/base/core.c:1038
3. kobject_put calls kref_put at ./lib/kobject.c
4. kref_put may call callback function kobject_release at ./lib/kref.c if
refcount becomes zero, which might_sleep because it calls user event. Details:
	4.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
	4.2 kobject_uevent calls kobject_uevent_env at  ./lib/kobject_uevent.c:282
	4.3 kobject_uevent_env calls call_usermodehelper_exec at
./include/linux/kmod.h:83
	4.4 call_usermodehelper_exec calls wait_for_completion at
./kernel/kmod.c:481
	4.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
	4.5 wait_for_common calls might_sleep at ./kernels/sched.c:5692

Found by Linux Driver Verification project.

Delete wrong sleeping function calls.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock
+++ a/drivers/scsi/scsi_lib.c
@@ -353,9 +353,9 @@ static void scsi_single_lun_run(struct s
 
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		blk_run_queue(sdev->request_queue);
-		spin_lock_irqsave(shost->host_lock, flags);
 	
 		scsi_device_put(sdev);
+		spin_lock_irqsave(shost->host_lock, flags);
 	}
  out:
 	spin_unlock_irqrestore(shost->host_lock, flags);
_
