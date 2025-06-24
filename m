Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01762E2EE3
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750796440; cv=none; b=ncvPgHIOTo5E6TE7xyCjXU+/DkIwRpYgemOR+Bss/lJ9VFteLVHdlEtC5uWU5UivqoHITBoswIS5a7knfHQxoK0olxxaWyWnGIl1jr+N8W8u692kXqK3Ve7MaKQgR+4NpA1BmP2bqwuZhz8lYD2Uv/txpMhR35NZxidd9poXyjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750796440; c=relaxed/simple;
	bh=QeLqEIxbOJSC4hzQNpaqg9sk/PC8T6UOOCVCN+NtL4M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fBeyy6gw5fZ2b8U8A+m/IbMo7HjBehfII8UuYg4T2kx97gjyF2kYHS/05aF/r3koKG5mipx5UQlnOqhJl0TBD2Y44+XoBtVWxfpMAZDB0kED8f7wm9cfqTNigMMmsDsEKDNqw3+3mSYiNm6Eelm/H62F0zdOkQg/zDcu5BFwKD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fVLzZBVr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVLzZBVr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750796437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sAon4/aUpge0AwBbK4GiAktDJCSlgNuBWZOwFjoHTCE=;
	b=fVLzZBVriR6eRIzXwlgKuBetXQR/ZIxbxQ8A/bSEFjBEpMEXLeeboHh6jT8eRJtReL1SyC
	sLziWTBjIG3U54F/iJz3cddtAw44YwqJHLuHRBA8UgsRpkxCz2Eg48YIuNpl9F7IvqhE3L
	AGMQiztKvGtGfN/5rBgeXbwYIMottYM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-Rp_6R6lDO66eX74Npgrqwg-1; Tue,
 24 Jun 2025 16:20:33 -0400
X-MC-Unique: Rp_6R6lDO66eX74Npgrqwg-1
X-Mimecast-MFC-AGG-ID: Rp_6R6lDO66eX74Npgrqwg_1750796432
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D33981956094;
	Tue, 24 Jun 2025 20:20:31 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.45.226.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2735D19560A3;
	Tue, 24 Jun 2025 20:20:25 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	bgurney@redhat.com,
	jmeneghi@redhat.com
Subject: [PATCH v7 0/6] nvme-fc: FPIN link integrity handling
Date: Tue, 24 Jun 2025 16:20:14 -0400
Message-ID: <20250624202020.42612-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

FPIN LI (link integrity) messages are received when the attached
fabric detects hardware errors. In response to these messages I/O
should be directed away from the affected ports, and only used
if the 'optimized' paths are unavailable.
Upon port reset the paths should be put back in service as the
affected hardware might have been replaced.
This patch adds a new controller flag 'NVME_CTRL_MARGINAL'
which will be checked during multipath path selection, causing the
path to be skipped when checking for 'optimized' paths. If no
optimized paths are available the 'marginal' paths are considered
for path selection alongside the 'non-optimized' paths.
It also introduces a new nvme-fc callback 'nvme_fc_fpin_rcv()' to
evaluate the FPIN LI TLV payload and set the 'marginal' state on
all affected rports.

The testing for this patch set was performed by Bryan Gurney, using the
process outlined by John Meneghini's presentation at LSFMM 2024, where
the fibre channel switch sends an FPIN notification on a specific switch
port, and the following is checked on the initiator:

1. The controllers corresponding to the paths on the port that has
received the notification are showing a set NVME_CTRL_MARGINAL flag.

   \
    +- nvme4 fc traddr=c,host_traddr=e live optimized
    +- nvme5 fc traddr=8,host_traddr=e live non-optimized
    +- nvme8 fc traddr=e,host_traddr=f marginal optimized
    +- nvme9 fc traddr=a,host_traddr=f marginal non-optimized

2. The I/O statistics of the test namespace show no I/O activity on the
controllers with NVME_CTRL_MARGINAL set.

   Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
   nvme4c4n1         0.00         0.00         0.00         0.00
   nvme4c5n1     25001.00         0.00        97.66         0.00
   nvme4c9n1     25000.00         0.00        97.66         0.00
   nvme4n1       50011.00         0.00       195.36         0.00
   
   
   Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
   nvme4c4n1         0.00         0.00         0.00         0.00
   nvme4c5n1     48360.00         0.00       188.91         0.00
   nvme4c9n1      1642.00         0.00         6.41         0.00
   nvme4n1       49981.00         0.00       195.24         0.00
   
   
   Device             tps    MB_read/s    MB_wrtn/s    MB_dscd/s
   nvme4c4n1         0.00         0.00         0.00         0.00
   nvme4c5n1     50001.00         0.00       195.32         0.00
   nvme4c9n1         0.00         0.00         0.00         0.00
   nvme4n1       50016.00         0.00       195.38         0.00

Link: https://people.redhat.com/jmeneghi/LSFMM_2024/LSFMM_2024_NVMe_Cancel_and_FPIN.pdf

More rigorous testing was also performed to ensure proper path migration
on each of the eight different FPIN link integrity events, particularly
during a scenario where there are only non-optimized paths available, in
a state where all paths are marginal.  On a configuration with a
round-robin iopolicy, when all paths on the host show as marginal, I/O
continues on the optimized path that was most recently non-marginal.
From this point, of both of the optimized paths are down, I/O properly
continues on the remaining paths.

Changes to the original submission:
- Changed flag name to 'marginal'
- Do not block marginal path; influence path selection instead
  to de-prioritize marginal paths

Changes to v2:
- Split off driver-specific modifications
- Introduce 'union fc_tlv_desc' to avoid casts

Changes to v3:
- Include reviews from Justin Tee
- Split marginal path handling patch

Changes to v4:
- Change 'u8' to '__u8' on fc_tlv_desc to fix a failure to build
- Print 'marginal' instead of 'live' in the state of controllers
  when they are marginal

Changes to v5:
- Minor spelling corrections to patch descriptions

Changes to v6:
- No code changes; added note about additional testing 

Hannes Reinecke (5):
  fc_els: use 'union fc_tlv_desc'
  nvme-fc: marginal path handling
  nvme-fc: nvme_fc_fpin_rcv() callback
  lpfc: enable FPIN notification for NVMe
  qla2xxx: enable FPIN notification for NVMe

Bryan Gurney (1):
  nvme: sysfs: emit the marginal path state in show_state()

 drivers/nvme/host/core.c         |   1 +
 drivers/nvme/host/fc.c           |  99 +++++++++++++++++++
 drivers/nvme/host/multipath.c    |  17 ++--
 drivers/nvme/host/nvme.h         |   6 ++
 drivers/nvme/host/sysfs.c        |   4 +-
 drivers/scsi/lpfc/lpfc_els.c     |  84 ++++++++--------
 drivers/scsi/qla2xxx/qla_isr.c   |   3 +
 drivers/scsi/scsi_transport_fc.c |  27 +++--
 include/linux/nvme-fc-driver.h   |   3 +
 include/uapi/scsi/fc/fc_els.h    | 165 +++++++++++++++++--------------
 10 files changed, 269 insertions(+), 140 deletions(-)

-- 
2.49.0

