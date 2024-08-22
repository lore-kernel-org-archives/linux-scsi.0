Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249A41D172B
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356832; cv=none; b=iY6zHJD5Fo6DiskNYYIvaA/fPtPwUgd8d7rHxqik+MYr88JWvcyxN5VF/9CoTcGUITNN4T3FVcmokhQWe8nwasca1Ucrhk/f5T6k65Djg48rsCe92Sn0GdDpdm2O9PiYFnpfvzNbaexyQxAFzAfjx9ozlJCZDopOmuN1SDJyy7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356832; c=relaxed/simple;
	bh=7kjn2PW0edxLbmi5bDpNtu70kfZrIQkHqINd9nrsch8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeUOky0GCieUI4Qn67qLvW1oqRLC7SR6eWdJakj+yH+dPfq5MCXALjkMtuaKlunI3bjvYsp1JQs7zCRjADpkIUSj3uekdRIZndJLlnbYIpvofGf3MgYdPTUA5vH6oRC0DDPBQ2HdifyBhhyN5dORKn0uiff0tq70VFI5glsCH7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=t5/gSG2+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="t5/gSG2+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYwG6MJcz6ClY9N;
	Thu, 22 Aug 2024 20:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356828; x=1726948829; bh=YAW7x
	A5GODRbTNzhiwNiFkH85DSCsHxdn6HxMQMRV2g=; b=t5/gSG2+l5NqaXZ4O+tOa
	0LeWJvn2V8pIUdMd2IAnFrzUtwetDJxJaCZ1qQTcvnoYiaNrtgb391nOzVYw8Bhi
	7cQ7onBBcTKIw1vpb5tOMMLqE21zKgLizckK+qKMcDBRyEJiQFZBR4R2bf0uMziN
	8jouSwKS1JLH6jCJdPjfclYm997HWt+o3t0wpSnGKHscBd/dghZ0nXrgqAZ2LfR2
	wUBJbJc63EwygH+qna+t8qXSHTMJNgj5/yghUSx1u4fFNcks3FUoG/EevCgEpQo4
	Sl7exxnRsn4qIsttTD9+GeMHYCDXDERluJ7v1hIZkCGu9Cp0e8kgKYgoI28cn/4U
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RMfO8RRBgGyS; Thu, 22 Aug 2024 20:00:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYwD3qyKz6ClY9L;
	Thu, 22 Aug 2024 20:00:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 18/18] scsi: core: Simplify an alloc_workqueue() invocation
Date: Thu, 22 Aug 2024 12:59:22 -0700
Message-ID: <20240822195944.654691-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_workqueue() format the workqueue name. Remove the
work_q_name[] member from struct Scsi_Host because it is no longer
used by any SCSI driver nor by the SCSI core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     | 9 ++++-----
 include/scsi/scsi_host.h | 1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7f987335b44c..e021f1106bea 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -292,11 +292,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost,=
 struct device *dev,
 	}
=20
 	if (shost->transportt->create_work_queue) {
-		snprintf(shost->work_q_name, sizeof(shost->work_q_name),
-			 "scsi_wq_%d", shost->host_no);
-		shost->work_q =3D alloc_workqueue("%s",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, shost->work_q_name);
+		shost->work_q =3D alloc_workqueue(
+			"scsi_wq_%d",
+			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND, 1,
+			shost->host_no);
=20
 		if (!shost->work_q) {
 			error =3D -EINVAL;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 19a1c5c48935..2b4ab0369ffb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -677,7 +677,6 @@ struct Scsi_Host {
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-	char work_q_name[20];
 	struct workqueue_struct *work_q;
=20
 	/*
