From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/21] lpfc 8.3.33: Add Interrupts per second stats via
 debugfs
Date: Fri, 3 Aug 2012 12:36:03 -0400
Message-ID: <1344011763.6110.38.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40330 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2HCQgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:36:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add Interrupts per second stats via debugfs


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   18 +++++++++++++++++-
 lpfc_sli.h |    2 ++
 2 files changed, 19 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-07-23 15:26:06.443425608 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-07-23 15:30:43.182415997 -0400
@@ -2825,10 +2825,26 @@ lpfc_sli_rsp_pointers_error(struct lpfc_
 void lpfc_poll_eratt(unsigned long ptr)
 {
 	struct lpfc_hba *phba;
-	uint32_t eratt = 0;
+	uint32_t eratt = 0, rem;
+	uint64_t sli_intr, cnt;
 
 	phba = (struct lpfc_hba *)ptr;
 
+	/* Here we will also keep track of interrupts per sec of the hba */
+	sli_intr = phba->sli.slistat.sli_intr;
+
+	if (phba->sli.slistat.sli_prev_intr > sli_intr)
+		cnt = (((uint64_t)(-1) - phba->sli.slistat.sli_prev_intr) +
+			sli_intr);
+	else
+		cnt = (sli_intr - phba->sli.slistat.sli_prev_intr);
+
+	/* 64-bit integer division not supporte on 32-bit x86 - use do_div */
+	rem = do_div(cnt, LPFC_ERATT_POLL_INTERVAL);
+	phba->sli.slistat.sli_ips = cnt;
+
+	phba->sli.slistat.sli_prev_intr = sli_intr;
+
 	/* Check chip HA register for error event */
 	eratt = lpfc_sli_check_eratt(phba);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2012-07-23 15:26:06.449425608 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2012-07-23 15:26:18.519425189 -0400
@@ -255,6 +255,8 @@ struct lpfc_sli_stat {
 	uint64_t mbox_stat_err;  /* Mbox cmds completed status error */
 	uint64_t mbox_cmd;       /* Mailbox commands issued */
 	uint64_t sli_intr;       /* Count of Host Attention interrupts */
+	uint64_t sli_prev_intr;  /* Previous cnt of Host Attention interrupts */
+	uint64_t sli_ips;        /* Host Attention interrupts per sec */
 	uint32_t err_attn_event; /* Error Attn event counters */
 	uint32_t link_event;     /* Link event counters */
 	uint32_t mbox_event;     /* Mailbox event counters */



