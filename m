Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30BA1B253F
	for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2024 18:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264978; cv=none; b=ZTjMPt7C1tlDAUyxQvB4kS/xGmSNgbn6HYci6EEm5dhILdBdFWvxObZPvVx+0EUHcETXh9on0wSyCnnEaBlB3WpVe9m8iycA6e3/KHVDrEXN6f1Jje2f8/myGKbVEqZzYhWWbEUhCymREoCEFc3AL1OTDFeeuX6V/Qsy7RMe0iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264978; c=relaxed/simple;
	bh=S2phs7NKqV/EJIJIl1QSkuCu9JfNDTnE+lZaDUgMEPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OSAwVeTEaKirEhD3SrC1dwE/z3+WUgqfU+cgqDTSiFELO2qoizZC51q/a/e+1hYxp9Wwm0GfP4+TbopPgVkex76p+iyX3JbsSZfqESgiMzmWPVK3vPdNTHeI915NBDICSule/xxoUXEr7AShWEx5uSf5BhFX6Sbh+DX5wyRl4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ixz0rnAw; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ixz0rnAw"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wpvxr1n3mzlgVnK;
	Wed, 21 Aug 2024 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1724264975; x=1726856976; bh=E3awdxIw0rjiXnogTuqRoRbnv5Ha2x5UENG
	BFe45pIA=; b=ixz0rnAwpUnm06KgwA4F7msZXFAvxZoPC4SX7mdW93KR2X1ucEm
	5TOSiq1IFbP6QYrRqoXrD+3SBpcJo1q1o1jPAdkSuAzaI1stv3Z3bBMEIThij2ws
	onqsaPCph6ETeYzExwazQ/t6AZZVH9t3wTbyMDTNF2vkJNJkWuNildSN5DbMkG9o
	/4V0xNJA1WddbQHHsjlGHgsvnwdOqx5gevotO1srtbpR8BmhmihpohHFo5/6pPkO
	ngpatFq4P9G5JDiij0QpjgSsuoaMdZI9lAr6jWd7ErT7gaJF8hqsrr23K5KyWaC0
	Iz14+daXya7n/44IVXexwDVlJj9yIJmoLyg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fppQma9qwBjm; Wed, 21 Aug 2024 18:29:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wpvxp6q4jzlgVnF;
	Wed, 21 Aug 2024 18:29:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Fix the UFS driver hibernation code
Date: Wed, 21 Aug 2024 11:29:10 -0700
Message-ID: <20240821182923.145631-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

While testing the UFS driver we noticed that the UFS host controller does=
 not
always enter hibernation when it should enter hibernation. This patch ser=
ies
fixes this. Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to read
  scsi: ufs: core: Fix the code for entering hibernation

 drivers/ufs/core/ufshcd.c | 37 +++++++++++++------------------------
 include/ufs/ufshcd.h      |  7 ++++---
 2 files changed, 17 insertions(+), 27 deletions(-)

