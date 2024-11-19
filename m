Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5CE1798C;
	Tue, 19 Nov 2024 00:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976119; cv=none; b=ZWrFegC+ccqZUa9yHDk6rbHw9DSejzsaN9Oz9hRdX9S3HK6UBL9qFrWTzWLo/a9ty5bY2o1/qM9rJv244cX0Ks8SXr+6C4lwYFwiO5+Z9BpzoyYwlIXuaj16l4/1y9/GI8Cmkfmsk00NIcFXlJ47WtG4fzHDTh/vdUrKGDYx6aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976119; c=relaxed/simple;
	bh=9PBVrMmy+HVii3Mtv/2EWPdIBpEnOL6Tu/YS92gMRHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M3MhhluTAnpUABQyDbvrtzhMnuoqY59Mo9YSYKhfBMl8u4g2w1Q2EQCt3zsWu4SNoiRh6rCLjHbFUwd5rPjukV+4/buSMpQ8NOfigOOnpJoZLxUfJiLbGAMXXde278kY+99FW51P7s8R3vDDUNFAJf1sk8DBYyuYsHs2yxcH7Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hLU3Sl6b; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hLU3Sl6b"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xslj13YrtzlgVnN;
	Tue, 19 Nov 2024 00:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1731976109; x=1734568110; bh=IRBX7gOtuMcIH0Zdyxaq+lcNqwqzVlL5HKN
	WcqLrx2I=; b=hLU3Sl6b5B46sSvyyd4Rn1JZ8e4X/D1L24x/FqiCNh4Odkdvp5b
	q+htxzZdgxkKCYkhbhW8vat4PKvglmIw2nW8cteLEvMLrB1Ar/T+QuGhkGbIGjGl
	ECCJcXP9GOgFoPd2kmspS3hokwT9FAcFROm2tgWwP2b4AdV7qby60TGCam1xfIEC
	Hc0d7ivg+5rLw0lEyxTtyQu/d09IfzmE3WWdAAjOx3YIh1mXRm99AzQk5xHf1Gcj
	1gkwKMBb89YNqPOT4LmJRRrRciLx/2RTCf1QFPfuX787ZrEaFEYcbphVtQ5b8izS
	Oh8cgwAPtkrccSa2ocRJojk9LcnB9ErJl4Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PnG-F3kIuNpO; Tue, 19 Nov 2024 00:28:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslhr1ZNbzlgTWQ;
	Tue, 19 Nov 2024 00:28:27 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 00/26] Improve write performance for zoned UFS devices
Date: Mon, 18 Nov 2024 16:27:49 -0800
Message-ID: <20241119002815.600608-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Damien and Christoph,

This patch series improves small write IOPS by a factor of four (+300%) f=
or
zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Althoug=
h
you are probably busy because the merge window is open, please take a loo=
k
at this patch series when you have the time. This patch series is organiz=
ed
as follows:
 - Bug fixes for existing code at the start of the series.
 - The write pipelining support implementation comes after the bug fixes.

Thanks,

Bart.

Changes compared to v15:
 - Reworked this patch series on top of the zone write plugging approach.
 - Moved support for requeuing requests from the SCSI core into the block
   layer core.
 - In the UFS driver, instead of disabling write pipelining if
   auto-hibernation is enabled, rely on the requeuing mechanism to handle
   reordering caused by resuming from auto-hibernation.

Changes compared to v14:
 - Removed the drivers/scsi/Kconfig.kunit and drivers/scsi/Makefile.kunit
   files. Instead, modified drivers/scsi/Kconfig and added #include "*_te=
st.c"
   directives in the appropriate .c files. Removed the EXPORT_SYMBOL()
   directives that were added to make the unit tests link.
 - Fixed a double free in a unit test.

Changes compared to v13:
 - Reworked patch "block: Preserve the order of requeued zoned writes".
 - Addressed a performance concern by removing the eh_needs_prepare_resub=
mit
   SCSI driver callback and by introducing the SCSI host template flag
   .needs_prepare_resubmit instead.
 - Added a patch that adds a 'host' argument to scsi_eh_flush_done_q().
 - Made the code in unit tests less repetitive.

