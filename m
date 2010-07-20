From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/28] libfc: provide space for LLD after remote port structure
Date: Tue, 20 Jul 2010 15:19:42 -0700
Message-ID: <20100720221942.17116.10305.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761870Ab0GTWTm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:42 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Add pre-zeroed space after the allocation for fc_rport_priv
for use by the lower-level driver.

This is primarily for VN2VN FIP mode, but could be used in
other ways someday.

The space required is specified in lport->rport_priv_size.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    2 +-
 include/scsi/libfc.h          |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6b56973..6d68482 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -127,7 +127,7 @@ static struct fc_rport_priv *fc_rport_create(struct fc_lport *lport,
 	if (rdata)
 		return rdata;
 
-	rdata = kzalloc(sizeof(*rdata), GFP_KERNEL);
+	rdata = kzalloc(sizeof(*rdata) + lport->rport_priv_size, GFP_KERNEL);
 	if (!rdata)
 		return NULL;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b0310b9..fcbee8c 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -799,6 +799,7 @@ struct fc_disc {
  * @mfs:                   The maximum Fibre Channel payload size
  * @max_retry_count:       The maximum retry attempts
  * @max_rport_retry_count: The maximum remote port retry attempts
+ * @rport_priv_size:       Size needed by driver after struct fc_rport_priv
  * @lro_xid:               The maximum XID for LRO
  * @lso_max:               The maximum large offload send size
  * @fcts:                  FC-4 type mask
@@ -848,6 +849,7 @@ struct fc_lport {
 	u32			       mfs;
 	u8			       max_retry_count;
 	u8			       max_rport_retry_count;
+	u16			       rport_priv_size;
 	u16			       link_speed;
 	u16			       link_supported_speeds;
 	u16			       lro_xid;

