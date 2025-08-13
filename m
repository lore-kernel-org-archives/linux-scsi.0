Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F385C2FD7AA
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 20:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755115688; cv=none; b=bWZHOhRJR/i2x/IDwGfJY0VSsatiKAqjEbbqq+n+SOf0w8kUnPX9FqdP5IBEpWutbTbctoFccdbfUXlZK6xzGecTiur0/SFQitp4mIXb8o+CyygiMQIFoKjuyPBVoT72/jy7+4BTotzSzWuNvaYF5S/ukGHPLLYFNtVPcdIU54g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755115688; c=relaxed/simple;
	bh=U4u5+5OOIgDBiJZLu+qX70rJyTfOwybMEUju62q4xg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O+tc8gKVnBcWOhe8hCCFnfIQPLwuKta+kS9z4ElHLlHRoHMp3T8eWN7odY6R8R+pdWWc5zzrl3tVrn7iYUyOGicrIu8JzApMb60EgcFwM0zkAX65sK9B0jRpp0tDR0biiaBDYiMT0W9kWFXIY8sZTDBQ6m4jynWILQwPiEdrriA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UWVrt+We; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWVrt+We"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755115684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b7mt1C+KG932faq+YCzD+ZbW3TK14YbVvjxKepFVdXo=;
	b=UWVrt+WekYzLFCLuBjH+SMGk/kafycBRjqIGAYoERMaShKfn5+A5ZdJnbnrngEa9REQF7h
	5iYG4NI/EXGInhsqm9ux1OLDU7duQc0iQUU/aCNflwrmB76jSbDgYXfeWiOG2FLKsOkwVP
	LcY5dU+8ZikCcg1hozXt6v0fkG73iLo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-R7D5RGDiOjSUVj5WLhqYuQ-1; Wed,
 13 Aug 2025 16:08:00 -0400
X-MC-Unique: R7D5RGDiOjSUVj5WLhqYuQ-1
X-Mimecast-MFC-AGG-ID: R7D5RGDiOjSUVj5WLhqYuQ_1755115678
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 458691956056;
	Wed, 13 Aug 2025 20:07:57 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.44.32.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 816DA18003FC;
	Wed, 13 Aug 2025 20:07:49 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: linux-nvme@lists.infradead.org,
	kbusch@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	axboe@kernel.dk
Cc: james.smart@broadcom.com,
	njavali@marvell.com,
	linux-scsi@vger.kernel.org,
	hare@suse.de,
	linux-hardening@vger.kernel.org,
	kees@kernel.org,
	gustavoars@kernel.org,
	bgurney@redhat.com,
	jmeneghi@redhat.com,
	emilne@redhat.com
Subject: [PATCH v9 0/8] nvme-fc: FPIN link integrity handling
Date: Wed, 13 Aug 2025 16:07:35 -0400
Message-ID: <20250813200744.17975-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

Testing has been performed by sending all FPIN LI ELS messages from the
switch to the Host and verifying the proper nvme multi-pathing behavior
is effected with each of the eight different FPIN link integrity events.
Results were verified with iostat and with the nvme list-subsys command.

These tests were run with all scenarios including where there were only
non-optimized paths available, and where all paths were
marginal/degraded. All multi-path io-policies were tested including:
numa, round-robin and queue-depth. When all paths on the host are
marginal/degraded, I/O continues on the optimized path that was most
recently non-marginal.  If both of the optimized paths are down, I/O
properly continues on one of the marginal/degraded non-optimized paths.

Testing has been complete with both Broadcom (lpfc) and Marvell (qla2xx)
32GB HBAs.  Both HBAs successfully complete all tests.

For a complete description of the tests that were run, please see
bugzilla 20329.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220329

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

Changes to v7:
- Split nvme core marginal flag addition into its own patch
- Add patch for queue_depth marginal path support

Changes to v8:
- Rebased patch series to nvme-6.17.
- Added patch from Gustavo Silva, "scsi: qla2xxx: Fix memcpy field-spanning
  write issue", which resolves the field-spanning write issue
- We decided to leave the "marginal" state as is, because the transport
  driver uses the term "marginal".

This patch series is based upon nvme-6.17.

Bryan Gurney (2):
  nvme: add NVME_CTRL_MARGINAL flag
  nvme: sysfs: emit the marginal path state in show_state()

Gustavo A. R. Silva (1):
  scsi: qla2xxx: Fix memcpy field-spanning write issue

Hannes Reinecke (5):
  fc_els: use 'union fc_tlv_desc'
  nvme-fc: marginal path handling
  nvme-fc: nvme_fc_fpin_rcv() callback
  lpfc: enable FPIN notification for NVMe
  qla2xxx: enable FPIN notification for NVMe

John Meneghini (1):
  nvme-multipath: queue-depth support for marginal paths

 drivers/nvme/host/core.c         |   1 +
 drivers/nvme/host/fc.c           |  99 +++++++++++++++++++
 drivers/nvme/host/multipath.c    |  24 +++--
 drivers/nvme/host/nvme.h         |   6 ++
 drivers/nvme/host/sysfs.c        |   4 +-
 drivers/scsi/lpfc/lpfc_els.c     |  84 ++++++++--------
 drivers/scsi/qla2xxx/qla_def.h   |  10 +-
 drivers/scsi/qla2xxx/qla_isr.c   |  20 ++--
 drivers/scsi/qla2xxx/qla_nvme.c  |   2 +-
 drivers/scsi/qla2xxx/qla_os.c    |   5 +-
 drivers/scsi/scsi_transport_fc.c |  27 +++--
 include/linux/nvme-fc-driver.h   |   3 +
 include/uapi/scsi/fc/fc_els.h    | 165 +++++++++++++++++--------------
 13 files changed, 293 insertions(+), 157 deletions(-)

-- 
2.50.1

