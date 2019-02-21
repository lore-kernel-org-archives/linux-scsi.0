From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] iscsi: fall back to sendmsg for slab pages
Date: Thu, 21 Feb 2019 18:23:17 +0300
Message-ID: <09491a85-077a-e8c7-bae0-c951cbf15c95@virtuozzo.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDYJNXFRYQBRB35SQHSAKGQEHZA6KVQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

In "XFS over network block device" scenario XFS can create IO requests
with slab-based XFS metadata. During processing such requests
tcp_sendpage() can merge skb fragments with neighbour slab objects.

If receiving side is located on the same host tcp_recvmsg() can trigger
BUG_ON in hardening check and crash the host with following message:

usercopy: kernel memory exposure attempt detected
		from XXXXXXXX (kmalloc-512) (1024 bytes)

This patch redirect such requests from sednpage to sendmsg path.
The problem is similar to one described in recent commit 7e241f647dc7
("libceph: fall back to sendmsg for slab pages")

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 drivers/scsi/libiscsi_tcp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 8a6b1b3f8277..66d97d3bef5a 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -129,12 +129,17 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
 	BUG_ON(sg->length == 0);
 
 	/*
+	 * We always map for the recv path.
+	 *
 	 * If the page count is greater than one it is ok to send
 	 * to the network layer's zero copy send path. If not we
-	 * have to go the slow sendmsg path. We always map for the
-	 * recv path.
+	 * have to go the slow sendmsg path.
+	 *
+	 * Same goes for slab pages: skb_can_coalesce() allows
+	 * coalescing neighboring slab objects into a single frag which
+	 * triggers one of hardened usercopy checks.
 	 */
-	if (page_count(sg_page(sg)) >= 1 && !recv)
+	if (!recv && page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)))
 		return;
 
 	if (recv) {
-- 
2.17.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
