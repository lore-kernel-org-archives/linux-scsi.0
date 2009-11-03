From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/54] fcoe: vport symbolic name support
Date: Tue, 03 Nov 2009 11:47:18 -0800
Message-ID: <20091103194718.4085.9979.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23931 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbZKCTrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:47:14 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Allow a vport specific string to be appended to the port symbolic
name.  The new symbolic name is sent to the name server after it
is set.

This currently messes with libhbalinux, which is looking for
the fcoe "fcoe <ver> over <ethX>" string and expects whatever
comes after the "over" to be a network interface name only.

Adds an EXPORT_SYMBOL to libfc for fc_frame_alloc_fill, which is
needed to allow fcoe to allocate a frame of variable length for
the RSPN request.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c      |   33 +++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_frame.c |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 437eacf..f1c126b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -96,6 +96,7 @@ static struct scsi_transport_template *fcoe_vport_transport_template;
 static int fcoe_vport_destroy(struct fc_vport *vport);
 static int fcoe_vport_create(struct fc_vport *vport, bool disabled);
 static int fcoe_vport_disable(struct fc_vport *vport, bool disable);
+static void fcoe_set_vport_symbolic_name(struct fc_vport *vport);
 
 struct fc_function_template fcoe_transport_function = {
 	.show_host_node_name = 1,
@@ -132,6 +133,7 @@ struct fc_function_template fcoe_transport_function = {
 	.vport_create = fcoe_vport_create,
 	.vport_delete = fcoe_vport_destroy,
 	.vport_disable = fcoe_vport_disable,
+	.set_vport_symbolic_name = fcoe_set_vport_symbolic_name,
 };
 
 struct fc_function_template fcoe_vport_transport_function = {
@@ -2326,3 +2328,34 @@ static int fcoe_vport_disable(struct fc_vport *vport, bool disable)
 	return 0;
 }
 
+/**
+ * fcoe_vport_set_symbolic_name() - append vport string to symbolic name
+ * @vport: fc_vport with a new symbolic name string
+ *
+ * After generating a new symbolic name string, a new RSPN_ID request is
+ * sent to the name server.  There is no response handler, so if it fails
+ * for some reason it will not be retried.
+ */
+static void fcoe_set_vport_symbolic_name(struct fc_vport *vport)
+{
+	struct fc_lport *lport = vport->dd_data;
+	struct fc_frame *fp;
+	size_t len;
+
+	snprintf(fc_host_symbolic_name(lport->host), FC_SYMBOLIC_NAME_SIZE,
+		 "%s v%s over %s : %s", FCOE_NAME, FCOE_VERSION,
+		 fcoe_netdev(lport)->name, vport->symbolic_name);
+
+	if (lport->state != LPORT_ST_READY)
+		return;
+
+	len = strnlen(fc_host_symbolic_name(lport->host), 255);
+	fp = fc_frame_alloc(lport,
+			    sizeof(struct fc_ct_hdr) +
+			    sizeof(struct fc_ns_rspn) + len);
+	if (!fp)
+		return;
+	lport->tt.elsct_send(lport, FC_FID_DIR_SERV, fp, FC_NS_RSPN_ID,
+			     NULL, NULL, lport->e_d_tov);
+}
+
diff --git a/drivers/scsi/libfc/fc_frame.c b/drivers/scsi/libfc/fc_frame.c
index ac3681a..4fea369 100644
--- a/drivers/scsi/libfc/fc_frame.c
+++ b/drivers/scsi/libfc/fc_frame.c
@@ -86,3 +86,4 @@ struct fc_frame *fc_frame_alloc_fill(struct fc_lport *lp, size_t payload_len)
 	}
 	return fp;
 }
+EXPORT_SYMBOL(fc_frame_alloc_fill);

