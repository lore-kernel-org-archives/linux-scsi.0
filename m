From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/9] libfc: add FC-BB-5 LESB counters to fcoe_dev_stats
Date: Fri, 20 Nov 2009 14:54:52 -0800
Message-ID: <20091120225452.495.98956.stgit@localhost.localdomain>
References: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbZKTWyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:54:46 -0500
In-Reply-To: <20091120225436.495.88600.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

FC-BB-5 Rev2.0, Clause 7.10 extends the FC-LS-3 LESB for FC-BB_E. We are
already tracking Link Failure Count so add the rest in this patch.

For VLinkFailureCount and MissDiscAdvCount, they are part of the per-cpu
fcoe_dev_stats. For SymbolErrorCount, ErroredBlockCount, and FCSErrorCount,
they are defined in IEEE 802.3-2008 and are per LLD. They are expected to
come from LLD.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/libfc.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 2936fba..b97be29 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -231,6 +231,8 @@ struct fc_rport_priv {
  * @ControlRequests:       Number of control requests
  * @InputMegabytes:        Number of received megabytes
  * @OutputMegabytes:       Number of transmitted megabytes
+ * @VLinkFailureCount:     Number of virtual link failures
+ * @MissDiscAdvCount:      Number of missing FIP discovery advertisement
  */
 struct fcoe_dev_stats {
 	u64		SecondsSinceLastReset;
@@ -249,6 +251,8 @@ struct fcoe_dev_stats {
 	u64		ControlRequests;
 	u64		InputMegabytes;
 	u64		OutputMegabytes;
+	u64		VLinkFailureCount;
+	u64		MissDiscAdvCount;
 };
 
 /**

