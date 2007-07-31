From: Andrew Morton <akpm@linux-foundation.org>
Subject: git-scsi-misc build error
Date: Tue, 31 Jul 2007 15:27:32 -0700
Message-ID: <20070731152732.ae8d251d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59261 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759347AbXGaW2I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 18:28:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org

ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!

This bug was reported about seven times against 2.6.23-rc1-mm1's
git-scsi-target, and now it has been moved into git-scsi-misc.




From: Andrew Morton <akpm@linux-foundation.org>

- Fix this:

ERROR: "scsi_tgt_it_nexus_create" [drivers/scsi/scsi_transport_srp.ko] undefined!
ERROR: "scsi_tgt_it_nexus_destroy" [drivers/scsi/scsi_transport_srp.ko] undefined!

- Also avoid anonymous args in the function prototypes: adding the names has
  commentary value, and makes it easier to check the stubbed inline function
  against the out-of-line declaration.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: FUJITA Tomonori <tomof@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_tgt.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN include/scsi/scsi_tgt.h~scsi-fix-build-for-config_scsi_tgt=n include/scsi/scsi_tgt.h
--- a/include/scsi/scsi_tgt.h~scsi-fix-build-for-config_scsi_tgt=n
+++ a/include/scsi/scsi_tgt.h
@@ -17,5 +17,20 @@ extern int scsi_tgt_tsk_mgmt_request(str
 extern struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *,
 					       enum dma_data_direction,	gfp_t);
 extern void scsi_host_put_command(struct Scsi_Host *, struct scsi_cmnd *);
-extern int scsi_tgt_it_nexus_create(struct Scsi_Host *, u64, char *);
-extern int scsi_tgt_it_nexus_destroy(struct Scsi_Host *, u64);
+
+#ifdef CONFIG_SCSI_TGT
+extern int scsi_tgt_it_nexus_create(struct Scsi_Host *shost, u64 itn_id,
+				char *initiator);
+extern int scsi_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id);
+#else
+static inline int scsi_tgt_it_nexus_create(struct Scsi_Host *shost,
+				u64 itn_id, char *initiator)
+{
+	return 0;
+}
+
+static inline int scsi_tgt_it_nexus_destroy(struct Scsi_Host *shost, u64 itn_id)
+{
+	return 0;
+}
+#endif
_

