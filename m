From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 5/7] scsi/bnx2i: Update bnx2i_ep_connect to accept iface and sockaddr_storage.
Date: Tue,  6 Jun 2017 12:07:15 -0600
Message-ID: <20170606180717.5007-6-robert@leblancnet.us>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBZW63PEQKGQEA4ZNPRQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Update QLogic NetXtreme II driver to accept the session iface for creating
the iSCSI connection. Also accept dst_addr as sockaddr_storage instead of
sockaddr.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |  1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 13 ++++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 42921dbba927..ce87ce2c2dc1 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/if.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libiscsi.h>
 #include "bnx2i.h"
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index f32a66f89d25..515106367426 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -16,8 +16,10 @@
  */
 
 #include <linux/slab.h>
+#include <linux/if.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libiscsi.h>
+#include <scsi/scsi_transport_iscsi.h>
 #include "bnx2i.h"
 
 struct scsi_transport_template *bnx2i_scsi_xport_template;
@@ -1771,8 +1773,9 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
  *	sending down option-2 request to complete TCP 3-way handshake
  */
 static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
-					       struct sockaddr *dst_addr,
-					       int non_blocking)
+					       struct sockaddr_storage *dst_addr,
+					       int non_blocking,
+					       struct iface_rec *iface)
 {
 	u32 iscsi_cid = BNX2I_CID_RESERVED;
 	struct sockaddr_in *desti = (struct sockaddr_in *) dst_addr;
@@ -1792,7 +1795,7 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 		 * check if the given destination can be reached through
 		 * a iscsi capable NetXtreme2 device
 		 */
-		hba = bnx2i_check_route(dst_addr);
+		hba = bnx2i_check_route((struct sockaddr *)dst_addr);
 
 	if (!hba) {
 		rc = -EINVAL;
@@ -1887,11 +1890,11 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	clear_bit(SK_TCP_TIMESTAMP, &bnx2i_ep->cm_sk->tcp_flags);
 
 	memset(&saddr, 0, sizeof(saddr));
-	if (dst_addr->sa_family == AF_INET) {
+	if (dst_addr->ss_family == AF_INET) {
 		desti = (struct sockaddr_in *) dst_addr;
 		saddr.remote.v4 = *desti;
 		saddr.local.v4.sin_family = desti->sin_family;
-	} else if (dst_addr->sa_family == AF_INET6) {
+	} else if (dst_addr->ss_family == AF_INET6) {
 		desti6 = (struct sockaddr_in6 *) dst_addr;
 		saddr.remote.v6 = *desti6;
 		saddr.local.v6.sin6_family = desti6->sin6_family;
-- 
2.11.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
