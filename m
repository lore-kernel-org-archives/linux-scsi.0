From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [RFC PATCH] lpfc: additional lpfc_printf_log() to PLOGI and other
 failure cases.
Date: Mon, 15 Feb 2010 16:47:12 +0900
Message-ID: <4B78FC00.6010400@jp.fujitsu.com>
References: <4B75196E.9040204@jp.fujitsu.com> <4B757498.7090509@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46900 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab0BOHrg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2010 02:47:36 -0500
Received: from m1.gw.fujitsu.co.jp ([10.0.50.71])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o1F7lYWX003475
	for <linux-scsi@vger.kernel.org> (envelope-from tokunaga.keiich@jp.fujitsu.com);
	Mon, 15 Feb 2010 16:47:35 +0900
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id BB68F45DE51
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 16:47:34 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9319A45DE4E
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 16:47:34 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 753C31DB803C
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 16:47:34 +0900 (JST)
Received: from m025.s.css.fujitsu.com (m025.s.css.fujitsu.com [10.0.81.65])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 290791DB8041
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 16:47:34 +0900 (JST)
In-Reply-To: <4B757498.7090509@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>

James Smart wrote:
> Kei,
>
> Sounds very reasonable.  Let me pull this into our team. We have a process of 
> assigning unique log message numbers, which gets tied to documentation, and 
> field support guides.  We'll include an updated version of this patch in a 
> future patch set.  Please note though, we're in the final throes of distro 
> submissions, so it may be a little delayed.
That's no problem.  Glad to hear the patch will be pulled in.

While waiting for the inclusion, please let me bring up a few
more potential points here to discuss.  This patch shows the
points which I think should help us as well.  Would you also
comment on the patch, please?

Kei

---

 linux-2.6.33-rc7-log-kei/drivers/scsi/lpfc/lpfc_scsi.c |   14 ++++++++++++--
 linux-2.6.33-rc7-log-kei/drivers/scsi/lpfc/lpfc_sli.c  |   11 ++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_els.c~lpfc_log_add_misc drivers/scsi/lpfc/lpfc_els.c
diff -puN drivers/scsi/lpfc/lpfc_scsi.c~lpfc_log_add_misc drivers/scsi/lpfc/lpfc_scsi.c
--- linux-2.6.33-rc7-log/drivers/scsi/lpfc/lpfc_scsi.c~lpfc_log_add_misc	2010-02-15 10:44:02.000000000 +0900
+++ linux-2.6.33-rc7-log-kei/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-15 16:47:03.000000000 +0900
@@ -2079,8 +2079,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 
 	if (resp_info & RSP_LEN_VALID) {
 		rsplen = be32_to_cpu(fcprsp->rspRspLen);
-		if ((rsplen != 0 && rsplen != 4 && rsplen != 8) ||
-		    (fcprsp->rspInfo3 != RSP_NO_FAILURE)) {
+		if (rsplen != 0 && rsplen != 4 && rsplen != 8) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "2719 Invalid response length: "
 				 "tgt x%x lun x%x cmnd x%x rsplen x%x\n",
@@ -2090,6 +2089,17 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 			host_status = DID_ERROR;
 			goto out;
 		}
+		if (fcprsp->rspInfo3 != RSP_NO_FAILURE) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+				 "xxxx Protocol failure detected during "
+				 "processing of FCP I/O op: "
+				 "tgt x%x lun x%x cmnd x%x rspInfo3 x%x\n",
+				 cmnd->device->id,
+				 cmnd->device->lun, cmnd->cmnd[0],
+				 fcprsp->rspInfo3);
+			host_status = DID_ERROR;
+			goto out;
+		}
 	}
 
 	if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen) {
diff -puN drivers/scsi/lpfc/lpfc_sli.c~lpfc_log_add_misc drivers/scsi/lpfc/lpfc_sli.c
--- linux-2.6.33-rc7-log/drivers/scsi/lpfc/lpfc_sli.c~lpfc_log_add_misc	2010-02-15 10:44:02.000000000 +0900
+++ linux-2.6.33-rc7-log-kei/drivers/scsi/lpfc/lpfc_sli.c	2010-02-15 10:44:02.000000000 +0900
@@ -3039,6 +3039,12 @@ lpfc_sli_brdready_s3(struct lpfc_hba *ph
 
 	/* Check to see if any errors occurred during init */
 	if ((status & HS_FFERM) || (i >= 20)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"xxxx Adapter failed to restart, "
+				"status reg x%x, FW Data: A8 x%x AC x%x\n",
+				status,
+				readl(phba->MBslimaddr + 0xa8),
+				readl(phba->MBslimaddr + 0xac));
 		phba->link_state = LPFC_HBA_ERROR;
 		retval = 1;
 	}
@@ -3226,6 +3232,9 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 	if (retval != MBX_SUCCESS) {
 		if (retval != MBX_BUSY)
 			mempool_free(pmb, phba->mbox_mem_pool);
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"xxxx KILL_BOARD command failed "
+				"retval %d\n", retval);
 		spin_lock_irq(&phba->hbalock);
 		phba->link_flag &= ~LS_IGNORE_ERATT;
 		spin_unlock_irq(&phba->hbalock);
@@ -3983,7 +3992,7 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 
 lpfc_sli_hba_setup_error:
 	phba->link_state = LPFC_HBA_ERROR;
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"0445 Firmware initialization failed\n");
 	return rc;
 }

_



