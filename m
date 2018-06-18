From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: lpfc: use monotonic timestamps for statistics
Date: Mon, 18 Jun 2018 17:28:23 +0200
Message-ID: <20180618152903.1756535-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The get_seconds() function suffers from a possible overflow in 2038
or 2106, as well as jitter due to settimeofday or leap second updates,
and is deprecated.

As we are interested in elapsed time only, using ktime_get_seconds()
to read the CLOCK_MONOTONIC timebase is ideal here. This also lets us
remove the hack that tries to deal with get_seconds() going slightly
backwards, which cannot happen with montonic timestamps.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_attr.c | 10 ++--------
 drivers/scsi/lpfc/lpfc_sli.c  |  4 ++--
 drivers/scsi/lpfc/lpfc_sli.h  |  2 +-
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 729d343861f4..15c07481fe23 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5891,7 +5891,6 @@ lpfc_get_stats(struct Scsi_Host *shost)
 	struct lpfc_lnk_stat * lso = &psli->lnk_stat_offsets;
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *pmb;
-	unsigned long seconds;
 	int rc = 0;
 
 	/*
@@ -5992,12 +5991,7 @@ lpfc_get_stats(struct Scsi_Host *shost)
 
 	hs->dumped_frames = -1;
 
-	seconds = get_seconds();
-	if (seconds < psli->stats_start)
-		hs->seconds_since_last_reset = seconds +
-				((unsigned long)-1 - psli->stats_start);
-	else
-		hs->seconds_since_last_reset = seconds - psli->stats_start;
+	hs->seconds_since_last_reset = ktime_get_seconds() - psli->stats_start;
 
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 
@@ -6076,7 +6070,7 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 	else
 		lso->link_events = (phba->fc_eventTag >> 1);
 
-	psli->stats_start = get_seconds();
+	psli->stats_start = ktime_get_seconds();
 
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6f3c00a233ec..e6786a5db502 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4591,7 +4591,7 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
-	psli->stats_start = get_seconds();
+	psli->stats_start = ktime_get_seconds();
 
 	/* Give the INITFF and Post time to settle. */
 	mdelay(100);
@@ -4638,7 +4638,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
 
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
-	psli->stats_start = get_seconds();
+	psli->stats_start = ktime_get_seconds();
 
 	/* Reset HBA AER if it was enabled, note hba_flag was reset above */
 	if (hba_aer_enabled)
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 431754195505..80b191d73190 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -339,7 +339,7 @@ struct lpfc_sli {
 	struct lpfc_iocbq ** iocbq_lookup; /* array to lookup IOCB by IOTAG */
 	size_t iocbq_lookup_len;           /* current lengs of the array */
 	uint16_t  last_iotag;              /* last allocated IOTAG */
-	unsigned long  stats_start;        /* in seconds */
+	time64_t  stats_start;		   /* in seconds */
 	struct lpfc_lnk_stat lnk_stat_offsets;
 };
 
-- 
2.9.0
