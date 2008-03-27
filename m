From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/11] zfcp: Register new recovery trace.
Date: Thu, 27 Mar 2008 14:22:00 +0100
Message-ID: <20080327133027.050312000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:57790 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396AbYC0Na3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:29 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_register.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch registers the new recovery trace with the s390 debug
feature.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |    1 +
 drivers/s390/scsi/zfcp_dbf.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h |   10 ++++++++++
 3 files changed, 53 insertions(+)

--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -279,6 +279,13 @@ struct zfcp_erp_dbf_record {
 	u8 dummy[16];
 } __attribute__ ((packed));
 
+struct zfcp_rec_dbf_record {
+	u8 id;
+	u8 id2;
+	union {
+	} u;
+} __attribute__ ((packed));
+
 struct zfcp_hba_dbf_record_response {
 	u32 fsf_command;
 	u64 fsf_reqid;
@@ -917,14 +924,17 @@ struct zfcp_adapter {
 						      for memory */
 	struct zfcp_port	*nameserver_port;  /* adapter's nameserver */
 	debug_info_t		*erp_dbf;
+	debug_info_t		*rec_dbf;
 	debug_info_t		*hba_dbf;
 	debug_info_t		*san_dbf;          /* debug feature areas */
 	debug_info_t		*scsi_dbf;
 	spinlock_t		erp_dbf_lock;
+	spinlock_t		rec_dbf_lock;
 	spinlock_t		hba_dbf_lock;
 	spinlock_t		san_dbf_lock;
 	spinlock_t		scsi_dbf_lock;
 	struct zfcp_erp_dbf_record	erp_dbf_buf;
+	struct zfcp_rec_dbf_record	rec_dbf_buf;
 	struct zfcp_hba_dbf_record	hba_dbf_buf;
 	struct zfcp_san_dbf_record	san_dbf_buf;
 	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -520,6 +520,36 @@ static struct debug_view zfcp_hba_dbf_vi
 	NULL
 };
 
+static const char *zfcp_rec_dbf_tags[] = {
+};
+
+static const char *zfcp_rec_dbf_ids[] = {
+};
+
+static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
+				    char *buf, const char *_rec)
+{
+	struct zfcp_rec_dbf_record *r = (struct zfcp_rec_dbf_record *)_rec;
+	char *p = buf;
+
+	zfcp_dbf_outs(&p, "tag", zfcp_rec_dbf_tags[r->id]);
+	zfcp_dbf_outs(&p, "hint", zfcp_rec_dbf_ids[r->id2]);
+	zfcp_dbf_out(&p, "id", "%d", r->id2);
+	switch (r->id) {
+	}
+	sprintf(p, "\n");
+	return (p - buf) + 1;
+}
+
+static struct debug_view zfcp_rec_dbf_view = {
+	"structured",
+	NULL,
+	&zfcp_dbf_view_header,
+	&zfcp_rec_dbf_view_format,
+	NULL,
+	NULL
+};
+
 static void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
 			      u32 s_id, u32 d_id, void *buffer, int buflen)
@@ -934,6 +964,16 @@ int zfcp_adapter_debug_register(struct z
 	debug_register_view(adapter->erp_dbf, &debug_hex_ascii_view);
 	debug_set_level(adapter->erp_dbf, 3);
 
+	/* debug feature area which records recovery activity */
+	sprintf(dbf_name, "zfcp_%s_rec", zfcp_get_busid_by_adapter(adapter));
+	adapter->rec_dbf = debug_register(dbf_name, dbfsize, 1,
+					  sizeof(struct zfcp_rec_dbf_record));
+	if (!adapter->rec_dbf)
+		goto failed;
+	debug_register_view(adapter->rec_dbf, &debug_hex_ascii_view);
+	debug_register_view(adapter->rec_dbf, &zfcp_rec_dbf_view);
+	debug_set_level(adapter->rec_dbf, 3);
+
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
 	sprintf(dbf_name, "zfcp_%s_hba", zfcp_get_busid_by_adapter(adapter));
 	adapter->hba_dbf = debug_register(dbf_name, dbfsize, 1,
@@ -981,10 +1021,12 @@ void zfcp_adapter_debug_unregister(struc
 	debug_unregister(adapter->scsi_dbf);
 	debug_unregister(adapter->san_dbf);
 	debug_unregister(adapter->hba_dbf);
+	debug_unregister(adapter->rec_dbf);
 	debug_unregister(adapter->erp_dbf);
 	adapter->scsi_dbf = NULL;
 	adapter->san_dbf = NULL;
 	adapter->hba_dbf = NULL;
+	adapter->rec_dbf = NULL;
 	adapter->erp_dbf = NULL;
 }
 
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -1034,6 +1034,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 	spin_lock_init(&adapter->hba_dbf_lock);
 	spin_lock_init(&adapter->san_dbf_lock);
 	spin_lock_init(&adapter->scsi_dbf_lock);
+	spin_lock_init(&adapter->rec_dbf_lock);
 
 	retval = zfcp_adapter_debug_register(adapter);
 	if (retval)

-- 
