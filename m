From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 02/33] Add sg helpers for iterating over a scatterlist table
Date: Mon, 16 Jul 2007 11:47:16 +0200
Message-ID: <11845792671450-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9286 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853AbXGPJsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:31 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

First step to being able to change the scatterlist setup without
having to modify drivers (a lot :-)

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4efbd9c..bed5ab4 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,4 +20,13 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
+#define sg_next(sg)		((sg) + 1)
+#define sg_last(sg, nents)	(&(sg[(nents) - 1]))
+
+/*
+ * Loop over each sg element, following the pointer to a new list if necessary
+ */
+#define for_each_sg(sglist, sg, nr, __i)	\
+	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.3.rc0.90.gbaa79

