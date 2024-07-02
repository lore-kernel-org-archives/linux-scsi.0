Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F403205E28
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957214; cv=none; b=mdg7RyLgEoS2U9kt4XDTr+9RmF7InBDo1ntsIvLxOWUh2SKjlE/xlM5eVGr08whW+cO+cqtqDUDMos1HS/zhGgykXA8uhQMKem0qAzL1wERfOrcLvkiKnPP9qxyAaq9bqgQl6GJHP9gsDRJAK6+V94lclfAd2Nsjbje6npmjkpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957214; c=relaxed/simple;
	bh=8+7p3FIgGJrP8/NgPn1Xqp14b5FhxjBchKH+zoeh0ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F02rPOoVZ20F0xkS090hYF9f0j45FQ8LCaoUQAOVn1IXtcTMQ9d3sGq+bFtN2LE4W1PVRE7WCPh7+0HCx/Ma2guQZOSPnl2vFEabZb55IjiUCXbpDGkyBZhBXRW8xsakdKycH2/rwvX88WlwWoAF1AhxiZt2/lisIwO8Gocc58E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=owLtNcm/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="owLtNcm/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGrD5tDQzlnRR9;
	Tue,  2 Jul 2024 21:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719957211; x=1722549212; bh=U+lVw
	cRuOPTq38g424yjpQFFkebTHR5UwSnphE6Bid8=; b=owLtNcm/QdW5XWKFYQzd6
	xNKKGwXgQSLWNGlXwU+cXQ+o29P2PKCe57ibYuwnTGN4JDIE3QPchQ1ahUdvcp8c
	69gCMV6SSpwFNxIEt9WyRIL204ahKvBJNFYNoFDjLGpxX7gqwOTxzVglpAT1N5vN
	hQ3D44HQEcBs8fGHbQHWY+xYVPAGdfbawC4N8gTktsPYVUlNbvdE8moihVh+OJeZ
	s5qTt+DFKYgpZ+Bbo0JL7wD1XsL3Rg+4NFzjce3+4AbAUCP3atC+4i1tXEwDT3/E
	+cuyaK5PDfrSxxAurRFchfAl4Vp9MGldWFZrnV6M2WQGmcaGDl5fSmMr8lQLbYGZ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SHv17_Szm--D; Tue,  2 Jul 2024 21:53:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGr95fr6zlnRKl;
	Tue,  2 Jul 2024 21:53:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 11/18] scsi: myrs: Simplify an alloc_ordered_workqueue() invocation
Date: Tue,  2 Jul 2024 14:51:58 -0700
Message-ID: <20240702215228.2743420-12-bvanassche@acm.org>
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
 drivers/scsi/myrs.c | 6 ++----
 drivers/scsi/myrs.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 8a8f26633cda..3392feb15cb4 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2206,10 +2206,8 @@ static bool myrs_create_mempools(struct pci_dev *p=
dev, struct myrs_hba *cs)
 		return false;
 	}
=20
-	snprintf(cs->work_q_name, sizeof(cs->work_q_name),
-		 "myrs_wq_%d", shost->host_no);
-	cs->work_q =3D
-		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, cs->work_q_name);
+	cs->work_q =3D alloc_ordered_workqueue("myrs_wq_%d", WQ_MEM_RECLAIM,
+					     shost->host_no);
 	if (!cs->work_q) {
 		dma_pool_destroy(cs->dcdb_pool);
 		cs->dcdb_pool =3D NULL;
diff --git a/drivers/scsi/myrs.h b/drivers/scsi/myrs.h
index 9f6696d0ddd5..e1d6b123de7b 100644
--- a/drivers/scsi/myrs.h
+++ b/drivers/scsi/myrs.h
@@ -904,7 +904,6 @@ struct myrs_hba {
 	bool disable_enc_msg;
=20
 	struct workqueue_struct *work_q;
-	char work_q_name[20];
 	struct delayed_work monitor_work;
 	unsigned long primary_monitor_time;
 	unsigned long secondary_monitor_time;
