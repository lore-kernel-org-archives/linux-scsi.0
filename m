Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F318F2D9
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718658553; cv=none; b=hHAWusiV+VYNKRafP5LrP+CMnzjjxU1W5rq80J71j6XHz/8EDoZGrBvF6Pza3ULHOXrjG9qhLB1ybPH1DqyJM06Y0rS3hkaEnh2WOMhvfSvxgMrbD9QWvlAcEBTmHqtGNOad4CMsRBRq+KErtgeNQAocryLKN5+2TsBVhZMMgoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718658553; c=relaxed/simple;
	bh=O/JB9XQAY0uS7Cq3b1wiklbTpa90dbpWm4YJGEgP5a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecaZUmTnSgakiTMNkwlkFBIIOCDq0twyQMOTvzwnm6wdqoQXCIzcceF1NaHulabeOwYiqmqRxMbrzIGXhPI23VWyYHh4A+cTaMurdRWkYn0Tkys/7VGlVuJ3xD59A73b6sMDNChieDc9jDtT/h3dmC8Pqr91Y3m8IwXMARgRQ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YPY34Zhe; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YPY34Zhe"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W32Yz6w3Gz6Cnk98;
	Mon, 17 Jun 2024 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718658548; x=1721250549; bh=UVoNf
	os25vc8suv/8xQHLa0e80xjHR4VymJwDgxT5TA=; b=YPY34ZheDxijAwNhTEThi
	+fzXn53NHl3VeitaCchrXQv0FQqe/zFqRy8IGJiiiO1t/uboWt+CDf3336JpZf1e
	mlEpb9GaviJGMfhZvjt6WLMH+2aC0W/KCUjKK5YrxZm7rFMGpTgYJpNmKmohHU2G
	pKev3kj/YQdmM2htbnujTuSCg6t6UMXMSJI3Tf57NBmnfq/uHnYFAjosJdBMomnZ
	v49HIw6Ab/hzX7YVt2pEMzgWwTqLS5hRqKSXoFa4XgJW7YV1dWsJtjwfh0S1/OCw
	rHvBlciPUukOPvdHZMyGabQxy0VlcA9vl3Lz0cmwfdMHe/HBpcvuYBo0cfqw0Y1v
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id U-MEyR0aGE76; Mon, 17 Jun 2024 21:09:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W32Yw0sqXz6Cnk97;
	Mon, 17 Jun 2024 21:09:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 2/8] scsi: ufs: Remove two constants
Date: Mon, 17 Jun 2024 14:07:41 -0700
Message-ID: <20240617210844.337476-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240617210844.337476-1-bvanassche@acm.org>
References: <20240617210844.337476-1-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5d784876513e..7761ccca2115 100644
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
@@ -8959,8 +8957,6 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.eh_timed_out		=3D ufshcd_eh_timed_out,
 	.this_id		=3D -1,
 	.sg_tablesize		=3D SG_ALL,
-	.cmd_per_lun		=3D UFSHCD_CMD_PER_LUN,
-	.can_queue		=3D UFSHCD_CAN_QUEUE,
 	.max_segment_size	=3D PRDT_DATA_BYTE_COUNT_MAX,
 	.max_sectors		=3D SZ_1M / SECTOR_SIZE,
 	.max_host_blocked	=3D 1,
