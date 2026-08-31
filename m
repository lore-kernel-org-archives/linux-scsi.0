Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18343546E5;
	Mon, 31 Aug 2026 02:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141924; cv=none; b=NLGtoVg5HYdgH4eOoZzWr6QoYVgkNO/T6Ptnm5r8tBGfH/cPBs2vq5HJPY3Ze+d7Jw9cAHS9Q2/ia5lKwBDd0z4rWHtawU5JdMs2U5SNeKt7aUWQY7uFGWYSTj49cdkKFuqGjw4VlNo5pyobsYxDa7+el9rWZ/vYPag9b1fgWjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141924; c=relaxed/simple;
	bh=viIF6CyZtthkRsLQO8fQlXyoC/+Y6fi8PlFvobsOUgM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J31COSnDkl5drSGfXgz2NOomwjLg9F58A84hKpveIzDRyc3H8hujaoHsV7fDuIBp+c6FOt9DNbIGYcSkP80yCEb/+F+bnoEEJ5ZT9K+JMQF77rOGVTT0xDWpqXj9jD/ioA4v3EIK2axYgl3L2RzeQ23P2Y+/ZAku4Sd3iv38cbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYPJusEk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYPJusEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308A51F000E9;
	Mon, 31 Aug 2026 02:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141923;
	bh=iS5O/hr4rZ0YkdRljRugC9w1UK6x+zNNcYZof5Ad4zc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=XYPJusEk3kMulq5apJAKRqcdPpuNPPCDdz8w3khhhHqNWJzVsKtI7kYF0N2Pmh0FA
	 ZFlrvTEax6EBOfVjrxcomvlTRfXtKBKDeXaE4qPVDReueq7kP4oqNSGkZmw40OHV0Z
	 FK4vHrCdM9OqDt2hSo2aF0tXamOlJuXk2kK63+moycMfrmiQqm4vkyugL9MGM8YLYC
	 Bj5huyLHJ9FtvWcg1AKmHh3sxk836hU9ZO7E6NFi4Ap6bb7yb2puJYY5SPWEEeDbr8
	 +/Wh3NbGmEmbUdMZTG+8usO2FMLCj9Ee3wc6EjLx5ZgY8/VJ3UFLc23+lofp6M5NK2
	 DMDH8d1hsLo7w==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/37] scsi: st: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:26 +0900
Message-ID: <20260831020451.585944-13-dlemoal@kernel.org>
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

