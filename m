Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98610205E18
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957212; cv=none; b=sWEXRANigi7qa+Us2eb7MCw7Xi4uIbjMVeKZwZ2V5Svnq9ti8LVlpvirCTC0jkSq8tCqXE8ZcfWj9Tx7Aj0h+tz+Sm7uF47FZszTtdgbwk+HMK3l2HpWcyv3BUgWzMUG4AmoPq/QtkyG2dY9/O0ZdSwnGyu8pCurTIyh0cRTmBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957212; c=relaxed/simple;
	bh=Gobxrn60s0ldP9bNCU5QZytSc53K3/PnwprqAf9NZYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlGOfx6spjC56X83Rd2g+5ivSYJ+d+UEFUCrgBKIODR0VIYNN0WbS/CRvXSg87n8Z6LrjKG9CG1/sRAZadMyQ9py9fUp5/TnWlLUF+hvFfgEJrJ2jw9uZQTtzYQbbO5PK+Lo4mz1jEgtEWJnsNXIrWw3TT2ys4dQCJkr5/jM3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yGiN2rI0; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yGiN2rI0"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrB2fKqzlnRR8;
	Tue,  2 Jul 2024 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957207; x=1722549208; bh=I3lfb
	pG6hH+7ZcpLkUOej+atklsJ7TaDuKnEM8ayUDc=; b=yGiN2rI0tJmFz2gbQyrgg
	u9X9L20sDMgfyQzPohUyK8cucVsCpwLVZ9s+6VzQnaGixMQADbj6C2cnnLo99YT6
	l3DdZM5H0eCWUf69rL1pns87EUdwiZRXKO6JuYJBewXMClf7OJtWLEoagGzh4k5s
	j5NBtyHhBMUr+qOopg32riarzpY3i847rw7O0ocjIV1w7smEdb7/rUPXS0+jj+gg
	P4SpJeNObPaadHBbl4Z1m94KIH92RR1visC060zNYsHLf9qqdk0LjWRPcv+Xc1u0
	MtmtFnkZoGb3pmX5k2pjwGFkbNxVsg0cUFBmms56UbrXdiG9hNqWpxFCdLo2yBzy
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iA611fgqUJyW; Tue,  2 Jul 2024 21:53:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGr55SdwzlnQkq;
	Tue,  2 Jul 2024 21:53:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 09/18] scsi: mpt3sas: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:56 -0700
Message-ID: <20240702215228.2743420-10-bvanassche@acm.org>
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
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 4 +---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/m=
pt3sas_base.h
index bf100a4ebfc3..fd6ed6e8aab3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1162,8 +1162,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct M=
PT3SAS_ADAPTER *ioc);
  * @fault_reset_work_q_name: fw fault work queue
  * @fault_reset_work_q: ""
  * @fault_reset_work: ""
- * @firmware_event_name: fw event work queue
- * @firmware_event_thread: ""
+ * @firmware_event_thread: fw event work queue
  * @fw_event_lock:
  * @fw_event_list: list of fw events
  * @current_evet: current processing firmware event
@@ -1351,7 +1350,6 @@ struct MPT3SAS_ADAPTER {
 	struct delayed_work fault_reset_work;
=20
 	/* fw event handler */
-	char		firmware_event_name[20];
 	struct workqueue_struct	*firmware_event_thread;
 	spinlock_t	fw_event_lock;
 	struct list_head fw_event_list;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
index 89ef43a5ef86..fa692a7c090c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12307,10 +12307,8 @@ _scsih_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)
 	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
=20
 	/* event thread */
-	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
-	    "fw_event_%s%d", ioc->driver_name, ioc->id);
 	ioc->firmware_event_thread =3D alloc_ordered_workqueue(
-	    ioc->firmware_event_name, 0);
+		"fw_event_%s%d", 0, ioc->driver_name, ioc->id);
 	if (!ioc->firmware_event_thread) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
