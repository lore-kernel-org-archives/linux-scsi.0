Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C5C3C0619
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 21:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779225710; cv=none; b=C++bUefD4RZDOjOa3GIpsR9QmCFHALJVjpuT8JO5aXvtLfyGrjjg9ntu1JnlPY8w/V5ZJbcxBSSAkB8obm/BqQbIcsayWn8gv8PvOTHeqOZWZiE2RSgBHBUgfqGMhn9OtjFlp40QQrQ4fo9RKQ5+e7ucpQohQ4kTA+isdg7YzLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779225710; c=relaxed/simple;
	bh=oEj6laNQYXuu533mgAvZC1eM8PjMqZuoF/eMj2LgSTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZaEyASUA2+fUgQnvoAtkEeK8EMgEK3QzeHBjCMb8A/Zeu3BVBsUlJBO8XrreBLveZzSETwOMbO4iGH0hIDDoG+9dCPfAw0RQUmhU8AuIeQpAJ2v0wokNcGQlrZ5Zp2Q4tCC5OZCjIpaCpTdjtL2ODOm36Hk0ocrOLY9H388auuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xxbvYSwQ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xxbvYSwQ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gKng02K4Mzlgtd1;
	Tue, 19 May 2026 21:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1779225706; x=1781817707; bh=6CTYaUX69x5nuE3YEUz79WI2LKQ5jIOm48g
	0pNpo9MU=; b=xxbvYSwQc+ZGFk52kBnOssHy0o8FJXtyo19vAr/Sq1nzg654iyJ
	qAGw9W5bTlDTRH0hTFXJRUJEGaIcTyUIBx+i4lhy2fh3lIXdJx4vyVXUnbV5EXnD
	4dYxtsuATpbCBrEy1gOZkKC254FrO/+TPnhu/ABVPOQMmYosYENUKM5hz/Y73Ud1
	Dozu30AVdchYhaHL7+hD5pvTC3Dix0l+6UGG2OufwVEpp7AtsTNBRaTfK2sJ7dJ8
	PMblh/yNcCDqcQ954Jy+OLV9L654z/gJ5UuU3/XxHHfS6FCdINrwop56ENP+yT9i
	WqHGBRDVA7u7uy9igMzsyXiEp+j/3CTQoZg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xqz_zemBRL5o; Tue, 19 May 2026 21:21:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gKnfx2nw6zlgtd3;
	Tue, 19 May 2026 21:21:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] ufs: core: Optimize the UIC command implementation
Date: Tue, 19 May 2026 14:21:26 -0700
Message-ID: <20260519212135.3130556-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series reduces the number of readl() calls while processing UI=
C
commands. Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - Reduced the number of changes in patch 3/3.

Bart Van Assche (3):
  ufs: core: Inline two functions related to UIC commands
  ufs: core: Complain if UIC argument 2 is invalid
  ufs: core: Optimize ufshcd_add_uic_command_trace()

 drivers/ufs/core/ufshcd.c | 58 ++++++++++++---------------------------
 1 file changed, 17 insertions(+), 41 deletions(-)

