From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] aacraid: use kthread_ API
Date: Tue, 14 Feb 2006 19:00:41 +0100
Message-ID: <20060214180041.GA19306@lst.de>
References: <20060214174506.GA18919@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:46541 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1422733AbWBNSAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 13:00:49 -0500
Content-Disposition: inline
In-Reply-To: <20060214174506.GA18919@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2006 at 06:45:06PM +0100, Christoph Hellwig wrote:
> Use the kthread_ API instead of opencoding lots of hairy code for kernel
> thread creation and teardown.

Followon patch to avoid the hardcoded aacraid string as kthread_run
argument.


Index: linux-2.6/drivers/scsi/aacraid/linit.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/linit.c	2006-02-14 16:24:17.000000000 +0100
+++ linux-2.6/drivers/scsi/aacraid/linit.c	2006-02-14 18:59:21.000000000 +0100
@@ -823,7 +823,7 @@
 	/*
 	 *	Start any kernel threads needed
 	 */
-	aac->thread = kthread_run(aac_command_thread, aac, "aacraid");
+	aac->thread = kthread_run(aac_command_thread, aac, AAC_DRIVERNAME);
 	if (IS_ERR(aac->thread)) {
 		printk(KERN_ERR "aacraid: Unable to create command thread.\n");
 		error = PTR_ERR(aac->thread);
