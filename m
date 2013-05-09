From: Denis Efremov <yefremov.denis@gmail.com>
Subject: [PATCH 01/21] [SCSI] libiscsi: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 11:58:23 +0400
Message-ID: <1368086323-9412-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, trivial@kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/scsi/libiscsi.c     | 2 +-
 drivers/scsi/libiscsi_tcp.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5de9469..8d8d3a5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -85,7 +85,7 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 					     __func__, ##arg);		\
 	} while (0);
 
-inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
+void iscsi_conn_queue_work(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 552e8a2..2e37fcc 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -309,7 +309,7 @@ iscsi_tcp_segment_recv(struct iscsi_tcp_conn *tcp_conn,
 	return copied;
 }
 
-inline void
+void
 iscsi_tcp_dgst_header(struct hash_desc *hash, const void *hdr, size_t hdrlen,
 		      unsigned char digest[ISCSI_DIGEST_SIZE])
 {
@@ -353,7 +353,7 @@ __iscsi_segment_init(struct iscsi_segment *segment, size_t size,
 	}
 }
 
-inline void
+void
 iscsi_segment_init_linear(struct iscsi_segment *segment, void *data,
 			  size_t size, iscsi_segment_done_fn_t *done,
 			  struct hash_desc *hash)
@@ -364,7 +364,7 @@ iscsi_segment_init_linear(struct iscsi_segment *segment, void *data,
 }
 EXPORT_SYMBOL_GPL(iscsi_segment_init_linear);
 
-inline int
+int
 iscsi_segment_seek_sg(struct iscsi_segment *segment,
 		      struct scatterlist *sg_list, unsigned int sg_count,
 		      unsigned int offset, size_t size,
@@ -852,7 +852,7 @@ iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
  * returns non zero if we are currently processing or setup to process
  * a header.
  */
-inline int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn)
+int iscsi_tcp_recv_segment_is_hdr(struct iscsi_tcp_conn *tcp_conn)
 {
 	return tcp_conn->in.segment.done == iscsi_tcp_hdr_recv_done;
 }
-- 
1.8.1.4
