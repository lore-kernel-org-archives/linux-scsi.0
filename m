From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC C 5/5] libosd: Remove deprecated bio based API
Date: Thu, 19 Mar 2009 16:38:26 +0200
Message-ID: <49C258E2.1010106@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6648 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754488AbZCSOjl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:39:41 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


Feel good be happy

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   14 --------------
 include/scsi/osd_initiator.h     |    6 ------
 2 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d18402c..14ab901 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -679,13 +679,6 @@ EXPORT_SYMBOL(osd_req_remove_object);
 	struct osd_obj_id *first, struct osd_obj_id_list *list, unsigned nelem);
 */
 
-void osd_req_write_old(struct osd_request *or,
-	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
-{
-	BUG_ON(1);
-}
-EXPORT_SYMBOL(osd_req_write_old);
-
 void osd_req_write(struct osd_request *or,
 	const struct osd_obj_id *obj, const struct osd_pages_array *opa,
 	u64 offset)
@@ -736,13 +729,6 @@ void osd_req_flush_object(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_flush_object);
 
-void osd_req_read_old(struct osd_request *or,
-	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
-{
-	BUG_ON(1);
-}
-EXPORT_SYMBOL(osd_req_read_old);
-
 void osd_req_read(struct osd_request *or,
 	const struct osd_obj_id *obj, const struct osd_pages_array *opa,
 	u64 offset)
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index fa32074..db96847 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -377,9 +377,6 @@ void osd_req_set_member_attrs(struct osd_request *or, ...);/* V2-only NI */
 void osd_req_create_object(struct osd_request *or, struct osd_obj_id *);
 void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *);
 
-void __deprecated osd_req_write_old(struct osd_request *or,
-	const struct osd_obj_id *, struct bio *data_out, u64 offset);
-
 void osd_req_write(struct osd_request *or,
 	const struct osd_obj_id *, const struct osd_pages_array *opa,
 	u64 offset);
@@ -398,9 +395,6 @@ void osd_req_flush_object(struct osd_request *or,
 	const struct osd_obj_id *, enum osd_options_flush_scope_values,
 	/*V2*/ u64 offset, /*V2*/ u64 len);
 
-void __deprecated osd_req_read_old(struct osd_request *or,
-	const struct osd_obj_id *, struct bio *data_in, u64 offset);
-
 void osd_req_read(struct osd_request *or,
 	const struct osd_obj_id *, const struct osd_pages_array *opa_in,
 	u64 offset);
-- 
1.6.2.1


