From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 1/4] fc: adds some more FC specific stats to fc_host
Date: Fri, 25 May 2012 10:26:38 -0700
Message-ID: <20120525172638.6980.40338.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2EYRmQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 13:42:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, devel@open-fcoe.org

The libfc provides more flexibility and with that
we can monitor some more FC specific stats for
FC exches or FCP error cases, this patch add
such new FC stats.

The patch adds *only* FC specific new stats to
existing fc_host attribute container.

Added stats names are self explanatory as
existing FC stats already has, however anyway
still added commentary along their definition
to describe them.

CC: James Smart <james.smart@emulex.com>

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by : Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---

 drivers/scsi/scsi_transport_fc.c |   18 ++++++++++++++++++
 include/scsi/scsi_transport_fc.h |   12 ++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 5797604..2fded79 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1744,6 +1744,15 @@ fc_host_statistic(fcp_output_requests);
 fc_host_statistic(fcp_control_requests);
 fc_host_statistic(fcp_input_megabytes);
 fc_host_statistic(fcp_output_megabytes);
+fc_host_statistic(fcp_packet_alloc_failures);
+fc_host_statistic(fcp_packet_aborts);
+fc_host_statistic(fcp_frame_alloc_failures);
+fc_host_statistic(fc_no_free_exch);
+fc_host_statistic(fc_no_free_exch_xid);
+fc_host_statistic(fc_xid_not_found);
+fc_host_statistic(fc_xid_busy);
+fc_host_statistic(fc_seq_not_found);
+fc_host_statistic(fc_non_bls_resp);
 
 static ssize_t
 fc_reset_statistics(struct device *dev, struct device_attribute *attr,
@@ -1784,6 +1793,15 @@ static struct attribute *fc_statistics_attrs[] = {
 	&device_attr_host_fcp_control_requests.attr,
 	&device_attr_host_fcp_input_megabytes.attr,
 	&device_attr_host_fcp_output_megabytes.attr,
+	&device_attr_host_fcp_packet_alloc_failures.attr,
+	&device_attr_host_fcp_packet_aborts.attr,
+	&device_attr_host_fcp_frame_alloc_failures.attr,
+	&device_attr_host_fc_no_free_exch.attr,
+	&device_attr_host_fc_no_free_exch_xid.attr,
+	&device_attr_host_fc_xid_not_found.attr,
+	&device_attr_host_fc_xid_busy.attr,
+	&device_attr_host_fc_seq_not_found.attr,
+	&device_attr_host_fc_non_bls_resp.attr,
 	&device_attr_host_reset_statistics.attr,
 	NULL
 };
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 719faf1..b797e8f 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -426,6 +426,18 @@ struct fc_host_statistics {
 	u64 fcp_control_requests;
 	u64 fcp_input_megabytes;
 	u64 fcp_output_megabytes;
+	u64 fcp_packet_alloc_failures;	/* fcp packet allocation failures */
+	u64 fcp_packet_aborts;		/* fcp packet aborted */
+	u64 fcp_frame_alloc_failures;	/* fcp frame allocation failures */
+
+	/* fc exches statistics */
+	u64 fc_no_free_exch;		/* no free exch memory */
+	u64 fc_no_free_exch_xid;	/* no free exch id */
+	u64 fc_xid_not_found;		/* exch not found for a response */
+	u64 fc_xid_busy;		/* exch exist for new a request */
+	u64 fc_seq_not_found;		/* seq is not found for exchange */
+	u64 fc_non_bls_resp;		/* a non BLS response frame with
+					   a sequence responder in new exch */
 };
 
 

