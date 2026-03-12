Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045C3B7B63
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350277; cv=none; b=a2NPZq76eXYAlH+j/E+nIkM8OPeWF/6NY+tWLE/8jj8WrzFEYSnaf9i0Nw+Vom7HNQX9djcoQ4f8nai/mU0/uey5Nx6gx9oW6Ruo04nm1vscXVZybpq0VyOGQIuRN7wFv/S/hKqlJj2KwrZFZWv4Go/HbswStn7DlI0TjOHYxvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350277; c=relaxed/simple;
	bh=zKlmRllY1GRHMRkgvISnURJUQ5oahKVBIUY7Gd7FSJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fym3uAjaswrQyJJt1Y6vTotrCD3OkvrvI74SbitGfTECsu7XZ9NKvVsKWKV9JlixgXvToElQ0x1HamelaU7f2ZYyPYRRdrW+d87IhyfJOD6+bTWF6ao8DLUzSqw+Kje9u3hULSGfSOvFlnaNy2P4OD1foXW8kvlQb2wzfBXMmUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aofsSTJq; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aofsSTJq"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nv5YRxzlfl5l;
	Thu, 12 Mar 2026 21:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350272; x=1775942273; bh=rb5VA
	Qd70xgHjzh7L4c/OcrwtIyf3ixZHza4Czi/Qpg=; b=aofsSTJqBkxrIxbyVF5Hh
	GqEomq04jrKiS5nzEg8V9UbvZYvBoTdqoVZjIcDgnb2ANkIZlR55kV38mhikVW9O
	j244W7xdvjWkvyWru+rddbSMskBXcAlMEZRqeetgapkw2xp7pIrJ7Pu+fnDvVINx
	0kzW5uwVKmWLclyHri/CICLE0le0GILDzIiN7J1LUMicKzC0dj+6U5pI27Nxi8LT
	neZv6WTPyxfBAdvZew8hQYHpwWJmK9CqdXniN7pMtIo6NwO2x3erJmMoXU2EIH/B
	d+83ou2nQleEtSISKKW/Qg74kto3ty86f4U5E2hDc3fjXQFwfX2SOHs0u2WqsQY4
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oycbhg00RXyu; Thu, 12 Mar 2026 21:17:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nk6pwszlfl5h;
	Thu, 12 Mar 2026 21:17:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Brian King <brking@us.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 19/36] scsi: ipr: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:30 -0700
Message-ID: <20260312211636.3245119-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index d207e5e81afe..51092834876c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1016,6 +1016,7 @@ static void ipr_init_ioadl(struct ipr_cmnd *ipr_cmd=
, dma_addr_t dma_addr,
 static void ipr_send_blocking_cmd(struct ipr_cmnd *ipr_cmd,
 				  void (*timeout_func) (struct timer_list *),
 				  u32 timeout)
+	__must_hold(ipr_cmd->ioa_cfg->host->host_lock)
 {
 	struct ipr_ioa_cfg *ioa_cfg =3D ipr_cmd->ioa_cfg;
=20
@@ -5012,6 +5013,7 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
  **/
 static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 			    struct ipr_resource_entry *res)
+	__must_hold(ioa_cfg->host->host_lock)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
@@ -5020,6 +5022,8 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa=
_cfg,
=20
 	ENTER;
 	ipr_cmd =3D ipr_get_free_ipr_cmnd(ioa_cfg);
+	/* Tell the compiler that ipr_cmd->ioa_cfg =3D=3D ioa_cfg. */
+	__assume_ctx_lock(ipr_cmd->ioa_cfg->host->host_lock);
 	ioarcb =3D &ipr_cmd->ioarcb;
 	cmd_pkt =3D &ioarcb->cmd_pkt;
=20
@@ -5050,6 +5054,7 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa=
_cfg,
  *	SUCCESS / FAILED
  **/
 static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
+	__must_hold(scsi_cmd->device->host->host_lock)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
@@ -5069,6 +5074,9 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scs=
i_cmd)
 	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead)
 		return FAILED;
=20
+	/* Tell the compiler that ioa_cfg->host =3D=3D scsi_cmd->device->host. =
*/
+	__assume_ctx_lock(ioa_cfg->host->host_lock);
+
 	res->resetting_device =3D 1;
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
=20
@@ -5189,6 +5197,7 @@ static void ipr_abort_timeout(struct timer_list *t)
  *	SUCCESS / FAILED
  **/
 static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
+	__must_hold(scsi_cmd->device->host->host_lock)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5239,6 +5248,8 @@ static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd=
)
 		return SUCCESS;
=20
 	ipr_cmd =3D ipr_get_free_ipr_cmnd(ioa_cfg);
+	/* Tell the compiler that ipr_cmd->ioa_cfg =3D=3D ioa_cfg. */
+	__assume_ctx_lock(ipr_cmd->ioa_cfg->host->host_lock);
 	ipr_cmd->ioarcb.res_handle =3D res->res_handle;
 	cmd_pkt =3D &ipr_cmd->ioarcb.cmd_pkt;
 	cmd_pkt->request_type =3D IPR_RQTYPE_IOACMD;
