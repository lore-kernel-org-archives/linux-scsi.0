Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793400178;
	b=w+nwYm/7Q1A9bAYYop0d64yYnPAZNg6SydLfbnXF1lO/ZFklUbtWA8BrYSgoojJP4IJx
	 uMDzhRVnJDKTWrI9MQnmbHXiCQs65Pd/s1liCGZ5nOYsBzyh+Ra9s33MkINclvYSkVG/Y
	 UM08O3RMT3OquTrAzB6TyEVqmPJlhr3zPPK86af04TRGD/qj1sHZRDxnqw8h9HcApRxNX
	 PUkyZeNf1qKut+t5qZCveV+SMgzE00epRs3x4YpHERu+YW1odyLAynGl2u5zIPyI3EB8g
	 NDVS3vYSOYH0F/VEdBv0AvS2rWinZ9IUKrKwEQlPvq0Y85+jsmDhvo0+GqYmHZQf2/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400178;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=hm5efXQ/ntgShoZk0j6IG28okjUc3yc6D+XhPH/dUpQ=;
	b=Sm3E17nBiOOx2S8y5jP3jOfOAH6jbztXESJMBktBklr/s3H7vapw/WRH2CBxw4syauqt
	 Ga/JX/d1TApkEvh75uHLDirDgiwtbusAOY/YtxxZ7u96AF6spyoXxzxjhlK/fdq3IIT6w
	 3CREjMhNIriFm87fH7Dfa8zSFNlhZlP73plCUhOvxRrexb7/AuQ8i9zdiGcH2NtlKgI1r
	 KlFIRvjiW0q9wLK5VQrxywOElJo9zS435ZrshA0wVCdZHs1tPdyBabez0L4Uct3NSXEgy
	 j4WfapLk4T49yyH2kuazjhNm1zAQ03IVZz03Oi3eOIrVlPboj4qUx8oihoTNnpNu0rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=X59egFFP;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B0606A325
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 22:42:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 459B0606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=X59egFFP
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jGbhx5tptzlfvqC;
	Fri, 30 Oct 2026 22:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1793400174; x=1795992175; bh=hm5ef
	XQ/ntgShoZk0j6IG28okjUc3yc6D+XhPH/dUpQ=; b=X59egFFPsvWuF/bRvFlNX
	gON0uiRLs9R65TOGhougfLJr8E0IdmVhdNkoKrsSaQHjfDLNgsrCkzUU1/kbBpSt
	3W4LGXi/G6owdlxrQJrlcfBgsMdccviUn3mwTM9hoaslojzSTU8lTD2IrKNcOEsr
	MbB0ANFIpzkES2GxMDgqQNsL5hDGMQP8GZy9BH3Rh5ScGLwfJrp4gutOSk6zdhdQ
	I++uoTMm9xvrADpXp4/2TqxAP8vxROeF808W2sO41HboX9yS9dHryI5+GRy7xKAe
	k+OH4lQaPys0Gp3HKjAHI2q3mU0bf2j2jDGahlU3B+hjRpCkqLQl9s9EmmKoQ536
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9J-bktckAduR; Fri, 30 Oct 2026 22:42:54 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (57.237.82.34.bc.googleusercontent.com [34.82.237.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jGbht2rFjzlfvqD;
	Fri, 30 Oct 2026 22:42:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Alexey Charkov <alchark@flipper.net>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH 2/5] scsi: core: Simplify scsi_eh_ready_devs()
Date: Fri, 30 Oct 2026 15:42:36 -0700
Message-ID: <de1a210fb52adaefd818ed68eb5e7678a004762e.1793400000.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <cover.1793400000.git.bvanassche@acm.org>
References: <cover.1793400000.git.bvanassche@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Replace the nested if-statements in scsi_eh_ready_devs() with a single
if-statement that combines the conditions with the && operator. This
reduces the indentation level and makes it easier to insert additional
recovery steps. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f27186d5262f..ee80af923a4a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2301,13 +2301,12 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q)
 {
-	if (!scsi_eh_stu(shost, work_q, done_q))
-		if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
-			if (!scsi_eh_target_reset(shost, work_q, done_q))
-				if (!scsi_eh_bus_reset(shost, work_q, done_q))
-					if (!scsi_eh_host_reset(shost, work_q, done_q))
-						scsi_eh_offline_sdevs(work_q,
-								      done_q);
+	if (!scsi_eh_stu(shost, work_q, done_q) &&
+	    !scsi_eh_bus_device_reset(shost, work_q, done_q) &&
+	    !scsi_eh_target_reset(shost, work_q, done_q) &&
+	    !scsi_eh_bus_reset(shost, work_q, done_q) &&
+	    !scsi_eh_host_reset(shost, work_q, done_q))
+		scsi_eh_offline_sdevs(work_q, done_q);
 }
 EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
=20
