Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B17047CA6E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559043; cv=none; b=FDrxTJTkyIKrUcWkjj/XinnHTvZ78pz5tZdW6E1kaW8Y+geQMwl8phQPsZuzVfEgVk+/dvpf71RV+h7M4hLHu5KmLyttsjGuNW7r2OY/B4PT5195OW4KL/O+QszFaOuCfU2CyGmo0yNTQbPdfMfbxD7gGgUAV3KhQhjYFzdZkJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559043; c=relaxed/simple;
	bh=dKA19GSQUZT8k3VmJk6TnIPQSr8rrKdksbmYmXNcW4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dk6dTBrcKt8H9cFcFwtPq88fcunACSwgXewBqoeGnpoBPx588Nrydvc/+zJn4p/NeRCH6FS9O/fOmpQTDxDoE6C26l47zYaXvMbpvYV7lEgSJVTMPjgEgfe+w9ZkS0xiBi9NqAnAq9QLt1rxyX8AoGwapDvWpQ+znP6gPEuwj80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SbdN3ZhO; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SbdN3ZhO"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hKxhd4zWQz1XM6Jl;
	Wed, 12 Aug 2026 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786559036; x=1789151037; bh=65Bw6
	yoRNazFPSft+ItPZPuvN/LlNYwQoxNJBcewWl4=; b=SbdN3ZhOR2N9OeGBIpjTq
	03xxPxEBNKgszDBUH46og0DCBZdk+UtX7PM+xAiaPwmbGJQm0nAghqz+9wHmj2Zf
	gPH+PDA9UB10Pxt6DP70OnVEMnUBTahnwjHYBw6xcm4/SNHuy9Q8zV1+gvREEfyu
	4G/aoO8n/LFjk8fwsFRfHxp13s4vDCXL/6BJErBKXoUZKfg8CnA0YaDkofzKjiKU
	z9bCdhMpv3TwpqWf77Ou186zmpOeySPuDm9RZOn1SZK9FiMM5O4NHe1Fd1KY5dIE
	Dm9WLYDWa/ZqphJ/CqJ9Acd7GXJjVcqugkAUFrB0Q9FN1fSk1vmk5b79geIsXm1Y
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FYieAdwYgzzD; Wed, 12 Aug 2026 18:23:56 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hKxhT41wcz1XM6JR;
	Wed, 12 Aug 2026 18:23:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Subject: [PATCH 1/3] ufs: core: Simplify timeout handling for START STOP UNIT commands
Date: Wed, 12 Aug 2026 18:22:56 +0000
Message-ID: <0a0a8245594f992a2318caf14164491974e79c46.1786558726.git.bvanassche@acm.org>
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

The set_host_byte(cmd, DID_REQUEUE) code has been copied from
ufshcd_mcq_force_compl_one(). That completion status is useful for SCSI
commands that should be retried but not for START STOP UNIT commands,
the only type of SCSI command for which ufshcd_eh_timed_out() calls
set_host_byte(). The SCMD_FAIL_IF_RECOVERING flag is set for START STOP
UNIT commands. This causes scsi_queue_rq() to fail SCSI commands. Simplif=
y
timeout handling for START STOP UNIT commands by skipping command
resubmission and by failing START STOP UNIT commands directly. See also
commit 01d5e237b339 ("scsi: ufs: core: Handle PM commands timeout before
SCSI EH").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a51e071916cf..73f1e8817f44 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9604,13 +9604,9 @@ static enum scsi_timeout_action ufshcd_eh_timed_ou=
t(struct scsi_cmnd *scmd)
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 		}
=20
-		if (ufshcd_is_scsi_cmd(scmd)) {
-			set_host_byte(scmd, DID_REQUEUE);
+		set_host_byte(scmd, DID_TIME_OUT);
+		if (ufshcd_is_scsi_cmd(scmd))
 			ufshcd_release_scsi_cmd(hba, scmd);
-		} else {
-			set_host_byte(scmd, DID_TIME_OUT);
-		}
-
 		scsi_done(scmd);
 	}
=20
