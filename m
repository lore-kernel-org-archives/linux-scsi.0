From: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH] cxgb3i: fixed programing of the dma page sizes
Date: Fri, 17 Jun 2011 16:10:32 -0700
Message-ID: <201106172310.p5HNAWQ5028255@localhost6.localdomain6>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCNvLk8fsDxDzve_vBBoEzp7S4Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

[PATCH] cxgb3i: fixed programing of the dma page sizes

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Fixed missing programming of the pages sizes for DMA. 

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index fc2cdb6..ffb9eea 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1245,7 +1245,7 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 	struct cxgbi_ddp_info *ddp = tdev->ulp_iscsi;
 	struct ulp_iscsi_info uinfo;
 	unsigned int pgsz_factor[4];
-	int err;
+	int i, err;
 
 	if (ddp) {
 		kref_get(&ddp->refcnt);
@@ -1271,6 +1271,8 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 
 	uinfo.tagmask = ddp->idx_mask << PPOD_IDX_SHIFT;
 	cxgbi_ddp_page_size_factor(pgsz_factor);
+	for (i = 0; i < 4; i++)
+		uinfo.pgsz_factor[i] = pgsz_factor[i];
 	uinfo.ulimit = uinfo.llimit + (ddp->nppods << PPOD_SIZE_SHIFT);
 
 	err = tdev->ctl(tdev, ULP_ISCSI_SET_PARAMS, &uinfo);

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
