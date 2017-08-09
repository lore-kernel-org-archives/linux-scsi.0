From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [RFC PATCH 3/6] bsg: scsi-transport: add compile-tests to prevent reply-buffer overflows
Date: Wed,  9 Aug 2017 16:11:17 +0200
Message-ID: <0f448e7771f438025de755530778691ff535e36c.1502120928.git.bblock@linux.vnet.ibm.com>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

The BSG implementations use the bsg_job's reply buffer as storage for their
own custom reply structures (e.g.: struct fc_bsg_reply or
struct iscsi_bsg_reply). The size of bsg_job's reply buffer and those of
the implementations is not dependent in any way the compiler can currently
check.

To make it easier to notice accidental violations add an explicit compile-
time check that tests whether the implementations' reply buffer is at most
as large as bsg_job's.

To do so, we have to move the size-define from bsg.c to a common header.

Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 block/bsg.c                         | 3 +--
 drivers/scsi/scsi_transport_fc.c    | 3 +++
 drivers/scsi/scsi_transport_iscsi.c | 3 +++
 include/linux/bsg-lib.h             | 2 ++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 285b1b8126c3..b924f1c23c58 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -20,6 +20,7 @@
 #include <linux/uio.h>
 #include <linux/idr.h>
 #include <linux/bsg.h>
+#include <linux/bsg-lib.h>
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
@@ -74,8 +75,6 @@ static int bsg_major;
 
 static struct kmem_cache *bsg_cmd_cachep;
 
-#define BSG_COMMAND_REPLY_BUFFERSIZE	SCSI_SENSE_BUFFERSIZE
-
 /*
  * our internal command type
  */
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 892fbd9800d9..ce6654b5d329 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3736,6 +3736,9 @@ static int fc_bsg_dispatch(struct bsg_job *job)
 {
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 
+	BUILD_BUG_ON(sizeof(struct fc_bsg_reply) >
+		     BSG_COMMAND_REPLY_BUFFERSIZE);
+
 	if (scsi_is_fc_rport(job->dev))
 		return fc_bsg_rport_dispatch(shost, job);
 	else
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a424eaeafeb0..4e021c949ad7 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1483,6 +1483,9 @@ static int iscsi_bsg_host_dispatch(struct bsg_job *job)
 	int cmdlen = sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 
+	BUILD_BUG_ON(sizeof(struct iscsi_bsg_reply) >
+		     BSG_COMMAND_REPLY_BUFFERSIZE);
+
 	/* check if we have the msgcode value at least */
 	if (job->request_len < sizeof(uint32_t)) {
 		ret = -ENOMSG;
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index e34dde2da0ef..85d7c7678cc6 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -25,6 +25,8 @@
 
 #include <linux/blkdev.h>
 
+#define BSG_COMMAND_REPLY_BUFFERSIZE	SCSI_SENSE_BUFFERSIZE
+
 struct request;
 struct device;
 struct scatterlist;
-- 
2.12.2
