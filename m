Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF3F35C19B
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 23:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790724200; cv=none; b=CKo7Pi4FvH5FUr1MHzNURUGjL8Bz/TVVOHoYZWmh97nwswrUeqHGYuP1n9wraIk3zVcNR9GxlBthMclB41bVpten4B++lp9y5oqukbkEhySGd2wecyyqyQngIMuQk2tfnp4QMF+Aky4aPPDllF7rV5lffs3flAN8RO5AIudKHpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790724200; c=relaxed/simple;
	bh=L9eI3jizjRSllug544eb5g3/HWWuKPLOT1yDhHGtMN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l0z2VVSu/KonXVvBZtfyg2nSQA1j2zNmWoLC9TIu660GllogEpXBwscicZ85tT9xgYDehVBsgYk8GV+quhyXlfy1X732rr9DXdNw5i41/wyRcMROxYSJ/PryDUArF5JqHkbT9DoR9KvnPs43tfdCMyKfSR+iXDojncOTnFz+Ktc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gBmF0rL2; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gBmF0rL2"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hvZ3p567Jz1XM5kW;
	Tue, 29 Sep 2026 23:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1790724196; x=1793316197; bh=QFjcJHmAnUxaKad66AtGMl2WyxLzB+nh4od
	zKQm9hGI=; b=gBmF0rL2WJ7WuH4ed8y5RVjnHM8cuNSBBSKWwgvk4YKmAtSd/Gc
	INpXfGlMFv3ZbWKK7Fpyae18WFlSYpU91zvfkARNfOaXMzoIpAH0BVrNlMKTDMWr
	ABW9GxnjR4kPvzrngyQJzDwCgpzyzunYknssSH9WffXD+4dlNRzbcFFErdGCx4Mm
	wGxlvQC0Jw9n9OJJWYBzCICdQ1UpzhuNs4FP2TelD1mlS5ymAi4nXfFoIhiBqx/b
	TWQI37gyto8HaPkCdDDm2abNAtwdpDJLgPV+JllWg6xt1l5nmYmjyIue7/qElZJh
	HcxenIgkiA42pVwHBYO+z5dRHgr5JzFoRDw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E9K56qs4O3RG; Tue, 29 Sep 2026 23:23:16 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hvZ3l3r9Zz1XM4Sx;
	Tue, 29 Sep 2026 23:23:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/7] scsi_debug: Enable lock context analysis
Date: Tue, 29 Sep 2026 16:22:56 -0700
Message-ID: <cover.1790723966.git.bvanassche@acm.org>
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

Thanks,

Bart.

Changes compared to v2:
 - Moved DIX/DIF verification into a helper function (__resp_read_dt0_dix=
())
   to reduce indentation.
 - Removed unnecessary 'else' branches after 'return'.
 - Set the SCSI status code only if do_device_access() fails instead of
   unconditionally setting it to DID_ERROR << 16 beforehand.

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

Bart Van Assche (7):
  scsi: scsi_debug: Fix a locking bug in resp_write_same()
  scsi: scsi_debug: Split resp_write_same()
  scsi: scsi_debug: Split corrupt_lbas()
  scsi: scsi_debug: Split resp_read_dt0()
  scsi: scsi_debug: Split resp_write_dt0()
  scsi: scsi_debug: Improve lock context annotations
  scsi: core: Enable lock context analysis for the scsi_debug driver

 drivers/scsi/Makefile     |   1 +
 drivers/scsi/scsi_debug.c | 412 +++++++++++++++++++++++---------------
 2 files changed, 250 insertions(+), 163 deletions(-)

