From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 32-byte CDB support in Libsas?
Date: Tue, 07 May 2013 15:38:18 -0700
Message-ID: <1367966298.4108.37.camel@dabdike>
References: <405BE55790F03349A85344435F25B01C0784369E@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	<1367867773.1868.39.camel@dabdike>
	 <CAD+HZHUynKmSgebmoLfPNgfbj8OVGaTUuFhJoJhNJxfvsNUFvg@mail.gmail.com>
	 <405BE55790F03349A85344435F25B01C07843842@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	 <1367957207.4108.7.camel@dabdike>
	 <405BE55790F03349A85344435F25B01C07843852@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48016 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab3EGWiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 18:38:22 -0400
In-Reply-To: <405BE55790F03349A85344435F25B01C07843852@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kamaljit Singh <Kamaljit.Singh@pmcs.com>
Cc: Jack Wang <xjtuwjp@gmail.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, linux-scsi@vger.kernel.org, Harry Yang <Harry.Yang@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, Sakthivel Saravanan Kamal Raju <sakthivel.sk@hcl.com>, Rich Bono <Rich.Bono@pmcs.com>, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>

On Tue, 2013-05-07 at 13:26 -0700, Kamaljit Singh wrote:
> > I wouldn't do it that way.  Since everything has to form a command IU
> > anyway by copying, I'd just make sas_ssp->cdb a pointer to the actual
> > command instead of an array of the command; if it points to the
> I'd prefer that too, specially since scsi_cmnd->cmnd is already a pointer.  I considered that but any such changes to libsas.h would've had wide repercussions.  Hence, I didn't go down that rathole at the moment.  

Actually, the enabling is pretty trivial.  I'll push this into the next
merge window (so for 3.11) if there are no objections.  This still
doesn't mean we have any SAS driver that will send > 16 byte commands
because they would need to alter Scsi_Host.max_cmd_len and cope with the
different format, but at least it's now a driver issue.

James

---
 drivers/scsi/aic94xx/aic94xx_task.c |    3 ++-
 drivers/scsi/isci/request.c         |    4 ++--
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 drivers/scsi/mvsas/mv_sas.c         |    3 ++-
 drivers/scsi/pm8001/pm8001_hwi.c    |    3 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c    |   21 +++++++++++----------
 include/scsi/libsas.h               |    2 +-
 7 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 393e7ce..59b86e2 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -505,7 +505,8 @@ static int asd_build_ssp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 		scb->ssp_task.ssp_cmd.efb_prio_attr |= EFB_MASK;
 	scb->ssp_task.ssp_cmd.efb_prio_attr |= (task->ssp_task.task_prio << 3);
 	scb->ssp_task.ssp_cmd.efb_prio_attr |= (task->ssp_task.task_attr & 7);
-	memcpy(scb->ssp_task.ssp_cmd.cdb, task->ssp_task.cdb, 16);
+	memcpy(scb->ssp_task.ssp_cmd.cdb, task->ssp_task.cmd->cmnd,
+	       task->ssp_task.cmd->cmd_len);
 
 	scb->ssp_task.sister_scb = cpu_to_le16(0xFFFF);
 	scb->ssp_task.conn_handle = cpu_to_le16(
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index e3e3bcb..7b08215 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -184,8 +184,8 @@ static void sci_io_request_build_ssp_command_iu(struct isci_request *ireq)
 	cmd_iu->task_attr = task->ssp_task.task_attr;
 	cmd_iu->_r_c = 0;
 
-	sci_swab32_cpy(&cmd_iu->cdb, task->ssp_task.cdb,
-		       sizeof(task->ssp_task.cdb) / sizeof(u32));
+	sci_swab32_cpy(&cmd_iu->cdb, task->ssp_task.cmd->cmnd,
+		       task->ssp_task.cmd->cmd_len / sizeof(u32));
 }
 
 static void sci_task_request_build_ssp_task_iu(struct isci_request *ireq)
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 6e795a1..da3aee1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -167,7 +167,7 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 	int_to_scsilun(cmd->device->lun, &lun);
 	memcpy(task->ssp_task.LUN, &lun.scsi_lun, 8);
 	task->ssp_task.task_attr = TASK_ATTR_SIMPLE;
