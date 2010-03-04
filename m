From: <kgudipat@brocade.com>
Subject: [PATCH 17/32] bfa: Added firmware save clear feature for BFA driver.
Date: Wed, 3 Mar 2010 17:45:46 -0800
Message-ID: <1267667146-26393-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:33966 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:45:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Added new fsave clear feature for the BFA driver.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_core.c    |    9 +++++++++
 drivers/scsi/bfa/bfa_ioc.c     |   10 +++++++++-
 drivers/scsi/bfa/bfa_ioc.h     |    1 +
 drivers/scsi/bfa/include/bfa.h |    1 +
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index 72e3f2f..0c08e18 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -385,6 +385,15 @@ bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen)
 }
 
 /**
+ * Clear the saved firmware trace information of an IOC.
+ */
+void
+bfa_debug_fwsave_clear(struct bfa_s *bfa)
+{
+	bfa_ioc_debug_fwsave_clear(&bfa->ioc);
+}
+
+/**
  * 		Fetch firmware trace data.
  *
  * @param[in]		bfa			BFA instance
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 8a6361c..0019ff7 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1488,7 +1488,6 @@ return (auto_recover) ? BFA_DBG_FWTRC_LEN : 0;
 void
 bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave)
 {
-	bfa_assert(ioc->auto_recover);
 	ioc->dbg_fwsave = dbg_fwsave;
 	ioc->dbg_fwsave_len = bfa_ioc_debug_trcsz(ioc->auto_recover);
 }
@@ -1925,6 +1924,15 @@ bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata, int *trclen)
 }
 
 /**
+ * Clear saved firmware trace
+ */
+void
+bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc)
+{
+	ioc->dbg_fwsave_once = BFA_TRUE;
+}
+
+/**
  * Retrieve saved firmware trace from a prior IOC failure.
  */
 bfa_status_t
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 853cc31..4b73efa 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -270,6 +270,7 @@ int bfa_ioc_debug_trcsz(bfa_boolean_t auto_recover);
 void bfa_ioc_debug_memclaim(struct bfa_ioc_s *ioc, void *dbg_fwsave);
 bfa_status_t bfa_ioc_debug_fwsave(struct bfa_ioc_s *ioc, void *trcdata,
 		int *trclen);
+void bfa_ioc_debug_fwsave_clear(struct bfa_ioc_s *ioc);
 bfa_status_t bfa_ioc_debug_fwtrc(struct bfa_ioc_s *ioc, void *trcdata,
 				 int *trclen);
 u32 bfa_ioc_smem_pgnum(struct bfa_ioc_s *ioc, u32 fmaddr);
diff --git a/drivers/scsi/bfa/include/bfa.h b/drivers/scsi/bfa/include/bfa.h
index 942ae64..17654ca 100644
--- a/drivers/scsi/bfa/include/bfa.h
+++ b/drivers/scsi/bfa/include/bfa.h
@@ -172,6 +172,7 @@ void bfa_timer_tick(struct bfa_s *bfa);
  */
 bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
 bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
+void bfa_debug_fwsave_clear(struct bfa_s *bfa);
 
 #include "bfa_priv.h"
 
-- 
1.6.5.3

