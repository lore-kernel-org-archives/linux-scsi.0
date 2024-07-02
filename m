Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D13F20127D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957202; cv=none; b=WzyNpXKcMV9eh21bU+ufOioI/hkuYH/vFe6F/GQNZrOE6WJrlNXRdIWblMvnPJ13y3LOtdQYxjB2KbUsWMRRKJmt4Ic88h4kUuhOQRYU17FOIqSR6v773OSQB9HUbAx+sMJutyTerROMGgZ3OMBCQSKS+rp51nL8GGHyp1mdlrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957202; c=relaxed/simple;
	bh=loXYXyFcPHxSm4oGA5Hka00d64Otm7zUReO1qVODTH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFbxpfv8kbZ0ppOj6a0MRIxz1GCNgiGWig8TCo9aRcrXnfCe5q/pgfswhPHee3P8lKdCOGyrqzq71oOfDQgNOhlBXdM93Hi9NNkPpTXoWr7UFPcfzCIt0Y9TjJnSx8jC2ST9ZbnmpYwJ5etSh30A18P+3bMyQynY2pgsv6b1sFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T5eHfHmb; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T5eHfHmb"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGr06znZzlnQkq;
	Tue,  2 Jul 2024 21:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957199; x=1722549200; bh=ope2b
	Zgdg6uen/17iF5cq5qvjLUE3R35vW81Zdlofic=; b=T5eHfHmbvi4VvoN19URF4
	e3EE73W8B+qMSOAIdkuHnixQa02qBQFKFH081o92Ur6Qmz7cgxVgBa8T9alTd+V/
	aUIHHre2YMoTlmzWGNb4rdvkZ44jox7wATaa6Wtqn12U+f6/MD/NswMgrp2LP+2J
	AjzLI07hx/kcg+iZBs/n2y92khvd9il4xrvoM5rLFsi4+bC8K4HJKX+zpWqhCaLE
	6PGb+yxmRfRY04ubqj5PEBxnkq+fk+96K5F2B8UZ4PLIDOPljtagIywNTUXdd1jI
	aRGBa3muaSa3rlm0IPLdZteHoHSpUR/3AVxynlU0EncDwaDz5uWeDuGvkpnhp5Js
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gNxkXUQTj9Sl; Tue,  2 Jul 2024 21:53:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGqx6TQvzlnRR8;
	Tue,  2 Jul 2024 21:53:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bradley Grove <linuxdrivers@attotech.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 05/18] scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:52 -0700
Message-ID: <20240702215228.2743420-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240702215228.2743420-1-bvanassche@acm.org>
References: <20240702215228.2743420-1-bvanassche@acm.org>
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
