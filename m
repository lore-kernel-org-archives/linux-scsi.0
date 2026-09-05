Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9C636C0C8;
	Sat,  5 Sep 2026 03:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788578580; cv=none; b=Cw5KH6qPmkfWCA1Exrs0xfYI9empUohxISZh5uAqNfRx/sSasnuC3KMlV8VCAuyMppvC1ZTzFAxgHuTV1IDXwlPXj6Q+EhIt82+PFEhGVCwOoBcRNaojtE0gENHiQqOTg6OiQmE6ICK/gevWlOHepT6nrxBbqto44tXh8FhDKfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788578580; c=relaxed/simple;
	bh=viIF6CyZtthkRsLQO8fQlXyoC/+Y6fi8PlFvobsOUgM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uB7kzkBzdS35OJpxS9NY17N6H/vNp6ZxjQM5+JAkNRs8bWEB2emCbdZIzU7GuliPC39nGOe2i8aQmp6v1q5heijbdGUx7Z+gDW2KXLpFCwm02LW3Z+AZw98e6DVGz28GWI0cASvslPui+O97iphhpX3k5zsSMiJQznTXqUrV/+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O9vERkKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O9vERkKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DF21F00A3F;
	Sat,  5 Sep 2026 03:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788578579;
	bh=iS5O/hr4rZ0YkdRljRugC9w1UK6x+zNNcYZof5Ad4zc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=O9vERkKb832KJiFOTUFQnWHR7zAFn0+FPPW4N2otnRMId4N/IQq5BgR/r+UtDmwVL
	 g9866DHz7QRLnpyGAFMRxSmZxL0QJf/KZRDDDVQbk1k+53hrvq1OksC89MkgMsmZwd
	 NqVUAxMHVnkubBC6V/qtQG2RjZM5C4SWmNPAxUBAIfbximyGL2RNrz0+8MLGOa3kyM
	 lUS3Zqm13/ueAM7G4YNn7KWsFB1xbEuDTrUTEBgIgO/5dZRcbHKezDEBaujsVJ4krR
	 u7D/KV4sRiY8u8YBFg9Zv0WFlAnrnG8S4uLMvu5rYPLP79oUR6Q1YSnPVULMi1rvGv
	 gDAxwsjyHYp0A==
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
Subject: [PATCH v4 12/40] scsi: st: use 16-bits defined sense codes
Date: Sat,  5 Sep 2026 12:21:56 +0900
Message-ID: <20260905032224.509860-13-dlemoal@kernel.org>
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

Refactor the SCSI tape driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/st.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..1ca9753cb734 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -421,11 +421,13 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 					       STp->cln_sense_mask) != 0);
 	}
 	if (cmdstatp->have_sense &&
-	    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
-		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
+	    cmdstatp->sense_hdr.sense_code == CLEANING_REQUESTED)
+		STp->cleaning_req = 1;
 	if (cmdstatp->have_sense && scode == UNIT_ATTENTION &&
-		cmdstatp->sense_hdr.asc == 0x29 && !STp->pos_unknown) {
-		STp->pos_unknown = 1; /* ASC => power on / reset */
+	    scsi_sense_asc(&cmdstatp->sense_hdr) ==
+	    ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED &&
+	    !STp->pos_unknown) {
+		STp->pos_unknown = 1;
 		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
 	}
 
@@ -1003,7 +1005,8 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 			scode = cmdstatp->sense_hdr.sense_key;
 
 			if (scode == UNIT_ATTENTION) { /* New media? */
-				if (cmdstatp->sense_hdr.asc == 0x28) { /* New media */
+				if (scsi_sense_asc(&cmdstatp->sense_hdr) ==
+				    ASC_NOT_READY_TO_READY_CHANGE_MEDIUM_MAY_HAVE_CHANGED) {
 					new_session = 1;
 					DEBC_printk(STp, "New tape session.");
 				}
@@ -1026,14 +1029,13 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 					waits++;
 					continue;
 				}
-				else {
-					if ((STp->device)->scsi_level >= SCSI_2 &&
-					    cmdstatp->sense_hdr.asc == 0x3a)	/* Check ASC */
-						retval = CHKRES_NO_TAPE;
-					else
-						retval = CHKRES_NOT_READY;
-					break;
-				}
+				if ((STp->device)->scsi_level >= SCSI_2 &&
+				    scsi_sense_asc(&cmdstatp->sense_hdr) ==
+				    ASC_MEDIUM_NOT_PRESENT)
+					retval = CHKRES_NO_TAPE;
+				else
+					retval = CHKRES_NOT_READY;
+				break;
 			}
 		}
 
@@ -3105,9 +3107,10 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			   cmd_in == MTSETDRVBUFFER ||
 			   cmd_in == SET_DENS_AND_BLK) {
 			if (cmdstatp->sense_hdr.sense_key == ILLEGAL_REQUEST &&
-				cmdstatp->sense_hdr.asc == 0x24 &&
-				(STp->device)->scsi_level <= SCSI_2 &&
-				!(STp->use_pf & PF_TESTED)) {
+			    scsi_sense_asc(&cmdstatp->sense_hdr) ==
+			    ASC_INVALID_FIELD_IN_CDB &&
+			    (STp->device)->scsi_level <= SCSI_2 &&
+			    !(STp->use_pf & PF_TESTED)) {
 				/* Try the other possible state of Page Format if not
 				   already tried */
 				STp->use_pf = (STp->use_pf ^ USE_PF) | PF_TESTED;
-- 
2.55.0

