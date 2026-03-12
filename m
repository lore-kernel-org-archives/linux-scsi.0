Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCF438B132
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350290; cv=none; b=ORWyu2uG20wWtA0hwMT69UwJQTrWArWdN5/3bzGjKppCArVuACVnJIf2bGvqxSGmd4rnPKPXdn+7qNQsIhSP8glNZYWubfQVDlGo1ppwpyV7G/8q20djsmNw7ZqoWaCYHnqV6Q+otB1S3yqtUMY14qeWVmBsufLZt8AMeN50yd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350290; c=relaxed/simple;
	bh=1F7SjNhMWibdbM4xOd2BxAvD9npLeH6o3+H6PgPsQ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBEm+Ge6wrDr9J7JxLCzirD+8Gq75ba7NI1U1OloCSsklwMryZ0t1M677IJWARsYyuMzisKjSTbCrmn/la1tn0xIT+nX6o+8uhy8tFu3R5MUi5oJ50CWyYBrqXWo8I4iWbmU1TjQknhIUgAGscXUkpOnbajF6n2pCcxG7t/aX0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TSSgQZig; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TSSgQZig"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0p93z4bzlfl5V;
	Thu, 12 Mar 2026 21:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350287; x=1775942288; bh=40iib
	GjW6i+HOi8x2h9cAyvOvTRWnEEPXGmTqTXtcw0=; b=TSSgQZigxGbp45jfGX9/X
	RKQJRj/KYtBlMMfrJNugDitxZOMIa49Zmkinineyvhw91poDJDg2YXK/DPRALwsz
	u41eq1J0rZFf07TGtJEkCr+8mkED+EkGKBpV7DHfUEsfUd+79+N2WGsViIW3uory
	jp0F3wcoKQIuT1NF2WJ1p2YmaZVArWU0/aWQZSS3Cqjq5ZzsxE3/YxOf6i80IapL
	CQgoNT62LUpczL41rvX1V/+aOPyfpB8dsO9zm4ZGIQXvgnNSJSUbl0eRJlZcpM/E
	4ZL9PbocZ9rW9SEzpR0V7L9mBgy2Hk9MN5nu3hWjtERR7vu+KMZJnuB/0tZ9LYm0
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ba8VdrwXTtab; Thu, 12 Mar 2026 21:18:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0p56syPzlfl5W;
	Thu, 12 Mar 2026 21:18:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 27/36] scsi: pm8001: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:38 -0700
Message-ID: <20260312211636.3245119-28-bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 954f307352e6..5f7501af482b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2287,6 +2287,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *p=
m8001_ha, void *piomb)
 static void
 mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	struct sas_task *t;
 	struct pm8001_ccb_info *ccb;
@@ -3849,6 +3850,7 @@ static int ssp_coalesced_comp_resp(struct pm8001_hb=
a_info *pm8001_ha,
  */
 static void process_one_iomb(struct pm8001_hba_info *pm8001_ha,
 		struct outbound_queue_table *circularQ, void *piomb)
+	__must_hold(&circularQ->oq_lock)
 {
 	__le32 pHeader =3D *(__le32 *)piomb;
 	u32 opc =3D (u32)((le32_to_cpu(pHeader)) & 0xFFF);
