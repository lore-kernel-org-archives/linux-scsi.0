Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E451E21CFE0;
	Wed, 27 Aug 2025 21:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330216; cv=none; b=sgy14om7sHWxwCmaDeBuogZyz90l8MJrhUh2yBO76rJMPUeyMLK9tyOrMDy3D3rjW7JZZ5VcqI9ddlb7lI1DwYnVWx/zxaZfIMvGXrfp2eXUzsZsSktQDwXVQ/h/JtFetdXcjEcbwbyv6vXazGRhLXA4bjT89qxlaKU38qVmjEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330216; c=relaxed/simple;
	bh=op+Yzpd62PO9NMW4TpMKZ9mQV9YMPIHVMTnYCCr/gpY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KE+GvTfl7W9gs6qmRU7TMrFrDBGI7OCilAK9W/YmrnGY5hV+NcBYVio6DVgMbYIQleRFTf/GAdftZUUht4f+CiV/jm6m+QLFs0gLyE5yOPBon0RCJjy9v18kydHcSlGMaaCrPqNhT5b3+5qRF5VM82VYuo7QjNqwhPFSlBdI0NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0IJzZgEo; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0IJzZgEo"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByNt3FBJzm0yMF;
	Wed, 27 Aug 2025 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1756330204; x=1758922205; bh=Ipn+s26c1F3x8dpk2z/DKpkMCR/GsRIE0v0
	HJGesofA=; b=0IJzZgEo0P2aZwhIoMRED757HBP6/7/IJo18az6qNSx3XntMg1x
	Yu1CHuGinHL2aV6BONWWCYCQRDdOIUqS8uGRbE0XWc+IybCCumUZqVB7l2s8/yPG
	vqsFFVWz+SEiVvTiyA4NRQDayeqe1oR5a/TzjfFn2kcNZXDa1ulnaY3LefkIIEnc
	7uWV/ldaFSd6pGXJidW3T+Hhm34sZ/r9ALLrescGTdloT6hz90Q5nnnvpoan6C1H
	T0H5dAAv/wa2FZAXLhsqUbYNR1fipOO/JhSvQ2E3ceZcrGo9oX9FaJAG+77zC6nJ
	LYdyQ5UAWZRqxQbVZAR36hpYpXNhpNXgG7w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FW068sWqrLs9; Wed, 27 Aug 2025 21:30:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByNl5dcPzm174B;
	Wed, 27 Aug 2025 21:29:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 00/18] Improve write performance for zoned UFS devices
Date: Wed, 27 Aug 2025 14:29:19 -0700
Message-ID: <20250827212937.2759348-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Jens,

This patch series improves small write IOPS by a factor of two for zoned =
UFS
devices on my test setup. The changes included in this patch series are a=
s
follows:
 - A new request queue limits flag is introduced that allows block driver=
s to
   declare whether or not the request order is preserved per hardware que=
ue.
 - The order of zoned writes is preserved in the block layer by submittin=
g all
   zoned writes from the same CPU core as long as any zoned writes are pe=
nding.
 - A new member 'from_cpu' is introduced in the per-zone data structure
   'blk_zone_wplug' to track from which CPU to submit zoned writes. This =
data
   member is reset to -1 after all pending zoned writes for a zone have
   completed.
 - The retry count for zoned writes is increased in the SCSI core to deal=
 with
   reordering caused by unit attention conditions or the SCSI error handl=
er.
 - New functionality is added in the null_blk and scsi_debug drivers to m=
ake it
   easier to test the changes introduced by this patch series.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v23:
 - Removed the sysfs attribute for configuring write pipelining.
 - Split patch "Run all hwqs for sq scheds if write pipelining is enabled=
" into
   two patches to make it easier to review.
 - Added patch "blk-zoned: Document disk_zone_wplug_schedule_bio_work() l=
ocking".
 - Rebased on top of Jens' for-next branch.

Changes compared to v22:
 - Made write pipelining configurable via sysfs.
 - Fixed sporadic write errors observed with the mq-deadline I/O schedule=
r.

Changes compared to v21:
 - Added a patch that makes the block layer preserve the request order wh=
en
   inserting a request.
 - Restored a warning statement in block/blk-zoned.c.
 - Reworked the code that selects a CPU to queue zoned writes from such t=
