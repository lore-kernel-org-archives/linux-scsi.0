Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036344C6C
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253326; cv=none; b=msmwGCANXhHV6bjCUuyQRzTv3dKfV/IfQtPfsEev3jllnGlsawbHr5IFUjLIG9vmgZCfr8jJSD4tHbXrsXPqEAyF9/J72vLq6sd1rhuYsyb8a4J+hWXCkGUpDCisyWa5529HSod+USmTiy5Z+h1Y5T2aQfq5Agr7hXFlmTh0wpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253326; c=relaxed/simple;
	bh=4uqTpLFiBZqEjRR4l6UayJ0pVUBXszvltS+pNMU9CXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f5wyOyplN66pc+Iyv95Ef00Se5seQVw9fhNFjUIE5MdnN2860hhujAoGJ71spoGzuO4GWiK2d/sgPQJiP4QM4CPm0vw7/qOc1l73NbPMHXjNu7VjspfSIOeSOAwHet1VUk/SFspfo+v3n/aur0eXiUFTKzDwLtb/R/9P6p88Wls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Qc3ruxyC; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Qc3ruxyC"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPyL6btqzm0ysy;
	Wed, 27 Aug 2025 00:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1756253321; x=1758845322; bh=JmTjRUXyx35wP+iAy+s8iT+Q/0m4/SuCMBc
	rCDPJi7s=; b=Qc3ruxyCJjpZ0erBlO4ZCiC2ZKv8i8Svf/2P9B7Vipvqfg4ZnD5
	zhN3UT/JSzM58QTzAI7npkPw1qyIjQJ4vvRnpF3Lv2n9BlgTBaVtq7DsJKiApSNC
	GhuKkTSq4DiXeJVorOCxXHAQ4CMEt5JLkYGsr0DfwNltH0lmjI2Q+P+NgxdfMSWg
	7temlVqdRDPCKVqk7wMPPYVhDYkuXBX0gGawRlru53fX9qWcy1dSPHzuJXQU2JUn
	jBP3H7pXj8OkX32Saj/O2wsH/UhsZ9Ztj8HA3eqzxyIO08k0fqB0OLU+W82UKI0W
	oXE4Igu/UlttON1nh1tuzktuBQil3EICWlQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7T6W0QutaMFJ; Wed, 27 Aug 2025 00:08:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPyJ2Q8vzm0yQq;
	Wed, 27 Aug 2025 00:08:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/26] Optimize the hot path in the UFS driver
Date: Tue, 26 Aug 2025 17:06:04 -0700
Message-ID: <20250827000816.2370150-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
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

Changes compared to v2:
 - Removed scsi_host_update_can_queue() and also the UFS driver refactori=
ng
   patches that were introduced to support this call.
-- Added .queue_reserved_command(). Added ufshcd_queue_reserved_command()=
.
-- Removed a BUG_ON() statement from ufshcd_get_dev_mgmt_cmd().
-- Modified and renamed ufshcd_mcq_decide_queue_depth().

Changes compared to v1:
 - Left out the kernel patches related to support for const SCSI command
   arguments.
 - Added SCSI core patches for allocating a pseudo SCSI device and reserv=
ed
   command support.
 - Added several kernel patches to switch the UFS driver from a hardcoded
   reserved slot to calling scsi_get_internal_cmd().
 - Enable .alloc_pseudo_sdev in the scsi_debug driver.

*** BLURB HERE ***

Bart Van Assche (22):
  scsi: core: Do not allocate a budget token for reserved commands
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
  ufs: core: Allocate more commands for the SCSI host
  ufs: core: Allocate the SCSI host earlier
  ufs: core: Call ufshcd_init_lrb() later
  ufs: core: Use hba->reserved_slot
  ufs: core: Make the reserved slot a reserved request
  ufs: core: Do not clear driver-private command data
  ufs: core: Optimize the hot path
  ufs: core: Pass a SCSI pointer instead of an LRB pointer
  ufs: core: Remove the ufshcd_lrb task_tag member
  ufs: core: Make blk_mq_tagset_busy_iter() skip reserved requests
  ufs: core: Switch to scsi_get_internal_cmd()

Hannes Reinecke (3):
  scsi: core: Support allocating reserved commands
  scsi: core: Support allocating a pseudo SCSI device
  scsi: core: Add scsi_{get,put}_internal_cmd() helpers

John Garry (1):
  scsi: core: Bypass the queue limit checks for reserved commands

 drivers/scsi/hosts.c             |  17 +
 drivers/scsi/scsi.c              |   7 +-
 drivers/scsi/scsi_debug.c        |   1 +
 drivers/scsi/scsi_lib.c          | 151 +++++-
 drivers/scsi/scsi_priv.h         |   2 +
 drivers/scsi/scsi_scan.c         |  70 ++-
 drivers/scsi/scsi_sysfs.c        |   4 +-
 drivers/ufs/core/ufs-mcq.c       |  51 +-
 drivers/ufs/core/ufshcd-crypto.h |  18 +-
 drivers/ufs/core/ufshcd-priv.h   |  20 +-
 drivers/ufs/core/ufshcd.c        | 802 +++++++++++++++++--------------
 include/scsi/scsi_cmnd.h         |   2 +
 include/scsi/scsi_device.h       |  23 +
 include/scsi/scsi_host.h         |  37 +-
 include/ufs/ufshcd.h             |  12 -
 15 files changed, 763 insertions(+), 454 deletions(-)

