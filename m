From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/16] libfc: recognize incoming FLOGI for point-to-point mode
Date: Fri, 12 Mar 2010 16:08:07 -0800
Message-ID: <20100313000807.22251.80271.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:08 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When receiving a FLOGI request from a point-to-point peer,
the D_ID of 0xfffffe was not recognized as belonging to one
of the lports, so it was dropped.

Change fc_vport_id_lookup() to treat d_id 0xfffffe as a match.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_npiv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index c68f6c7..45b6f1e 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -72,6 +72,9 @@ struct fc_lport *fc_vport_id_lookup(struct fc_lport *n_port, u32 port_id)
 	if (fc_host_port_id(n_port->host) == port_id)
 		return n_port;
 
+	if (port_id == FC_FID_FLOGI)
+		return n_port;		/* for point-to-point */
+
 	mutex_lock(&n_port->lp_mutex);
 	list_for_each_entry(vn_port, &n_port->vports, list) {
 		if (fc_host_port_id(vn_port->host) == port_id) {

