From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 4/7] cxlflash: Use local mutex for AFU serialization
Date: Fri, 11 May 2018 14:05:37 -0500
Message-ID: <1526065537-38969-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1526065440-38806-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

AFUs can only process a single AFU command at a time. This is enforced
with a global mutex situated within the AFU send routine. As this mutex
has a global scope, it has the potential to unnecessarily block commands
destined for other AFUs.

Instead of using a global mutex, transition the mutex to be per-AFU. This
will allow commands to only be blocked by siblings of the same AFU.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 1 +
 drivers/scsi/cxlflash/main.c   | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 3556b1d..dfcbecb 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -240,6 +240,7 @@ struct afu {
 	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
 
 	atomic_t cmds_active;	/* Number of currently active AFU commands */
+	struct mutex sync_active;	/* Mutex to serialize AFU commands */
 	u64 hb;
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index cf0b407..c91e912 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2126,6 +2126,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 
 	cfg->ops->perst_reloads_same_image(cfg->afu_cookie, true);
 
+	mutex_init(&afu->sync_active);
 	afu->num_hwqs = afu->desired_hwqs;
 	for (i = 0; i < afu->num_hwqs; i++) {
 		rc = init_mc(cfg, i);
@@ -2309,7 +2310,6 @@ static int send_afu_cmd(struct afu *afu, struct sisl_ioarcb *rcb)
 	char *buf = NULL;
 	int rc = 0;
 	int nretry = 0;
-	static DEFINE_MUTEX(sync_active);
 
 	if (cfg->state != STATE_NORMAL) {
 		dev_dbg(dev, "%s: Sync not required state=%u\n",
@@ -2317,7 +2317,7 @@ static int send_afu_cmd(struct afu *afu, struct sisl_ioarcb *rcb)
 		return 0;
 	}
 
-	mutex_lock(&sync_active);
+	mutex_lock(&afu->sync_active);
 	atomic_inc(&afu->cmds_active);
 	buf = kmalloc(sizeof(*cmd) + __alignof__(*cmd) - 1, GFP_KERNEL);
 	if (unlikely(!buf)) {
@@ -2372,7 +2372,7 @@ static int send_afu_cmd(struct afu *afu, struct sisl_ioarcb *rcb)
 		*rcb->ioasa = cmd->sa;
 out:
 	atomic_dec(&afu->cmds_active);
-	mutex_unlock(&sync_active);
+	mutex_unlock(&afu->sync_active);
 	kfree(buf);
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
 	return rc;
-- 
2.1.0
