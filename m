From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 25/28] libfc: Extending lport's roles for target if there is a
	registered target.
Date: Fri, 28 Jan 2011 16:05:22 -0800
Message-ID: <20110129000522.1784.63132.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1A2AFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:05:22 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Reason: From initaitor machine, when queried role of target (other end of connection),
        it is "initiator", hence SCSI-ml doesn't send any LUN Inquiry commands.

Fix:    If there is a registered target for FC_TYPE_FCP, extend lport's params (capability)
        to be target as well, By default lport params are INITIATOR only. Having this fix,
        caused initiator to send SCSI LUN inquiry command to target.

Technical Details: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_libfc.c |   19 +++++++++++++++++++
 drivers/scsi/libfc/fc_libfc.h |    1 +
 drivers/scsi/libfc/fc_lport.c |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_libfc.c b/drivers/scsi/libfc/fc_libfc.c
index 5e40dab..b773512 100644
--- a/drivers/scsi/libfc/fc_libfc.c
+++ b/drivers/scsi/libfc/fc_libfc.c
@@ -232,6 +232,25 @@ void fc_fill_reply_hdr(struct fc_frame *fp, const struct fc_frame *in_fp,
 }
 EXPORT_SYMBOL(fc_fill_reply_hdr);
 
+/**
+ * fc_fc4_conf_lport_params() - Modify "service_params" of specified lport
+ * if there is service provider (target provider) registered with libfc
+ * for specified "fc_ft_type"
+ * @lport: Local port which service_params needs to be modified
+ * @type: FC-4 type, such as FC_TYPE_FCP
+ */
+void fc_fc4_conf_lport_params(struct fc_lport *lport, enum fc_fh_type type)
+{
+	struct fc4_prov *prov_entry;
+	BUG_ON(type >= FC_FC4_PROV_SIZE);
+	BUG_ON(!lport);
+	prov_entry = fc_passive_prov[type];
+	if (type == FC_TYPE_FCP) {
+		if (prov_entry && prov_entry->recv)
+			lport->service_params |= FCP_SPPF_TARG_FCN;
+	}
+}
+
 void fc_lport_iterate(void (*notify)(struct fc_lport *, void *), void *arg)
 {
 	struct fc_lport *lport;
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index 8496f70..fedc819 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -125,6 +125,7 @@ void fc_destroy_fcp(void);
 const char *fc_els_resp_type(struct fc_frame *);
 extern void fc_fc4_add_lport(struct fc_lport *);
 extern void fc_fc4_del_lport(struct fc_lport *);
+extern void fc_fc4_conf_lport_params(struct fc_lport *, enum fc_fh_type);
 
 /*
  * Copies a buffer into an sg list
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e0ef814..735f1f8 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1597,6 +1597,7 @@ int fc_lport_config(struct fc_lport *lport)
 
 	fc_lport_add_fc4_type(lport, FC_TYPE_FCP);
 	fc_lport_add_fc4_type(lport, FC_TYPE_CT);
+	fc_fc4_conf_lport_params(lport, FC_TYPE_FCP);
 
 	return 0;
 }

