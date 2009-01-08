From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iscsi_tcp - make padbuf non-static
Date: Thu, 8 Jan 2009 12:58:56 -0800
Message-ID: <200901082058.n08Kwuml015512@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, erezzi.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


[PATCH] iscsi_tcp - make padbuf non-static

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

virt_to_page() call should not be used on kernel text and data addresses.
virt_to_page() is used by sg_init_one(). So change padbuf to be allocated within iscsi_segment.

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---

 drivers/scsi/iscsi_tcp.c |    3 +--
 drivers/scsi/iscsi_tcp.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index ed6c54c..3b07868 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -190,7 +190,6 @@ iscsi_tcp_segment_splice_digest(struct iscsi_segment *segment, void *digest)
 static inline int
 iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv, unsigned copied)
 {
-	static unsigned char padbuf[ISCSI_PAD_LEN];
 	struct scatterlist sg;
 	unsigned int pad;
 
@@ -245,7 +244,7 @@ iscsi_tcp_segment_done(struct iscsi_segment *segment, int recv, unsigned copied)
 		debug_tcp("consume %d pad bytes\n", pad);
 		segment->total_size += pad;
 		segment->size = pad;
-		segment->data = padbuf;
+		segment->data = segment->padbuf;
 		return 0;
 	}
 
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 498d8ca..a906db2 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -40,6 +40,7 @@ struct iscsi_segment {
 	unsigned int		total_copied;
 
 	struct hash_desc	*hash;
+	unsigned char		padbuf[ISCSI_PAD_LEN];
 	unsigned char		recv_digest[ISCSI_DIGEST_SIZE];
 	unsigned char		digest[ISCSI_DIGEST_SIZE];
 	unsigned int		digest_len;
