From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libiscsi: Add an internal error code
Date: Fri, 21 Apr 2017 12:42:01 -0600
Message-ID: <1492800121-21840-1-git-send-email-logang@deltatee.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBC645DPNQEERBA5F5HDQKGQESBFHB6A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Varun Prakash <varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This is a prep patch to add a new error code to libiscsi. We want to
rework some kmap calls to be able to fail. When we do, we'd like to
use this error code.

This patch simply introduces ISCSI_TCP_INTERNAL_ERR and prints
"Internal Error." when it gets hit.

Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
---

Please see these links for additional context.

https://patchwork.kernel.org/patch/9680329/
https://patchwork.kernel.org/patch/9680091/

Thanks,

Logan

 drivers/scsi/cxgbi/libcxgbi.c | 5 +++++
 include/scsi/libiscsi_tcp.h   | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index bd7d39e..e38d0c1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1556,6 +1556,11 @@ static inline int read_pdu_skb(struct iscsi_conn *conn,
 		 */
 		iscsi_conn_printk(KERN_ERR, conn, "Invalid pdu or skb.");
 		return -EFAULT;
+	case ISCSI_TCP_INTERNAL_ERR:
+		pr_info("skb 0x%p, off %u, %d, TCP_INTERNAL_ERR.\n",
+			skb, offset, offloaded);
+		iscsi_conn_printk(KERN_ERR, conn, "Internal error.");
+		return -EFAULT;
 	case ISCSI_TCP_SEGMENT_DONE:
 		log_debug(1 << CXGBI_DBG_PDU_RX,
 			"skb 0x%p, off %u, %d, TCP_SEG_DONE, rc %d.\n",
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index 30520d5..90691ad 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -92,6 +92,7 @@ enum {
 	ISCSI_TCP_SKB_DONE,		/* skb is out of data */
 	ISCSI_TCP_CONN_ERR,		/* iscsi layer has fired a conn err */
 	ISCSI_TCP_SUSPENDED,		/* conn is suspended */
+	ISCSI_TCP_INTERNAL_ERR,         /* an internal error occurred */
 };

 extern void iscsi_tcp_hdr_recv_prep(struct iscsi_tcp_conn *tcp_conn);
--
2.1.4

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
