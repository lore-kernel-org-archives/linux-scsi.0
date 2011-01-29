From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/28] libfc: add local port hook for provider session lookup
Date: Fri, 28 Jan 2011 16:04:13 -0800
Message-ID: <20110129000413.1784.26132.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29129 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1A2AE2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:28 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

The target provider needs a per-instance lookup table
or other way to lookup sessions quickly without going through
a linear list or serializing too much.

Add a simple void * array indexed by FC-4 type to the fc_lport.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Committed-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/libfc.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 3b8f5d8..a9aff25 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -805,6 +805,7 @@ struct fc_disc {
  * @lp_mutex:              Mutex to protect the local port
  * @list:                  Handle for list of local ports
  * @retry_work:            Handle to local port for delayed retry context
+ * @prov:		   Pointers available for use by passive FC-4 providers
  */
 struct fc_lport {
 	/* Associations */
@@ -860,6 +861,7 @@ struct fc_lport {
 	struct mutex                   lp_mutex;
 	struct list_head               list;
 	struct delayed_work	       retry_work;
+	void			       *prov[FC_FC4_PROV_SIZE];
 };
 
 /**

