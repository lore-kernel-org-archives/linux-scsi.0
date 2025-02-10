Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97919264601
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 20:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219984; cv=none; b=JMnnUFZbKeDv1IvCgejZSbhjS/N3/HoDRAeetpTkvhlfSqvKbHQ5hbibCgP2WG6693zY0wENnHQGcAcyxFkDyqyB/Iki7ON8jen9Nd2sF+ijrMvKV32QWt/Qla/IUB29B9aNrQKokySKBDzn3uAcEjfaa38o3NM0kEzNNGPkQ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219984; c=relaxed/simple;
	bh=IJbj7/tWIYUgzyjD4nWWeZ2OAqCLD2JRfHfoG9qAI+M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=glZ8Q7dRwl3PMKqt2KWOE/QtDa5BLrzbfP6wXTjXk1B5JpjUyUdRQxDOZmzZdBnO9dJf/FzrxnnjcStyVwBBZkX0V6pp4zEeM2SHKQxsOUBD3Y0Aoq8Dk8aHFdtFV4ewwki3dkurn1tKRgx/pPAA2VcOMEOFVhySSqYgHS70+OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5La2zu8K; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5La2zu8K"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YsGf56cygzlgTwT;
	Mon, 10 Feb 2025 20:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1739219980; x=1741811981; bh=9rKV+uTHELsS/R2D1YXum/Tl37f4/RKV8ZC
	V+WTHUpY=; b=5La2zu8KcPCJ8kCvz6aZ8ftaAcjZnXPR5I+8G8DY0xX9k54wSvp
	S6FYqgraWfJYWENsIYmABwYlzCmkCXJt4gHK6Z/P9/BwAk5BnNsvkbXLSSapmiHG
	KC+M7B8rb96NlOixvXIy0a150ygSrphcwLRubVtpg7rVJ0YRmoKjjE/2ns4a7raa
	C/ueWa28xSGYThLefzEOss6rtwHnm8Rdp7WtmTAEp0TsDoRVV32m39aifnYgRxlH
	ZLoxzRE7+vOY3FK7opfxHzFS5uCC0v6+y6SgSIJlgBrgtIQp8NYd2CdPetgi2k4Y
	OGAQhRN2ph4PTZBSO229tEgggU8EXweAkqg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TEgiBmLZLArE; Mon, 10 Feb 2025 20:39:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YsGf40njzzlgTvv;
	Mon, 10 Feb 2025 20:39:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Fix locking bugs in error paths
Date: Mon, 10 Feb 2025 12:39:34 -0800
Message-ID: <20250210203936.2946494-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Annotating struct mutex and the mutex_*() functions with Clang thread-saf=
ety
attributes led to the discovery of two locking bugs in error paths of SCS=
I
drivers. This patch series fixes these locking bugs. Please consider this
patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: mpi3mr: Fix locking in an error path
  scsi: mpt3sas: Fix a locking bug in an error path

 drivers/scsi/mpi3mr/mpi3mr_app.c    |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

