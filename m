Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9C1C6886
	for <linux-scsi@vger.kernel.org>; Fri, 16 Aug 2024 21:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723845382; cv=none; b=bOEWhF+iquzuwDguoteq0sE4QT9qUAJnRHqqsdHBIpxydHCfkJtMO4R+jgzqCXOdURyH0xv0h5m2h5CPBuI6DZq3UlriGJiAA2dlskaivkSGJi1cK3xLI3T3o1T2M3eKzWmLrHpIVShu/hNRVUmDeu05ALfejz5tVVXuvB+kBC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723845382; c=relaxed/simple;
	bh=b4KdYT5CZt2LQd0qUkWAveNreqgP/xir5LZMLi7qgUM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bhokAq59pAt3BqDvS2b5cJw7XVPCuB6rKwAF0Q2yiho/n2DUIqkGeZ5wiMoQMKPuAvaA4P5iUNkHbQ7pCVM44aMtWkO9vHRE+vLt/0hgJWV6D4i2X3c3PfD6acHfMoYKs4s62vH+2MygB1WC0tGy1mzojeX1BSE2B+XhZES+r0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4nrxYHnS; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4nrxYHnS"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlwmZ3Z1Pz6ClY98;
	Fri, 16 Aug 2024 21:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1723845372; x=1726437373; bh=3EZH85AuhqSTZvvgnNK/LKybhOJCawVJe2d
	uWWPzvGg=; b=4nrxYHnShznLmjEHuWsuzTOTpsJ1KsO/7DpGG6OHntm50ZWzEFX
	XwblEZqqb8Hc1uLyt59mIYFKil7ihqnDOD0OJW5kcCJsfKnsDYSzvnU5+O28/V/s
	I48wBvnsDrDjHUWNGfyl9D4wgJy6TQvcrghInyeCs3/lYRRGEPaV/MSbzRETCiIZ
	Ye+ctJg390UNab5LIzX/bP+ERuKnBhV3gDuQTxk70wHAZoa9b0KQmVbOXFO+Y45D
	OyUvDAGuWqlZL8WTF0wdGycEbPHMVsDlRwFbAKet3HnsbsZ6lVXdh7qoOakd7WFO
	sKL1SO8n+82nMI4RgQXNpACtNBu1LLkXtqA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 13tJtAokb6V7; Fri, 16 Aug 2024 21:56:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlwmW3xQ4z6ClY95;
	Fri, 16 Aug 2024 21:56:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/18] Simplify multiple create*_workqueue() invocations
Date: Fri, 16 Aug 2024 14:55:23 -0700
Message-ID: <20240816215605.36240-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Multiple SCSI drivers use snprintf() to format a workqueue name before
invoking one of the create*_workqueue() macros. This patch series
simplifies such code by passing the format string and arguments to
alloc_workqueue(). Please consider this patch series for the next
merge window.

Thanks,

Bart.

Changes compared to v1:
 - Added several Reviewed-by tags.

Bart Van Assche (18):
  scsi: Expand all create*_workqueue() invocations
  scsi: mptfusion: Simplify the alloc*_workqueue() invocations
  scsi: be2iscsi: Simplify an alloc_workqueue() invocation
  scsi: bfa: Simplify an alloc_ordered_workqueue() invocation
  scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation
  scsi: fcoe: Simplify alloc_ordered_workqueue() invocations
  scsi: ibmvscsi_tgt: Simplify an alloc_workqueue() invocation
  scsi: mpi3mr: Simplify an alloc_ordered_workqueue() invocation
  scsi: mpt3sas: Simplify an alloc_ordered_workqueue() invocation
  scsi: myrb: Simplify an alloc_ordered_workqueue() invocation
  scsi: myrs: Simplify an alloc_ordered_workqueue() invocation
  scsi: qedf: Simplify alloc_workqueue() invocations
  scsi: qedi: Simplify an alloc_workqueue() invocation
  scsi: snic: Simplify alloc_workqueue() invocations
  scsi: scsi_transport_fc: Simplify alloc_workqueue() invocations
  scsi: stex: Simplify an alloc_ordered_workqueue() invocation
  scsi: ufs: Simplify alloc*_workqueue() invocation
  scsi: core: Simplify an alloc_workqueue() invocation

 drivers/message/fusion/mptbase.c            | 10 +++-------
 drivers/message/fusion/mptbase.h            |  3 ---
 drivers/message/fusion/mptfc.c              |  7 ++-----
 drivers/scsi/be2iscsi/be_main.c             |  6 ++----
 drivers/scsi/bfa/bfad_im.c                  |  5 ++---
 drivers/scsi/bfa/bfad_im.h                  |  1 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  3 ++-
 drivers/scsi/elx/efct/efct_lio.c            |  3 ++-
 drivers/scsi/esas2r/esas2r.h                |  1 -
 drivers/scsi/esas2r/esas2r_init.c           |  5 ++---
 drivers/scsi/fcoe/fcoe_sysfs.c              | 18 +++++------------
 drivers/scsi/fnic/fnic_main.c               |  6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  3 ++-
 drivers/scsi/hosts.c                        |  9 ++++-----
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  5 ++---
 drivers/scsi/libfc/fc_exch.c                |  3 ++-
 drivers/scsi/libfc/fc_rport.c               |  3 ++-
 drivers/scsi/libsas/sas_init.c              |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr.h                |  2 --
 drivers/scsi/mpi3mr/mpi3mr_fw.c             |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c             |  4 +---
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  4 +---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  4 +---
 drivers/scsi/myrb.c                         |  5 ++---
 drivers/scsi/myrb.h                         |  1 -
 drivers/scsi/myrs.c                         |  5 ++---
 drivers/scsi/myrs.h                         |  1 -
 drivers/scsi/qedf/qedf_main.c               | 20 +++++++++----------
 drivers/scsi/qedi/qedi_main.c               |  8 +++++---
 drivers/scsi/qla2xxx/qla_os.c               |  6 ++++--
 drivers/scsi/qla4xxx/ql4_os.c               |  2 +-
 drivers/scsi/scsi_transport_fc.c            | 11 +++--------
 drivers/scsi/snic/snic_main.c               |  8 ++++----
 drivers/scsi/stex.c                         |  6 ++----
 drivers/scsi/vmw_pvscsi.c                   |  3 ++-
 drivers/ufs/core/ufshcd.c                   | 22 +++++++--------------
 include/scsi/fcoe_sysfs.h                   |  2 --
 include/scsi/scsi_host.h                    |  1 -
 include/scsi/scsi_transport_fc.h            |  6 ------
 42 files changed, 90 insertions(+), 142 deletions(-)

