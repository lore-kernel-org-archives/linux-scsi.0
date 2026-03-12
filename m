Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4997D3C552D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350240; cv=none; b=N9x+dIMViLsEP0ENWahHI5ollqNhAfWzVrV9Jdw9KjYb0kLIjay8LGeiPtHj0lXEdcbPRPE0tSNP8wMVdKvlwKsGeok2SNn9UUqYKBPwJ73pQ37IIH4ZnJ82Qxp/NTaYjnca4wKS1gXlgpT6jOVxl9DIaxla7M6VxrDcm7vJm7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350240; c=relaxed/simple;
	bh=UFUsns/3No8Hem//ZyezWg8dP/sTWM/uvvHRNxbyhDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqyUWff4lv9dt9vv7Pq80ynks8W0z2dJlo1gBRKmsnLwvkQtAzWA/N6FlrunJcGzPQEVRc4XTamr3cbRwiy4UtPXxhQGEkqFDgsSyAG0ABgox1Uz+3sWNwN2HNV3MIjYFZMng0sDqjNONKGET8MZUFOlcYVCUadv5H/E3gzI+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=njxUVMQH; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="njxUVMQH"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0nB6RK9zlfl8L;
	Thu, 12 Mar 2026 21:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350236; x=1775942237; bh=3/CmT
	6GHIR6KKMS06++xvh+jbBXvxNDfnbWkzgAUOKc=; b=njxUVMQHouImhyzrixtfH
	1sVRX58MWhzX6+pwJrNUNuYkfAons/84Suy38BEFfD/lT9z6ADzzAqoMxe4rPz0n
	SUsri9cP74UDPLKuWZffAMaMHqBgYLyC4xdBzNKRv/Ca1qqyqFrF9OEuaal5THNq
	t4/256WdaWHKUhxdvAN/R04XWTuckbEHray4/VPP0s1VChKPNMd2Bya4NIfMUvjY
	pBBAUqH7aQOuHyb6wkF59mdqh2OFA7lWv/BdIl0+JeXWpyyV8/Km5z4Q1OsHj/kq
	lGGCOe4UWI7Dpm0T1KPBPdOpcp+sX+IyoCcGbGImJLXxntlCioHc/fAyF3WUK78G
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yddjle2-SFgA; Thu, 12 Mar 2026 21:17:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0n66Y7Xzlfl5W;
	Thu, 12 Mar 2026 21:17:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 05/36] scsi: BusLogic: Introduce a local variable
Date: Thu, 12 Mar 2026 14:15:16 -0700
Message-ID: <20260312211636.3245119-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Introduce a new local variable to prepare for thread-safety analysis. No
functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 5304d2febd63..e3790ff24e56 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2886,6 +2886,7 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
csi_cmnd *command)
 	struct blogic_tgt_flags *tgt_flags =3D
 		&adapter->tgt_flags[command->device->id];
 	struct blogic_tgt_stats *tgt_stats =3D adapter->tgt_stats;
+	struct Scsi_Host *const shost =3D command->device->host;
 	unsigned char *cdb =3D command->cmnd;
 	int cdblen =3D command->cmd_len;
 	int tgt_id =3D command->device->id;
@@ -2915,9 +2916,9 @@ static enum scsi_qc_status blogic_qcmd_lck(struct s=
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
@@ -3062,10 +3063,10 @@ static enum scsi_qc_status blogic_qcmd_lck(struct=
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
