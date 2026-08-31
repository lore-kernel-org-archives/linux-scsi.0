Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECA14CCDFB
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788204553; cv=none; b=Hz0HbCTe4YV5qlWinOWx4fkvktg85CtwS1CvFZb94dOydbSRRH09HUksJuw6In6XZKjBdtfHmEpYN3QHA6r0rdT0De1OlJY6CKVMEkcwNrcEHG1lj1q872WyVpzCbIsjvjRpYmEHXsixRyjWJA8pSk7RizCl91CDogd7KosmXQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788204553; c=relaxed/simple;
	bh=LDFIyeAQWA9YuguGKoijIlyDTWOvI5vS/DaP52xcUww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KLRL4oNQ40vDJR8GNk8Q8fYsUMAcEfCL+GlIkpLmfjUKgdOw6ITW4kNqCXVR1KJQL+3yAgjZMNpvCzomVF26DGYIMmBBioww0GBBaP5cQq0wo/SiXAgV9QM3qgThOGhkY1TtzGGLqpTANUrOzrU+J6md0G5D/ZuAuPUbrm7/xRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4pXAqxHY; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4pXAqxHY"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hYfF340fczlfvpM;
	Mon, 31 Aug 2026 19:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1788204548; x=1790796549; bh=H/HuyjN33IBDsF1e3RpKyQ+gKbRBdc3AiFV
	yLGTHpgU=; b=4pXAqxHY53HiOe5EYwD/VdhoHTCWX2ySrMaOXROCzSc8L0M+2fk
	pLNwbY+BmCVAVckjvnew2WJ5yeyW5ANx2LGsESxG4tj64ZyOZnRbBvOzTFXo5km+
	QkGcjmmN7vLTRrg6IxyL2XthRQaFns81f0KSpinFPs486hmPA0PZDapL6q5tko0y
	EzkNh9HFRuNKeXISq7OuD7vD+za9UrAe2CA94W7OvHLfrO9gLQVGzHE06kcQIvpW
	9CSl2XpUz8xYvgWz6LLhZqAaeQTBshBP91U9zEb9GEMLpFZyc1CWeJvzO2lQqOze
	SQ2UcmC62555xzILhWjd0i4feZF52NrYS2A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Da2-b1Cakk0F; Mon, 31 Aug 2026 19:29:08 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hYfDx4vkczlfvpH;
	Mon, 31 Aug 2026 19:29:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH] scsi: core: Rework the DEF_SCSI_QCMD() implementation
Date: Mon, 31 Aug 2026 12:28:56 -0700
Message-ID: <61df3d2ad6e65f188469708fb05b679b49596cef.1788204517.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In DEF_SCSI_QCMD(), make the following changes:
 - Replace shost with cmd->device->host because func_name##_lck()
   implementations will be annotated with
   __must_hold(&cmd->device->host->host_lock).
 - Do not save and restore the IRQ flags. Since support for the legacy
   block layer has been removed, .queue_rq() implementations are always
   called from thread context and with interrupts enabled. Hence, saving
   and restoring the interrupt state is not necessary.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_host.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 16243ec376cd..c018f78ce3ce 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -531,12 +531,11 @@ struct scsi_host_template {
 	enum scsi_qc_status func_name(struct Scsi_Host *shost,		\
 				      struct scsi_cmnd *cmd)		\
 	{								\
-		unsigned long irq_flags;				\
 		enum scsi_qc_status rc;					\
 									\
-		spin_lock_irqsave(shost->host_lock, irq_flags);		\
+		spin_lock_irq(cmd->device->host->host_lock);		\
 		rc =3D func_name##_lck(cmd);				\
-		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
+		spin_unlock_irq(cmd->device->host->host_lock);		\
 		return rc;						\
 	}
=20
