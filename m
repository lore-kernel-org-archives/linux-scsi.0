From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 14:30:49 -0600
Message-ID: <1135369849.3728.39.camel@mulgrave>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	 <20051222221329.5f317b8d.akpm@osdl.org>
	 <20051223200532.GI1112@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16576 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161038AbVLWUbK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 15:31:10 -0500
In-Reply-To: <20051223200532.GI1112@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 12:05 -0800, Andrew Vasquez wrote:
> 	EIP is at sysfs_hash_and_remove+0x31/0x11f
> 	eax: 00000000   ebx: 6b6b6b6b   ecx: 00000000   edx: ee6aac68
> 	esi: 6b6b6b6b   edi: f8839d44   ebp: f8839cc0   esp: c1af7e98
> 	ds: 007b   es: 007b   ss: 0068
> 	Process events/2 (pid: 16, threadinfo=c1af7000 task=c1aef030)
> 	Stack: c03998d2 00000063 eb6a0e2c eb6a0e24 f8839d44 f8839cc0 c025877b e640aac0 
> 	       ee000f5c ee000f5c 00000000 f8839cc0 f332e178 eb6a0e24 c025ab08 c025ab39 
> 	       eb6a0e24 c0370606 eb6a0e00 f332e178 c1af7f00 e5a872dc c025a722 f332e178 
> 	Call Trace:
> 	 [<c025877b>] class_device_del+0x138/0x163
> 	 [<c025ab08>] transport_remove_classdev+0x0/0x68

This one is the signal for class devices being deleted *after* the
underlying device has been deleted, so the class device delete oopses
trying to remove the symlink from the real device to the class device.

Strange it should show up now, since that particular piece of code
hasn't been altered, just moved into a work queue.

See if the attached fixes it (if it does, I'm mystified as to why you
haven't always seen this).

James

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -418,8 +418,9 @@ static void scsi_target_reap_work(void *
 	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
 		list_del_init(&starget->siblings);
 		spin_unlock_irqrestore(shost->host_lock, flags);
+		transport_remove_device(&starget->dev);
 		device_del(&starget->dev);
-		transport_unregister_device(&starget->dev);
+		transport_destroy_device(&starget->dev);
 		put_device(&starget->dev);
 		return;
 


