Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8F2305E2D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473094; cv=none; b=IHIzjXcEJxgkEmY/zMDhauChyUPnqcwcMzyIXOX/fzun3rvBvGWOeFujjLDYWsprIa6kqlC1JwXBfeBiXEyfT+e/xrGmTp5BLUroxusfIk9dtUAOABi7GUBIAEempEAqlVqB2axlvx9vkMAvOxi2yh5TfKzSgtHu8Tetp6Rw4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473094; c=relaxed/simple;
	bh=PvjVep4nD9AiWV55KTQJYTHakndYj4kAe3mSKOJ3eyI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J9OWy+PPz4UIEMDgrkC88mKZ8nVFTgbyOLHN1e092WlbjLMPHguFaJpkwprw7kClgRxplpts7bW296t9T6uaeudzKEd7EJjGAdBRDYG4KK+DIBpVgUja+1oHY+2tSCwtoiyQa/HXl+sldZoAs24OWmaTcLMAFVzjp1/7yosLQsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ieW44WPV; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ieW44WPV"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQWd66Jhzm0yVM;
	Tue, 14 Oct 2025 20:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1760473084; x=1763065085; bh=7/5OMUZBODQz7wC1k3l9qoPaRiB/jaON06S
	XEvOf5Hg=; b=ieW44WPVaXfYso8uCgpMzcb5rOb+f1Ns43jDvii7A3Cl+Z/n3m+
	x8G7IuzLNcNQ61thOrbRZhBkH7v4Gn/eQpTyL/RxwjD8lMK4Onq08AkolUdnh/xH
	x7a83vui9CmP1AxYt7wt8BEWIwPvyhc95jWji8djdIE9PuIeFjuohtQ7sPnThERu
	TczLNLngpXJeFh5Etp62As4uTWqulSK4RbIWegyg/q7LaGNkzgclzFCS3/QUP61d
	uX0wQ8/qgCju/sfUMuWng1KXvAvOMd8R2bYNMzVHJk97dIctV1C5pyCwqkqehFUz
	owL+bBbm4QDD9boV/eUaeYlbEQTNExCZI6g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fxavkqO6BTEj; Tue, 14 Oct 2025 20:18:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQWZ5lhzzm0yV3;
	Tue, 14 Oct 2025 20:18:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 00/28] Optimize the hot path in the UFS driver
Date: Tue, 14 Oct 2025 13:15:42 -0700
Message-ID: <20251014201707.3396650-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
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

Changes compared to v5:
 - Removed the "|| sht->queue_reserved_command" test from
   scsi_add_host_with_dma().
 - Removed "WARN_ON_ONCE" from "WARN_ON_ONCE(!sdev->budget_map.map)" in
   scsi_change_queue_depth().
 - Removed "if (WARN_ON_ONCE(!sdev->budget_map.map)) return -EINVAL;" fro=
m
   scsi_realloc_sdev_budget_map().
 - Simplified and improved the scsi_debug abort implementation.
 - Removed the scsi_device_is_pseudo_dev() declaration from
   drivers/scsi/scsi_priv.h.
 - Fixed ufshcd_get_hba_mac(): "Failed to get mac" is no longer reported =
if the
   function succeeds.
 - In the UFS driver, set .nr_reserved_cmds in the SCSI host template ins=
tead of
   in ufshcd_init().

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
  scsi_debug: Abort SCSI commands via an internal command
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
 drivers/scsi/scsi_debug.c        | 113 ++++-
 drivers/scsi/scsi_error.c        |   3 +
 drivers/scsi/scsi_lib.c          | 145 +++++-
 drivers/scsi/scsi_priv.h         |   1 +
 drivers/scsi/scsi_scan.c         |  74 ++-
 drivers/scsi/scsi_sysfs.c        |   5 +-
 drivers/ufs/core/ufs-mcq.c       |  56 +--
 drivers/ufs/core/ufshcd-crypto.h |  18 +-
 drivers/ufs/core/ufshcd-priv.h   |  20 +-
 drivers/ufs/core/ufshcd.c        | 802 ++++++++++++++++---------------
 include/scsi/scsi_device.h       |  23 +
 include/scsi/scsi_host.h         |  33 +-
 include/ufs/ufshcd.h             |  12 -
 15 files changed, 859 insertions(+), 473 deletions(-)

