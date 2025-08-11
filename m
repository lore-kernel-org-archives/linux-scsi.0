Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C072129BD81
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754927252; cv=none; b=iNS4YLfKwKDEILvnzO7G0JBByqujQLXKLBbr0ya40uz6/kcFlxgcpViRxmbAf6Pstc1dTmK5/jXBd3p4JyLlkZQ7WcDJNNTmau0K8AYyz1hNCKxmOyBxZHEcPcK/Lt0wIgS25NW+YbwQUNEVQBW7bM/eCLpkmGgXa8m6LLVNVv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754927252; c=relaxed/simple;
	bh=ZR5EojHbs1ISO1Nf4V+cFngL4XA/cjmJZ7cUF5MTYIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V/t6V+hnzTf6Wz47NTOqN5T/gdlupiewlmlo75MWOeWfj86QaHYZvaJrVvaq2wqMFru6wQJRbIXvDREva2XVX3c9WG+Gm7h4Rucm2o+Vtglu87OaVyhP6gNGxkisU3haioLA/Zzf5vHOe6FTMqDRnwsepRMKdv1JQtYRAE90nH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3QEfdfg6; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3QEfdfg6"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c0zXx4fYFzlgqVH;
	Mon, 11 Aug 2025 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754927248; x=1757519249; bh=cWH4z
	6GzjJhSEAsP1+k76iVtlCZMMn6sc2iz9B5A0ow=; b=3QEfdfg6dj16Yu6f5XQWE
	bfka8cog3x+R4U2oMZ/WQGHFVNuWoLG/HIYoGmLnqxZKncZ9yUdH6/Ls/dnJIFRO
	rMUfrSuVADXVMi3IuKHNLGUCa2CK8lt24ucmhZNqT/v1VQdfiXgewddUeWQmub0Z
	qmsB7oBHaM0dO1+OuL5+pBHK0WeOeRH5HM5oLQCHUhBYHa3O9gCjRiEcfNkmZSNl
	kRdx15d9P8HPouGMWJ+YrrC0vRNs/GfzjCuO3rposw+SPVkCvlOqr5UzMDs1EtYc
	yJ/Mlx8dJesLdMpYkxrWt1mK5m2r1XZwHOIL0wKB6/pfCgm/S03SJ3p5Toc7ag4Q
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OmfCal2rmDXj; Mon, 11 Aug 2025 15:47:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c0zXt5pNHzlgqV2;
	Mon, 11 Aug 2025 15:47:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] UFS driver bug fixes
Date: Mon, 11 Aug 2025 08:46:54 -0700
Message-ID: <20250811154711.394297-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
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

Bart Van Assche (4):
  ufs: core: Fix IRQ lock inversion for the SCSI host lock
  ufs: core: Remove WARN_ON_ONCE() call from ufshcd_uic_cmd_compl()
  ufs: core: Fix the return value documentation
  ufs: core: Rename ufshcd_wait_for_doorbell_clr()

 drivers/ufs/core/ufshcd.c | 76 ++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 32 deletions(-)

