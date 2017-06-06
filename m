From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 7/7] scsi/qla4xxx: Update qla4xxx_ep_connect to accept iface and sockaddr_storage.
Date: Tue,  6 Jun 2017 12:07:17 -0600
Message-ID: <20170606180717.5007-8-robert@leblancnet.us>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBZO63PEQKGQEXQRHMQI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Update QLogic ISP4XXX and ISP82XX drivers to accept the session iface for
creating the iSCSI connection. Also accept dst_addr as sockaddr_storage
instead of sockaddr.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa563fdb..4fccb580bd48 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -119,8 +119,9 @@ static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 				   int param, char *buf);
 static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 static struct iscsi_endpoint *qla4xxx_ep_connect(struct Scsi_Host *shost,
-						 struct sockaddr *dst_addr,
-						 int non_blocking);
+						 struct sockaddr_storage *dst_addr,
+						 int non_blocking,
+						 struct iface_rec *iface);
 static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms);
 static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep);
 static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
@@ -1656,8 +1657,8 @@ static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 }
 
 static struct iscsi_endpoint *
-qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
-		   int non_blocking)
+qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
+		   int non_blocking, struct iface_rec *iface)
 {
 	int ret;
 	struct iscsi_endpoint *ep;
@@ -1681,12 +1682,12 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	qla_ep = ep->dd_data;
 	memset(qla_ep, 0, sizeof(struct qla_endpoint));
-	if (dst_addr->sa_family == AF_INET) {
+	if (dst_addr->ss_family == AF_INET) {
 		memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct sockaddr_in));
 		addr = (struct sockaddr_in *)&qla_ep->dst_addr;
 		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
 				  (char *)&addr->sin_addr));
-	} else if (dst_addr->sa_family == AF_INET6) {
+	} else if (dst_addr->ss_family == AF_INET6) {
 		memcpy(&qla_ep->dst_addr, dst_addr,
 		       sizeof(struct sockaddr_in6));
 		addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
@@ -6569,7 +6570,7 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
 		addr->sin_port = htons(le16_to_cpu(fw_ddb_entry->port));
 	}
 
-	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
+	ep = qla4xxx_ep_connect(ha->host, dst_addr, 0, NULL);
 	vfree(dst_addr);
 	return ep;
 }
-- 
2.11.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