-	memcpy(task->ssp_task.cdb, cmd->cmnd, 16);
+	task->ssp_task.cmd = cmd;
 
 	task->scatter = scsi_sglist(cmd);
 	task->num_scatter = scsi_sg_count(cmd);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index c9e2449..f14665a 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -686,7 +686,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 	if (ssp_hdr->frame_type != SSP_TASK) {
 		buf_cmd[9] = fburst | task->ssp_task.task_attr |
 				(task->ssp_task.task_prio << 3);
-		memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
+		memcpy(buf_cmd + 12, task->ssp_task.cmd->cmnd,
+		       task->ssp_task.cmd->cmd_len);
 	} else{
 		buf_cmd[10] = tmf->tmf;
 		switch (tmf->tmf) {
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 69dd49c..a58546f 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4291,7 +4291,8 @@ static int pm8001_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		ssp_cmd.ssp_iu.efb_prio_attr |= 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
-	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cdb, 16);
+	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
+	       task->ssp_task.cmd->cmd_len);
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
 	/* fill in PRD (scatter/gather) table, if any */
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 302514d..f6c65ee 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3559,9 +3559,9 @@ err_out:
 
 static int check_enc_sas_cmd(struct sas_task *task)
 {
-	if ((task->ssp_task.cdb[0] == READ_10)
-		|| (task->ssp_task.cdb[0] == WRITE_10)
-		|| (task->ssp_task.cdb[0] == WRITE_VERIFY))
+	u8 cmd = task->ssp_task.cmd->cmnd[0];
+
+	if (cmd == READ_10 || cmd == WRITE_10 || cmd == WRITE_VERIFY)
 		return 1;
 	else
 		return 0;
@@ -3624,7 +3624,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		ssp_cmd.ssp_iu.efb_prio_attr |= 0x80;
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_prio << 3);
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
-	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cdb, 16);
+	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
+		       task->ssp_task.cmd->cmd_len);
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 
 	/* Check if encryption is set */
@@ -3632,7 +3633,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		!(pm8001_ha->encrypt_info.status) && check_enc_sas_cmd(task)) {
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
 			"Encryption enabled.Sending Encrypt SAS command 0x%x\n",
-			task->ssp_task.cdb[0]));
+			task->ssp_task.cmd->cmnd[0]));
 		opc = OPC_INB_SSP_INI_DIF_ENC_IO;
 		/* enable encryption. 0 for SAS 1.1 and SAS 2.0 compatible TLR*/
 		ssp_cmd.dad_dir_m_tlr =	cpu_to_le32
@@ -3666,14 +3667,14 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 		/* XTS mode. All other fields are 0 */
 		ssp_cmd.key_cmode = 0x6 << 4;
 		/* set tweak values. Should be the start lba */
-		ssp_cmd.twk_val0 = cpu_to_le32((task->ssp_task.cdb[2] << 24) |
-						(task->ssp_task.cdb[3] << 16) |
-						(task->ssp_task.cdb[4] << 8) |
-						(task->ssp_task.cdb[5]));
+		ssp_cmd.twk_val0 = cpu_to_le32((task->ssp_task.cmd->cmnd[2] << 24) |
+						(task->ssp_task.cmd->cmnd[3] << 16) |
+						(task->ssp_task.cmd->cmnd[4] << 8) |
+						(task->ssp_task.cmd->cmnd[5]));
 	} else {
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
 			"Sending Normal SAS command 0x%x inb q %x\n",
-			task->ssp_task.cdb[0], inb));
+			task->ssp_task.cmd->cmnd[0], inb));
 		/* fill in PRD (scatter/gather) table, if any */
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter, ccb->n_elem,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e2c1e66..f843dd8 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -608,7 +608,7 @@ struct sas_ssp_task {
 	u8     enable_first_burst:1;
 	enum   task_attribute task_attr;
 	u8     task_prio;
-	u8     cdb[16];
+	struct scsi_cmnd *cmd;
 };
 
 struct sas_task {


