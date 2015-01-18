From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: module: fix module_refcount() return when running in a module exit routine
Date: Mon, 19 Jan 2015 10:07:54 +1030
Message-ID: <87ppabd5il.fsf@rustcorp.com.au>
References: <1421600146.2080.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:47555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbbARXwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2015 18:52:05 -0500
In-Reply-To: <1421600146.2080.8.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> From: James Bottomley <JBottomley@Parallels.com>
>
> After e513cc1 module: Remove stop_machine from module unloading,
> module_refcount() is returning (unsigned long)-1 when called from within
> a routine that runs in module_exit.  This is confusing the scsi device
> put code which is coded to detect a module_refcount() of zero for
> running within a module exit routine and not try to do another
> module_put.  The fix is to restore the original behaviour of
> module_refcount() and return zero if we're running inside an exit
> routine.

I think this code used to be wrong, if someone used rmmod --wait.
Fortunately nobody ever did that, so we removed the feature in 2013 and
your code was OK again :)

But I think the correct fix is the same: turn try_module_get() into
__module_get():

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e02885451425..9b3829931f40 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -986,9 +986,9 @@ int scsi_device_get(struct scsi_device *sdev)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
-	/* We can fail this if we're doing SCSI operations
+	/* We can fail try_module_get if we're doing SCSI operations
 	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	__module_get(sdev->host->hostt->module);
 
 	return 0;
 }
@@ -1004,14 +1004,7 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-#ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
-
-	/* The module refcount will be zero if scsi_device_get()
-	 * was called from a module removal routine */
-	if (module && module_refcount(module) != 0)
-		module_put(module);
-#endif
+	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);