Changes compared to v12:
 - Added two new patches: "block: Preserve the order of requeued zoned wr=
ites"
   and "scsi: sd: Add a unit test for sd_cmp_sector()"
 - Restricted the number of zoned write retries. To my surprise I had to =
add
   "&& scmd->retries <=3D scmd->allowed" in the SCSI error handler to lim=
it the
   number of retries.
 - In patch "scsi: ufs: Inform the block layer about write ordering", onl=
y set
   ELEVATOR_F_ZBD_SEQ_WRITE for zoned block devices.

Changes compared to v11:
 - Fixed a NULL pointer dereference that happened when booting from an AT=
A
   device by adding an scmd->device !=3D NULL check in scsi_needs_prepara=
tion().
 - Updated Reviewed-by tags.

Changes compared to v10:
 - Dropped the UFS MediaTek and HiSilicon patches because these are not c=
orrect
   and because it is safe to drop these patches.
 - Updated Acked-by / Reviewed-by tags.

Changes compared to v9:
 - Introduced an additional scsi_driver callback: .eh_needs_prepare_resub=
mit().
 - Renamed the scsi_debug kernel module parameter 'no_zone_write_lock' in=
to
   'preserves_write_order'.
 - Fixed an out-of-bounds access in the unit scsi_call_prepare_resubmit()=
 unit
   test.
 - Wrapped ufshcd_auto_hibern8_update() calls in UFS host drivers with
   WARN_ON_ONCE() such that a kernel stack appears in case an error code =
is
   returned.
 - Elaborated a comment in the UFSHCI driver.

Changes compared to v8:
 - Fixed handling of 'driver_preserves_write_order' and 'use_zone_write_l=
ock'
   in blk_stack_limits().
 - Added a comment in disk_set_zoned().
 - Modified blk_req_needs_zone_write_lock() such that it returns false if
   q->limits.use_zone_write_lock is false.
 - Modified disk_clear_zone_settings() such that it clears
   q->limits.use_zone_write_lock.
 - Left out one change from the mq-deadline patch that became superfluous=
 due to
   the blk_req_needs_zone_write_lock() change.
 - Modified scsi_call_prepare_resubmit() such that it only calls list_sor=
t() if
   zoned writes have to be resubmitted for which zone write locking is di=
sabled.
 - Added an additional unit test for scsi_call_prepare_resubmit().
 - Modified the sorting code in the sd driver such that only those SCSI c=
ommands
   are sorted for which write locking is disabled.
 - Modified sd_zbc.c such that ELEVATOR_F_ZBD_SEQ_WRITE is only set if th=
e
   write order is not preserved.
 - Included three patches for UFS host drivers that rework code that wrot=
e
   directly to the auto-hibernation controller register.
 - Modified the UFS driver such that enabling auto-hibernation is not all=
owed
   if a zoned logical unit is present and if the controller operates in l=
egacy
   mode.
 - Also in the UFS driver, simplified ufshcd_auto_hibern8_update().

