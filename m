From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/33] crypto: don't pollute the global namespace with sg_next()
Date: Mon, 16 Jul 2007 11:47:15 +0200
Message-ID: <1184579267914-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbXGPJsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:31 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>

It's a subsystem function, prefix it as such.

Cc: James Morris <jmorris@namei.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 crypto/digest.c      |    2 +-
 crypto/scatterwalk.c |    2 +-
 crypto/scatterwalk.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/digest.c b/crypto/digest.c
index 1bf7414..e56de67 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -77,7 +77,7 @@ static int update2(struct hash_desc *desc,
 
 		if (!nbytes)
 			break;
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	return 0;
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 81afd17..2e51f82 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -70,7 +70,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		walk->offset += PAGE_SIZE - 1;
 		walk->offset &= PAGE_MASK;
 		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, sg_next(walk->sg));
+			scatterwalk_start(walk, scatterwalk_sg_next(walk->sg));
 	}
 }
 
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index f1592cc..e049c62 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -20,7 +20,7 @@
 
 #include "internal.h"
 
-static inline struct scatterlist *sg_next(struct scatterlist *sg)
+static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
 	return (++sg)->length ? sg : (void *)sg->page;
 }
-- 
1.5.3.rc0.90.gbaa79

