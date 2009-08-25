From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 26/64] libfc: fix RPORT_TO_PRIV and PRIV_TO_RPORT() macros.
Date: Tue, 25 Aug 2009 14:00:45 -0700
Message-ID: <20090825210045.1553.97541.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbZHYVAm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:42 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

These macros introduce extra undesirable semicolons that keep
them from being used in expressions, and they don't protect
against being passed an expression.

Add parens and remove the semicolons.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/libfc.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index d888cbe..2fdd8ac 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -223,9 +223,9 @@ struct fc_rport_libfc_priv {
 };
 
 #define PRIV_TO_RPORT(x)						\
-	(struct fc_rport *)((void *)x - sizeof(struct fc_rport));
+	((struct fc_rport *)((void *)(x) - sizeof(struct fc_rport)))
 #define RPORT_TO_PRIV(x)						\
-	(struct fc_rport_libfc_priv *)((void *)x + sizeof(struct fc_rport));
+	((struct fc_rport_libfc_priv *)((void *)(x) + sizeof(struct fc_rport)))
 
 static inline void fc_rport_set_name(struct fc_rport *rport, u64 wwpn, u64 wwnn)
 {

