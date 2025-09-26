Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B787634
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 00:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758844936; cv=none; b=IBVbGxNdvA841487/B6E/wxzayq5xPebO1Dq86PnKbkgpyOAU8utXVUVwOo7LRaCXPPOM3lVnoM1wDkwcaHcxJFU2ne7ksgIUq2fbyD/0B/eGiQv2IPpAh6eNcUhr/0UXBN8xEExXQTCynT+bw/WK6eAPZYdMNoHjjqQtO3AKo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758844936; c=relaxed/simple;
	bh=NcFIePYPN2VlgOMrbKjH4bG8J3oiwP992S06euFqlm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=l0XR3NGFqcBQ0N+g+gwpB3P6qSaS4aFLz1OzL/TIXLNd/EALWSaKh7bhDWU7/OBoU4ZmR7Wo9lfJhe4mVfnTQzDslNWm2pI+YJaBrofUvyzLOYMjjgq8zPeKm6S9yk5kbh2A6MwtO7verJfgFfhwKdcjoPTSzbQ4xqnL6xfj4d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FD9b4dgI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FD9b4dgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758844933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wvu9uFFeJOFDOc53VVq5RN+mSYEcZ4WSKOSXb2ynPRM=;
	b=FD9b4dgIsVr6gAWJCOk7qqI3wpLnbkBCBZyGjTdK179LQWh/wvSyJbGSo0Hrw9bFHXyhfP
	i/bkWsYR1s5uQWtQmHCSgxkguWnJ3STNTzKl+X7DS6k9ldqcgzSyjJqeDtTSy18eJ+ImKk
	yI1lWujBE5VNc4a+2/CTTCAA3oMIKKo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-HynJ0YY2PzKJbxUkpHmGHA-1; Thu,
 25 Sep 2025 20:02:09 -0400
X-MC-Unique: HynJ0YY2PzKJbxUkpHmGHA-1
X-Mimecast-MFC-AGG-ID: HynJ0YY2PzKJbxUkpHmGHA_1758844928
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27E7319774D4;
	Fri, 26 Sep 2025 00:02:07 +0000 (UTC)
Received: from jmeneghi-thinkpadp1gen7.rmtusnh.csb (unknown [10.22.81.200])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD9631800579;
	Fri, 26 Sep 2025 00:02:03 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: hare@suse.de,
	kbusch@kernel.org,
	martin.petersen@oracle.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com,
	axboe@kernel.dk,
	emilne@redhat.com,
	gustavoars@kernel.org,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me
Subject: [PATCH v10 00/11] nvme-fc: FPIN link integrity handling 
Date: Thu, 25 Sep 2025 20:01:49 -0400
Message-ID: <20250926000200.837025-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

FPIN LI (link integrity) messages are received when the attached fabric
detects hardware errors. In response to these messages I/O should be
directed away from the affected ports, and only used if the 'optimized'
paths are unavailable.  Upon port reset the paths should be put back in
service as the affected hardware might have been replaced.  This patch
adds a new controller flag 'NVME_CTRL_MARGINAL' which will be checked
during multipath path selection, causing the path to be skipped when
checking for 'optimized' paths. If no optimized paths are available the
'marginal' paths are considered for path selection alongside the
'non-optimized' paths.  It also introduces a new nvme-fc callback
'nvme_fc_fpin_rcv()' to evaluate the FPIN LI TLV payload and set the
'marginal' state on all affected rports.

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

New refactored implmentation enables administrators to manually control
port marginal states via sysfs. For example:

# Set remote port to marginal state
echo "Marginal" > /sys/class/fc_remote_ports/rport-4:0-1/port_state

# Clear marginal state (set to online)
echo "Online" > /sys/class/fc_remote_ports/rport-4:0-1/port_state

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

Changes to v9:
- Rebased patch series to nvme-6.18.
- Refactor and fix a patch from Gustavo Silva, "scsi: qla2xxx: Fix 2 memcpy
  field-spanning write issue", which resolves the field-spanning write issue.
  This new version of Gustavo's patch fixes a bug found in testing.
- Refactored original implementation
  New functions added:
    nvme_fc_lport_from_wwpn() - Find local port by WWPN
    nvme_fc_fpin_set_state() - Set marginal state on controllers
    nvme_fc_modify_rport_fpin_state() - Main API function
  Functions removed:
    nvme_fc_fpin_li_lport_update() - FPIN processing logic
    nvme_fc_fpin_rcv() - Direct FPIN message processing
  Functions modified:
    fc_rport_set_marginal_state - allows administrative control

This patch series is based upon nvme-6.18.

Bryan Gurney (2):
  nvme: add NVME_CTRL_MARGINAL flag
  nvme: sysfs: emit the marginal path state in show_state()

Gustavo A. R. Silva (1):
  scsi: qla2xxx: Fix 2 memcpy field-spanning write issue

Hannes Reinecke (2):
  fc_els: use 'union fc_tlv_desc'
  nvme-fc: marginal path handling

John Meneghini (6):
  nvme-multipath: queue-depth support for marginal paths
  nvme-fc: add nvme_fc_modify_rport_fpin_state()
  scsi: scsi_transport_fc: add fc_host_fpin_set_nvme_rport_marginal()
  scsi: lpfc: enable FPIN notification for NVMe
  scsi: qla2xxx: enable FPIN notification for NVMe
  scsi: scsi_transport_fc: user support for clearing NVME_CTRL_MARGINAL

 drivers/nvme/host/core.c         |   1 +
 drivers/nvme/host/fc.c           |  80 +++++++++++++++
 drivers/nvme/host/multipath.c    |  24 +++--
 drivers/nvme/host/nvme.h         |   6 ++
 drivers/nvme/host/sysfs.c        |   4 +-
 drivers/scsi/lpfc/lpfc_els.c     |  82 ++++++++-------
 drivers/scsi/qla2xxx/qla_def.h   |  10 +-
 drivers/scsi/qla2xxx/qla_isr.c   |  18 ++--
 drivers/scsi/qla2xxx/qla_nvme.c  |   2 +-
 drivers/scsi/qla2xxx/qla_os.c    |   9 +-
 drivers/scsi/scsi_transport_fc.c | 154 ++++++++++++++++++++++++-----
 include/linux/nvme-fc-driver.h   |   2 +
 include/scsi/scsi_transport_fc.h |   1 +
 include/uapi/scsi/fc/fc_els.h    | 165 +++++++++++++++++--------------
 14 files changed, 391 insertions(+), 167 deletions(-)

-- 
2.51.0

