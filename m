Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F53D5221
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451633; cv=none; b=F/bDq9rQd7UaONFurB0AGa8L9JSsCE/+vtNHXNrvHaldT8ZLUBXuu7lqokwbL8w8utJRu6kKl9oSMvdTcnpSi8QayjUF7EuVuP/JwCIp/DYfEcOevGUKBCZILsInziOW6HXlUu9LYWMH7TLA7DDPUhGllYKnDb9Z1ArgOwHWeJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451633; c=relaxed/simple;
	bh=xf9DbuKi8FDAI/GaIPa10gPv8n9IAiRt1oBSfDYbKO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLJ30fH4aMjTwG9Ld21DH8omvnsCPbzBKM6sGtCvoxR7eHkBjZQde8t89c7/1+9FLa2/wZ14ftTLh+a1vWbWfSCLp8uwIgjV9f6+5y1SFEZNN1SUvrgymQ0x6aRauEm0bxDj0+G787zWNc0LVBOtRdn7+A95xi2ys9EqcxhorsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kS89NbB2; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kS89NbB2"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48H3tNrz1XM30r;
	Thu, 30 Jul 2026 22:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451627; x=1788043628; bh=QZsHJ
	n+wnAtehaKSmYyfGWx30xNTbMVdtvLJC7NCcW0=; b=kS89NbB2z5zVtkKjD0y6R
	ZpirvF6QaKo2CxHTxubRkGWtjytzLMIAmulNr/fpbfeVgH6uBfXqmzWNIYh6aRtg
	u0SI+5lVcS9Jo/vHz/Uu7JjbKa2Ts5qdIxM1T0qMbMoZIFlJSzEs3MH8u3jddMEL
	hGmWpyM/E4LK5vYTYWoQ3zHRXjbtUntob1pw4QPGjT6omJTtVggKtFQk0QPqQRnX
	WC5uSlfQX3h8Hi5Z2j/YaCp48wHg2NohPWL9vMnws06TOZ0/zhqIu1TA7aUC7o/I
	46/rxC0A+J02Bt2nA3HorZabmjTNbN+OQHqlWU1Iedzk52I2z/d+OewGC4as/8iW
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GTuzXOKLrR04; Thu, 30 Jul 2026 22:47:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48968hjz1XM6Jm;
	Thu, 30 Jul 2026 22:47:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 05/57] scsi: BusLogic: Introduce two local variables
Date: Thu, 30 Jul 2026 15:44:48 -0700
Message-ID: <b30f5a73d3af6821005f5e6a28fc71dfa9b7081a.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Introduce two local variables to prepare for enabling lock context
analysis. No functionality has been changed.

Cc: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 5304d2febd63..f2a6ed710c77 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2859,17 +2859,16 @@ static int blogic_hostreset(struct scsi_cmnd *SCp=
nt)
 {
 	struct blogic_adapter *adapter =3D
 		(struct blogic_adapter *) SCpnt->device->host->hostdata;
-
+	struct Scsi_Host *shost =3D adapter->scsi_host;
 	unsigned int id =3D SCpnt->device->id;
 	struct blogic_tgt_stats *stats =3D &adapter->tgt_stats[id];
 	int rc;
=20
-	spin_lock_irq(SCpnt->device->host->host_lock);
-
+	spin_lock_irq(shost->host_lock);
 	blogic_inc_count(&stats->adapter_reset_req);
-
 	rc =3D blogic_resetadapter(adapter, false);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
+
 	return rc;
 }
=20
@@ -2886,6 +2885,7 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 	struct blogic_tgt_flags *tgt_flags =3D
 		&adapter->tgt_flags[command->device->id];
 	struct blogic_tgt_stats *tgt_stats =3D adapter->tgt_stats;
+	struct Scsi_Host *const shost =3D command->device->host;
 	unsigned char *cdb =3D command->cmnd;
 	int cdblen =3D command->cmd_len;
 	int tgt_id =3D command->device->id;
@@ -2915,9 +2915,9 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 	 */
 	ccb =3D blogic_alloc_ccb(adapter);
 	if (ccb =3D=3D NULL) {
-		spin_unlock_irq(adapter->scsi_host->host_lock);
+		spin_unlock_irq(shost->host_lock);
 		blogic_delay(1);
-		spin_lock_irq(adapter->scsi_host->host_lock);
+		spin_lock_irq(shost->host_lock);
 		ccb =3D blogic_alloc_ccb(adapter);
 		if (ccb =3D=3D NULL) {
 			command->result =3D DID_ERROR << 16;
@@ -3062,10 +3062,10 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
 scsi_cmnd *command)
 		   be initiated soon.
 		 */
 		if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START, ccb)) {
-			spin_unlock_irq(adapter->scsi_host->host_lock);
+			spin_unlock_irq(shost->host_lock);
 			blogic_warn("Unable to write Outgoing Mailbox - Pausing for 1 second\=
n", adapter);
 			blogic_delay(1);
-			spin_lock_irq(adapter->scsi_host->host_lock);
+			spin_lock_irq(shost->host_lock);
 			if (!blogic_write_outbox(adapter, BLOGIC_MBOX_START,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter D=
ead?\n", adapter);
