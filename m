From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/8] libfc: Fixing a memory leak when destroying an interface
Date: Fri, 25 Feb 2011 15:02:51 -0800
Message-ID: <20110225230251.9310.67430.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34006 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXCv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:02:51 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Neerav Parikh <neerav.parikh@intel.com>

From: Parikh, Neerav <neerav.parikh@intel.com>

When an fcoe interface is being destroyed; in the process the
fcoe driver will try to release all the resources it had allocated
for that interface including rports. But, it seems that it does not
release the reference held for the name server rport in that process
resulting into a memory leak. This patch fixes that memory leak.

Signed-off-by: Neerav Parikh <neerav.parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 59b16bb..49e1ccc 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -357,6 +357,7 @@ static void fc_rport_work(struct work_struct *work)
 			if (port_id == FC_FID_DIR_SERV) {
 				rdata->event = RPORT_EV_NONE;
 				mutex_unlock(&rdata->rp_mutex);
+				kref_put(&rdata->kref, lport->tt.rport_destroy);
 			} else if ((rdata->flags & FC_RP_STARTED) &&
 				   rdata->major_retries <
 				   lport->max_rport_retry_count) {

