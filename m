From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] isci: avoid array subscript warning
Date: Fri, 18 Nov 2016 17:14:01 +0100
Message-ID: <20161118161418.755779-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:50709 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcKRQOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 11:14:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Colin Ian King <colin.king@canonical.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I'm getting a new warning with gcc-7:

isci/remote_node_context.c: In function 'sci_remote_node_context_destruct':
isci/remote_node_context.c:69:16: error: array subscript is above array bounds [-Werror=array-bounds]

This is odd, since we clearly cover all values for enum
scis_sds_remote_node_context_states here. Anyway, checking
for an array overflow can't harm and it makes the warning
go away.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/isci/remote_node_context.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index 30bd80052e03..e3f2a5359d71 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -66,6 +66,9 @@ const char *rnc_state_name(enum scis_sds_remote_node_context_states state)
 {
 	static const char * const strings[] = RNC_STATES;
 
+	if (state >= ARRAY_SIZE(strings))
+		return "UNKNOWN";
+
 	return strings[state];
 }
 #undef C
-- 
2.9.0

