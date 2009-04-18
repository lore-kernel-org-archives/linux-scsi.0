From: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH] cxgb3i: fix ddp map overrun
Date: Fri, 17 Apr 2009 18:23:57 -0700
Message-ID: <200904180123.n3I1NvjK003958@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


[PATCH] cxgb3i: fix ddp map overrun

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Fixed a bug in calculating ddp map range when search for free entries: 
it was going beyond the end by one, thus corrupting gl_skb[0].

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index d06a661..43f6ece 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -367,7 +367,7 @@ int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
 	}
 
 	npods = (gl->nelem + PPOD_PAGES_MAX - 1) >> PPOD_PAGES_SHIFT;
-	idx_max = ddp->nppods - npods + 1;
+	idx_max = ddp->nppods - npods;
 
 	if (ddp->idx_last == ddp->nppods)
 		idx = ddp_find_unused_entries(ddp, 0, idx_max, npods, gl);
@@ -376,7 +376,7 @@ int cxgb3i_ddp_tag_reserve(struct t3cdev *tdev, unsigned int tid,
 					      idx_max, npods, gl);
 		if (idx < 0 && ddp->idx_last >= npods)
 			idx = ddp_find_unused_entries(ddp, 0,
-						      ddp->idx_last - npods + 1,
+						      ddp->idx_last + npods - 1,
 						      npods, gl);
 	}
 	if (idx < 0) {
