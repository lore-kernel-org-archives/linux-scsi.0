From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/11] zfcp: remove some __attribute__ ((packed))
Date: Mon, 19 May 2008 12:17:46 +0200
Message-ID: <20080519101833.535770000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:56415 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYESKSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:37 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_cleanup_packed_attributes.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

There is no need to pack data structures which describe the
contents of records in the new recovery trace.

lcrash currently depends on the binary format for the other traces,
removing the packed attribute from all traces would break trace
debugging with lcrash.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:35:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-05-19 11:36:54.000000000 +0200
@@ -38,7 +38,7 @@ struct zfcp_rec_dbf_record_thread {
 	u32 total;
 	u32 ready;
 	u32 running;
-} __attribute__ ((packed));
+};
 
 struct zfcp_rec_dbf_record_target {
 	u64 ref;
@@ -47,7 +47,7 @@ struct zfcp_rec_dbf_record_target {
 	u64 wwpn;
 	u64 fcp_lun;
 	u32 erp_count;
-} __attribute__ ((packed));
+};
 
 struct zfcp_rec_dbf_record_trigger {
 	u8 want;
@@ -59,14 +59,14 @@ struct zfcp_rec_dbf_record_trigger {
 	u64 action;
 	u64 wwpn;
 	u64 fcp_lun;
-} __attribute__ ((packed));
+};
 
 struct zfcp_rec_dbf_record_action {
 	u32 status;
 	u32 step;
 	u64 action;
 	u64 fsf_req;
-} __attribute__ ((packed));
+};
 
 struct zfcp_rec_dbf_record {
 	u8 id;
@@ -77,7 +77,7 @@ struct zfcp_rec_dbf_record {
 		struct zfcp_rec_dbf_record_target target;
 		struct zfcp_rec_dbf_record_trigger trigger;
 	} u;
-} __attribute__ ((packed));
+};
 
 enum {
 	ZFCP_REC_DBF_ID_ACTION,

-- 
