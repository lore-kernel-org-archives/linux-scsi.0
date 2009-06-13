From: kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Subject: [PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp usage
Date: Sat, 13 Jun 2009 14:29:01 -0700
Message-ID: <200906132129.n5DLT1l5029019@localhost.localdomain>
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


[PATCH 1/2 2.6.30-rc] cxgb3i -- add a refcnt to track ddp usage

From: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

The iscsi ddp functionality could be used by multiple iscsi entities,
add a refcnt to keep track of it, so we would not release it pre-maturely.

Signed-off-by: Karen Xie <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c |   11 +++++++----
 drivers/scsi/cxgb3i/cxgb3i_ddp.h |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 99c9125..b6fdb5e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -603,9 +603,10 @@ void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
 	int i = 0;
 	struct cxgb3i_ddp_info *ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
 
-	ddp_log_info("t3dev 0x%p, release ddp 0x%p.\n", tdev, ddp);
+	ddp_log_info("t3dev 0x%p, release ddp 0x%p, ref %d.\n",
+			tdev, ddp, atomic_read(&ddp->refcnt));
 
-	if (ddp) {
+	if (ddp && atomic_dec_and_test(&ddp->refcnt)) {
 		tdev->ulp_iscsi = NULL;
 		while (i < ddp->nppods) {
 			struct cxgb3i_gather_list *gl = ddp->gl_map[i];
@@ -631,12 +632,13 @@ void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
  */
 static void ddp_init(struct t3cdev *tdev)
 {
-	struct cxgb3i_ddp_info *ddp;
+	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
 	struct ulp_iscsi_info uinfo;
 	unsigned int ppmax, bits;
 	int i, err;
 
-	if (tdev->ulp_iscsi) {
+	if (ddp) {
+		atomic_inc(&ddp->refcnt);
 		ddp_log_warn("t3dev 0x%p, ddp 0x%p already set up.\n",
 				tdev, tdev->ulp_iscsi);
 		return;
@@ -670,6 +672,7 @@ static void ddp_init(struct t3cdev *tdev)
 					  ppmax *
 					  sizeof(struct cxgb3i_gather_list *));
 	spin_lock_init(&ddp->map_lock);
+	atomic_set(&ddp->refcnt, 1);
 
 	ddp->tdev = tdev;
 	ddp->pdev = uinfo.pdev;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 0d296de..0e699e8 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -54,6 +54,7 @@ struct cxgb3i_gather_list {
  * struct cxgb3i_ddp_info - cxgb3i direct data placement for pdu payload
  *
  * @list:	list head to link elements
+ * @refcnt:	count of iscsi entities using it
  * @tdev:	pointer to t3cdev used by cxgb3 driver
  * @max_txsz:	max tx packet size for ddp
  * @max_rxsz:	max rx packet size for ddp
@@ -70,6 +71,7 @@ struct cxgb3i_gather_list {
  */
 struct cxgb3i_ddp_info {
 	struct list_head list;
+	atomic_t refcnt;
 	struct t3cdev *tdev;
 	struct pci_dev *pdev;
 	unsigned int max_txsz;
