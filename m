Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B8332BC13
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746130; cv=none; b=PlRAva4wMr51jse03rHLXMg9d17nCqGysahO4NFqcPp+1lVTpY1KKoy8MD1eK0O5yPzM9WnOgtrv6FO8R/CDiK60zU27Mc/yBaDmq5RMgSMLO76X9r2zOzxLhLbQruOxCpYhKv4fwURTzAu5RgKotLjp2r14W1dUcizlLeQ68Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746130; c=relaxed/simple;
	bh=GgC6hhz4u1ogmWlpztjCiCFwCy1XUmmOBAOgGdv60ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=geTQT3HcqtDJ+E9o3FdZkl4h/4LBTxwlhC9EutNeBacfUT3C+6ETNUGSkuMpBySZL/d6cA5bxwLrbCR9Rk+sEgjFhkC6Bvo6Pi0YAWp0WMDux361ByImNbpdFYAGwEwRziz/VVtcLI8C9mufLigwQqru2kmkqg2zrqssdsTAQWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=McP6Zu/R; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="McP6Zu/R"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7mt3p1Dzlgqyd;
	Wed, 24 Sep 2025 20:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1758745917; x=1761337918; bh=81Jt/MaAq/q1B5LhG7LIgjzGTZLeRPqcbOc
	3cLZYLRo=; b=McP6Zu/RgotHofkePsWEpQPbvbLXitQJTS3J8W7eOqYqIvmkGmh
	tmx7k94Oaf4G7xS711boZ+CZiSeS2GYnpIgnbCcxK4E84Pz0cZNQC5UA+rv1nVkh
	/DWcERpiJwvK0mdu73Cw4tAe6ju6EEmxPy/uvjjaaPKBreNG+X9DO7jX68QY/tRM
	HtoRoFhKCBF7hw6JO8gtuRDvtcRaMGeKvHM5tRh4n48d/23x9aJvAtZ3m4yCnaUg
	yKnu5TFeBvnes4MtoMGuPAHwLJYLHhEdzP6cCA6Zkb0qnwWfRtdcFqz4uM8xN8ux
	1xL66fk9Dcl0vAjSkXK70dQ7EE2A48WNeVw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ath_ojxysEU1; Wed, 24 Sep 2025 20:31:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7mq674zzlgqxw;
	Wed, 24 Sep 2025 20:31:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 00/28] Optimize the hot path in the UFS driver
Date: Wed, 24 Sep 2025 13:30:19 -0700
Message-ID: <20250924203142.4073403-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series optimizes the hot path of the UFS driver by making
struct scsi_cmnd and struct ufshcd_lrb adjacent. Making these two data
structures adjacent is realized as follows:

@@ -9040,6 +9046,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
     .name           =3D UFSHCD,
     .proc_name      =3D UFSHCD,
     .map_queues     =3D ufshcd_map_queues,
+    .cmd_size       =3D sizeof(struct ufshcd_lrb),
     .init_cmd_priv  =3D ufshcd_init_cmd_priv,
     .queuecommand   =3D ufshcd_queuecommand,
     .mq_poll        =3D ufshcd_poll,

The following changes had to be made prior to making these two data
structures adjacent:
* Add support for driver-internal and reserved commands in the SCSI core.
* Instead of making the reserved command slot (hba->reserved_slot)
  invisible to the SCSI core, let the SCSI core allocate a reserved comma=
nd.
* Remove all UFS data structure members that are no longer needed
  because struct scsi_cmnd and struct ufshcd_lrb are now adjacent
* Call ufshcd_init_lrb() from inside ufshcd_queuecommand() instead of
  calling this function before I/O starts. This is necessary because
  ufshcd_memory_alloc() allocates fewer instances than the block layer
  allocates requests. See also the following code in the block layer
  core:

    if (blk_mq_init_request(set, hctx->fq->flush_rq, hctx_idx,
                hctx->numa_node))

  Although the UFS driver could be modified such that ufshcd_init_lrb()
  is called from ufshcd_init_cmd_priv(), realizing this would require
  moving the memory allocations that happen from inside
  ufshcd_memory_alloc() into ufshcd_init_cmd_priv(). That would make
  this patch series even larger. Although ufshcd_init_lrb() is called for=
 each
  command, the benefits of reduced indirection and better cache efficienc=
y
  outweigh the small overhead of per-command lrb initialization.
* ufshcd_add_scsi_host() happens now before any device management
  commands are submitted. This change is necessary because this patch
  makes device management command allocation happen when the SCSI host
  is allocated.
* Allocate as many command slots as the host controller supports. Decreas=
e
  host->cmds_per_lun if necessary once it is clear whether or not the UFS
  device supports less command slots than the host controller.

