Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AD33546FE;
	Mon, 31 Aug 2026 02:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141923; cv=none; b=NyjWzAoOBxt6ZxHl/ZXaJV7LzwBIRYckuDQd43Zwjtx7y/Ina4L9Zz3n7Raef4fbyVeAGR1S86j8b1mzTx+EoeFSo1smM957Mq3+8iBEku3qIDzfKGXUnLaYAVOK5AqBu2zCX7hGNpfZfa+0PifwVQGVXkjM2to1pWcwu/Dxo8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141923; c=relaxed/simple;
	bh=h91m6Gi9mfzy56yUa3CWOR+qlA3zOVIWDtYNuw0109o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG41yH84EGXOkWi+iPEJzSAVtx45KrlPlO9GeN03VbkDVrKlkLMSlL3zdBr33w8Mu23Qn8d5+nTmgtNLyJi41Apod1pbdlLEkP1LheJOXFkn6LePDBRYUHyh9jZEvbZ3aizboAPPBXNtcCwycPhwr0ToVmCQD56sa1mJPBmbNxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQt8XjCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQt8XjCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AE21F00A3D;
	Mon, 31 Aug 2026 02:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141921;
	bh=4ziDYpOL94v6bXlJ3khU3VjKH7TizWIUJKqk2QQ8ppM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=eQt8XjCsxGxJs3rs7jZe9kRSNTlcc4xtRXfCNoPpccWrKpBQj/d+R3NImq5eU/ESK
	 X5bSpFDm5i7lnLTB4leb7AUjUiJlj6yUUHyW5sxIqnq2u38B3A2Y7cfSIZx1yyFGmZ
	 OPC7BE9b0s1jTVuuIWURP0s4U4//pXclyYzzN8ATa6LclsP2UZEcXgyWgLA3hNZSE3
	 zyeKlHXxvRVLXnjBKqyhIGRCXUoVZWqaPCEnPqM5KykdaKbW62PTf+DRxxyGjCXrrz
	 UpKwy9MV/v+Jv5+Rf0ODJJC8nnWoeJuBlNkbOlSGivthFcxmsFfgnkWPBmEK3Of1Dt
	 k6Lb0D0kFkgbg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 11/37] scsi: ch: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:25 +0900
Message-ID: <20260831020451.585944-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the SCSI media changer driver to use the 16-bits sense_code field
of struct scsi_sense_hdr and struct scsi_failure and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/ch.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index b804291a36ff..87e51e50a741 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -123,38 +123,32 @@ static DEFINE_IDR(ch_index_idr);
 static DEFINE_SPINLOCK(ch_index_lock);
 
 static const struct {
-	unsigned char  sense;
-	unsigned char  asc;
-	unsigned char  ascq;
-	int	       errno;
+	u8	sense_key;
+	u16	sense_code;
+	int	errno;
 } ch_err[] = {
 /* Just filled in what looks right. Hav'nt checked any standard paper for
    these errno assignments, so they may be wrong... */
 	{
-		.sense  = ILLEGAL_REQUEST,
-		.asc    = 0x21,
-		.ascq   = 0x01,
-		.errno  = EBADSLT, /* Invalid element address */
+		.sense_key	= ILLEGAL_REQUEST,
+		.sense_code	= INVALID_ELEMENT_ADDRESS,
+		.errno		= EBADSLT,
 	},{
-		.sense  = ILLEGAL_REQUEST,
-		.asc    = 0x28,
-		.ascq   = 0x01,
-		.errno  = EBADE,   /* Import or export element accessed */
+		.sense_key	= ILLEGAL_REQUEST,
+		.sense_code	= IMPORT_OR_EXPORT_ELEMENT_ACCESSED,
+		.errno		= EBADE,
 	},{
-		.sense  = ILLEGAL_REQUEST,
-		.asc    = 0x3B,
-		.ascq   = 0x0D,
-		.errno  = EXFULL,  /* Medium destination element full */
+		.sense_key	= ILLEGAL_REQUEST,
+		.sense_code	= MEDIUM_DESTINATION_ELEMENT_FULL,
+		.errno		= EXFULL,
 	},{
-		.sense  = ILLEGAL_REQUEST,
-		.asc    = 0x3B,
-		.ascq   = 0x0E,
-		.errno  = EBADE,   /* Medium source element empty */
+		.sense_key	= ILLEGAL_REQUEST,
+		.sense_code	= MEDIUM_SOURCE_ELEMENT_EMPTY,
+		.errno		= EBADE,
 	},{
-		.sense  = ILLEGAL_REQUEST,
-		.asc    = 0x20,
-		.ascq   = 0x00,
-		.errno  = EBADRQC, /* Invalid command operation code */
+		.sense_key	= ILLEGAL_REQUEST,
+		.sense_code	= INVALID_COMMAND_OP_CODE,
+		.errno		= EBADRQC,
 	},{
 	        /* end of list */
 	}
@@ -167,12 +161,10 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 	int i,errno = 0;
 
 	/* Check to see if additional sense information is available */
-	if (scsi_sense_valid(sshdr) &&
-	    sshdr->asc != 0) {
+	if (scsi_sense_valid(sshdr) && scsi_sense_asc(sshdr) != 0) {
 		for (i = 0; ch_err[i].errno != 0; i++) {
-			if (ch_err[i].sense == sshdr->sense_key &&
-			    ch_err[i].asc   == sshdr->asc &&
-			    ch_err[i].ascq  == sshdr->ascq) {
+			if (ch_err[i].sense_key == sshdr->sense_key &&
+			    ch_err[i].sense_code == sshdr->sense_code) {
 				errno = -ch_err[i].errno;
 				break;
 			}
@@ -192,8 +184,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
-- 
2.55.0

