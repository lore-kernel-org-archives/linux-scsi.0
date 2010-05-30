From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/2] drivers/scsi: Use GFP_ATOMIC when a lock is held
Date: Sun, 30 May 2010 15:49:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005301549030.15938@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function adpt_i2o_post_wait is called from several places, in some of
which, such as adpt_abort, a lock may be held.

The functions adpt_i2o_reparse_lct and adpt_i2o_lct_get are called from
several places, including adpt_rescan where a lock may be held.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@gfp exists@
identifier fn;
position p;
@@

fn(...) {
 ... when != spin_unlock_irqrestore
     when any
 GFP_KERNEL@p
 ... when any
}

@locked@
identifier gfp.fn;
@@

spin_lock_irqsave(...)
...  when != spin_unlock_irqrestore
fn(...)

@depends on locked@
position gfp.p;
@@

- GFP_KERNEL@p
+ GFP_ATOMIC
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/dpt_i2o.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b0c576f..4df589a 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1290,7 +1290,7 @@ static int adpt_i2o_post_wait(adpt_hba* pHba, u32* msg, int len, int timeout)
 	ulong flags = 0;
 	struct adpt_i2o_post_wait_data *p1, *p2;
 	struct adpt_i2o_post_wait_data *wait_data =
-		kmalloc(sizeof(struct adpt_i2o_post_wait_data),GFP_KERNEL);
+		kmalloc(sizeof(struct adpt_i2o_post_wait_data), GFP_ATOMIC);
 	DECLARE_WAITQUEUE(wait, current);
 
 	if (!wait_data)
@@ -2651,7 +2651,8 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 				pDev = pDev->next_lun;
 			}
 			if(!pDev ) { // Something new add it
-				d = kmalloc(sizeof(struct i2o_device), GFP_KERNEL);
+				d = kmalloc(sizeof(struct i2o_device),
+					    GFP_ATOMIC);
 				if(d==NULL)
 				{
 					printk(KERN_CRIT "Out of memory for I2O device data.\n");
@@ -2673,7 +2674,9 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 				}
 				pDev = pHba->channel[bus_no].device[scsi_id];	
 				if( pDev == NULL){
-					pDev =  kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev =
+					  kzalloc(sizeof(struct adpt_device),
+						  GFP_ATOMIC);
 					if(pDev == NULL) {
 						return -ENOMEM;
 					}
@@ -2682,7 +2685,9 @@ static s32 adpt_i2o_reparse_lct(adpt_hba* pHba)
 					while (pDev->next_lun) {
 						pDev = pDev->next_lun;
 					}
-					pDev = pDev->next_lun = kzalloc(sizeof(struct adpt_device),GFP_KERNEL);
+					pDev = pDev->next_lun =
+					  kzalloc(sizeof(struct adpt_device),
+						  GFP_ATOMIC);
 					if(pDev == NULL) {
 						return -ENOMEM;
 					}
@@ -3127,7 +3132,7 @@ static int adpt_i2o_lct_get(adpt_hba* pHba)
 		if (pHba->lct == NULL) {
 			pHba->lct = dma_alloc_coherent(&pHba->pDev->dev,
 					pHba->lct_size, &pHba->lct_pa,
-					GFP_KERNEL);
+					GFP_ATOMIC);
 			if(pHba->lct == NULL) {
 				printk(KERN_CRIT "%s: Lct Get failed. Out of memory.\n",
 					pHba->name);
