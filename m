Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154BD3BE178
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360960; cv=none; b=ZzVDvWZsIIyRmIlyUaMuJshtqooz+EmHdONogPNTK3y+c0Qs6GLn3rQc8LDRyLbPA8M2i05+gvc183lSijMufAQftNTMoN6xZz7+nwKV5V75MKuexYK60JCCutppzDsquD8mKEdpu8K8LgE34HByH0npdccHavDwhUojf0h6T1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360960; c=relaxed/simple;
	bh=L2JAMA0zlCVkPHUXJWVa2uDYoyapwPzERLH0aO31upc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXtzxhARwXDx5yR9E1htHAWAmSid9QMx9prggn8HVk2Hv+Hq0qZ3ly7k0RUvgB7BQ+uJUfIZ2WgFfDZ1P1eHbY3vW6Yd2+D9h1zWsP2Y0LLgvb4Ycilz4R6TJhIRtacdpItsiWxCt0wqWSyBDFIyZnIFcXwKpFOXu7BDIpSL9cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vgK4kiPI; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vgK4kiPI"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkQ4n6Sz1XM5kt;
	Fri, 25 Sep 2026 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360947; x=1792952948; bh=4ruC1
	xYTmEMqoxjYkP92zR1yTeDDtF3Rih2vXwKSmtY=; b=vgK4kiPIieKZC3msEVLMX
	KxzumBzxvKrWNYu2+uj5/fTN6RY77GVVhWwHpt5C5Z54tueFPKm3Uf59+5l3QdZm
	wDeArFjs/YgQgFTKFcB4S1RFZr//Dp+cyTR8WtRFLh8cvu5QBMWR9DqvbrbPtU1V
	OBjwMOCXwCKJd6WaaMIHLC566XVwVkcZta85y2KH/QGhYoph7LmYuFodbuIs+h9F
	qtD4eLXHOr9eUiY7ypWvuceLqRhn0V/r0aKI86b0t2bSQiIcp/DPdhQnchp53n5s
	G1KTZGEP1O1BeakA/75MADe7WaeIn9/mEJ9PHOHQORNH4xdkS51rBHquaISNS2pH
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v8uXhm9TK0fd; Fri, 25 Sep 2026 18:29:07 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzk93CFbz1XM30g;
	Fri, 25 Sep 2026 18:29:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly to several functions
Date: Fri, 25 Sep 2026 11:25:42 -0700
Message-ID: <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Pass the struct Scsi_Host pointer directly to multiple functions. This
prepares the BusLogic driver for enabling compiler-based lock context
analysis. No functionality has been changed.

Cc: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 93 +++++++++++++++++++++++------------------
 drivers/scsi/BusLogic.h |  2 +-
 2 files changed, 54 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 27b446c0c5d0..75aaf35383a9 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -276,8 +276,9 @@ static void blogic_create_addlccbs(struct blogic_adap=
ter *adapter,
   Lock should already have been acquired by the caller.
 */
=20
-static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapte=
r)
+static struct blogic_ccb *blogic_alloc_ccb(struct Scsi_Host *host)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	static unsigned long serial;
 	struct blogic_ccb *ccb;
 	ccb =3D adapter->free_ccbs;
@@ -307,7 +308,8 @@ static struct blogic_ccb *blogic_alloc_ccb(struct blo=
gic_adapter *adapter)
   caller.
 */
