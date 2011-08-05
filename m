From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 05/18] bnx2fc: Do not attempt destroying NPIV port
 twice
Date: Thu, 4 Aug 2011 17:38:39 -0700
Message-ID: <1312504732-4572-6-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4921 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab1HEAjI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:08 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When NPIV ports are created/deleted rapidly there is a race condition between
bnx2fc_vport_destroy() from sysfs and bnx2fc_flogi_resp(), which could try to
delete the NPIV port from the list twice. Fix is to loop through the list of
NPIV ports to find a match, and only when it exists remove it.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 9e2bf39..21792e7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1028,8 +1028,20 @@ static int bnx2fc_vport_destroy(struct fc_vport *vport)
 	struct fc_lport *n_port = shost_priv(shost);
 	struct fc_lport *vn_port = vport->dd_data;
 	struct fcoe_port *port = lport_priv(vn_port);
+	struct fc_lport *v_port;
+	bool found = false;
 
 	mutex_lock(&n_port->lp_mutex);
+	list_for_each_entry(v_port, &n_port->vports, list)
+		if (v_port->vport == vport) {
+			found = true;
+			break;
+		}
+
+	if (!found) {
+		mutex_unlock(&n_port->lp_mutex);
+		return -ENOENT;
+	}
 	list_del(&vn_port->list);
 	mutex_unlock(&n_port->lp_mutex);
 	queue_work(bnx2fc_wq, &port->destroy_work);
-- 
1.7.0.6


