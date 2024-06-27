Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628D561FCE
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 20:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518437; cv=none; b=XcgLjtXDfoJYq4Yl4lu0xvBPlSARc8V6qWGhK2azr56IL/jskhikbbGxBsxSEC3eY/6z6sUaRMgInKGzbrklYwkoGcf0csZU0M2yVbzsdCdAAHKJT32aK8DOiCwqzES1xyQFGHX9cK5Eh/VxOo8OwNK2RP3/e7VnuKbH0QJHUTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518437; c=relaxed/simple;
	bh=woWKB4+NiMyb3xgaqZIhovUTbg9vlaHzA1AnoNcHygE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/9+F+8LlGF+DTJxW73OBDSWrVDIF5LkE0UX6D2XPrvt2JT230R++rVN0RxPMY7GLuyEhK6QrptavX9ruXS4jGYMk14luU+RzBGjEO3WnRO9pmfUUApOK8lTsBcQQTo3eFAN+5G+GZvCg9tnD8b9rCtGRnRZJQ5QgPL6ncOB4iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w+zG3gPb; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w+zG3gPb"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98ZC6LzDzlgMVW;
	Thu, 27 Jun 2024 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719518433; x=1722110434; bh=S2GC7
	XC5vzHcPelKpfLA9TpmyUdkePRwe/ZH3qgvo0s=; b=w+zG3gPbvMl/J13KWy4uA
	li8q8ycZ5dcGeeaW9j3w5DloZmcyBGPKFoIuEl39NqDGpVhM8DtytMqWG/4cSpyi
	g60WhElAVk1kvOFtF0MTOtmCNZ2UEHeJUMfSa4yOJzscHrd+EC9qkrA/yVBERzD8
	RqZEMPX6AIBDIVnkZlBd0gWG4+kJzP6nm/bI85rCZZo190ynRyAxJkruntxkSq9n
	+MukUcq1wgOfJdG8ihX7fqRzv2LrzpUlethi58w4QQ1PQMuSMiZCnitAe/0Ialee
	keUPA5JdsKN1E1FKnnx3Z5pG9TbtFnSi/1F5O2nL5w43MU+6dxxmG60qC69GKFaF
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O_CM0OgxGFSV; Thu, 27 Jun 2024 20:00:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98Z71ybkzll9bp;
	Thu, 27 Jun 2024 20:00:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 3/7] scsi: ufs: Remove two constants
Date: Thu, 27 Jun 2024 12:58:29 -0700
Message-ID: <20240627195918.2709502-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240627195918.2709502-1-bvanassche@acm.org>
References: <20240627195918.2709502-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI host template members .cmd_per_lun and .can_queue are copied
into the SCSI host data structure. Before these are used, these are
overwritten by ufshcd_init(). Hence, this patch does not change any
functionality.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b7ceedba4f93..9a0697556953 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -164,8 +164,6 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
 enum {
 	UFSHCD_MAX_CHANNEL	=3D 0,
 	UFSHCD_MAX_ID		=3D 1,
-	UFSHCD_CMD_PER_LUN	=3D 32 - UFSHCD_NUM_RESERVED,
-	UFSHCD_CAN_QUEUE	=3D 32 - UFSHCD_NUM_RESERVED,
 };
=20
 static const char *const ufshcd_state_name[] =3D {
@@ -8958,8 +8956,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.eh_timed_out		=3D ufshcd_eh_timed_out,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D SG_ALL,
-	.cmd_per_lun		=3D UFSHCD_CMD_PER_LUN,
-	.can_queue		=3D UFSHCD_CAN_QUEUE,
 	.max_segment_size	=3D PRDT_DATA_BYTE_COUNT_MAX,
 	.max_sectors		=3D SZ_1M / SECTOR_SIZE,
 	.max_host_blocked	=3D 1,