=20
-static void blogic_dealloc_ccb(struct blogic_ccb *ccb, int dma_unmap)
+static void blogic_dealloc_ccb(struct Scsi_Host *host, struct blogic_ccb=
 *ccb,
+			       int dma_unmap)
 {
 	struct blogic_adapter *adapter =3D ccb->adapter;
=20
@@ -2596,8 +2598,10 @@ static void blogic_scan_inbox(struct blogic_adapte=
r *adapter)
   should already have been acquired by the caller.
 */
=20
-static void blogic_process_ccbs(struct blogic_adapter *adapter)
+static void blogic_process_ccbs(struct Scsi_Host *host)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
+
 	if (adapter->processing_ccbs)
 		return;
 	adapter->processing_ccbs =3D true;
@@ -2621,7 +2625,7 @@ static void blogic_process_ccbs(struct blogic_adapt=
er *adapter)
 			/*
 			   Place CCB back on the Host Adapter's free list.
 			 */
-			blogic_dealloc_ccb(ccb, 1);
+			blogic_dealloc_ccb(host, ccb, 1);
 #if 0			/* this needs to be redone different for new EH */
 			/*
 			   Bus Device Reset CCBs have the command field
@@ -2650,7 +2654,7 @@ static void blogic_process_ccbs(struct blogic_adapt=
er *adapter)
 				if (ccb->status =3D=3D BLOGIC_CCB_RESET &&
 						ccb->tgt_id =3D=3D tgt_id) {
 					command =3D ccb->command;
-					blogic_dealloc_ccb(ccb, 1);
+					blogic_dealloc_ccb(host, ccb, 1);
 					adapter->active_cmds[tgt_id]--;
 					command->result =3D DID_RESET << 16;
 					scsi_done(command);
@@ -2721,7 +2725,7 @@ static void blogic_process_ccbs(struct blogic_adapt=
er *adapter)
 			/*
 			   Place CCB back on the Host Adapter's free list.
 			 */
-			blogic_dealloc_ccb(ccb, 1);
+			blogic_dealloc_ccb(host, ccb, 1);
 			/*
 			   Call the SCSI Command Completion Routine.
 			 */
@@ -2740,11 +2744,12 @@ static void blogic_process_ccbs(struct blogic_ada=
pter *adapter)
 static irqreturn_t blogic_inthandler(int irq_ch, void *devid)
 {
 	struct blogic_adapter *adapter =3D (struct blogic_adapter *) devid;
+	struct Scsi_Host *host =3D adapter->scsi_host;
 	unsigned long processor_flag;
 	/*
 	   Acquire exclusive access to Host Adapter.
 	 */
-	spin_lock_irqsave(&adapter->scsi_host->host_lock, processor_flag);
+	spin_lock_irqsave(&host->host_lock, processor_flag);
 	/*
 	   Handle Interrupts appropriately for each Host Adapter type.
 	 */
@@ -2794,25 +2799,25 @@ static irqreturn_t blogic_inthandler(int irq_ch, =
void *devid)
 	   Process any completed CCBs.
 	 */
 	if (adapter->firstccb !=3D NULL)
-		blogic_process_ccbs(adapter);
+		blogic_process_ccbs(host);
 	/*
 	   Reset the Host Adapter if requested.
 	 */
 	if (adapter->adapter_extreset) {
 		blogic_warn("Resetting %s due to External SCSI Bus Reset\n", adapter, =
adapter->full_model);
 		blogic_inc_count(&adapter->ext_resets);
-		blogic_resetadapter(adapter, false);
+		blogic_resetadapter(host, false);
 		adapter->adapter_extreset =3D false;
 	} else if (adapter->adapter_intern_err) {
 		blogic_warn("Resetting %s due to Host Adapter Internal Error\n", adapt=
er, adapter->full_model);
 		blogic_inc_count(&adapter->adapter_intern_errors);
-		blogic_resetadapter(adapter, true);
+		blogic_resetadapter(host, true);
 		adapter->adapter_intern_err =3D false;
 	}
 	/*
 	   Release exclusive access to Host Adapter.
 	 */
-	spin_unlock_irqrestore(&adapter->scsi_host->host_lock, processor_flag);
+	spin_unlock_irqrestore(&host->host_lock, processor_flag);
 	return IRQ_HANDLED;
 }
=20
@@ -2823,9 +2828,10 @@ static irqreturn_t blogic_inthandler(int irq_ch, v=
oid *devid)
   already have been acquired by the caller.
 */
=20
-static bool blogic_write_outbox(struct blogic_adapter *adapter,
+static bool blogic_write_outbox(struct Scsi_Host *host,
 		enum blogic_action action, struct blogic_ccb *ccb)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	struct blogic_outbox *next_outbox;
=20
 	next_outbox =3D adapter->next_outbox;
@@ -2859,17 +2865,16 @@ static int blogic_hostreset(struct scsi_cmnd *SCp=
nt)
 {
 	struct blogic_adapter *adapter =3D
 		(struct blogic_adapter *) SCpnt->device->host->hostdata;
-
+	struct Scsi_Host *shost =3D adapter->scsi_host;
 	unsigned int id =3D SCpnt->device->id;
 	struct blogic_tgt_stats *stats =3D &adapter->tgt_stats[id];
 	int rc;
=20
-	spin_lock_irq(&SCpnt->device->host->host_lock);
-
+	spin_lock_irq(&shost->host_lock);
 	blogic_inc_count(&stats->adapter_reset_req);
+	rc =3D blogic_resetadapter(shost, false);
+	spin_unlock_irq(&shost->host_lock);
=20
-	rc =3D blogic_resetadapter(adapter, false);
-	spin_unlock_irq(&SCpnt->device->host->host_lock);
 	return rc;
 }
=20
@@ -2878,11 +2883,11 @@ static int blogic_hostreset(struct scsi_cmnd *SCp=
nt)
   Outgoing Mailbox for execution by the associated Host Adapter.
 */
=20
-static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
+static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, stru=
ct scsi_cmnd *command)
 {
 	void (*comp_cb)(struct scsi_cmnd *) =3D scsi_done;
 	struct blogic_adapter *adapter =3D
-		(struct blogic_adapter *) command->device->host->hostdata;
+		(struct blogic_adapter *) shost->hostdata;
 	struct blogic_tgt_flags *tgt_flags =3D
 		&adapter->tgt_flags[command->device->id];
 	struct blogic_tgt_stats *tgt_stats =3D adapter->tgt_stats;
@@ -2913,12 +2918,12 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
 scsi_cmnd *command)
 	   probably hung so signal an error as a Host Adapter Hard Reset
 	   should be initiated soon.
 	 */
-	ccb =3D blogic_alloc_ccb(adapter);
+	ccb =3D blogic_alloc_ccb(shost);
 	if (ccb =3D=3D NULL) {
-		spin_unlock_irq(&adapter->scsi_host->host_lock);
+		spin_unlock_irq(&shost->host_lock);
 		blogic_delay(1);
-		spin_lock_irq(&adapter->scsi_host->host_lock);
-		ccb =3D blogic_alloc_ccb(adapter);
+		spin_lock_irq(&shost->host_lock);
+		ccb =3D blogic_alloc_ccb(shost);
 		if (ccb =3D=3D NULL) {
 			command->result =3D DID_ERROR << 16;
 			comp_cb(command);
@@ -3046,7 +3051,7 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 	if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
 		blogic_err("DMA mapping for sense data buffer failed\n",
 				adapter);
-		blogic_dealloc_ccb(ccb, 0);
+		blogic_dealloc_ccb(shost, ccb, 0);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	ccb->sensedata =3D sense_buf;
@@ -3061,15 +3066,15 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
 scsi_cmnd *command)
 		   so signal an error as a Host Adapter Hard Reset should
 		   be initiated soon.
 		 */
-		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
-			spin_unlock_irq(&adapter->scsi_host->host_lock);
+		if (!blogic_write_outbox(shost, BLOGIC_MBOX_START, ccb)) {
+			spin_unlock_irq(&shost->host_lock);
 			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\=
n", adapter);
 			blogic_delay(1);
-			spin_lock_irq(&adapter->scsi_host->host_lock);
-			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
+			spin_lock_irq(&shost->host_lock);
+			if (!blogic_write_outbox(shost, BLOGIC_MBOX_START,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter D=
ead?\n", adapter);
-				blogic_dealloc_ccb(ccb, 1);
+				blogic_dealloc_ccb(shost, ccb, 1);
 				command->result =3D DID_ERROR << 16;
 				scsi_done(command);
 			}
@@ -3089,12 +3094,20 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
 scsi_cmnd *command)
 		   pending.
 		 */
 		if (ccb->status =3D=3D BLOGIC_CCB_COMPLETE)
-			blogic_process_ccbs(adapter);
+			blogic_process_ccbs(shost);
 	}
 	return 0;
 }
=20
-static DEF_SCSI_QCMD(blogic_qcmd)
+static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *shost, struct s=
csi_cmnd *cmd)
+{
+	enum scsi_qc_status rc;
+
+	spin_lock_irq(&shost->host_lock);
+	rc =3D blogic_qcmd_lck(shost, cmd);
+	spin_unlock_irq(&shost->host_lock);
+	return rc;
+}
=20
 #if 0
 /*
@@ -3103,9 +3116,8 @@ static DEF_SCSI_QCMD(blogic_qcmd)
=20
 static int blogic_abort(struct scsi_cmnd *command)
 {
-	struct blogic_adapter *adapter =3D
-		(struct blogic_adapter *) command->device->host->hostdata;
-
+	struct Scsi_Host *const shost =3D command->device->host;
+	struct blogic_adapter *adapter =3D (void *) shost->hostdata;
 	int tgt_id =3D command->device->id;
 	struct blogic_ccb *ccb;
 	blogic_inc_count(&adapter->tgt_stats[tgt_id].aborts_request);
@@ -3144,7 +3156,7 @@ static int blogic_abort(struct scsi_cmnd *command)
 				adapter->fw_ver[0] < '5') {
 			blogic_warn("Unable to Abort CCB #%ld to Target %d - Abort Tag Not Su=
pported\n", adapter, ccb->serial, tgt_id);
 			return FAILURE;
-		} else if (blogic_write_outbox(adapter, BLOGIC_MBOX_ABORT,
+		} else if (blogic_write_outbox(shost, BLOGIC_MBOX_ABORT,
 					ccb)) {
 			blogic_warn("Aborting CCB #%ld to Target %d\n",
 					adapter, ccb->serial, tgt_id);
@@ -3169,7 +3181,7 @@ static int blogic_abort(struct scsi_cmnd *command)
 		   may still be pending.
 		 */
 		if (ccb->status =3D=3D BLOGIC_CCB_COMPLETE)
