From: jsmart2021@gmail.com
Subject: [PATCH] Fix panic on BFS configuration.
Date: Fri, 21 Apr 2017 17:21:45 -0700
Message-ID: <20170422002145.15923-1-jsmart2021@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, emilne@redhat.com, jthumshirn@suse.de, linux-block@vger.kernel.org, stable@vger.kernel.org, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

To select the appropriate shost template, the driver is issuing
a mailbox command to retrieve the wwn. Turns out the sending of
the command precedes the reset of the function.  On SLI-4 adapters,
this is inconsequential as the mailbox command location is specified
by dma via the BMBX register. However, on SLI-3 adapters, the
location of the mailbox command submission area changes. When the
function is first powered on or reset, the cmd is submitted via PCI
bar memory. Later the driver changes the function config to use
host memory and DMA. The request to start a mailbox command is the
same, a simple doorbell write, regardless of submission area.
So.. if there has not been a boot driver run against the adapter,
the mailbox command works as defaults are ok. But, if the boot
driver has configured the card and, and if no platform pci
function/slot reset occurs as the os starts, the mailbox command
will fail. The SLI-3 device will use the stale boot driver dma
location. This can cause PCI eeh errors.

Fix is to reset the sli-3 function before sending the
mailbox command, thus synchronizing the function/driver on mailbox
location.

This issue was introduced by this patch:
http://www.spinics.net/lists/linux-scsi/msg105908.html
which is in the stable pools with commit id:
96418b5e2c8867da3279d877f5d1ffabfe460c3d

This patch needs to be applied to the stable trees where ever the
introducing patch exists.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_crtn.h | 1 +
 drivers/scsi/lpfc/lpfc_init.c | 7 +++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 944b32c..62016d6 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -294,6 +294,7 @@ int lpfc_selective_reset(struct lpfc_hba *);
 void lpfc_reset_barrier(struct lpfc_hba *);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
 int lpfc_sli_brdkill(struct lpfc_hba *);
+int lpfc_sli_chipset_init(struct lpfc_hba *);
 int lpfc_sli_brdreset(struct lpfc_hba *);
 int lpfc_sli_brdrestart(struct lpfc_hba *);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 90ae354..e85f273 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3602,6 +3602,13 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *mb;
 
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		/* Reset the port first */
+		lpfc_sli_brdrestart(phba);
+		rc = lpfc_sli_chipset_init(phba);
+		if (rc)
+			return (uint64_t)-1;
+	}
 
 	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						GFP_KERNEL);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cf19f49..22862b7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4446,7 +4446,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
  * iteration, the function will restart the HBA again. The function returns
  * zero if HBA successfully restarted else returns negative error code.
  **/
-static int
+int
 lpfc_sli_chipset_init(struct lpfc_hba *phba)
 {
 	uint32_t status, i = 0;
-- 
2.9.3
