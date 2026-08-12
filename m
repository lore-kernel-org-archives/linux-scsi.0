Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF45E436BCE
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558402; cv=none; b=fHy/L3SLpZDAk/Xv4zk8G8jWyA4lE0X8dSzveM/DCoLV6KBXrhci/AwRI7NpjOqVgDFMCj24eZ8e5IZySFCaOlISa3CI3+mdC60B249do5K6N4iRGHtjYKmE7QGWF3cU8dOrONKvmuawQ4xHMmA5ZDiVX4XpZorQnLIld2C/VDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558402; c=relaxed/simple;
	bh=AYhq66HOyIUMlCvsokJ8hQlh1oUCBjabz9MUQC8yx/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=toLCkMRuGjXm1A5jFy58Kegh4xKnUdoAkl/jG7cL7T2uY3ggaP8P1hAEUxGZd+ucqFUSDGHRmAqQ6DDBANzro9ysVFbZXkEdV/vyZtcmxjvrZcuek+VLRk3yNxqOpuik0R6YSuCTl9RFHomc7XBLKcL0Z4s55T1Fkb3yNnqac0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eksXimU2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eksXimU2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786558399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/s54xIz6tpD/x1mCQ2HkaTIJX+XULmmjWVywO144yMg=;
	b=eksXimU2lrFwixz0bI4dwtOz3amG6U6Hf/URd6jo5A95r4JwHvuiSy3+UFz/ht4lYfZi/Z
	aeTPy/qkoAW8pRHz7CJWa2RJ7uJO67AT0TrmE0pnoin38UuA0ewrtf2EJkoTDUUEj9MjIq
	NE5ia5SfIcA7jxJ3smNEnBEhKHsc/UQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609--gcgToVBPpiDQpX9qzIJww-1; Wed,
 12 Aug 2026 14:13:14 -0400
X-MC-Unique: -gcgToVBPpiDQpX9qzIJww-1
X-Mimecast-MFC-AGG-ID: -gcgToVBPpiDQpX9qzIJww_1786558389
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B248B1800614;
	Wed, 12 Aug 2026 18:13:08 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D3642180034C;
	Wed, 12 Aug 2026 18:13:01 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org
Subject: [PATCH 00/13] nvme-fc: FPIN link integrity handling
Date: Wed, 12 Aug 2026 14:12:47 -0400
Message-ID: <20260812181300.3712426-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

FPIN LI (link integrity) messages are received when the attached fabric
detects hardware errors. In response to these messages I/O should be
directed away from the affected ports, and only used as a last resort.
This patch adds a new controller flag 'NVME_CTRL_MARGINAL' which will be
checked during multipath path selection, causing the path to be skipped
when checking for paths. If no other paths are available the 'marginal'
paths are considered for path selection.

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
bugzilla 220329.

To test the path handeling use:
https://github.com/linux-blktests/blktests/pull/264
or
https://lore.kernel.org/linux-nvme/20260812174503.3705830-1-jtaubepe@redhat.com/

To test the full set including FPIN decoding use:
https://github.com/johnmeneghini/fpin_li_tests

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220329

New refactored implementation enables administrators to manually control
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
  field-spanning write issue", which resolves the field-spanning write
  issue.
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

Changes to v10:
 - Rebase onto 7.2-rc1
 - Add marginal support to fcloop driver (new patch)
 - Rewrite multipath handeling ("nvme-fc: marginal path handling") and
     ("nvme-multipath: queue-depth support for marginal paths") replacing
     them with ("nvme-multipath: round-robin...")
     ("nvme-fc: marginal path handling...") and
     ("nvme-multipath: queue-depth support")
 - New patch ("scsi: scsi_transport_fc: Add set_rport_marginal to ")
     replaces ("scsi: scsi_transport_fc: add fc_host_fpin_set_nvme").
     Uses existing function template to add a new callback for setting
     the marginal state on a remote port, similar to the existing
     set_rport_dev_loss_tmo() callback.
 - Replace `nvme_fc_modify_rport_fpin_state` with
     `nvme_fc_set_remoteport_fpin` which takes
     `struct nvme_fc_remote_port` insead of wwpn and wwnn
 - Rewrite the "enable FPIN notification for NVMe" patches
      to use the new callback methods.

This patch series is based upon 7.3/scsi-staging at
Commit 376a3960e5ef ("scsi: fnic: Fix built-in NVMe/FC build")

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=7.3/scsi-staging&id=376a3960e5efe85ff765abfb5b5b7e4655ad6aed

Bryan Gurney (2):
  nvme: add NVME_CTRL_MARGINAL flag
  nvme: sysfs: emit the marginal path state in show_state()

Hannes Reinecke (1):
  fc_els: use 'union fc_tlv_desc'

Jesse Taube (8):
  nvme-multipath: numa support for marginal paths
  nvme-multipath: round-robin support for marginal paths
  scsi: scsi_transport_fc: Add set_rport_marginal to
    fc_function_template
  nvme-fc: add nvme_fc_set_remoteport_fpin()
  scsi: qla2xxx: enable FPIN notification for NVMe
  scsi: lpfc: enable FPIN notification for NVMe
  nvme: fcloop: Add set_rport_marginal to sysfs
  docs: nvme-multipath: Add FC-NVMe marginal state

John Meneghini (2):
  nvme-multipath: queue-depth support for marginal paths
  scsi: scsi_transport_fc: user support for clearing NVME_CTRL_MARGINAL

 Documentation/admin-guide/nvme-multipath.rst |  17 ++
 drivers/nvme/host/core.c                     |   1 +
 drivers/nvme/host/fc.c                       |  20 +++
 drivers/nvme/host/multipath.c                | 122 +++++++++++--
 drivers/nvme/host/nvme.h                     |   6 +
 drivers/nvme/host/sysfs.c                    |   4 +-
 drivers/nvme/target/fcloop.c                 |  41 +++++
 drivers/scsi/lpfc/lpfc_attr.c                |  28 +++
 drivers/scsi/lpfc/lpfc_els.c                 |  77 ++++----
 drivers/scsi/lpfc/lpfc_hw4.h                 |  12 +-
 drivers/scsi/qla2xxx/qla_attr.c              |  13 ++
 drivers/scsi/scsi_transport_fc.c             |  89 +++++++---
 include/linux/nvme-fc-driver.h               |   2 +
 include/scsi/scsi_transport_fc.h             |   1 +
 include/uapi/scsi/fc/fc_els.h                | 174 ++++++++++---------
 15 files changed, 441 insertions(+), 166 deletions(-)

-- 
2.54.0

