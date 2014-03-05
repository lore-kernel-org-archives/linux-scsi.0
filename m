From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 11/13] SCSI/libiscsi: Add check_protection callback for transports
Date: Wed,  5 Mar 2014 19:43:49 +0200
Message-ID: <1394041431-28399-12-git-send-email-sagig@mellanox.com>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:59711 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754855AbaCERoC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 12:44:02 -0500
In-Reply-To: <1394041431-28399-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org, michaelc@cs.wisc.edu
Cc: martin.petersen@oracle.com, oren@mellanox.com, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

iSCSI needs to be at least aware that a task involves protection
information. In case it does, after the transaction completed
libiscsi will ask the transport to check the protection status
of the transaction.

Unlike transport errors, DIF errors should not prevent successful
completion of the transaction from the transport point of view,
but should be escelated to scsi mid-layer when constructing the
scsi result and sense data.

check_protection routine will return the ascq corresponding to the
DIF error that occured (or 0 if no error happened).

return ascq:
- 0x1: GUARD_CHECK_FAILED
- 0x2: APPTAG_CHECK_FAILED
- 0x3: REFTAG_CHECK_FAILED

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Alex Tabachnik <alext@mellanox.com>
---
 drivers/scsi/libiscsi.c             |   32 ++++++++++++++++++++++++++++++++
 include/scsi/libiscsi.h             |    4 ++++
 include/scsi/scsi_transport_iscsi.h |    1 +
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4046241..3c11acf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -395,6 +395,10 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		if (rc)
 			return rc;
 	}
+
+	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
+		task->protected = true;
+
 	if (sc->sc_data_direction == DMA_TO_DEVICE) {
 		unsigned out_len = scsi_out(sc)->length;
 		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
@@ -823,6 +827,33 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 	sc->result = (DID_OK << 16) | rhdr->cmd_status;
 
+	if (task->protected) {
+		sector_t sector;
+		u8 ascq;
+
+		/**
+		 * Transports that didn't implement check_protection
+		 * callback but still published T10-PI support to scsi-mid
+		 * deserve this BUG_ON.
+		 **/
+		BUG_ON(!session->tt->check_protection);
+
+		ascq = session->tt->check_protection(task, &sector);
+		if (ascq) {
+			sc->result = DRIVER_SENSE << 24 |
+				     SAM_STAT_CHECK_CONDITION;
+			scsi_build_sense_buffer(1, sc->sense_buffer,
+						ILLEGAL_REQUEST, 0x10, ascq);
+			sc->sense_buffer[7] = 0xc; /* Additional sense length */
+			sc->sense_buffer[8] = 0;   /* Information desc type */
+			sc->sense_buffer[9] = 0xa; /* Additional desc length */
+			sc->sense_buffer[10] = 0x80; /* Validity bit */
+
+			put_unaligned_be64(sector, &sc->sense_buffer[12]);
+			goto out;
+		}
+	}
+
 	if (rhdr->response != ISCSI_STATUS_CMD_COMPLETED) {
 		sc->result = DID_ERROR << 16;
 		goto out;
@@ -1567,6 +1598,7 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
 	task->have_checked_conn = false;
 	task->last_timeout = jiffies;
 	task->last_xfer = jiffies;
+	task->protected = false;
 	INIT_LIST_HEAD(&task->running);
 	return task;
 }
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 309f513..1457c26 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -133,6 +133,10 @@ struct iscsi_task {
 	unsigned long		last_xfer;
 	unsigned long		last_timeout;
 	bool			have_checked_conn;
+
+	/* T10 protection information */
+	bool			protected;
+
 	/* state set/tested under session->lock */
 	int			state;
 	atomic_t		refcount;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 88640a4..2555ee5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -167,6 +167,7 @@ struct iscsi_transport {
 				 struct iscsi_bus_flash_conn *fnode_conn);
 	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
 	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
+	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
 };
 
 /*
-- 
1.7.1

