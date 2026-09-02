Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA90380FD6
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379563; cv=none; b=NXB5bp1Y2U9PCwUbkpmiNVCZ8ctiZi/Etx7sQE+HXA/4fzV49Cu77AW66bqaCaO5UUPXrGfxB7DAyWXmqUGCBAIMgrgz0vmmizj3Z6aAUm7rYeMSJeb6npCRWJHC/t+ErbAdxMRTSpdGV06JThKUnsk/WuYNjsyv+Q/odc2jrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379563; c=relaxed/simple;
	bh=iR8/nL1o84bZpx30i3LrclT5slLiA8fLcmGJMToQCcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iDkBe0DnpBGfpd/eJCnOI3b+07Ccxh20zSRGxMOFyTU+qCFGn7omlVQweDabXBin2NLW8/PROSr+oO5GqFs6czrghp40fkQCdwk61hbm8TRZe76UhnLjScmCnVjKsgoP3jReF3VQSSB1AYSqaWUspE6hF9aN4OJPRTaTrXlbY0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GTrrDhJY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GTrrDhJY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eBQcSElaZkcEckJKB+BTczHiIJy9qDtRsMfhC/jg6FM=;
	b=GTrrDhJYShNuzvvhOO8lyA15k0MbfEWwx+rNRWXskj9HBudnltckctK6eAovYc6i99Yu62
	Dy9qTk5mM72h1u0s05oadi9vbsEInctMhxvUSATDlCm2pr0WhAZmog+nqAInNMs4BWZ18y
	MeKk63MfcPGAiBonczIjqH3rAws5oWc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-rlCn2vM5P46IzC_R91aRCw-1; Wed,
 02 Sep 2026 16:05:56 -0400
X-MC-Unique: rlCn2vM5P46IzC_R91aRCw-1
X-Mimecast-MFC-AGG-ID: rlCn2vM5P46IzC_R91aRCw_1788379553
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC14C1926B6E;
	Wed,  2 Sep 2026 20:05:52 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1649D1955F02;
	Wed,  2 Sep 2026 20:05:48 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
	linux-block@vger.kernel.org
Subject: [PATCH v2 0/7] nvme-fc: FPIN link integrity handling
Date: Wed,  2 Sep 2026 16:05:40 -0400
Message-ID: <20260902200547.184734-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This set has been split into an NVMe set which adds marginal path
handling and a SCSI set which handles decoding FPIN LI events and
setting the marginal flag. The NVMe set, this one, can be tested and
used independently of the SCSI set.

FPIN LI (link integrity) messages are received when the attached fabric
detects hardware errors. In response, I/O should be directed away from
the affected ports. This series adds a new controller flag
'NVME_CTRL_MARGINAL' which is checked during multipath path selection,
causing the path to be de-prioritized. If no other paths are available
the marginal paths are still used.

Testing was performed by Jesse Taube and John Meneghini using blktests
with the fcloop driver.

Controllers on the affected port show the NVME_CTRL_MARGINAL flag:

   \
    +- nvme4 fc traddr=c,host_traddr=e live optimized
    +- nvme5 fc traddr=8,host_traddr=e live non-optimized
    +- nvme8 fc traddr=e,host_traddr=f marginal optimized
    +- nvme9 fc traddr=a,host_traddr=f marginal non-optimized

All multipath io-policies were verified: numa, round-robin, and
queue-depth. Scenarios included optimized, non-optimized, and
inaccessible, and marginal paths. When all paths are
marginal, I/O continues based on the multipath policy.

Original work on this set was presented at the LSFMM 2024 conference:
Link: https://people.redhat.com/jmeneghi/LSFMM_2024/LSFMM_2024_NVMe_Cancel_and_FPIN.pdf

To test path handling use:
https://github.com/linux-blktests/blktests/pull/264
or
https://lore.kernel.org/linux-nvme/20260828153029.853768-1-jtaubepe@redhat.com/T/

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220329

Previously posted as a combined NVMe+SCSI series (v1-v11).

V1 -> V2:
- Changed flag name to 'marginal'
- Do not block marginal path; influence path selection instead
  to de-prioritize marginal paths

V2 -> V3:
- Split off driver-specific modifications
- Introduce 'union fc_tlv_desc' to avoid casts

V3 -> V4:
- Include reviews from Justin Tee
- Split marginal path handling patch

V4 -> V5:
- Change 'u8' to '__u8' on fc_tlv_desc to fix a failure to build
- Print 'marginal' instead of 'live' in the state of controllers
  when they are marginal

V5 -> V6:
- Minor spelling corrections to patch descriptions

V6 -> V7:
- No code changes; added note about additional testing

V7 -> V8:
- Split nvme core marginal flag addition into its own patch
- Add patch for queue_depth marginal path support

V8 -> V9:
- Rebased patch series to nvme-6.17.
- Added patch from Gustavo Silva, "scsi: qla2xxx: Fix memcpy field-spanning
  write issue", which resolves the field-spanning write issue
- We decided to leave the "marginal" state as is, because the transport
  driver uses the term "marginal".

V9 -> V10:
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

V10 -> V1:
 - Rebase onto 7.2-rc1
 - Add marginal support to fcloop driver (new patch)
 - Rewrite multipath handling ("nvme-fc: marginal path handling") and
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
     `struct nvme_fc_remote_port` instead of wwpn and wwnn
 - Rewrite the "enable FPIN notification for NVMe" patches
      to use the new callback methods.

V1 -> V2 (split):
 - Split SCSI and NVME parts.
 - Rewrite path handling code.

Bryan Gurney (2):
  nvme: add NVME_CTRL_MARGINAL flag
  nvme: sysfs: emit the marginal path state in show_state()

Jesse Taube (4):
  nvme-multipath: numa support for marginal paths
  nvme-multipath: round-robin support for marginal paths
  nvme-fc: add nvme_fc_set_remoteport_fpin()
  nvme: fcloop: Add set_marginal_rport to sysfs

John Meneghini (1):
  nvme-multipath: queue-depth support for marginal paths

 drivers/nvme/host/core.c       |  1 +
 drivers/nvme/host/fc.c         | 17 +++++++++
 drivers/nvme/host/multipath.c  | 70 ++++++++++++++++++++++++++++++----
 drivers/nvme/host/nvme.h       | 11 ++++++
 drivers/nvme/host/sysfs.c      |  3 ++
 drivers/nvme/target/fcloop.c   | 50 ++++++++++++++++++++++++
 include/linux/nvme-fc-driver.h |  2 +
 7 files changed, 146 insertions(+), 8 deletions(-)

-- 
2.55.0

