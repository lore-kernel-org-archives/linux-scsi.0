Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F91C7B71
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845410; cv=none; b=q4ZGKyFGl/wEKUNXFAIn/aULFP7fsTHY7mmW9F4930DI1MziBik2J7PLJyDtlhWNjXYk0svBwlyuvd/g0/4Pfhj/tL9rZTy16XVzQ+KLd3g8G6K3ZHszV5PR6/WIjNi2uwGakxyprtgE2U+5+jxrOvE6xvvHhSNw43og1OTxR4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845410; c=relaxed/simple;
	bh=loXYXyFcPHxSm4oGA5Hka00d64Otm7zUReO1qVODTH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbieNqo0sDZD2plmTw2Co8KmmudKdxgNQ6hYzHZYsEJG1L+Gk7FCR+xoy3NlBP3Zth0Jr4j36bGwVx7dxt/g0LroSzkSAkdRVH2OcayZRFTYfBvFwOgBUB56VFLFlmljq9J35nQ9f1UJYgj1UAEIjCL0UFJJU6IOUJZSkU2PeN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iHWJGr+E; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iHWJGr+E"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwnD4BFSz6ClY9C;
	Fri, 16 Aug 2024 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723845406; x=1726437407; bh=ope2b
	Zgdg6uen/17iF5cq5qvjLUE3R35vW81Zdlofic=; b=iHWJGr+EGR8bMXdF7KhXK
	BdmwP/TCkoeFDbTX5YVvXB/CgvXQBhUxAm4dXAR326FUcmSsOKw8WXwCdLSEKMWk
	zo9nhCzBd3aYNnyk8qHxe5jg09JQyX0C5cuaXh9GdQMWgWjhwutBx0i81MwJFx7+
	tEmiTBg39jGSXDovLCDUEjpNnEluOBGbUT2cACT+KSgIZ2LZssRol9eYhMmmJMBI
	lIEwTMxcMNvit/wWJO8q4w13r3HCZoNhcwwqWWUm7x3rKX1BLbLYjf2BDzZ9EIFr
	3/RgWz6SuIHp+opbixDwovyAVNqr3+8uCRKFZNfkg+YY+6nyvvqZVHrW+sgtpjMN
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0B3eKlCdiunY; Fri, 16 Aug 2024 21:56:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wlwn85m2Tz6ClY99;
	Fri, 16 Aug 2024 21:56:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bradley Grove <linuxdrivers@attotech.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 05/18] scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation
Date: Fri, 16 Aug 2024 14:55:28 -0700
Message-ID: <20240816215605.36240-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240816215605.36240-1-bvanassche@acm.org>
References: <20240816215605.36240-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of callin=
g
snprintf() explicitly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r.h      | 1 -
 drivers/scsi/esas2r/esas2r_init.c | 6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index ed63f7a9ea54..8a133254c4f6 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -929,7 +929,6 @@ struct esas2r_adapter {
 	struct list_head fw_event_list;
 	spinlock_t fw_event_lock;
 	u8 fw_events_off;                       /* if '1', then ignore events *=
/
-	char fw_event_q_name[ESAS2R_KOBJ_NAME_LEN];
 	/*
 	 * intr_mode stores the interrupt mode currently being used by this
 	 * adapter. it is based on the interrupt_mode module parameter, but
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas=
2r_init.c
index ff1fa3160c61..0cea5f3d1a08 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -311,10 +311,8 @@ int esas2r_init_adapter(struct Scsi_Host *host, stru=
ct pci_dev *pcid,
 	sema_init(&a->nvram_semaphore, 1);
=20
 	esas2r_fw_event_off(a);
-	snprintf(a->fw_event_q_name, ESAS2R_KOBJ_NAME_LEN, "esas2r/%d",
-		 a->index);
-	a->fw_event_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
-						a->fw_event_q_name);
+	a->fw_event_q =3D
+		alloc_ordered_workqueue("esas2r/%d", WQ_MEM_RECLAIM, a->index);
=20
 	init_waitqueue_head(&a->buffered_ioctl_waiter);
 	init_waitqueue_head(&a->nvram_waiter);
