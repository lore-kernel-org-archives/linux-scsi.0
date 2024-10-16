Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EF75478E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113133; cv=none; b=YKU3h/hTLbv+X8AAhH537dWyDW+FicQ7behIJr2QNKPjqk60GQGfwozs8J80LQjClVP0v2Dsua9pJuZiBaMqQR41BlNPdku64y33Z6qip7iVDwf69bjY27LJ56RwFThaqMzeNf5Jwi/sJ54lEdllUAHODoVZu18p6xHIaWZdiv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113133; c=relaxed/simple;
	bh=XKPXu8UuKC3o5TfAxlTok7328/3RXVTfG6qZlzsgsDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fsrg9ybc9sLLMrZwj5zZvYxkXaAGhYdViNGKLOjVlwva67XtBRiapdjjWNBzm6K329VgzX7JX251W8TVe+sSUEdh9+VJS5NFsqxXKFyF/nd6PbdFbieFxulRqEVfvClR/PVvYt0vuVMquCH9KfvjDRyDv7HoFcEZAIJ9hEsaGas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yJj4ylEX; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yJj4ylEX"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNvT38G0zlgMVr;
	Wed, 16 Oct 2024 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1729113124; x=1731705125; bh=hGIbPOgHBlNhmu6D7IKW2iYlcWS9niPZnuH
	4wfnpaf0=; b=yJj4ylEXYGV59oWcG7VoVZ2l8QwRc+Jn7LOEIMh1hcpqP61aOuy
	jnX1THjGl6dWHxtD61V+LFfxQJAmPHzAGDwIkmrarhPirr/o2ooWlmkPWv3z0p5/
	7NF98fKASX7yLRZG0N/6vE+BiqIMNZajEAosBBXh180Sh7P9hj5xTpjrAhHHYiPP
	rS/HFUAq/I2VJrhbwiWbtBaZh6GNsApg+7mW6xH2Wy8gmc9pDcBVoFlNTsIq5H6F
	hrH/rhznmbOYMq8kD82pXLbRYj8Eczeym3x/3ztgI8KgtjL7T09LGkxhh9ZEZ81r
	X1QwlmIQJulPC3GqicOs6JYy1tt48GH2nlw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WSuX6tUwalj3; Wed, 16 Oct 2024 21:12:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNvR3GfmzlgTWP;
	Wed, 16 Oct 2024 21:12:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/7] UFS driver fixes and cleanups
Date: Wed, 16 Oct 2024 14:11:11 -0700
Message-ID: <20241016211154.2425403-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series includes several fixes and cleanup patches for the UFS =
driver.
Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (7):
  scsi: ufs: core: Move the ufshcd_mcq_enable_esi() definition
  scsi: ufs: core: Remove goto statements from
    ufshcd_try_to_abort_task()
  scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
  scsi: ufs: core: Fix ufshcd_exception_event_handler()
  scsi: ufs: core: Simplify ufshcd_err_handling_prepare()
  scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
  scsi: ufs: core: Make DMA mask configuration more flexible

 drivers/ufs/core/ufs-mcq.c     | 28 ++++++-------
 drivers/ufs/core/ufshcd.c      | 76 ++++++++++------------------------
 drivers/ufs/host/ufs-renesas.c |  9 +++-
 include/ufs/ufshcd.h           | 13 ++----
 4 files changed, 45 insertions(+), 81 deletions(-)

