Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6C324B25
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701494; cv=none; b=rOzsDctfy70PPpRBjyTgjjhf0AHLc/BbsnXaOqbzfi3yyYrXYLDUXgOoRwj9APaTzHgplrJX5fLpF/kbzZJwjdNVKooKGq6deuDX0MEuco0XicJeCv9TTL9MuFSPTM8rJTcB+/2LxSoj3aIa80ubZlfZ8K+p1q23mM+jnf5YQeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701494; c=relaxed/simple;
	bh=qKcxzKDrXjZLI+XUGYRHAVNoUm/q2jDLWw89+JfQRUE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SVYP3ycR1jaFenPo6AmJiFxcN0dir/0A/wr2pWkM1awwE5aSOii+WYCEEPUCQwUwRYP+Cd+sCzE1cdpKAQIld916fmIvM++NXeTnNG9R9cPaosLQzbc5x6bdgw9lV1cU1BG3sznmG/TjT3W4KltGfeiFwfRg6UFQVvCAMP+BaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qMED1Jtu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qMED1Jtu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjWd03fvzlgqyC;
	Fri, 12 Sep 2025 18:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1757701483; x=1760293484; bh=Y+cAe6yaltFesIL+Su7bX8PPwifHo+30sjk
	cUQk1BC4=; b=qMED1JtuO0WJdRV8oNhcJDDU5TV1tbGOiC44Q4Zc0DS+6b5Af+8
	DG8tivELSoEcY8s7SEfyZ2kSrhOoUZlIezABGWlKHPsVVvc2RqqhX2V9M2W/DmO0
	mOci84EYysNOAXCmeNLDEuSaAXSlsNU4An5L/I+AaoxRZWsw2s1TM9pVhP0oSG3n
	sqqDwfw4w3L2AFQyK866nlH59l0MV0wUMD7+Z73dUQUrzGDIpTGiZJqEo2kUQzLg
	6PyCjoAmlmW8syqBf+lShK7KUQhcpjNq5x1agClf4dycojw98jIIniivwG7+YR9S
	6noM/VVyaUwA0ZSUETwDTT0Kw1rygkMPIpQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zm3p44S1k_9r; Fri, 12 Sep 2025 18:24:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjWZ2hrxzltPsj;
	Fri, 12 Sep 2025 18:24:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/29] Optimize the hot path in the UFS driver
Date: Fri, 12 Sep 2025 11:21:21 -0700
Message-ID: <20250912182340.3487688-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
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
     .name            =3D UFSHCD,
     .proc_name        =3D UFSHCD,
     .map_queues        =3D ufshcd_map_queues,
+    .cmd_size        =3D sizeof(struct ufshcd_lrb),
     .init_cmd_priv        =3D ufshcd_init_cmd_priv,
     .queuecommand        =3D ufshcd_queuecommand,
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

Bart Van Assche (26):
  scsi: core: Move two statements
  scsi: core: Make the budget map optional
  scsi: core: Extend the scsi_execute_cmd() functionality
  scsi_debug: Allocate a pseudo SCSI device
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
  ufs: core: Rework the ufshcd_issue_dev_cmd() callers
  ufs: core: Switch to scsi_execute_cmd()

Hannes Reinecke (2):
  scsi: core: Support allocating reserved commands
  scsi: core: Support allocating a pseudo SCSI device

John Garry (1):
  scsi: core: Introduce .queue_reserved_command()

 drivers/scsi/hosts.c             |   15 +
 drivers/scsi/scsi.c              |   11 +-
 drivers/scsi/scsi_debug.c        |   14 +
 drivers/scsi/scsi_error.c        |    3 +
 drivers/scsi/scsi_lib.c          |   99 ++-
 drivers/scsi/scsi_priv.h         |    2 +
 drivers/scsi/scsi_scan.c         |   76 ++-
 drivers/scsi/scsi_sysfs.c        |    5 +-
 drivers/ufs/core/ufs-mcq.c       |   51 +-
 drivers/ufs/core/ufshcd-crypto.h |   18 +-
 drivers/ufs/core/ufshcd-priv.h   |   20 +-
 drivers/ufs/core/ufshcd.c        | 1045 +++++++++++++++++-------------
 include/scsi/scsi_cmnd.h         |    2 +
 include/scsi/scsi_device.h       |   53 +-
 include/scsi/scsi_host.h         |   33 +-
 include/ufs/ufshcd.h             |   12 -
 16 files changed, 902 insertions(+), 557 deletions(-)