Changes compared to v7:
 - Split the queue_limits member variable `use_zone_write_lock' into two =
member
   variables: `use_zone_write_lock' (set by disk_set_zoned()) and
   `driver_preserves_write_order' (set by the block driver or SCSI LLD). =
This
   should clear up the confusion about the purpose of this variable.
 - Moved the code for sorting SCSI commands by LBA from the SCSI error ha=
ndler
   into the SCSI disk (sd) driver as requested by Christoph.
  =20
Changes compared to v6:
 - Removed QUEUE_FLAG_NO_ZONE_WRITE_LOCK and instead introduced a flag in
   the request queue limits data structure.

Changes compared to v5:
 - Renamed scsi_cmp_lba() into scsi_cmp_sector().
 - Improved several source code comments.

Changes compared to v4:
 - Dropped the patch that introduces the REQ_NO_ZONE_WRITE_LOCK flag.
 - Dropped the null_blk patch and added two scsi_debug patches instead.
 - Dropped the f2fs patch.
 - Split the patch for the UFS driver into two patches.
 - Modified several patch descriptions and source code comments.
 - Renamed dd_use_write_locking() into dd_use_zone_write_locking().
 - Moved the list_sort() call from scsi_unjam_host() into scsi_eh_flush_d=
one_q()
   such that sorting happens just before reinserting.
 - Removed the scsi_cmd_retry_allowed() call from scsi_check_sense() to m=
ake
   sure that the retry counter is adjusted once per retry instead of twic=
e.

Changes compared to v3:
 - Restored the patch that introduces QUEUE_FLAG_NO_ZONE_WRITE_LOCK. That=
 patch
   had accidentally been left out from v2.
 - In patch "block: Introduce the flag REQ_NO_ZONE_WRITE_LOCK", improved =
the
   patch description and added the function blk_no_zone_write_lock().
 - In patch "block/mq-deadline: Only use zone locking if necessary", move=
d the
   blk_queue_is_zoned() call into dd_use_write_locking().
 - In patch "fs/f2fs: Disable zone write locking", set REQ_NO_ZONE_WRITE_=
LOCK
   from inside __bio_alloc() instead of in f2fs_submit_write_bio().

Changes compared to v2:
 - Renamed the request queue flag for disabling zone write locking.
 - Introduced a new request flag for disabling zone write locking.
 - Modified the mq-deadline scheduler such that zone write locking is onl=
y
   disabled if both flags are set.
 - Added an F2FS patch that sets the request flag for disabling zone writ=
e
   locking.
 - Only disable zone write locking in the UFS driver if auto-hibernation =
is
   disabled.

Changes compared to v1:
 - Left out the patches that are already upstream.
 - Switched the approach in patch "scsi: Retry unaligned zoned writes" fr=
om
   retrying immediately to sending unaligned write commands to the SCSI e=
rror
   handler.

Bart Van Assche (26):
  blk-zoned: Fix a reference count leak
  blk-zoned: Split disk_zone_wplugs_work()
  blk-zoned: Split queue_zone_wplugs_show()
  blk-zoned: Only handle errors after pending zoned writes have
    completed
  blk-zoned: Fix a deadlock triggered by unaligned writes
  blk-zoned: Fix requeuing of zoned writes
  block: Support block drivers that preserve the order of write requests
  dm-linear: Report to the block layer that the write order is preserved
  mq-deadline: Remove a local variable
  blk-mq: Clean up blk_mq_requeue_work()
  block: Optimize blk_mq_submit_bio() for the cache hit scenario
  block: Rework request allocation in blk_mq_submit_bio()
  block: Support allocating from a specific software queue
  blk-mq: Restore the zoned write order when requeuing
  blk-zoned: Document the locking order
  blk-zoned: Document locking assumptions
  blk-zoned: Uninline functions that are not in the hot path
  blk-zoned: Make disk_should_remove_zone_wplug() more robust
  blk-zoned: Add an argument to blk_zone_plug_bio()
  blk-zoned: Support pipelining of zoned writes
  scsi: core: Retry unaligned zoned writes
  scsi: sd: Increase retry count for zoned writes
  scsi: scsi_debug: Add the preserves_write_order module parameter
  scsi: scsi_debug: Support injecting unaligned write errors
  scsi: scsi_debug: Skip host/bus reset settle delay
  scsi: ufs: Inform the block layer about write ordering

 block/bfq-iosched.c       |   2 +
 block/blk-mq.c            |  97 ++++++----
 block/blk-mq.h            |   3 +
 block/blk-settings.c      |   2 +
 block/blk-zoned.c         | 376 +++++++++++++++++++++++++-------------
 block/blk.h               |  33 +++-
 block/kyber-iosched.c     |   2 +
 block/mq-deadline.c       |  10 +-
 drivers/md/dm-linear.c    |   6 +
 drivers/md/dm.c           |   2 +-
 drivers/scsi/scsi_debug.c |  22 ++-
 drivers/scsi/scsi_error.c |  16 ++
 drivers/scsi/sd.c         |   7 +
 drivers/ufs/core/ufshcd.c |   7 +
 include/linux/blk-mq.h    |  20 +-
 include/linux/blkdev.h    |  11 +-
 16 files changed, 444 insertions(+), 172 deletions(-)

