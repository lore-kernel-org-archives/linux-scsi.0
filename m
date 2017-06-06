From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 6/7] scsi/cxgbi: Update cxgbi_ep_connect to accept iface and sockaddr_storage.
Date: Tue,  6 Jun 2017 12:07:16 -0600
Message-ID: <20170606180717.5007-7-robert@leblancnet.us>
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

Update Chelsio iSCSI driver to accept the session iface for creating the
iSCSI connection. Also accept dst_addr as sockaddr_storage instead of
sockaddr.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 drivers/scsi/cxgbi/libcxgbi.c | 15 ++++++++-------
 drivers/scsi/cxgbi/libcxgbi.h |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39ecbd24..62f62305be49 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2499,8 +2499,9 @@ int cxgbi_get_host_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 EXPORT_SYMBOL_GPL(cxgbi_get_host_param);
 
 struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
-					struct sockaddr *dst_addr,
-					int non_blocking)
+					struct sockaddr_storage *dst_addr,
+					int non_blocking,
+					struct iface_rec *iface)
 {
 	struct iscsi_endpoint *ep;
 	struct cxgbi_endpoint *cep;
@@ -2520,15 +2521,15 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
 		}
 	}
 
-	if (dst_addr->sa_family == AF_INET) {
-		csk = cxgbi_check_route(dst_addr);
+	if (dst_addr->ss_family == AF_INET) {
+		csk = cxgbi_check_route((struct sockaddr *)dst_addr);
 #if IS_ENABLED(CONFIG_IPV6)
-	} else if (dst_addr->sa_family == AF_INET6) {
-		csk = cxgbi_check_route6(dst_addr);
+	} else if (dst_addr->ss_family == AF_INET6) {
+		csk = cxgbi_check_route6((struct sockaddr *)dst_addr);
 #endif
 	} else {
 		pr_info("address family 0x%x NOT supported.\n",
-			dst_addr->sa_family);
+			dst_addr->ss_family);
 		err = -EAFNOSUPPORT;
 		return (struct iscsi_endpoint *)ERR_PTR(err);
 	}
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 18e0ea83d361..e2e0c4dc7abc 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -596,7 +596,7 @@ int cxgbi_set_host_param(struct Scsi_Host *,
 			enum iscsi_host_param, char *, int);
 int cxgbi_get_host_param(struct Scsi_Host *, enum iscsi_host_param, char *);
 struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *,
-			struct sockaddr *, int);
+			struct sockaddr_storage *, int, struct iface_rec *);
 int cxgbi_ep_poll(struct iscsi_endpoint *, int);
 void cxgbi_ep_disconnect(struct iscsi_endpoint *);
 
-- 
2.11.0

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
