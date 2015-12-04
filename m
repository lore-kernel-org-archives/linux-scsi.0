From: Michal Marek <mmarek@suse.com>
Subject: [PATCH v2 2/8] aic7xxx: Avoid name collision with <linux/list.h>
Date: Fri,  4 Dec 2015 16:26:21 +0100
Message-ID: <1449242787-16598-3-git-send-email-mmarek@suse.com>
References: <1449242787-16598-1-git-send-email-mmarek@suse.com>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1449242787-16598-1-git-send-email-mmarek@suse.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rename the local definition of LIST_HEAD to BSD_LIST_HEAD. This fixes a
ctags error if we apply the C rules to header files  as well:

ctags: Warning: drivers/scsi/aic7xxx/aic79xx.h:1072: null expansion of name pattern "\3"
ctags: Warning: drivers/scsi/aic7xxx/aic7xxx.h:919: null expansion of name pattern "\3"

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.com>
---
v2: No change

 drivers/scsi/aic7xxx/aic79xx.h     | 4 ++--
 drivers/scsi/aic7xxx/aic79xx_osm.h | 5 -----
 drivers/scsi/aic7xxx/aic7xxx.h     | 2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.h | 5 -----
 drivers/scsi/aic7xxx/queue.h       | 2 +-
 5 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index df2e0e5367d2..d47b527b25dd 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -624,7 +624,7 @@ struct scb {
 };
 
 TAILQ_HEAD(scb_tailq, scb);
-LIST_HEAD(scb_list, scb);
+BSD_LIST_HEAD(scb_list, scb);
 
 struct scb_data {
 	/*
@@ -1069,7 +1069,7 @@ struct ahd_softc {
 	/*
 	 * SCBs that have been sent to the controller
 	 */
-	LIST_HEAD(, scb)	  pending_scbs;
+	BSD_LIST_HEAD(, scb)	  pending_scbs;
 
 	/*
 	 * Current register window mode information.
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index c58fa33c6592..728193a42e6e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -65,11 +65,6 @@
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahd
 
-/* Name space conflict with BSD queue macros */
-#ifdef LIST_HEAD
-#undef LIST_HEAD
-#endif
-
 #include "cam.h"
 #include "queue.h"
 #include "scsi_message.h"
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index f695774645c1..4ce4e903a759 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -916,7 +916,7 @@ struct ahc_softc {
 	/*
 	 * SCBs that have been sent to the controller
 	 */
-	LIST_HEAD(, scb)	  pending_scbs;
+	BSD_LIST_HEAD(, scb)	  pending_scbs;
 
 	/*
 	 * Counting lock for deferring the release of additional
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h b/drivers/scsi/aic7xxx/aic7xxx_osm.h
index bc4cca92ff04..54c702864103 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -82,11 +82,6 @@
 /* Core SCSI definitions */
 #define AIC_LIB_PREFIX ahc
 
-/* Name space conflict with BSD queue macros */
-#ifdef LIST_HEAD
-#undef LIST_HEAD
-#endif
-
 #include "cam.h"
 #include "queue.h"
 #include "scsi_message.h"
diff --git a/drivers/scsi/aic7xxx/queue.h b/drivers/scsi/aic7xxx/queue.h
index 8adf8003a164..ba602981f193 100644
--- a/drivers/scsi/aic7xxx/queue.h
+++ b/drivers/scsi/aic7xxx/queue.h
@@ -246,7 +246,7 @@ struct {								\
 /*
  * List declarations.
  */
-#define	LIST_HEAD(name, type)						\
+#define	BSD_LIST_HEAD(name, type)					\
 struct name {								\
 	struct type *lh_first;	/* first element */			\
 }
-- 
2.1.4