hat no
   changes have to be undone if blk_zone_wplug_prepare_bio() fails.
 - Removed the "plug" label in block/blk-zoned.c and retained the
   "add_to_bio_list" label.
 - Changed scoped_guard() back into spin_lock_*() calls.
 - Fixed a recently introduced reference count leak in
   disk_zone_wplug_schedule_bio_work().
 - Restored the patch for the null_blk driver.

Changes compared to v20:
 - Converted a struct queue_limits member variable into a queue_limits fe=
ature
   flag.
 - Optimized performance of blk_mq_requeue_work().
 - Instead of splitting blk_zone_wplug_bio_work(), introduce a loop in th=
at
   function.
 - Reworked patch "blk-zoned: Support pipelining of zoned writes".
 - Dropped the null_blk driver patch.
 - Improved several patch descriptions.

Changes compared to v19:
 - Dropped patch 2/11 "block: Support allocating from a specific software=
 queue"
 - Implemented Damien's proposal to always add pipelined bios to the plug=
 list
   and to submit all pipelined bios from the bio work for a zone.
 - Added three refactoring patches to make this patch series easier to re=
view.

Changes compared to v18:
 - Dropped patch 2/12 "block: Rework request allocation in blk_mq_submit_=
bio()".
 - Improved patch descriptions.

Changes compared to v17:
 - Rebased the patch series on top of kernel v6.16-rc1.
 - Dropped support for UFSHCI 3.0 controllers because the UFSHCI 3.0 auto=
-
   hibernation mechanism causes request reordering. UFSHCI 4.0 controller=
s
   remain supported.
 - Removed the error handling and write pointer tracking mechanisms again
   from block/blk-zoned.c.
 - Dropped the dm-linear patch from this patch series since I'm not aware=
 of
   any use cases for write pipelining and dm-linear.

Changes compared to v16:
 - Rebased the entire patch series on top of Jens' for-next branch. Compa=
red
   to when v16 of this series was posted, the BLK_ZONE_WPLUG_NEED_WP_UPDA=
TE
   flag has been introduced and support for REQ_NOWAIT has been fixed.
 - The behavior for SMR disks is preserved: if .driver_preserves_write_or=
der
   has not been set, BLK_ZONE_WPLUG_NEED_WP_UPDATE is still set if a writ=
e
   error has been encountered. If .driver_preserves_write_order has not b=
een
   set, the write pointer is restored and the failed zoned writes are ret=
ried.
 - The superfluous "disk->zone_wplugs_hash_bits !=3D 0" tests have been r=
emoved.

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
   retrying immediately to sending unaligne

Bart Van Assche (18):
  block: Support block devices that preserve the order of write requests
  blk-mq: Always insert sequential zoned writes into a software queue
  blk-mq: Restore the zone write order when requeuing
  blk-mq: Move the blk_queue_sq_sched() calls
  blk-mq: Run all hwqs for sq scheds if write pipelining is enabled
  block/mq-deadline: Enable zoned write pipelining
  blk-zoned: Add an argument to blk_zone_plug_bio()
  blk-zoned: Split an if-statement
  blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
  blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
  blk-zoned: Document disk_zone_wplug_schedule_bio_work() locking
  blk-zoned: Support pipelining of zoned writes
  null_blk: Add the preserves_write_order attribute
  scsi: core: Retry unaligned zoned writes
  scsi: sd: Increase retry count for zoned writes
  scsi: scsi_debug: Add the preserves_write_order module parameter
  scsi: scsi_debug: Support injecting unaligned write errors
  ufs: core: Inform the block layer about write ordering

 block/bfq-iosched.c               |   2 +
 block/blk-mq.c                    |  88 +++++++++---
 block/blk-mq.h                    |   2 +
 block/blk-settings.c              |   2 +
 block/blk-zoned.c                 | 220 ++++++++++++++++++++----------
 block/elevator.h                  |   1 +
 block/kyber-iosched.c             |   2 +
 block/mq-deadline.c               | 107 +++++++++++----
 drivers/block/null_blk/main.c     |   4 +
 drivers/block/null_blk/null_blk.h |   1 +
 drivers/md/dm.c                   |   5 +-
 drivers/scsi/scsi_debug.c         |  22 ++-
 drivers/scsi/scsi_error.c         |  16 +++
 drivers/scsi/sd.c                 |   6 +
 drivers/ufs/core/ufshcd.c         |   7 +
 include/linux/blk-mq.h            |  13 +-
 include/linux/blkdev.h            |  18 ++-
 17 files changed, 392 insertions(+), 124 deletions(-)

