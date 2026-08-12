Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE86B48D883
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786569977; cv=none; b=PAErhgmvma7gFNwo3cIjdoTfxdSuw6bNtgSTuJLEUULoVdN2JW2GRuF7ID73taWY5hYGFbv5u66HFESJ0H3fTxJSW1tdlpU7Gm6RvlejfKhVKU6DqQuQjvzNDbwna+U7ngGLzfxksJpjswouCeQsX8S/6SN/YsRRR0tHyjFcUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786569977; c=relaxed/simple;
	bh=HFre7jMazrxjgmgIaVVU1MCcwBZUufS+D3su0g9PLB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhc95NiJuL8B1tYGjb5wkDCPmQ7Q4YYQgD6AySMCMlfQMFIlv3v5E+zLwpOCF6v+/s9qBdKLPG5iWqqvVrkJvdlTgAtt66Pw86isQjJFcs619+AGkkaJjnkrqAEAz0BidpWFzu+Du7Gu/zijiUrAQm5RZRsFjTX2uMnUIMq31K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qQ1eSyv4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qQ1eSyv4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hL1kX3JR9z1XM6JX;
	Wed, 12 Aug 2026 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786569950; x=1789161951; bh=2wFHc
	p6dEx3MCdNFq9F0hRnrZwgzfY0ler52ILnmyCk=; b=qQ1eSyv4bLI5Mx4C0rxhz
	1ztgINFNz8sJnpuWhCCqJyybbxLa9BZNzR1dW+DD/oXTid+e03Ip1l8okQ4xsZl8
	SdqlsMoRqfvxlWiBTaq9nKuiHKDqhDTk9kNbg/iBhuVfL0E9rS7KKoGaVrYqm0Kv
	kCJQse3vBNwUpDTBDQbBqiaKp6ru7bg1AFv/NrEifC6KvcM3AiQ5rHxAUJJyY3A3
	eoGqSkeTsueokYWBLSCuY9ZC1UTfc5+fmWrUF0dH33DYeHebbCwMzEa68F7awMWm
	T1ZE40ErBuxdyagjMcOecdToWNqdhAkZO5Kbid3jXYXkxtKmNbqBQ0naHUddyBB5
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fIp9lFhy1VLS; Wed, 12 Aug 2026 21:25:50 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hL1kM0L00z1XM4TB;
	Wed, 12 Aug 2026 21:25:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 1/2] ufs: core: Fix a race condition triggered by ufshcd_eh_timed_out()
Date: Wed, 12 Aug 2026 21:25:23 +0000
Message-ID: <fd054bab859b55a9a8182e54a8e5c901c474c421.1786569828.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
In-Reply-To: <cover.1786569828.git.bvanassche@acm.org>
References: <cover.1786569828.git.bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a51e071916cf..d719100bfe38 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9582,18 +9582,6 @@ static enum scsi_timeout_action ufshcd_eh_timed_ou=
t(struct scsi_cmnd *scmd)
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
 	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
 		if (!hba->mcq_enabled) {
 			unsigned long flags;
@@ -10130,6 +10118,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba=
 *hba,
 		if (ret > 0) {
 			if (scsi_sense_valid(&sshdr))
 				scsi_print_sense_hdr(sdp, NULL, &sshdr);
+			ufshcd_link_recovery(hba);
 			ret =3D -EIO;
 		}
 	} else {
