Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D9025B085
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 19:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615210; cv=none; b=H8i2ZIL4I3OYSACxkWZrYAwjFUid9rzAZSuNHXSUjaWdeZBUpTGOIndE4K1C8xubddn+KDcwLLooGI7MzLDVYIFQm8NRNusAE6fWun5qMvLozSwoMA91ukXPYBQgJReC5A41wKNnQzm39wfNxtHN9Oi6fyWsjqqzN+65+DbkAd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615210; c=relaxed/simple;
	bh=G1wJCrdr3Q1C0XVR7X2LUqYgSCX9ahFUz4GKVEbw1rE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dau1mNK1XcYvcQ3/NZkFQHj7VwGRraJJiAdpgHdtNwP6LRSRUXV//B1G2m+y2wJ32EVWfxjYSuJnk6zfQO8l+mJCOjYa6ALeNQ5EeMu7S2X4JlkTkX9HTy3ddtk4KIpTmUdPg7oVW0IOizKLlPtm+VzZtCzGI27NDLFudeWqLgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nI9UHBZi; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nI9UHBZi"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gFRtd0G1rzlh2gD;
	Tue, 12 May 2026 19:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1778615205; x=1781207206; bh=uqSJ9Wv2046HH7mMpmZUGGpyKZxabyLkM4G
	F9pEph98=; b=nI9UHBZi0D96v8cXWEQzvw9ihX0IADNlMAYFA9y5RnvRjfqGHJH
	9sMGAgFJ7qNAad5AAuyW6tufuJRHV4B5+h2f7QE9Rl+68Xcbwoz+V6mmyi4yqpXz
	WKLA5OWEbHPQDseQPUKg2fXAnKVczYfDX/B2BOscnPh/RYiqEkysvd5mWHf9thZo
	flyRFOnFQVeFm4a36R0exO3EDQAP1naUqFtATdpc+F6mMjiWqcSn4QWjkFcQcyiX
	l9oMqGqFmWPzjgKzK8k4j1wuArlNngtJQWQ79+05ACpKoa+s71zimxMB8PnQ+Px7
	ZeoOz+LTHv0bXilcmXSXVMwSb7NfjDXzWyA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xhlP35UcBWm8; Tue, 12 May 2026 19:46:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gFRtW6kCqzlfgf6;
	Tue, 12 May 2026 19:46:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Brian Bunker <brian@purestorage.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Rework the struct scsi_device inquiry information
Date: Tue, 12 May 2026 12:46:32 -0700
Message-ID: <20260512194634.58145-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

The vendor, model and rev members in struct scsi_device are fixed-length
strings that are not NUL-terminated. This patch converts these members in=
to
NUL-terminated character arrays. This makes it less error-prone to deal w=
ith
these structure members. The patches in this series have been implemented=
 such
that the number of lines changed and the risk for regressions is minimize=
d.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core, target: Move three constants into <scsi/scsi_common.h>
  scsi: core: Convert inquiry information

 drivers/hwmon/drivetemp.c         |  5 +----
 drivers/scsi/scsi_scan.c          | 12 ++++++------
 include/scsi/scsi_common.h        |  4 ++++
 include/scsi/scsi_device.h        |  7 ++++---
 include/target/target_core_base.h |  5 +----
 5 files changed, 16 insertions(+), 17 deletions(-)

