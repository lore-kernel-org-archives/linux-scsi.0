From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 04/20] target: Enforce 1 page max for control cdb buffer sizes
Date: Thu,  7 Jul 2011 15:33:15 -0700
Message-ID: <1310078011-15504-5-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1GGWdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:43 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Due to all cdbs' data buffers being referenced by scatterlists, buffers
of more than a page are not contiguous. Instead of handling this in all
control command handlers, we may be able to get away with just limiting
control cdb data buffers to one page. The only control CDBs we handle that
have potentially large data buffers are REPORT LUNS and UNMAP, so if we
didn't want to live with this limitation, they would need to be modified
to walk the pages in the data buffer's sgl.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |    5 +++++
 include/target/target_core_base.h      |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e2887c3..f9645b7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3568,6 +3568,11 @@ static int transport_generic_cmd_sequencer(
 		cmd->data_length = size;
 	}
 
+	/* Let's limit control cdbs to a page, for simplicity's sake. */
+	if ((cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)
+	    && size > PAGE_SIZE)
+		goto out_invalid_cdb_field;
+
 	transport_set_supported_SAM_opcode(cmd);
 	return ret;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 91a1d93..029da6f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -15,6 +15,7 @@
 /* Used by transport_generic_allocate_iovecs() */
 #define TRANSPORT_IOV_DATA_BUFFER		5
 /* Maximum Number of LUNs per Target Portal Group */
+/* Don't raise above 511 or REPORT_LUNS needs to handle >1 page */
 #define TRANSPORT_MAX_LUNS_PER_TPG		256
 /*
  * By default we use 32-byte CDBs in TCM Core and subsystem plugin code.
-- 
1.7.1

