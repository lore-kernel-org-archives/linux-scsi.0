Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51438369D6D
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214794; cv=none; b=JOsyw5PoVSq9JME2MU1IPANKCLJydDEysXo5+uFS+yJ7znlIv8uEMmWewIHTr758WEkOaO22G24UjMoziE/fJaau/d8nupsywBcggeAxROVBqRAlHYW8NyUg8LnWEnnnBfUGB7/cRvfeDDVY+A4tuB7bhPYeL1kYx5vkieAcjdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214794; c=relaxed/simple;
	bh=oeSeRL7IH89JI1I6btl9JAo9y7QvkmJwgrsS5KLLxQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rqeX98rt+dtQcj4UKd9KxbRYTJ5Jz8v4q8IOM6uqhT8dsQB8lJJuRLWLlIugt4rzhbZfTs+KG9hI0oOtTpNl9r87CyN/34XNL51Xa23zKGZazMy3/SCQETbtKbOKRSwX9LmJ0nFP+W6EZJQp7iBrA3+JNeCpy6xmFEqz22w0J9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B/yphSzh; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B/yphSzh"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hYk204pl0zlfvps;
	Mon, 31 Aug 2026 22:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1788214788; x=1790806789; bh=U+tCfpelsC1BQ+SD5s/oBYON4seoMQ9KKmH
	ciUb3Jw8=; b=B/yphSzhKDeWxBLUV65eistk+r5OZIBlY5zghZ0kc2rDn8zCAfY
	k21lxPO3TwkAmF8VDfPyz5GBgqipnGFroNSF+EBNLjAreE5g3tQa29hmQMtQ6XlB
	a1+Ms2A2My5QCI9L2awOs4r5cWUe9ef/yQVAQwpXNrQBcijHRf1MVNefAI76swKI
	rHl7R0fvRqQszROTP2TWm8qtpBGgDHZixJI/Iv+TOQpdi4CwznfPoraIWd+Hm2en
	7cxMwlwBRTQUnHACUz7wCSVn32kDPXock7GE16RELgtSdDFZwoa4cOLBkMT5OhiA
	4uRy3trA3/0sqnkLbAjN+JdHD3Fsbqo3FGg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fYLuxQbFiDr1; Mon, 31 Aug 2026 22:19:48 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hYk1v17YVzlfvpH;
	Mon, 31 Aug 2026 22:19:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v2] scsi: core: Rework the DEF_SCSI_QCMD() implementation
Date: Mon, 31 Aug 2026 15:19:36 -0700
Message-ID: <7d904551041c58fd2cda31f82cf3e7b246e6550a.1788214709.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In DEF_SCSI_QCMD(), make the following changes:
 - Assign cmd->device->host to shost because func_name##_lck()
   implementations will be annotated with
   __must_hold(&cmd->device->host->host_lock). This change prepares for
   enabling lock context annotations for SCSI drivers.
 - Do not save and restore the IRQ flags. Since support for the legacy
   block layer has been removed, .queue_rq() implementations are always
   called from thread context and with interrupts enabled. Hence, saving
   and restoring the interrupt state is not necessary.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1:
 - Fixed a use-after-free bug.
 - Added __maybe_unused to the shost argument.

 include/scsi/scsi_host.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 16243ec376cd..d62f1e1fbd0c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -528,15 +528,22 @@ struct scsi_host_template {
  *
  */
 #define DEF_SCSI_QCMD(func_name) \
-	enum scsi_qc_status func_name(struct Scsi_Host *shost,		\
+	enum scsi_qc_status func_name(struct Scsi_Host *shost		\
+				      __maybe_unused,			\
 				      struct scsi_cmnd *cmd)		\
 	{								\
-		unsigned long irq_flags;				\
 		enum scsi_qc_status rc;					\
 									\
-		spin_lock_irqsave(shost->host_lock, irq_flags);		\
+		/*							\
+		 * Help compiler context analysis by using		\
+		 * cmd->device->host instead of the shost argument	\
+		 * for the func_name##_lck() implementations annotated	\
+		 * with __must_hold(cmd->device->host->host_lock).	\
+		 */							\
+		shost =3D cmd->device->host;				\
+		spin_lock_irq(shost->host_lock);			\
 		rc =3D func_name##_lck(cmd);				\
-		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
+		spin_unlock_irq(shost->host_lock);			\
 		return rc;						\
 	}
=20
