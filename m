From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: git-scsi-misc oops
Date: Wed, 06 Sep 2006 09:00:29 -0500
Message-ID: <1157551229.3469.4.camel@mulgrave.il.steeleye.com>
References: <20060905231933.3371cd8a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5002 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751053AbWIFOAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 10:00:35 -0400
In-Reply-To: <20060905231933.3371cd8a.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-05 at 23:19 -0700, Andrew Morton wrote:
> aic79xxx isn't happy.  Using
> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git,
> no other patches applied.

Try this, please:

James

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index eedfd05..c35f5fc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -873,10 +873,12 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
+	struct module *module = sdev->host->hostt->module;
+
 	/* The module refcount will be zero if scsi_device_get()
 	 * was called from a module removal routine */
-	if (likely(module_refcount(sdev->host->hostt->module) != 0))
-		module_put(sdev->host->hostt->module);
+	if (module && module_refcount(module) != 0)
+		module_put(module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);


