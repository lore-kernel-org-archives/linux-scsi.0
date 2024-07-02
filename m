Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA0201276
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 21:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719957170; cv=none; b=N3lYHmwG+DY//f0PrdO/drTOBjmucDcgJ/rmzg10bhmE/iVPpqx7MlzeKmGTgsugswq31MOJryjbLwBQCjq9ARDn5VPD7zgrdHZ/THxQT8dkdEsk2HC2Q1TrRJ+Stm1uFEOA45nSuYh2fE6E+xEs63W5h+Vaecw/GedHG9V2gjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719957170; c=relaxed/simple;
	bh=TTEbhHRyfebA8MtPFYHuJTw3nDS2pYax+LmGQV9+meA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TIMADsiEbKwXNlMPwLpLzY1IQHySqdm7Ws7DIj5COrmfmhiFggutzIeaDnERmDP/1pAuQkZooe/CPA27DHT1yhLa5/M0jKWraZYD4mhDw+V2uozHmDX/RZUqw2AafOmOw1WxGEsAnBWNFgyotlowop7aL/7Fh8yvqXMPq4Ab0Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qHMlWPTd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qHMlWPTd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDGqN2BlKzlnQkq;
	Tue,  2 Jul 2024 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1719957166; x=1722549167; bh=+6ChLYSWrd/hYeb825sWZo9Ac9eBDE19OgG
	Mc9/9dCg=; b=qHMlWPTdUYILMuDZKYEsWqVt4oaaqkwLIoV+24Y5nnO0YvLGk4D
	a1cAsiFQ0S+zxtw86/FLWfRkfjRgarJwzSgE0tGkp8fQyzIUmFDooNGrw2o/imoR
	Iy8YDXgssGRvHtJCO2JMyXJhvKBslaNFAc39SWHkZJhZDYXyFa01qz6GxtmjOMUg
	phbR8DEY6kdB0SoCyOcAm+nihPVtGRX/vtKb8SzvTZeTStI2R4HeCQnTJaSmZ5E+
	WsSZPAt6aHrZm7r79PVcL8DCZooRKZBA/tDPmmH53TMXTlfPoZhgUJUlAHNdsLNg
	riVuef10n7UorRGcBFpFM6jdvirJc2f+tDA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id No1j3kT6I514; Tue,  2 Jul 2024 21:52:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDGqK5tFLzlnQkp;
	Tue,  2 Jul 2024 21:52:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/18] Simplify multiple create*_workqueue() invocations
Date: Tue,  2 Jul 2024 14:51:47 -0700
Message-ID: <20240702215228.2743420-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
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

