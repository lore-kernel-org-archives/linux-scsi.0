Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF334204F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062761; cv=none; b=bx6nEkg6MX30gdQXEHkp+OmuSZd/kn2z1qIHjkZ2hwiOUZj4m1ds1QU3nZP5IF2vcmTvrHjYMgGmisppyIk7RyPuJa0SFbuFxnpybo7cMQQqUPVKpumaT6cMDhO2qmJ3MrcmYjfVt6kPsfSz5onzdC+v3A29NIgJhopm7iJTYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062761; c=relaxed/simple;
	bh=CPgEQoZ98ogiEnKPsKZmZgEBtUsmIo6QPoPhGiOnJho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L7EtIfGw9FAbsmZKKUZix4RLxzVPhwuxyUC71xtOmUbacYxOPdsLbvtKrxXvwFeYIEFJ0XO0MUnt04diNkElKq9IyJPHRJMLjbyRnJEdtZWWkXaeO3mUCDS1RvEum0IX30rE5lbMePGkD4uRB6uJvytHka/sxGeGFsVzW6ssiLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oERTnUAT; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oERTnUAT"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WfMLG6bDpzlgVnY;
	Wed,  7 Aug 2024 20:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1723062757; x=1725654758; bh=B08oJCV26Z6EdzICw4UigpouCO+3K0H7+5l
	5o/7ujiU=; b=oERTnUATWQGBYzCeHGZXI7y+Nm4ANJhW6GiiCoau+Xx5MCQkabt
	P0AkR+YWbGEgHrzjSsJRCrlAKSolozrNisErp0RkhuQia0J7XxkjcUkdrE2B/zr/
	LZhv4vHcGu5rTDSMB+3MbQNA4eV8N6mLbuG2HgyRKP/hp1+F1n8JUiCJQavckcuq
	biVOMfgNp5y1VwZWEyYThV5aldS7GpN4eeWudzJshgO1GxI129q9XyBg6gtjq0Uq
	ZEUY1V68wEEyha5IZYrzPw+ervH1jQDnAMJ4lYsR2UZBg+hjoctOMYYv7pnYgdyg
	hnYQeP98oa5JATCcS1M05bk/iInLIsqDSfg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Kv9mL4Ul0Wyu; Wed,  7 Aug 2024 20:32:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WfMLF4M8ZzlgTGW;
	Wed,  7 Aug 2024 20:32:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Fix system resume for SCSI devices
Date: Wed,  7 Aug 2024 13:32:12 -0700
Message-ID: <20240807203215.2439244-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes a particular type of system resume failure for
SCSI devices. Please consider this patch series for the next merge window=
.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core: Retry passthrough commands if SCMD_RETRY_PASST_ON_UA is
    set
  sd: Retry START STOP UNIT commands in case of a unit attention

 drivers/scsi/scsi_error.c | 5 ++++-
 drivers/scsi/sd.c         | 1 +
 include/scsi/scsi_cmnd.h  | 5 ++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

