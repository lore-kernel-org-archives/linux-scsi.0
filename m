From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 4/7] scsi/be2iscsi: Update beiscsi_ep_connect to accept iface and sockaddr_storage.
Date: Tue,  6 Jun 2017 12:07:14 -0600
Message-ID: <20170606180717.5007-5-robert@leblancnet.us>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBY663PEQKGQET4RHLJY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20170606180717.5007-1-robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: lduncan-IBi9RG/b67k@public.gmane.org
Cc: cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Update Emulex BladeEngine driver to accept the session iface for
creating the iSCSI connection. Also accept dst_addr as sockaddr_storage
instead of sockaddr.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 drivers/scsi/be2iscsi/be_cmds.c  | 1 +
 drivers/scsi/be2iscsi/be_iscsi.c | 8 +++++---
 drivers/scsi/be2iscsi/be_iscsi.h | 5 +++--
 drivers/scsi/be2iscsi/be_main.c  | 1 +
 drivers/scsi/be2iscsi/be_mgmt.c  | 1 +
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index a79a5e72c777..6617f2add9c6 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -13,6 +13,7 @@
  */
 
 #include <scsi/iscsi_proto.h>
+#include <linux/if.h>
 
 #include "be_main.h"
 #include "be.h"
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 97dca4681784..90adf20dc373 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -12,6 +12,7 @@
  *
  */
 
+#include <linux/if.h>
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/scsi_transport.h>
@@ -1161,8 +1162,8 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
  * This routines first asks chip to create a connection and then allocates an EP
  */
 struct iscsi_endpoint *
-beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
-		   int non_blocking)
+beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
+		   int non_blocking, struct iface_rec *iface)
 {
 	struct beiscsi_hba *phba;
 	struct beiscsi_endpoint *beiscsi_ep;
@@ -1198,7 +1199,8 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	beiscsi_ep = ep->dd_data;
 	beiscsi_ep->phba = phba;
 	beiscsi_ep->openiscsi_ep = ep;
-	ret = beiscsi_open_conn(ep, NULL, dst_addr, non_blocking);
+	ret = beiscsi_open_conn(ep, NULL, (struct sockaddr *)dst_addr,
+		       		non_blocking);
 	if (ret) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : Failed in beiscsi_open_conn\n");
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index b9d459a21f25..68616f81a12f 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -68,8 +68,9 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn);
 
 struct iscsi_endpoint *beiscsi_ep_connect(struct Scsi_Host *shost,
-					  struct sockaddr *dst_addr,
-					  int non_blocking);
+					  struct sockaddr_storage *dst_addr,
+					  int non_blocking,
+					  struct iface_rec *iface);
 
 int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f862332261f8..aab7772e2678 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/bsg-lib.h>
 #include <linux/irq_poll.h>
+#include <linux/if.h>
 
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_bsg_iscsi.h>
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index c73775368d09..926afa4ddb9d 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/bsg-lib.h>
+#include <linux/if.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/scsi_bsg_iscsi.h>
 #include "be_mgmt.h"
-- 
2.11.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
