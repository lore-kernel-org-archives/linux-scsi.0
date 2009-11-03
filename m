From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 45/54] fnic: enable bsg pass-thru for fcping
Date: Tue, 03 Nov 2009 11:49:32 -0800
Message-ID: <20091103194932.4085.25846.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218AbZKCTt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:27 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Add initialization of .bsg_request in the scsi_transport_fc
template so that fcping works.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0333c7f..fe1b103 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -143,6 +143,7 @@ static struct fc_function_template fnic_fc_functions = {
 	.get_fc_host_stats = fnic_get_stats,
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.terminate_rport_io = fnic_terminate_rport_io,
+	.bsg_request = fc_lport_bsg_request,
 };
 
 static void fnic_get_host_speed(struct Scsi_Host *shost)

