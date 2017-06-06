From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 2/7] scsi/scsi_transport_iscsi: Update ep_connect to include iface.
Date: Tue,  6 Jun 2017 12:07:12 -0600
Message-ID: <20170606180717.5007-3-robert@leblancnet.us>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBZG63PEQKGQEWTRQEIY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Update the ep_connect function to include the iface in the parameters
passed to the driver. Since we have to make a change, also change the
dst_addr to sockaddr_storage so that it is future proof and a static
size.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 9 ++++++---
 include/scsi/scsi_transport_iscsi.h | 5 +++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a424eaeafeb0..64157a1d62e6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -34,6 +34,7 @@
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_bsg_iscsi.h>
+#include <linux/inet.h>
 
 #define ISCSI_TRANSPORT_VERSION "2.0-870"
 
@@ -2794,7 +2795,8 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 			       struct iscsi_uevent *ev, int msg_type)
 {
 	struct iscsi_endpoint *ep;
-	struct sockaddr *dst_addr;
+	struct sockaddr_storage *dst_addr;
+	struct iface_rec *iface;
 	struct Scsi_Host *shost = NULL;
 	int non_blocking, err = 0;
 
@@ -2813,8 +2815,9 @@ static int iscsi_if_ep_connect(struct iscsi_transport *transport,
 	} else
 		non_blocking = ev->u.ep_connect.non_blocking;
 
-	dst_addr = (struct sockaddr *)((char*)ev + sizeof(*ev));
-	ep = transport->ep_connect(shost, dst_addr, non_blocking);
+	dst_addr = (struct sockaddr_storage *)((char*)ev + sizeof(*ev));
+	iface = (struct iface_rec *)((char*)ev + sizeof(*ev) + sizeof(*dst_addr));
+	ep = transport->ep_connect(shost, dst_addr, non_blocking, iface);
 	if (IS_ERR(ep)) {
 		err = PTR_ERR(ep);
 		goto release_host;
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 26fe284daf9a..c146e90e912b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -133,8 +133,9 @@ struct iscsi_transport {
 
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
 	struct iscsi_endpoint *(*ep_connect) (struct Scsi_Host *shost,
-					      struct sockaddr *dst_addr,
-					      int non_blocking);
+					      struct sockaddr_storage *dst_addr,
+					      int non_blocking,
+					      struct iface_rec *iface);
 	int (*ep_poll) (struct iscsi_endpoint *ep, int timeout_ms);
 	void (*ep_disconnect) (struct iscsi_endpoint *ep);
 	int (*tgt_dscvr) (struct Scsi_Host *shost, enum iscsi_tgt_dscvr type,
-- 
2.11.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