Changes compared to v4:
 - Dropped the scsi_execute_cmd() changes.
 - Restored patch "scsi: core: Add scsi_{get,put}_internal_cmd() helpers"=
.
 - Switched back from scsi_execute_cmd() to blk_execute_rq() for submitti=
ng
   device management commands in the UFS driver.
 - As suggested by John Garry, modified the scsi_debug patch such that ab=
orting
   a SCSI command happens by submitting a reserved command.

Changes compared to v3:
 - Fixed a spelling error in patch 1 and left out a superfluous if-statem=
ent.
 - Left out scsi_host_template.alloc_pseudo_sdev and allocate a pseudo SC=
SI
   device if either nr_reserved_cmds > 0 or .queue_reserved_commands has =
been
   set.
 - Left out the 'pseudo_sdev' local variable from scsi_forget_host().
 - Removed a backwards jump from scsi_get_pseudo_dev().
 - Included a bug fix for synchronous scanning.
 - Skip scsi_track_queue_full() and scsi_handle_queue_ramp_up() for pseud=
o SCSI
   devices.
 - Extended the scsi_execute_rq() functionality.
 - Use scsi_execute_rq() for submitting reserved commands instead of
   blk_execute_rq().
 - Dropped the patch that introduces scsi_get_internal_cmd() and
   scsi_put_internal_cmd().

Changes compared to v2:
 - Removed scsi_host_update_can_queue() and also the UFS driver refactori=
ng
   patches that were introduced to support this call.
 - Added .queue_reserved_command(). Added ufshcd_queue_reserved_command()=
.
 - Removed a BUG_ON() statement from ufshcd_get_dev_mgmt_cmd().
 - Modified and renamed ufshcd_mcq_decide_queue_depth().

Changes compared to v1:
 - Left out the kernel patches related to support for const SCSI command
   arguments.
 - Added SCSI core patches for allocating a pseudo SCSI device and reserv=
ed
   command support.
 - Added several kernel patches to switch the UFS driver from a hardcoded
   reserved slot to calling scsi_get_internal_cmd().
 - Enable .alloc_pseudo_sdev in the scsi_debug driver.

Bart Van Assche (24):
  scsi: core: Move two statements
  scsi: core: Make the budget map optional
  scsi_debug: Abort SCSI commands via .queue_reserved_command()
  ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
  ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
  ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
  ufs: core: Change the type of one ufshcd_add_command_trace() argument
  ufs: core: Change the type of one ufshcd_send_command() argument
  ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
  ufs: core: Change the monitor function argument types
  ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
  ufs: core: Rework ufshcd_eh_device_reset_handler()
  ufs: core: Rework the SCSI host queue depth calculation code
  ufs: core: Allocate the SCSI host earlier
  ufs: core: Call ufshcd_init_lrb() later
  ufs: core: Use hba->reserved_slot
  ufs: core: Make the reserved slot a reserved request
  ufs: core: Do not clear driver-private command data
  ufs: core: Optimize the hot path
  ufs: core: Pass a SCSI pointer instead of an LRB pointer
  ufs: core: Remove the ufshcd_lrb task_tag member
  ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
  ufs: core: Move code out of ufshcd_wait_for_dev_cmd()
  ufs: core: Switch to scsi_get_internal_cmd()

Hannes Reinecke (3):
  scsi: core: Support allocating reserved commands
  scsi: core: Support allocating a pseudo SCSI device
  scsi: core: Add scsi_{get,put}_internal_cmd() helpers

John Garry (1):
  scsi: core: Introduce .queue_reserved_command()

 drivers/scsi/hosts.c             |  15 +
 drivers/scsi/scsi.c              |  12 +-
 drivers/scsi/scsi_debug.c        | 106 +++-
 drivers/scsi/scsi_error.c        |   3 +
 drivers/scsi/scsi_lib.c          | 145 +++++-
 drivers/scsi/scsi_priv.h         |   2 +
 drivers/scsi/scsi_scan.c         |  77 ++-
 drivers/scsi/scsi_sysfs.c        |   5 +-
 drivers/ufs/core/ufs-mcq.c       |  51 +-
 drivers/ufs/core/ufshcd-crypto.h |  18 +-
 drivers/ufs/core/ufshcd-priv.h   |  20 +-
 drivers/ufs/core/ufshcd.c        | 808 ++++++++++++++++---------------
 include/scsi/scsi_device.h       |  23 +
 include/scsi/scsi_host.h         |  33 +-
 include/ufs/ufshcd.h             |  12 -
 15 files changed, 861 insertions(+), 469 deletions(-)

