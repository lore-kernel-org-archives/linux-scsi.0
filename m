From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: minor bug fixes
Date: Fri, 30 Mar 2007 17:36:26 +0900
Message-ID: <20070330173626P.fujita.tomonori@lab.ntt.co.jp>
References: <20070330103902U.fujita.tomonori@lab.ntt.co.jp>
	<20070330063804.GE6320@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:44340 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbXC3Igj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 04:36:39 -0400
In-Reply-To: <20070330063804.GE6320@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: minor bug fixes
Date: Fri, 30 Mar 2007 08:38:04 +0200

> On Fri, Mar 30 2007, FUJITA Tomonori wrote:
> > This fixes the following minor issues:
> > 
> > - When bsg_register_queue is called with a request queue that doesn't
> > have request_fn, it returns -EINVAL instead of zero.
> 
> Seems a little backwards, you wont be able to talk to the device then.

What do you mean? All the devices that we might bind to bsg has
request_fn?


> So, what is the purpose of this patch?

When I wrote a SMP pass through interface via bsg, I thought that it
would be better to return an error instead of success when we call
bsg_register_queue with a request queue that doesn't have a
request_fn.


Anyway, it doesn't matter much. Here is a new version.

---
>From db616d88a5e180a6be4928ba66947e501da581fa Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 30 Mar 2007 17:24:35 +0900
Subject: [PATCH] bsg: minor bug fixes

This fixes the following minor issues:

- add EXPORT_SYMBOL_GPL for bsg_register_queue and
bsg_unregister_queue.

- shut up gcc warnings

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c         |    4 +++-
 include/linux/bsg.h |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 4ef3cc5..a333c93 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -961,8 +961,9 @@ void bsg_unregister_queue(struct request
 	bsg_device_nr--;
 	mutex_unlock(&bsg_mutex);
 }
+EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
-int bsg_register_queue(struct request_queue *q, char *name)
+int bsg_register_queue(struct request_queue *q, const char *name)
 {
 	struct bsg_class_device *bcd, *__bcd;
 	dev_t dev;
@@ -1025,6 +1026,7 @@ err:
 	mutex_unlock(&bsg_mutex);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(bsg_register_queue);
 
 static int bsg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
 {
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index 0475a6d..0dd01f9 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -51,7 +51,7 @@ struct bsg_class_device {
 	struct request_queue *queue;
 };
 
-extern int bsg_register_queue(struct request_queue *, char *);
+extern int bsg_register_queue(struct request_queue *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
 struct bsg_class_device { };
-- 
1.4.3.2

