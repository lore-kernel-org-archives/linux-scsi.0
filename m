Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38D83D88F5;
	Mon,  6 Jul 2026 06:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320992; cv=none; b=RAWN+axCQgmAqMBJO7gVIOBs/FfcuSbOAfl4mmPDh7bA/JoPsOoKczE3ELn0O1XfpbGxactPC/9JZ4WtUEzmfBE1GpBQMypnPOnY1zkeA6n1hMi2yN/6z4gPP0CAp6oTVQsDtLrzeSgKEFuHGuoiF89uh668jAGWFI/L8n88MnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320992; c=relaxed/simple;
	bh=OE5djxARK5fUCsZfS5lPRA9rBRbzoI/2aHXyjZTrsnQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXE1Zf02eWK/yjwd3buuKL4RcdXQvvscS1H4HL48xsnSJDZccQn6MG750Xk+u3uO28MOxAdFLftkKxSfA7Dx0xqMum9AIIlL1QGUI70ZaPqD/jQCHxMWag6geL7ePmyE/gKE9lRCctY0gp6KnbZQjC6YR9pQI+9v1xNQ63IVT2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+frHbPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+frHbPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569A21F00ACF;
	Mon,  6 Jul 2026 06:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783320984;
	bh=TB62Cizf1uWpK38GyEp3i+NW3cSCIe1tOjiy77Lmfnc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=U+frHbPPXhKLhFFQTJRZIzEo9TAeVVAS238IMeUALixghKYRIvCcn32g6zn2KiODG
	 wsfdY3bktbDasek1Xzj5iC0cCQbJ/Z9APYTK+k/PxNcMNPHs/FmGetKtClIHgCMDg7
	 PstW0BN5lptsVMoDLDNHRovzVMzApythhWmwfsTIdmVUCx/CKRVatw4DQEaJnY/rV1
	 1VtLByJ03JfNMxvoLieUBKmrdcOXn/i9s4TBHzDuERIMmZbyOoKkXpTb93tEvns+/k
	 AiOOI4S4zvK1W0j+VQOcrRwmq3hh9S3woIcy6sWKTXZRZmbjfL22lam58H5bU5O3L+
	 sJiAnuDwN7PwA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v1 4/9] ata: libata-scsi: improve ata_get_xlat_func
Date: Mon,  6 Jul 2026 15:56:05 +0900
Message-ID: <20260706065610.3559692-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706065610.3559692-1-dlemoal@kernel.org>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ata_get_xlat_func() is given only the opcode of a SCSI command to
determine the ATA command to translate to. This makes it impossible to
translate SCSI commands such as SERVICE ACTION IN which need a service
action field to fully specify the command.

In preparation for supporting the translation of the SERVICE ACTION IN
command with service actions different from the SAI_READ_CAPACITY_16 (READ
CAPACITY 16), change ata_get_xlat_func() to take a pointer to a SCSI
command CDB so that all fields of the SCSI command to translate can be
easily inspected.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5cddb63a6bc6..f5c838ca0ce9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4606,7 +4606,7 @@ static unsigned int ata_scsi_var_len_cdb_xlat(struct ata_queued_cmd *qc)
 /**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
- *	@cmd: SCSI command opcode to consider
+ *	@cdb: CDB of the SCSI command to consider
  *
  *	Look up the SCSI command given, and determine whether the
  *	SCSI command is to be translated or simulated.
@@ -4615,9 +4615,10 @@ static unsigned int ata_scsi_var_len_cdb_xlat(struct ata_queued_cmd *qc)
  *	Pointer to translation function if possible, %NULL if not.
  */
 
-static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
+static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
+						u8 *cdb)
 {
-	switch (cmd) {
+	switch (cdb[0]) {
 	case READ_6:
 	case READ_10:
 	case READ_16:
@@ -4748,7 +4749,8 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 					struct ata_port *ap)
 	__must_hold(ap->lock)
 {
-	u8 scsi_op = scmd->cmnd[0];
+	u8 *cdb = scmd->cmnd;
+	u8 scsi_op = cdb[0];
 	ata_xlat_func_t xlat_func;
 
 	/*
@@ -4768,7 +4770,7 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 		if (unlikely(scmd->cmd_len > dev->cdb_len))
 			goto bad_cdb_len;
 
-		xlat_func = ata_get_xlat_func(dev, scsi_op);
+		xlat_func = ata_get_xlat_func(dev, cdb);
 	} else if (likely((scsi_op != ATA_16) || !atapi_passthru16)) {
 		/* relay SCSI command to ATAPI device */
 		int len = COMMAND_SIZE(scsi_op);
@@ -4784,7 +4786,7 @@ enum scsi_qc_status __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 		if (unlikely(scmd->cmd_len > 16))
 			goto bad_cdb_len;
 
-		xlat_func = ata_get_xlat_func(dev, scsi_op);
+		xlat_func = ata_get_xlat_func(dev, cdb);
 	}
 
 	if (xlat_func)
-- 
2.54.0

