Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD90483816
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559053; cv=none; b=S56vTPHvPktGXFPhIKkhHHZnrL2i4STSMIzuWPCbSDvEzELAe9FfWoG1/Lm3A69YFIJN/mE4JtYmvv0N2cYWhVjvugvvcZNpZ4cZEoltkQo7aAyAcgF5XqI99uCg2gPy2d/Ohkartq2wNWktCpSA+sod4sD0ZZHzepMDF4zbqSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559053; c=relaxed/simple;
	bh=jjEkMFoWy2wGoYfMoTI7ce1JrB7HDx8awikbZYimdUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTy+TBGNPcvJIq/rmbiN8Tu7U4k0GIo/Vhcz9yCb/oKFTo4XO/c8/L2sus6SY+LrAdB8gWIvgWxTCVCLGmmG7kRT1DPGgSZ8O8vn3dCR5KAwYnDx5uHGD3S9QXj+x0rlwq2MO0vwB/jGJGpb83JtgjyruXPbao19jZc3EqgYI/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Uz4UOy8H; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Uz4UOy8H"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hKxhq0Y11z1XM6JR;
	Wed, 12 Aug 2026 18:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786559044; x=1789151045; bh=iBgJH
	1qqzdC+wEDrOAa2HV3jwfz413XPSOAh65cVKM8=; b=Uz4UOy8HS6WKq/q0oaUYu
	chNmPlGmDYP76ubypuF2P47wEGZZXrKYz8ldLYjObBuOxpRlci3NNCksdYU4FIqn
	7kph9ZxbrXsmyjifImGckbLtRd9V8+TmcXda3mAO5BbBFWO6UQ864Ns9cEZm1cr3
	ve9KEp+mFMGnJQMjP/P0w5lKR6xrg+h4/r4AhsjYRP1q2L9Nt9jlQvGFGKPfv6sH
	1J/WVlIPfZ5KxqRsSg4rhEHCX71gCfjk8us7n/oOefC2jrMsWigMehsjhcilWHaY
	A3FKyGL099RAer/ZDMsNoe+C4HP2JSkz0OS/9et04AZMbr6/q3wj2P1boMEGir6m
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YPY-I7hL0WlN; Wed, 12 Aug 2026 18:24:04 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hKxhd0Zzdz1XM6Jb;
	Wed, 12 Aug 2026 18:24:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/3] ufs: core: Fix a race condition triggered by ufshcd_eh_timed_out()
Date: Wed, 12 Aug 2026 18:22:57 +0000
Message-ID: <fc388a5ff11decf35246780f19ccfce2fda35f16.1786558726.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
In-Reply-To: <cover.1786558726.git.bvanassche@acm.org>
References: <cover.1786558726.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

If a START STOP UNIT command times out, the ufshcd_link_recovery() call
in ufshcd_eh_timed_out() may call scsi_done() for that command via the
force-completion mechanism. This may cause ufshcd_set_dev_pwr_mode() to
return before link recovery has finished. Fix this race condition by
moving the ufshcd_link_recovery() call into ufshcd_set_dev_pwr_mode().

Fixes: 7029e2151a7c ("scsi: ufs: Fix a deadlock between PM and the SCSI e=
rror handler")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 73f1e8817f44..0618712be32c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9582,34 +9582,18 @@ static enum scsi_timeout_action ufshcd_eh_timed_o=
ut(struct scsi_cmnd *scmd)
 		return SCSI_EH_NOT_HANDLED;
 	}
=20
-	/*
-	 * Handle the timeout directly to prevent a deadlock between
-	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
-	 */
-	ufshcd_link_recovery(hba);
-	dev_info(hba->dev, "%s() finished; outstanding_tasks =3D %#lx.\n",
-		 __func__, hba->outstanding_tasks);
-
-	/*
-	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
-	 * the existing MCQ force-completion path.
-	 */
-	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
-		if (!hba->mcq_enabled) {
-			unsigned long flags;
-			struct request *rq =3D scsi_cmd_to_rq(scmd);
+	if (!hba->mcq_enabled) {
+		struct request *rq =3D scsi_cmd_to_rq(scmd);
=20
-			spin_lock_irqsave(&hba->outstanding_lock, flags);
+		scoped_guard(spinlock_irqsave, &hba->outstanding_lock)
 			__clear_bit(rq->tag, &hba->outstanding_reqs);
-			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
-		}
-
-		set_host_byte(scmd, DID_TIME_OUT);
-		if (ufshcd_is_scsi_cmd(scmd))
-			ufshcd_release_scsi_cmd(hba, scmd);
-		scsi_done(scmd);
 	}
=20
+	set_host_byte(scmd, DID_TIME_OUT);
+	if (ufshcd_is_scsi_cmd(scmd))
+		ufshcd_release_scsi_cmd(hba, scmd);
+	scsi_done(scmd);
+
 	return SCSI_EH_DONE;
 }
=20
@@ -10123,9 +10107,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hb=
a *hba,
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
 			    pwr_mode, ret);
+
+		ufshcd_link_recovery(hba);
+
 		if (ret > 0) {
 			if (scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdp, NULL, &sshdr);
+
 			ret =3D -EIO;
 		}
 	} else {