-			blogic_process_ccbs(adapter);
+			blogic_process_ccbs(shost);
 		return SUCCESS;
 	}
 	return SUCCESS;
@@ -3181,8 +3193,9 @@ static int blogic_abort(struct scsi_cmnd *command)
   currently executing SCSI Commands as having been Reset.
 */
=20
-static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard=
_reset)
+static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset)
 {
+	struct blogic_adapter *adapter =3D (void *)host->hostdata;
 	struct blogic_ccb *ccb;
 	int tgt_id;
=20
@@ -3203,7 +3216,7 @@ static int blogic_resetadapter(struct blogic_adapte=
r *adapter, bool hard_reset)
=20
 	for (ccb =3D adapter->all_ccbs; ccb !=3D NULL; ccb =3D ccb->next_all)
 		if (ccb->status =3D=3D BLOGIC_CCB_ACTIVE)
-			blogic_dealloc_ccb(ccb, 1);
+			blogic_dealloc_ccb(host, ccb, 1);
 	/*
 	 * Wait a few seconds between the Host Adapter Hard Reset which
 	 * initiates a SCSI Bus Reset and issuing any SCSI Commands.  Some
@@ -3212,9 +3225,9 @@ static int blogic_resetadapter(struct blogic_adapte=
r *adapter, bool hard_reset)
 	 */
=20
 	if (hard_reset) {
-		spin_unlock_irq(&adapter->scsi_host->host_lock);
+		spin_unlock_irq(&host->host_lock);
 		blogic_delay(adapter->bus_settle_time);
-		spin_lock_irq(&adapter->scsi_host->host_lock);
+		spin_lock_irq(&host->host_lock);
 	}
=20
 	for (tgt_id =3D 0; tgt_id < adapter->maxdev; tgt_id++) {
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 24697a5bedc8..6ace3c307a90 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1279,7 +1279,7 @@ static int blogic_sdev_configure(struct scsi_device=
 *,
 				 struct queue_limits *lim);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
-static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset)=
;
+static int blogic_resetadapter(struct Scsi_Host *host, bool hard_reset);
 static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapt=
er *, ...);
 static int __init blogic_setup(char *);
=20
