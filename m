Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A64257D
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 00:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726101080; cv=none; b=b7YfT6V7ARKIuPnsOejd7P2y2MWQSrbsGkoLw+ojygb6EfOgrAvFhEW+sTHZr/RNAoDxpCG1adXy8LlyCU6NOCGzuYIkgBsv1rA+G4T1nnJGaDqUsRhSgYK7PdJCB9DoKxjSGUKZKQqGEU/qYY+qHcp0IG2PVNiFh5YsYf8caQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726101080; c=relaxed/simple;
	bh=zKJfrLeoBPPI3uHpNP+FXEv5R0/yEhtRTKeW7bWtfzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwQJ2k+BKN6SjeMh9Myye70z9Iz2wLNxyTv8ejvwv1aaRkS+z61f2QATwq4ylkhRFttQqcEuuDGCaDLngdRsJ3JXpFNbDaTuGfTcBJoIdyJqV2dpJLOm6lnapGnc16AmaiYiHO6/sSG1umUSukVcPUycsb6QRvQbHcc4IoDA2wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aZ3Aquly; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aZ3Aquly"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3yzV2Zlxz6ClY9R;
	Thu, 12 Sep 2024 00:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726101073; x=1728693074; bh=M602l
	HejhFAGmvvzqGitnCXvr6yptgiUPr9f9z3DINk=; b=aZ3AqulykLIm1Ztm0MgMb
	tWoDeZdpZ8XiXZWjLItWrTGZFbkW19uw9K7yuQI3t6W+nJ5+64lP++q5gbuG8Tu7
	9TZR+pu3WVTMgx81Y3mbhKjUpRor/3eKmK/1hzuKpG5CdZ/3Txw4lDJrIlomYZy/
	QCrLIQdRmiL5UA2alAH//NUf45PeTXDlKi76GD8GADGp7GcnUjyD9vBN6QrnAtjo
	zJD+UFpwQ3yDFKP4DF9+760/BQiLBm/ew30E4ZsC55W91x+1wOVXNGW9O51Ls6Zh
	uqn3EmNcm3eNGq+IUKjQAcM/PLGG/n2Np4oap5vclUQzLw1a4lt4g5kelNeXiGJE
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FUF77uE9cTuV; Thu, 12 Sep 2024 00:31:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3yzN4gkcz6ClY9K;
	Thu, 12 Sep 2024 00:31:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v3 1/4] scsi: ufs: core: Improve the struct ufs_hba documentation
Date: Wed, 11 Sep 2024 17:30:46 -0700
Message-ID: <20240912003102.3110110-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240912003102.3110110-1-bvanassche@acm.org>
References: <20240912003102.3110110-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make the role of the structure members related to UIC command processing
more clear.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/ufs/ufshcd.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b14276bc3..85933775c9f3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -868,9 +868,10 @@ enum ufshcd_mcq_opr {
  * @tmf_tag_set: TMF tag set.
  * @tmf_queue: Used to allocate TMF tags.
  * @tmf_rqs: array with pointers to TMF requests while these are in prog=
ress.
- * @active_uic_cmd: handle of active UIC command
- * @uic_cmd_mutex: mutex for UIC command
- * @uic_async_done: completion used during UIC processing
+ * @active_uic_cmd: pointer to active UIC command.
+ * @uic_cmd_mutex: mutex used for serializing UIC command processing.
+ * @uic_async_done: completion used to wait for power mode or hibernatio=
n state
+ *	changes.
  * @ufshcd_state: UFSHCD state
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
