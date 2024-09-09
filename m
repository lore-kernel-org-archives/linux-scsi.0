Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C418D63B
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 23:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725923520; cv=none; b=agrH4fmIC4C1Zg3fSL/seBfa9psaoSlqXmSz+mVwesFa4T4ThUnJZiWE0WcnXB1AXvsEsJdVDn+7/LYKND2zLXNYBxTg98n0fOck+WgYZc0WiDeMocARCa1hISaPsFHzbobYKeKfzA2XI1IZdkLjFcpbaTG1Hv+rpg3ZlQ/WFEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725923520; c=relaxed/simple;
	bh=FddhbQfTp8v88Lur8UiiaU/Y+zXnAsClXr2EXxSAQUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqpS+sNMzZkTy6g3inCxoPNN0Aj7hjiIae7CV0vt5LVmHkMY3zq/GKY/VLV7cId3SJSe3SGcXcEhcXOxJ94aJ1dN6DsuJCn3ERYOl0VNiZAVxrgouy4M7E/5CQywYlh0t2o4/GS1+ZzN1whUdluQU34zYAm7vXM5IQZEjaw8ib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a1SKazNI; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a1SKazNI"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2jJt55HDz6ClY8r;
	Mon,  9 Sep 2024 23:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1725923515; x=1728515516; bh=EeN/B
	K4+bVHxC43DlnVycNpO9vP4PGo6gQmjRLawboY=; b=a1SKazNIMCF8r5S/B5NxF
	U22ZRtTufSTJuacQU9iZf+anR++L94Y1oSQqkpibrc5pk/xjiOJJfKZ2+gBj/W9G
	bH16w0toPrthMiIaKDrfperYgwI+gfn3ItCpYiNmzEnfD8tL9EhHybhH1nCvZqtU
	RH3ulaoDduEsvoTdPOTv9/3cnpxyM/SwQjcq5BjVX1YUCEegpC/SzDKgVby/vq2L
	qHrBSuCz27qVT8QvQlCZ+SUxsQhNMwDydywEjIGK6aVXTJEL4vuNz7rENMxI/QF+
	oG7qYyhE/wM+kN9tLeCny+BhRo6gLE96MZ5Jg+fF0s9GLJgKp2m82nnh96fdS02d
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3QdSdkZQqcno; Mon,  9 Sep 2024 23:11:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2jJn0ZZWz6ClbFf;
	Mon,  9 Sep 2024 23:11:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v2 1/4] scsi: ufs: core: Improve the struct ufs_hba documentation
Date: Mon,  9 Sep 2024 16:11:19 -0700
Message-ID: <20240909231139.2367576-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240909231139.2367576-1-bvanassche@acm.org>
References: <20240909231139.2367576-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make the role of the structure members related to UIC command processing
more clear.

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
