Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30804D7D35
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361117; cv=none; b=qLepf06H6fcWdu6/KDdcIiqiRjXNDwZu4oyw34rC+6WFEY269TT90UAItxkfzmjUmlR0u80J1rr21OxjhmVAuXPLhksqD/LV1SSf1VHzHdZ+ZFLZgcufDL0juoO8O1R20xWWZRFdADmc8k240NdbwXEUeD56d21akIv0uDcH5Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361117; c=relaxed/simple;
	bh=U/QlNYwJkczILqg8wwN+RdOvMRbAFwp+OO53X+4x4h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXGkU1FnVGXIbNhmrtsKmw8R/lY52e6mdqmal5rHKXZSaiL8esbw+YqUun9KqqlUTLpPthN3ihYBaagemY6/FDk+pI0dzSxAGLmrsxgQPVQwKDqcIGY5vC9pfkt/V56PFSSsQwyUdGkfj9XldwZgewPFhjTyZ8vpvM5fXbLwkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vIwFGWqy; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vIwFGWqy"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrznQ3hWBz1XM4Sx;
	Fri, 25 Sep 2026 18:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361107; x=1792953108; bh=SIMg4
	CbZvzUrgSspD6+lE+6fda+80WFm9vqkk9OL9nQ=; b=vIwFGWqy8Pglkm4FljTTh
	aW6Hj1fkTx0GlELUJpMzvVcICNoXYS3MTM6RHuMErgBDLewMuF32R2bpkEXZtdIj
	E+oH+QnHTa8BSEkm+s/j3pO0/Abo9spCKpIsKEDId40veyZj0zkfAiPFKsgcCd0J
	cOm5OOh+Eqdgxa++D0xctifJ88UFIZ2ZSDa7CA0K84xOLvCUmluzpBFerGZZpfzk
	74Pdj0tbxWyn+Luqn9+7GRAoOZt4hFODHgSzQQWBXF6hDGAYfeoCoCpLZXUelMNQ
	xq+6a1LCsqZH1Zkcf/J9C5pehBcLyS349ACv7CoXW9VKcdj1bK8YBkMYEPUp96LI
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OVwQhGQCSpp5; Fri, 25 Sep 2026 18:31:47 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznD5P38z1XM5kt;
	Fri, 25 Sep 2026 18:31:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 32/54] scsi: ipr: Pass the host pointer directly to several functions
Date: Fri, 25 Sep 2026 11:26:10 -0700
Message-ID: <3b255296f86ae38f349f92e14736adaa18c9d8ec.1790360262.git.bvanassche@acm.org>
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

