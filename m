Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57D42C21FA
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933852; cv=none; b=H3yN7M6K+2KpaZueu4B4n4XaI+HLp9fNnZhu27xFmySj8tFYfeLLgarpuKNjnXCzb0fhBqHZJliAcl1E0rJrVdNUgCFTgMwRO5EF/7mk5PGNW06tD4P9VE0S8O/FNZZrN9jPA/Ge0Kd1ZN9/A+UTxp0JvRA/EmR5cbC4PNOT9jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933852; c=relaxed/simple;
	bh=/5iJbWRTmYjje2dK1jZZ0TUEiTgFkk/ymBaRi90UP54=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KL9Pgmzu8yXgTK1Z3qbVg0KUDjn2Nmp6wZ8VEV6KxlsTiJdie1u3lg3Lvzo5vTl7yS1XuE4ZnG6D8bxvZUnNQLqQaWSLku9z/gJowgOr55IUHX6GWDReHGV3WDQ59fAopMQiy6MEzlcRAWg29ywPKSOGqEgVWMSUjdjLHRTkWgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u6fsaG8h; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u6fsaG8h"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c11zs6hFmzlgqVH;
	Mon, 11 Aug 2025 17:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1754933848; x=1757525849; bh=ATkLwsRQ6IP6+DLvj1qXus/FTdovq1cZc0w
	5eJtL9Ps=; b=u6fsaG8hdY4ifDJmsxMbmYj5jHy/XKWn7XsEGMiaFsrylGLsRPV
	9hRN0KVpnQU5OGdGcjGk1z4MfabqtujDo3vsnKq5UWS7rVTm0kxNiXMiLhtunZDw
	IMYfk+doPILXv9MlwkTrp18MJPFUjfgLLWzJiFTPSiOhzfhdoER8ILqtO+UijESE
	xc5svPrqn1xS/zRZj9lCelEXa4MUcwMnKXgzLD6n0LPWi4Nf54gVahZLf1TKQAny
	eKYswvf/h4AQE4DSiCENrMQbtIA2HNUhtwbf4FQVUAfSGrXlv8z3RXrrGULwj5uS
	e0ooyUJvpIIdiWXQMPRXaGe8eq8ESbQgmIw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jbtBDCdyR8Om; Mon, 11 Aug 2025 17:37:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c11zq2Zr6zlgqV3;
	Mon, 11 Aug 2025 17:37:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/30] Optimize the hot path in the UFS driver
Date: Mon, 11 Aug 2025 10:34:12 -0700
Message-ID: <20250811173634.514041-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
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
* Start with allocating 32 command slots and increase this number later
  after it is clear whether or not the UFS device supports more than 32
  command slots. Introduce scsi_host_update_can_queue() to support this
  approach.

Changes compared to v1:
 - Left out the kernel patches related to support for const SCSI command
   arguments.
 - Added SCSI core patches for allocating a pseudo SCSI device and reserv=
ed
   command support.
 - Added several kernel patches to switch the UFS driver from a hardcoded
   reserved slot to calling scsi_get_internal_cmd().
 - Enable .alloc_pseudo_sdev in the scsi_debug driver.

Bart Van Assche (27):
  scsi: core: Do not allocate a budget token for reserved commands
  scsi: core: Introduce scsi_host_update_can_queue()
  scsi_debug: Set .alloc_pseudo_sdev
  ufs: core: Move an assignment
  ufs: core: Change the type of one ufshcd_add_cmd_upiu_trace() argument
  ufs: core: Only call ufshcd_add_command_trace() for SCSI commands
  ufs: core: Change the type of one ufshcd_add_command_trace() argument
  ufs: core: Change the type of one ufshcd_send_command() argument
  ufs: core: Only call ufshcd_should_inform_monitor() for SCSI commands
  ufs: core: Change the monitor function argument types
  ufs: core: Rework ufshcd_mcq_compl_pending_transfer()
  ufs: core: Rework ufshcd_eh_device_reset_handler()
  ufs: core: Cache the DMA buffer sizes
  ufs: core: Add an argument to ufshcd_mcq_decide_queue_depth()
  ufs: core: Add an argument to ufshcd_alloc_mcq()
  ufs: core: Call ufshcd_mcq_init() once
  ufs: core: Allocate the SCSI host earlier
  ufs: core: Make ufshcd_mcq_init() independent of hba->nutrs
  ufs: core: Call ufshcd_init_lrb() later
  ufs: core: Use hba->reserved_slot
  ufs: core: Make the reserved slot a reserved request
  ufs: core: Do not clear driver-private command data
  ufs: core: Optimize the hot path
  ufs: core: Remove the ufshcd_lrb task_tag member
  ufs: core: Initialize the 'hwq' variable earlier
  ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
  ufs: core: Switch to scsi_get_internal_cmd()

Hannes Reinecke (3):
  scsi: core: Support allocating reserved commands
  scsi: core: Support allocating a pseudo SCSI device
  scsi: core: Add scsi_{get,put}_internal_cmd() helpers

 drivers/scsi/hosts.c             |  11 +
 drivers/scsi/scsi.c              |  52 +-
 drivers/scsi/scsi_debug.c        |   1 +
 drivers/scsi/scsi_lib.c          |  97 +++-
 drivers/scsi/scsi_priv.h         |   2 +
 drivers/scsi/scsi_scan.c         |  70 ++-
 drivers/scsi/scsi_sysfs.c        |   4 +-
 drivers/ufs/core/ufs-mcq.c       |  50 +-
 drivers/ufs/core/ufshcd-crypto.h |  18 +-
 drivers/ufs/core/ufshcd-priv.h   |  20 +-
 drivers/ufs/core/ufshcd.c        | 845 ++++++++++++++++---------------
 include/scsi/scsi_cmnd.h         |   2 +
 include/scsi/scsi_device.h       |  23 +
 include/scsi/scsi_host.h         |  33 +-
 include/ufs/ufshcd.h             |  17 +-
 15 files changed, 783 insertions(+), 462 deletions(-)

