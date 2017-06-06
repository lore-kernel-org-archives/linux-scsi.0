From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 3/7] ib/iSER: Add binding to source IP address.
Date: Tue,  6 Jun 2017 12:07:13 -0600
Message-ID: <20170606180717.5007-4-robert@leblancnet.us>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBYW63PEQKGQEKC6P6SA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

If the iface passed in has ip address set, then attept to create an RDMA
connection using it as the source IP address. This allows iSER to use
multiple ports on the same network or in more complex routing
configurations. Also update to accepting sockaddr_storage.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     | 33 ++++++++++++++++++++++++----
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  4 ++--
 drivers/infiniband/ulp/iser/iser_initiator.c |  1 +
 drivers/infiniband/ulp/iser/iser_memory.c    |  1 +
 drivers/infiniband/ulp/iser/iser_verbs.c     |  8 ++++---
 5 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a887efb4bdf..7ba5ed9afe05 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -59,6 +59,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/inet.h>
 
 #include <net/sock.h>
 
@@ -808,12 +809,16 @@ static int iscsi_iser_get_ep_param(struct iscsi_endpoint *ep,
  *         if fails.
  */
 static struct iscsi_endpoint *
-iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
-		      int non_blocking)
+iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
+		      int non_blocking, struct iface_rec *iface)
 {
 	int err;
 	struct iser_conn *iser_conn;
 	struct iscsi_endpoint *ep;
+	struct sockaddr_storage src_addr;
+	struct sockaddr_in *tmp_addr;
+	struct sockaddr_in6 *tmp_addr6;
+	memset(&src_addr, 0, sizeof(src_addr));
 
 	ep = iscsi_create_endpoint(0);
 	if (!ep)
@@ -828,8 +833,28 @@ iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	ep->dd_data = iser_conn;
 	iser_conn->ep = ep;
 	iser_conn_init(iser_conn);
-
-	err = iser_connect(iser_conn, NULL, dst_addr, non_blocking);
+	if (iface && iface->ipaddress[0]) {
+		if (strchr(iface->ipaddress, ':')) {
+			tmp_addr6 = (struct sockaddr_in6 *)&src_addr;
+			tmp_addr6->sin6_family = AF_INET6;
+			if(!in6_pton(iface->ipaddress, -1,
+				 tmp_addr6->sin6_addr.s6_addr,
+				 -1, NULL)) {
+				err = -EINVAL;
+				goto failure;
+			}
+		} else {
+			tmp_addr = (struct sockaddr_in *)&src_addr;
+			tmp_addr->sin_family = AF_INET;
+			if (!in4_pton(iface->ipaddress, -1,
+				 (u8 *)&tmp_addr->sin_addr.s_addr,
+				 -1, NULL)) {
+				err = -EINVAL;
+				goto failure;
+			}
+		}
+	}
+	err = iser_connect(iser_conn, &src_addr, dst_addr, non_blocking);
 	if (err)
 		goto failure;
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index c1ae4aeae2f9..1eda6ff49bdc 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -628,8 +628,8 @@ void iser_unreg_rdma_mem(struct iscsi_iser_task *task,
 			 enum iser_data_dir dir);
 
 int  iser_connect(struct iser_conn *iser_conn,
-		  struct sockaddr *src_addr,
-		  struct sockaddr *dst_addr,
+		  struct sockaddr_storage *src_addr,
+		  struct sockaddr_storage *dst_addr,
 		  int non_blocking);
 
 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 12ed62ce9ff7..361d5e411fe7 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/kfifo.h>
+#include <linux/if.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9c3e9ab53a41..c9d95b997820 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -36,6 +36,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
+#include <linux/if.h>
 
 #include "iscsi_iser.h"
 static
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index c538a38c91ce..0a43009296b6 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -35,6 +35,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/if.h>
 
 #include "iscsi_iser.h"
 
@@ -941,8 +942,8 @@ void iser_conn_init(struct iser_conn *iser_conn)
  * sleeps until the connection is established or rejected
  */
 int iser_connect(struct iser_conn   *iser_conn,
-		 struct sockaddr    *src_addr,
-		 struct sockaddr    *dst_addr,
+		 struct sockaddr_storage *src_addr,
+		 struct sockaddr_storage *dst_addr,
 		 int                 non_blocking)
 {
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
@@ -968,7 +969,8 @@ int iser_connect(struct iser_conn   *iser_conn,
 		goto id_failure;
 	}
 
-	err = rdma_resolve_addr(ib_conn->cma_id, src_addr, dst_addr, 1000);
+	err = rdma_resolve_addr(ib_conn->cma_id, (struct sockaddr *)src_addr,
+		       		(struct sockaddr *)dst_addr, 1000);
 	if (err) {
 		iser_err("rdma_resolve_addr failed: %d\n", err);
 		goto addr_failure;
-- 
2.11.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
