From: akpm@linux-foundation.org
Subject: [patch for 2.6.32? 2/3] scsi: fix crash when disconnecting usb storage
Date: Tue, 17 Nov 2009 14:10:11 -0800
Message-ID: <200911172210.nAHMABna014259@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353AbZKQWLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru, alan@lxorguk.ukuu.org.uk, den@openvz.org, stern@rowland.harvard.edu

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

__scsi_remove_device() in scsi_forget_host() is executed out of scan_mutex
and races with scsi_destroy_sdev() <- scsi_sysfs_add_devices() <-
scsi_finish_async_scan().  The result is use after free and/or double
free, oops.

The fix is simple, move scsi_forget_host() under scan_mutex.

scsi_forget_host() is just sequence of __scsi_remove_device().  All
another calls of __scsi_remove_device() are made under scan_mutex.  So
that it is safe.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hosts.c~scsi-fix-crash-when-disconnecting-usb-storage drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-fix-crash-when-disconnecting-usb-storage
+++ a/drivers/scsi/hosts.c
@@ -164,8 +164,8 @@ void scsi_remove_host(struct Scsi_Host *
 			return;
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
 	scsi_forget_host(shost);
+	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
_
