Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B09C33122A
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499363; cv=none; b=CX9V35vsTx/u5fKMXZD94smyfIlpNa8iBCw0QJTtAKG3V51IVQOk68R8bCTxAG79U9IeDEhRrThsRsEOSI0B8KZK/6nzUT818zksKZplSb6+F276koO7h7pnhpsBP2vg5qQwyWQUrV4FsBpkv2j3yXd+StSMp9Wr4GcB2BlfUms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499363; c=relaxed/simple;
	bh=vs/Ge2/aUWR+Qcr2+DXoOybmqoewYAMR1qjTUccL9Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AWTFel/2yar7RLpD1nL4ziO+/O05CukgalDFpqDmX8DRtahFQwKyN1dndQPF8EKP6csdLicMan/gimOnEw3O9T6tnVxi/gOe/b4ZgDg2eW4b3Byjsc7bCbqUR3/EkEPP5wLiryAGbQzAXSU35a9LMJf7IqSOLSNIxatHLgAqi2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CmZF2blN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CmZF2blN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14kh018Tz1XM30k;
	Thu,  8 Oct 2026 22:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1791499351; x=1794091352; bh=4ilLAK1ha7QVYNc2DfZ6211yGfcD+jvoqL2
	U57Fpebw=; b=CmZF2blNtmFFLAyksU1PdgaeWt/a32LtRf5XvOFfAibSTVWqADO
	pQenMC3T6fHMf+pSJKhbb4QSW5qxiBHA05sohj6kCxxvzvKSbj1/zNvfT1uFZbOG
	e3oqRZAv/tMDe6ss+LJbNnE4kMSPu3V0DvXdNfGy6B9t0g6FmoLZSRQyXWAAsBjY
	iEBL/hOgNaZaGR9TKiabAfAolsGauPCspWAX17Gc3CrhOmCVTAmTVh6dDoLOTdTT
	Vcgp2zNinfGE1sPbtm9Vz45Nr7uudCEXofD9NFayJZRztGTJHSRH7ctlci0LhF/U
	Cvol3TLVRJiQydzaJCvJKnjVsUyMwLSoOdw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dV-PAPBzZBkm; Thu,  8 Oct 2026 22:42:31 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14kY6CqJz1XM5kD;
	Thu,  8 Oct 2026 22:42:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/8] scsi_debug: Enable lock context analysis
Date: Thu,  8 Oct 2026 15:42:11 -0700
Message-ID: <cover.1791499174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.170.g584c36229d-goog
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

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v4:
- Add a Reviewed-by tag from Christoph Hellwig to patch 6/8.
- Drop __context_unsafe() from sdeb_read_lock(), sdeb_read_unlock(),
  sdeb_write_lock(), and sdeb_write_unlock() in patch 7/8. Preserve the
  original if (sdebug_no_rwlock) conditional structure and annotate with
  __acquire_shared(), __release_shared(), __acquire(), and __release().
- Drop __context_unsafe() from sdeb_data_lock(), sdeb_data_unlock(),
  sdeb_data_sector_lock(), and sdeb_data_sector_unlock() in patch 7/8,
  and add explicit context capability transitions on the read paths.
- Retain __context_unsafe() exclusively for
  sdeb_meta_{read,write}_{,un}lock() to prevent undefined pointer
  arithmetic when sip is NULL under fake_rw.
- Update the commit description of patch 7/8 to reflect these changes.

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
- Move DIX/DIF verification into a helper function (__resp_read_dt0_dix()=
)
  to reduce indentation.
- Remove unnecessary "else" branches after "return".
- Set the SCSI status code only if do_device_access() fails instead of
  unconditionally setting it to DID_ERROR << 16 beforehand.

Changes compared to v1:
- Fix an issue where the error code was clobbered in resp_write_same() an=
d
  __resp_write_same() when fetch_to_dev_buffer() fails (John Garry and
  sashiko-bot).
- Fix return value handling in resp_read_dt0() and resp_write_dt0():
  previously a positive byte count returned by do_device_access() was
  incorrectly treated as a SCSI status code and returned to the caller.
  Now, pass the SCSI status via an output pointer and only trigger an err=
or
  return on negative return values (sashiko-bot).
- Improve lock context annotations:
  * Annotate existing rwlock_t members (&sip->macc_data_lck,
    &sip->macc_sector_lck, &sip->macc_meta_lck) directly with __acquires =
/
    __releases instead of defining and embedding dummy context lock struc=
ts
    in struct sdeb_store_info.
  * Drop the unwarranted __context_unsafe() annotation from
    sdeb_data_read_lock().
  * Update the commit descriptions to match the code changes.

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
 drivers/scsi/scsi_debug.c | 426 +++++++++++++++++++++++---------------
 2 files changed, 264 insertions(+), 163 deletions(-)

