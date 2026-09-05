Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F367937A840;
	Sat,  5 Sep 2026 03:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578579; cv=none; b=IcLjVKPzTPJllU242Sg6vnpnPPVvog0/qrCVwpqPZR1MENuKW/xjOyupi3bzrPN++zqHa/KILZ7VtEzDqmFLrTaK+YDHxsM29uy326iVuwoxKg221XhEO+MmpIXIUpHtsx7ZuAo76Z/eHj0lhPGNjt8d4/M7R1BzX7rbtCgaky4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578579; c=relaxed/simple;
	bh=h91m6Gi9mfzy56yUa3CWOR+qlA3zOVIWDtYNuw0109o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHa92lrrNHp/nmFje7FgvNTB2G8XibKpJeOFvelgH0vTHnwGFq15csPdqTwQe7V1Hwxtrsr3ZK8AXgMptwIE12vUJJ426S4znTnhohdjg9bwvGOgczmd/Y8AmUI4nKapAN8jid2Dx7sCBpG10NTruW/QvBx90844TZcU+9o4JQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2Ppm6/X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2Ppm6/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6001F00A3E;
	Sat,  5 Sep 2026 03:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578577;
	bh=4ziDYpOL94v6bXlJ3khU3VjKH7TizWIUJKqk2QQ8ppM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=F2Ppm6/Xs1RXt2XdUOEvVScSbZx7zjN9Su49mrs8CPuj2zktVc2lK4i3BTWCN6cNw
	 CIA1EUOcBaHp/T/JNcEe9+RDZnwht0NXzAuyP29a9TllNuXReGIxg9Hu09tA0Lrgjb
	 MGj3a/2oSsmwpQfIYrvGovMr0xmg+GoEuMXpGwpN8z3P/wcRwcmFQMq8jsbLvXIduZ
	 uyysGMj3Ibs1ylfSgHccCUHzr8HK8dxS9dYCBKMu6jpYnsRq9dsXmh3QLng7UxCfKo
	 dqLyObeWhNKYXlb6CliAOzk4+pkx7dM2hJBJI0luBV/bChxUfm/6Vn71281/LR/G8M
	 NwQKKCvdIZmiQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v4 11/40] scsi: ch: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:21:55 +0900
Message-ID: <20260905032224.509860-12-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905032224.509860-1-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
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