Pass the struct Scsi_Host pointer directly to ipr_send_blocking_cmd(),
ipr_device_reset(), and __ipr_eh_dev_reset(). Introduce the local variabl=
e
'host' in error handling functions to avoid repetitive dereferencing of
cmd->device->host. This patch prepares for enabling lock context analysis=
.
No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d221689d28c6..e9066608323c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1006,6 +1006,7 @@ static void ipr_init_ioadl(struct ipr_cmnd *ipr_cmd=
, dma_addr_t dma_addr,
=20
 /**
  * ipr_send_blocking_cmd - Send command and sleep on its completion.
+ * @host:	SCSI host
  * @ipr_cmd:	ipr command struct
  * @timeout_func:	function to invoke if command times out
  * @timeout:	timeout
@@ -1013,18 +1014,17 @@ static void ipr_init_ioadl(struct ipr_cmnd *ipr_c=
md, dma_addr_t dma_addr,
  * Return value:
  * 	none
  **/
-static void ipr_send_blocking_cmd(struct ipr_cmnd *ipr_cmd,
+static void ipr_send_blocking_cmd(struct Scsi_Host *host, struct ipr_cmn=
d *ipr_cmd,
 				  void (*timeout_func) (struct timer_list *),
 				  u32 timeout)
+	__must_hold(&host->host_lock)
 {
-	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
-
 	init_completion(&ipr_cmd->completion);
 	ipr_do_req(ipr_cmd, ipr_internal_cmd_done, timeout_func, timeout);
=20
-	spin_unlock_irq(&ioa_cfg->host->host_lock);
+	spin_unlock_irq(&host->host_lock);
 	wait_for_completion(&ipr_cmd->completion);
-	spin_lock_irq(&ioa_cfg->host->host_lock);
+	spin_lock_irq(&host->host_lock);
 }
=20
 static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
@@ -5011,7 +5011,9 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
  *	0 on success / non-zero on failure
  **/
 static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
+			    struct Scsi_Host *host,
 			    struct ipr_resource_entry *res)
+	__must_hold(&host->host_lock)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
@@ -5030,7 +5032,8 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa=
_cfg,
 	cmd_pkt->request_type =3D IPR_RQTYPE_IOACMD;
 	cmd_pkt->cdb[0] =3D IPR_RESET_DEVICE;
=20
-	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
+	ipr_send_blocking_cmd(host, ipr_cmd, ipr_timeout,
+			      IPR_DEVICE_RESET_TIMEOUT);
 	ioasc =3D be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
=20
@@ -5049,14 +5052,15 @@ static int ipr_device_reset(struct ipr_ioa_cfg *i=
oa_cfg,
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
+static int __ipr_eh_dev_reset(struct Scsi_Host *host, struct scsi_cmnd *=
scsi_cmd)
+	__must_hold(&host->host_lock)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 	int rc =3D 0;
=20
 	ENTER;
-	ioa_cfg =3D (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
+	ioa_cfg =3D (struct ipr_ioa_cfg *) host->hostdata;
 	res =3D scsi_cmd->device->hostdata;
=20
 	/*
@@ -5072,7 +5076,7 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scs=
i_cmd)
 	res->resetting_device =3D 1;
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
=20
-	rc =3D ipr_device_reset(ioa_cfg, res);
+	rc =3D ipr_device_reset(ioa_cfg, host, res);
 	res->resetting_device =3D 0;
 	res->reset_occurred =3D 1;
=20
@@ -5085,16 +5089,17 @@ static int ipr_eh_dev_reset(struct scsi_cmnd *cmd=
)
 	int rc;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
+	struct Scsi_Host *host =3D cmd->device->host;
=20
-	ioa_cfg =3D (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
+	ioa_cfg =3D (struct ipr_ioa_cfg *) host->hostdata;
 	res =3D cmd->device->hostdata;
=20
 	if (!res)
 		return FAILED;
=20
-	spin_lock_irq(&cmd->device->host->host_lock);
-	rc =3D __ipr_eh_dev_reset(cmd);
-	spin_unlock_irq(&cmd->device->host->host_lock);
+	spin_lock_irq(&host->host_lock);
+	rc =3D __ipr_eh_dev_reset(host, cmd);
+	spin_unlock_irq(&host->host_lock);
=20
 	if (rc =3D=3D SUCCESS)
 		rc =3D ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
@@ -5190,6 +5195,7 @@ static void ipr_abort_timeout(struct timer_list *t)
  **/
 static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 {
+	struct Scsi_Host *host =3D scsi_cmd->device->host;
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
@@ -5199,7 +5205,7 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd=
)
 	struct ipr_hrr_queue *hrrq;
=20
 	ENTER;
-	ioa_cfg =3D (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
+	ioa_cfg =3D (struct ipr_ioa_cfg *)host->hostdata;
 	res =3D scsi_cmd->device->hostdata;
=20
 	/* If we are currently going through reset/reload, return failed.
@@ -5247,7 +5253,8 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd=
)
=20
 	scmd_printk(KERN_ERR, scsi_cmd, "Aborting command: %02X\n",
 		    scsi_cmd->cmnd[0]);
-	ipr_send_blocking_cmd(ipr_cmd, ipr_abort_timeout, IPR_CANCEL_ALL_TIMEOU=
T);
+	ipr_send_blocking_cmd(host, ipr_cmd, ipr_abort_timeout,
+			      IPR_CANCEL_ALL_TIMEOUT);
 	ioasc =3D be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
=20
 	/*
