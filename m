From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] bsg: fix oops on remove
Date: Mon, 07 Jul 2008 15:50:01 -0500
Message-ID: <1215463801.3274.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58867 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbYGGUuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2008 16:50:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <Jens.Axboe@oracle.com>

If you do a modremove of any sas driver, you run into an oops on
shutdown when the host is removed (coming from the host bsg device).
The root cause seems to be that there's a use after free of the
bsg_class_device:  In bsg_kref_release_function, this is used (to do a
put_device(bcg->parent) after bcg->release has been called.  In sas (and
possibly many other things) bcd->release frees the queue which contains
the bsg_class_device, so we get a put_device on unreferenced memory.
Fix this by taking a copy of the pointer to the parent before releasing
bsg.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/block/bsg.c b/block/bsg.c
index 7cdec32..0526471 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -709,11 +709,12 @@ static void bsg_kref_release_function(struct kref *kref)
 {
 	struct bsg_class_device *bcd =
 		container_of(kref, struct bsg_class_device, ref);
+	struct device *parent = bcd->parent;
 
 	if (bcd->release)
 		bcd->release(bcd->parent);
 
-	put_device(bcd->parent);
+	put_device(parent);
 }
 
 static int bsg_put_device(struct bsg_device *bd)


