Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF8536B909
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349670; cv=none; b=lgrmKnuMXm2n5ufSXZFt2AUqIzDfE6dUKvabqrCwkr/MySaC40WUtw/BbmcweKBuvmpwMVaXr9z+hA/aYPcSGVi5MlZZL+NMW9Db4r1G1XycpVfhrlW+akUiOEd8JiWv2qMxvfE7KmfNAWZebgGoMjM02fckYGY7U+YsoNlX2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349670; c=relaxed/simple;
	bh=NSVVw442doY8DFVllBxY+r2B9imVqDQGCu18dO7gR+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Za7EzPXllfJKsPDWkyYTMharwrN/WqcXqWbllHe7vz9qti8XN7mN0yoQeShucKuUNmo2e7m/kPNgGW262P0Q+CisOIwKsl0OepxXsi0mfy1PamgCU7xM7w2QBfD8K3NsJgpf8+CiNXKF3RJl1EHbsZNAw91unW6bp0KRqBtuX30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=H2NmMTm4; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="H2NmMTm4"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j01N46zd1zlfl5T;
	Wed,  7 Oct 2026 05:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1791349665; x=1793941666; bh=GvbiFgtFYsuJnBs3AODdaQUq9SoBZejZOBE
	Z+dcOGLA=; b=H2NmMTm4APC72D3fedC8lH9wu2RxR4K71CivSK9AZE2I7dJKzYj
	adI0lxEedGWWEnzmDsRDb3lALzXW6ZrOqPpT+eyY3skvznBWw5p3E85cZbr5e0RG
	2myvj1CPLoo6DH0KfDuT7ZJBpKqF3szLW4MjDlCnRgeT9sAqB9hCfo1u0/RQMBdw
	V9xzdYyzLRV8l87Qe9nHZ4O2FgbD8Pijm8lZRMRznQZKkA8G/r0+EBCyunXWjzWI
	3U20zphrfzJFELteas62SQ42rPSXBJRLD+3H8IajUKXKenQiURRyWctjZXI7gU8H
	K2r4ObWB7ue2yAKBkVZDKYrAvG5nhAGNAGg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CrGQUDRGwkUD; Wed,  7 Oct 2026 05:07:45 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j01N02JZNzlfvpH;
	Wed,  7 Oct 2026 05:07:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/8] scsi_debug: Enable lock context analysis
Date: Tue,  6 Oct 2026 22:07:22 -0700
Message-ID: <cover.1791349129.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series enables compiler-based lock context analysis for the
scsi_debug driver. Conditional locking is eliminated across command respo=
nse
and error injection functions so that static analysis can verify lock
acquisitions and releases. Internal locking helper functions are annotate=
d
with __acquires(),__releases(), __acquires_shared() and __releases_shared=
()
attributes. An error-path lock leak in resp_write_same() is fixed. Finall=
y,
lock context analysis is enabled in drivers/scsi/Makefile.

Changes compared to v3:
- Add a new patch to split resp_atomic_write() and eliminate conditional
  locking in atomic write handling.
- Pass the LBP state boolean down into __resp_write_same(),
  __corrupt_lbas(), and __resp_write_dt0() to avoid repeated calls to
  scsi_debug_lbp().
- Drop unused function arguments from __resp_read_dt0_dix() and
  __resp_write_dt0_dix().
- Correct the return value descriptions in the header comments of
  __resp_read_dt0_dix() and __resp_write_dt0_dix().

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

Bart Van Assche (8):
  scsi: scsi_debug: Fix a locking bug in resp_write_same()
  scsi: scsi_debug: Split resp_write_same()
  scsi: scsi_debug: Split corrupt_lbas()
  scsi: scsi_debug: Split resp_read_dt0()
  scsi: scsi_debug: Split resp_write_dt0()
  scsi: scsi_debug: Split resp_atomic_write()
  scsi: scsi_debug: Improve lock context annotations
  scsi: core: Enable lock context analysis for the scsi_debug driver

 drivers/scsi/Makefile     |   1 +
 drivers/scsi/scsi_debug.c | 418 +++++++++++++++++++++++---------------
 2 files changed, 254 insertions(+), 165 deletions(-)

