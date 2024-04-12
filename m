Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E567C161
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 00:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712880176; cv=none; b=nMSUOrSHI1+G+cMNLVfgAbfoyeeADc9k7zqw2mKER2CeciwHC3WW8tglFWxufTg34V1qHvyjvrzeKSlXpEE6RVRl3tkbHnpKsViuZwnBJDi2np2aGcLM9tmpi9L4tUy3wkyYD9IgxAKHS5HuK5xhW1hoalFSy2CxSKlCAxVYSF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712880176; c=relaxed/simple;
	bh=w+LBHjEq9LqRfsvU5wVj2wWttP66ZIpKU332qnNcTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QH13U0QwXkp54wK+Xxbrr65JtPy9aamKn6m4xMe37LttD+cd544y938YpVUd6Fdpuv92FUcQTiRkLwIk94JPndNvqbpkqbiH0mTd6p4Jcf2r54D5VOHPa3EFwQhO5LLWeoAnWfsHfa2h8yfXnXJ7IU9zz/yLoVyVFpvRwYtoMnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aKVP3Pzr; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aKVP3Pzr"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VFxbL0jMPz6Cnk8t;
	Fri, 12 Apr 2024 00:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1712880172; x=1715472173; bh=UZT+L
	/Jv5cT6nRJvgDraa+K2TVqDfuzwjvvOq+beYnw=; b=aKVP3PzrpQnNkv7KzDqBa
	3u8uPhZ5BuvJ2LqqJJ71XuklzAvpUs9e8z5ege9r23BxsIjjQP44Qaf1Ad2DqozN
	OgbxMRUL/NtxhT1ULbyA7gx01o8mqUpdPYeQUwdawMwGeilJPA+e63zClxVXmpw/
	u2Mj2UstM6oqV6/a+O/Z0ePHJ/fON1NyWmOeqDYIJWWrhUEvavNodQpV+4FKgSz2
	DN7RaDycFYRe8O6xP0BxOGcrJ4k3SzLu40t59C5G8jknLrSwgWsw+8NEU2TLr6DW
	HHcZqoFUsWz842u4XJSQ0yHfaDhvURM++pBTsToD67dJEF6Cz30Xes0KJzuEftYt
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o3Y1_-nEqJUb; Fri, 12 Apr 2024 00:02:52 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VFxbJ01Zlz6Cnk8m;
	Fri, 12 Apr 2024 00:02:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Fix a rare crash in the UFS driver
Date: Thu, 11 Apr 2024 17:02:20 -0700
Message-ID: <20240412000246.1167600-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Sporadic crashes have been observed with the UFS kernel driver if a timeo=
ut
occurs. This patch series fixes these crashes. Please consider this patch
series for the next merge window.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
  scsi: ufs: Make ufshcd_poll() complain about unsupported arguments
  scsi: ufs: Make the polling code report which command has been
    completed
  scsi: ufs: Check for completion from the timeout handler

 drivers/ufs/core/ufs-mcq.c     | 23 ++++++++-----
 drivers/ufs/core/ufshcd-priv.h |  6 ++--
 drivers/ufs/core/ufshcd.c      | 59 +++++++++++++++++++++++++++-------
 drivers/ufs/host/ufs-qcom.c    |  2 +-
 include/ufs/ufshcd.h           |  3 +-
 5 files changed, 67 insertions(+), 26 deletions(-)

