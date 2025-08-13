Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9E4C92
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755102198; cv=none; b=VqSxvRWYKRjZFf5wnL4W/HRYml4V+5gmQgnxpsh+g+MTNaTGZOL9uwYS0y8bMu4eel8Lj8lCCYBKIkhSk3fZuQ8GtrlDBpWScnrvl1kAYApTaEwqFMiqplostWMzgH6M12aSC/AglP4VBo7IqvxKfrgNlbq+DzJzURPN2IBIazA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755102198; c=relaxed/simple;
	bh=fTFoX+q1GSf8DnVp7z3Rc64QFvKeq17yuud/AWpIPLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VWk3lmDZnUcjC6Hc7ReWQzV2NGry80hA95+noBViNYfIaAJcTi3g7PzewcfX7IoEmao7aPGnbx+skBl6pXkWOzTGCe+sr9lBS8U0EuLpx5tQuxqG51CTfbMQH3b21LTUQJKsnU1SeS1ul5ekqkptjRnsLiw5j/pQvNSAFOV517k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LLlYjdlQ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LLlYjdlQ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2DFB3M3lzm174F;
	Wed, 13 Aug 2025 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1755102189; x=1757694190; bh=iuugs
	WbOOWey6Rm7S7PVLHtC6cnvn2so4AmIGXBTsuU=; b=LLlYjdlQUXaAd5+0LFKbe
	Ng6iuQACMdLfJheGYJarPfmRVTziCyqT1mIgq4tz6gga+7sikbhJJ0Qs3X89jiwI
	qhiycKDh/eHac+rhmfiTyZXnZKsYYRYGhfu+MRf8wCBsQWtQkPAEsgs9nCskfG5a
	/wlWYYp6l19ez8uxLiVU7Es9bhMgf3acBZGox9xJti6it4uSckbFWZN1uYg9stM3
	GvcxRNgZ2Zm0yqgCusK9qum1mcnGUFMEf0ctLHyEVVeRsh0tFNs+MR93KamCnezc
	yGH0Db+QdoLN//7N19tu4Hkd+vYH0ELut/y5g9EcAVcweK9W+7x5AO1wUGYKVuOB
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JlZsD1eDR04M; Wed, 13 Aug 2025 16:23:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2DF76hqkzm174C;
	Wed, 13 Aug 2025 16:23:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] UFS driver bug fixes
Date: Wed, 13 Aug 2025 09:22:34 -0700
Message-ID: <20250813162253.3358851-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes three bug fixes and one rename patch for the U=
FS
driver. Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1: improved the return value documentation further.

Bart Van Assche (4):
  ufs: core: Fix IRQ lock inversion for the SCSI host lock
  ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
  ufs: core: Fix the return value documentation
  ufs: core: Rename ufshcd_wait_for_doorbell_clr()

 drivers/ufs/core/ufshcd.c | 76 ++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 32 deletions(-)

