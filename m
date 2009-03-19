From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC C 2/5] libosd: Rename osd_req_write/read to osd_req_write/read_old
Date: Thu, 19 Mar 2009 16:34:41 +0200
Message-ID: <49C25801.5040000@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:9155 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754117AbZCSOhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:37:05 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


In an attempt to not use bio(s) at the initiator, we want
to convert to something else (array of page pointers).
This patch renames the current bio API to xxx_old.

The next patch will implement the new API.
After all Kernel users (exofs) will convert to the new API
The old can be removed.

The API is marked __deprecated and will spew warnings until
conversion is done.

Note that this patch patches all users (exofs)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    4 ++++
 fs/exofs/common.h                |    4 ++++
 include/scsi/osd_initiator.h     |    4 ++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index ccfd347..8885524 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -52,6 +52,10 @@
 #    define __unused			__attribute__((unused))
 #endif
 
+/* FIXME: Temporarly until next patch */
+#define osd_req_write osd_req_write_old
+#define osd_req_read  osd_req_read_old
+
 enum { OSD_REQ_RETRIES = 1 };
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
diff --git a/fs/exofs/common.h b/fs/exofs/common.h
index 8a56338..f02cb4c 100644
--- a/fs/exofs/common.h
+++ b/fs/exofs/common.h
@@ -44,6 +44,10 @@
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
 
+/* FIXME: Temporarly until exofs tree syncs with scsi-misc's osd_initiator */
+#define osd_req_write osd_req_write_old
+#define osd_req_read  osd_req_read_old
+
 /****************************************************************************
  * Object ID related defines
  * NOTE: inode# = object ID - EXOFS_OBJ_OFF
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 6132790..7a317aa 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -362,7 +362,7 @@ void osd_req_set_member_attrs(struct osd_request *or, ...);/* V2-only NI */
 void osd_req_create_object(struct osd_request *or, struct osd_obj_id *);
 void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *);
 
-void osd_req_write(struct osd_request *or,
+void __deprecated osd_req_write_old(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_out, u64 offset);
 int osd_req_write_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
@@ -379,7 +379,7 @@ void osd_req_flush_object(struct osd_request *or,
 	const struct osd_obj_id *, enum osd_options_flush_scope_values,
 	/*V2*/ u64 offset, /*V2*/ u64 len);
 
-void osd_req_read(struct osd_request *or,
+void __deprecated osd_req_read_old(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_in, u64 offset);
 int osd_req_read_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
-- 
1.6.2.1


