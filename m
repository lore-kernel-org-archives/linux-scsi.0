From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: module: fix module_refcount() return when running in a module exit routine
Date: Fri, 23 Jan 2015 13:24:15 +1030
Message-ID: <87iofyurzc.fsf@rustcorp.com.au>
References: <1421600146.2080.8.camel@HansenPartnership.com> <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au> <1421683701.2080.25.camel@HansenPartnership.com> <871tmqcmau.fsf@rustcorp.com.au> <1421774615.2080.88.camel@HansenPartnership.com> <20150122165018.GA27377@infradead.org> <1421946175.2093.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35159 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbbAWDKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2015 22:10:22 -0500
In-Reply-To: <1421946175.2093.1.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> On Thu, 2015-01-22 at 08:50 -0800, Christoph Hellwig wrote:
>> We'll also still need to change scsi_device_put to deal with
>> a negative refcount..
>
> I don't believe so ... we never call module_refcount() now, and the
> actual module ref count never goes negative.  That's the point of
> Rusty's change.  In the unload routines, the actual module refcount is
> zero.  __module_get() will increment this and the final module_put()
> will decrement it without triggering a warning.
>
> In the old code, we expected try_module_get() to fail but then used
> module_refcount() to detect the failure and not do a put.

Yep, I've put that patch in my fixes queue now.

Thanks,
Rusty.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: scsi: always increment reference count

James reported:
> After e513cc1 module: Remove stop_machine from module unloading,
> module_refcount() is returning (unsigned long)-1 when called from within
> a routine that runs in module_exit.  This is confusing the scsi device
> put code which is coded to detect a module_refcount() of zero for
> running within a module exit routine and not try to do another
> module_put.  The fix is to restore the original behaviour of
> module_refcount() and return zero if we're running inside an exit
> routine.

The correct fix is to turn try_module_get() into __module_get(), and
always do the module_put().

Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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
