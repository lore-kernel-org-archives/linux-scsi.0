Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2730282F1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 22:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790290500; cv=none; b=ZZCSTbdhK1G4Slua8GFaDm5SXffmZHDBMXijNjFzoVV5Cpuq0BdzaS0mxPXjz2ZXB8ib2lB29W9h9rcIgRGcuYetq9dkSDQ/m9MKzVTdYNFHB8pVCSY3c6R7am+cZkXWkITFBHiB8Itit/yrJ9qyuen375fjmB3WGrCz567QHFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790290500; c=relaxed/simple;
	bh=7jHIJSOTj/cxFA//eaiWREyJUbb+WBZGJwYXnK5Iipc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dMen9IWIpK7j5GbX2ik1Pq1S6FrXX3EW9qDX3Yj1LawcOlorxnBb92I/sMtvCrYh07VLnrUO4Fg2Rgh8jY/3GvStu84jCbeOtxiPbThp9xAHSVRyz4ZcBVA6mPi0c/4OUOSFJRQ9TvyZjGXnm1NGxiUQ2eZ5yZWuHOksZltK2w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MP4Mpsbw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MP4Mpsbw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrTgQ116rzlfvpS;
	Thu, 24 Sep 2026 22:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1790290494; x=1792882495; bh=/nCFDxmyXMo+m2/D23MgW2x3x88CVJLn3TJ
	0RFcTNlE=; b=MP4MpsbwOLbSt1Kf6amP29HdU4VFI7Vi/gd3k5LdBWRhpgDG/na
	jQzxbLK7ZYkEI8U+z0iONG/qvf9cN0kGpng0UOPo/1cZQRCuc7BISBK7JaRIZUVs
	UrDSv+OokjxWHcLH39pRR5VIDKOhuQI9chOt7etiKAXPdVRitGqpDeoW7e0SinS1
	Q1voBdJWC9sM/VjRtCcAwfUanweeMDHM9FLz68/FLUC6Ibgsnwern82oxprF4yBo
	nGCLNAHi0QsR/uONTEo58jGFf38QZFATCPT8n7orCLkiLpuMGyZLIMXu4jOTsbb7
	ffKuyLoyOavwIzs1c36CMHJZrgNV0WBUU4g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NOAXve7ykb68; Thu, 24 Sep 2026 22:54:54 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrTgK11cqzlfvpG;
	Thu, 24 Sep 2026 22:54:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/7] scsi_debug: Enable lock context analysis
Date: Thu, 24 Sep 2026 15:54:36 -0700
Message-ID: <cover.1790290089.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes a locking bug in the scsi_debug driver and enable=
s
lock context analysis.

Please consider this patch series for the next merge window.

Changes compared to v1:
 - Fixed an issue where the error code was clobbered in resp_write_same()=
 and
   __resp_write_same() when fetch_to_dev_buffer() fails (John Garry and
   sashiko-bot).
 - Fixed return value handling in resp_read_dt0() and resp_write_dt0():
   previously a positive byte count returned by do_device_access() was
   incorrectly treated as a SCSI status code and returned to the caller. =
Now,
   the SCSI status is passed via an output pointer and only negative retu=
rn
   values trigger an error return (sashiko-bot).
 - Improved lock context annotations:
   * Annotated existing rwlock_t members (&sip->macc_data_lck,
     &sip->macc_sector_lck, &sip->macc_meta_lck) directly with __acquires=
 /
     __releases instead of defining and embedding dummy context lock stru=
cts
     in struct sdeb_store_info.
   * Dropped the unwarranted __context_unsafe() annotation from
     sdeb_data_read_lock().
   * Updated the commit descriptions to match the code changes.

Thanks,

Bart.

Bart Van Assche (7):
  scsi: scsi_debug: Fix a locking bug in resp_write_same()
  scsi: scsi_debug: Split resp_write_same()
  scsi: scsi_debug: Split corrupt_lbas()
  scsi: scsi_debug: Split resp_read_dt0()
  scsi: scsi_debug: Split resp_write_dt0()
  scsi: scsi_debug: Improve lock context annotations
  scsi: core: Enable lock context analysis for the scsi_debug driver

 drivers/scsi/Makefile     |   1 +
 drivers/scsi/scsi_debug.c | 372 +++++++++++++++++++++-----------------
 2 files changed, 210 insertions(+), 163 deletions(-)

