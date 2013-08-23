From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 9/9] target: Enable global EXTENDED_COPY setup/release
Date: Fri, 23 Aug 2013 02:27:01 +0000
Message-ID: <1377224821-23422-10-git-send-email-nab@daterainc.com>
References: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377224821-23422-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Add calls to target_xcopy_setup_pt() + target_xcopy_release_pt() to
target_core_init_configfs() and target_core_exit_configfs()
respectively.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_configfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 026e42b..328f425 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -48,6 +48,7 @@
 #include "target_core_alua.h"
 #include "target_core_pr.h"
 #include "target_core_rd.h"
+#include "target_core_xcopy.h"
 
 extern struct t10_alua_lu_gp *default_lu_gp;
 
@@ -2935,6 +2936,10 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
+	ret = target_xcopy_setup_pt();
+	if (ret < 0)
+		goto out;
+
 	return 0;
 
 out:
@@ -3007,6 +3012,7 @@ static void __exit target_core_exit_configfs(void)
 
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
+	target_xcopy_release_pt();
 	release_se_kmem_caches();
 }
 
-- 
1.7.2.5
