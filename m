Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3743413230
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929429; cv=none; b=Znb16o5JojPtVaEGCmAgpE/yOu9pQZo9A0ze+HybxDWG0FkCBpP37zj8ezBOwC7+2nnqkG3YfkykedHwYwAbgvCu1XtvJSq1bbrFIWrXKLJjYMftbdykipdRGvyAv2KUnA13MacpaancctQa1rgN12lLi9ipUSBoXuxs+A6bh7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929429; c=relaxed/simple;
	bh=BR2MpvcLn+aVbb3L/UA7zWN1zIrAjLcGkzOjZRkTY5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qEPs78l96JoBqpaMRs4lKVc5rUSdFl/K+3nCdxjuGPIBfGiOdiCgxtuXkmD6Rk9TxM7bf2qB6eZ684qVST3az7e4Iag7y5+6T6Nt8JXm090c6Okwc+OZz875Co4O8PDlaOdXS2R1Pk4SqcpDl3IPyuLehYiklmcfyxEtWXlGEfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RCFKzxvV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RCFKzxvV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j47nH31L1zlfvq8;
	Tue, 13 Oct 2026 22:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1791929423; x=1794521424; bh=Ze+FT8koROO972ED4sILyTav3KxZAD7rosw
	6j0VOvYY=; b=RCFKzxvV/t5sYCChD3RTDxaSDpK8++NHQnmeo35BUZi3KPTQogD
	kkVNcipH8qGhWhpQDdjqO1H/u1hPqWgdB9LeI4KTJVDLP1ZKHcfRm79AaHVNXTBr
	9bKzF9zWi4hApyI1FSODzCVe0g7g0a+xrr7uSFnEbnVl367QQj0noc3kCsVNw3Yf
	orAdHkuHPNkB+OAbFqFrygSshi5sqwUA1SKv1loBSohqiqVdlJJTKpuqfbH9yhwl
	0EYCrpv93bilsPHBsWcHZZizHxUxjtBFHs9lhHsC/JKLuRNoB3KmgIVgPuu6m8tg
	kcFx3nvRSVhPw/jsMp/Hpy5sXZikpFHcQqg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HHx22XJVFct5; Tue, 13 Oct 2026 22:10:23 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j47nB5ZGKzlfvpH;
	Tue, 13 Oct 2026 22:10:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/8] [PATCH v6 0/8] scsi_debug: Enable lock context analysis
Date: Tue, 13 Oct 2026 15:10:01 -0700
Message-ID: <cover.1791924924.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
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

Changes compared to v5:
- Dropped a redundant zero-initialization of variable 'error' in corrupt_=
lbas()
  (patch 3/8).
- Changed 'ret =3D=3D -1' checks to 'ret < 0' in resp_read_dt0() and
  resp_atomic_write() (John Garry; patches 4/8 and 6/8).
- Add Reviewed-by tags from Christoph Hellwig and John Garry to
  resp_read_dt0() (patch 4/8).
- In sdeb_meta_{read,write}_{,un}lock(), replace the inline comment
  '/*conditional locking*/' in __context_unsafe() with a comment explaini=
ng
  that these functions cannot be annotated with __acquire() or __release(=
)
  without triggering undefined behavior (Christoph Hellwig; patch 7/8).

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
 drivers/scsi/scsi_debug.c | 454 ++++++++++++++++++++++++--------------
 2 files changed, 286 insertions(+), 169 deletions(-)

