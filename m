Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F748425C
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559033; cv=none; b=YWpbvinvmpPXv3kOFaIsY1C/HtFv2ixudHB6jkQyLvZUTYn2PtrNOfFC6i2fOclsrZNwhlJSZQqDQxLMmU4I3gI0rV5fExIuzXMyl17AXifaTfpeOmulIcQqGuqTDiIzmqpcWlpSqVbochTq4C5mVn3acRZi5l1muYctRR6w2C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559033; c=relaxed/simple;
	bh=X1EB4L7wShkaYvq9v4wVYtdJLJNxTrLfhasaCggoy0U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O8Q+iRKz/kUldygIsJK841DSScpQr/aqRP7OxeDPwPHyCv4T/QiUGaqDkskAIucqU1Q2+foQHYat1zd4rVS3+GEOqsXtjQPl15qEAqJ9t7oLh7VeYLeCwj4mxQ5FdG8ykyojg+vGRGRKR8zSmDQLuGEhdje9/aeg2NcG6wsiRRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4mO9uylY; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4mO9uylY"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hKxhQ6rkkz1XM6Jb;
	Wed, 12 Aug 2026 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786559029; x=1789151030; bh=DSLZH7BkVmN/FFg3Y6nv7UPdooIeyJWUj0d
	YxbzV4LY=; b=4mO9uylYnRDyjPw8OPUMr5ElHaMJsaqxU1s/ckkQQ3HG0+I66mD
	tXltM12Aavzr53FxTZgGPrxWccY+vpRAmYEhsVZttMvGT0tLwcWEQUa9rh1cZ+wW
	7/P2R1ceTZKabDZ+xNl3x63pX53qfSknF3RZeSLDtjfH/bwqZCvEfnIEQCb7fWJO
	7yeg5plgZ03NR+V9JUc4bgw2QPkqmOvRUiR/h2KCMnW/MZVfBnMTDusE3FtRbKn0
	P0Cedtw5C7t2j4bzUvmzvAgYUGYvQcD8Jz2xm0UjowoM3J4M9WiuaMOenTr53c5T
	bW5z5VA+6xx1kOg9wQGds82zT/rvPkCiz4g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fihbXuJfeXH9; Wed, 12 Aug 2026 18:23:49 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hKxhN2KpYz1XM6JR;
	Wed, 12 Aug 2026 18:23:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] ufs: core: Improve error handling
Date: Wed, 12 Aug 2026 18:22:55 +0000
Message-ID: <cover.1786558726.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes two subtle race conditions related to UFS error h=
andling.
Please consider these changes for the next merge window.

Thanks,

Bart.

Bart Van Assche (3):
  ufs: core: Simplify timeout handling for START STOP UNIT commands
  ufs: core: Fix a race condition triggered by ufshcd_eh_timed_out()
  ufs: core: Do not forcibly complete SCSI commands

 drivers/ufs/core/ufs-mcq.c     | 26 ----------
 drivers/ufs/core/ufshcd-priv.h |  2 -
 drivers/ufs/core/ufshcd.c      | 88 ++++++++--------------------------
 3 files changed, 19 insertions(+), 97 deletions(-)

