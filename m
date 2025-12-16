Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14FB21CA03;
	Tue, 16 Dec 2025 22:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765924270; cv=none; b=QG2tbkpLjwn9e5qRHyWAVASXIZPr9VAeJHTLG/fRQf1yGyw4surCk1SFutLRxaIi7a0m2CvlC9jTsH/Jc7pvYreRCnTSr35CPgjbmRYNS4kwJmvDIgn5Z4tCghg4sZjsjAoJ3BGWI7IKWMLw5yTOAYiC6lFWVAKSOTqt1CyajGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765924270; c=relaxed/simple;
	bh=rrOOt5jDSGAroermPfgjMZ9+gLj/vfpTurs6uUNe0j8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XFP6v1nxtTkZtDXmyaEomEXN9R8a9VKUXdsTe4g8CVoEp8KOMLsRIh3N7Tm3wt0vShlvRSjqAoq7hq4CiFeJaUcCh+R+RJK91BYtDV6S7FQeytQjt+DYWOrq4x/5sIfBlihtPbnBmmV2jt8h28zCL2tUQ6NzMnkgVHVLsWb9Cxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yBsc/qbw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yBsc/qbw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dWBV305ffzmP4v6;
	Tue, 16 Dec 2025 22:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1765924265; x=1768516266; bh=JpvvrnUb4niVYXwpcJrNRd9Hv6ezMChpZX5
	+Y4oC0jY=; b=yBsc/qbwJVN2FDjUtR1Dh9+m2SzDJqrrE/I97Y5ViBr4vXcvbD2
	aNZd/eKS8gKZ0zIijhiXhgIHKaIaJs8khkgUWOD3NZNrqCXdAJPCxrfPLgLP0L1T
	ISQaBAI70MCSJIzExsMs6n129HLYL70GLoJ21vUurOgLU+c5Wv6TYUFO1+pZHxrB
	o5FyRH8oAzif4/pfaXMLfFP/26RNkKouFN+PZImZkmngpGtEjj7GjJag4etm4Ohx
	MPXRPUP/2uEHMX04EeS647KcPF9Fa3+41+A+081VQ5hc+ufoZVwVsNQJFLAVPhV4
	tiIGzkwhD+5zWDBF/g0HKVXAOqzTbK0vNog==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4ENXOX7678P6; Tue, 16 Dec 2025 22:31:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dWBTz2qCwzmKtSM;
	Tue, 16 Dec 2025 22:31:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/6] Increase SCSI IOPS
Date: Tue, 16 Dec 2025 14:30:44 -0800
Message-ID: <20251216223052.350366-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.305.g3fc767764a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series increases scsi_debug IOPS by 5% on my test setup by dis=
abling
SCSI budget management if it is not needed. This patch series improves th=
e
performance of many SCSI LLDs, including the UFS and ATA drivers. On my U=
FS 4
test setup this patch improves IOPS by 1% and reduces the time spent in
scsi_mq_get_budget() from 0.22% to 0.01%. The improvement for UFS 5 devic=
es is
expected to be significantly larger than what I measured on my UFS 4 test=
 setup.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
 - Instead of removing the use of cmd->budget_token from the ATA core, in=
troduce
   the SCSI host flag .needs_budget_token and set it from the ATA core.

Changes compared to v2:
 - Fixed a hang during LUN scanning for ATA devices.

Changes compared to v1:
 - Added three block layer patches to introduce the function
   blk_mq_tagset_iter().
 - Applied the optimization not only for host-wide tags but also if there=
 is
   only a single hardware queue.
 - Renamed scsi_device_check_in_flight() into scsi_device_check_allocated=
().
 - Added support for set->shared_tags =3D=3D NULL in scsi_device_busy().
=20
Bart Van Assche (6):
  block: Rename busy_tag_iter_fn into blk_mq_rq_iter_fn
  block: Introduce __blk_mq_tagset_iter()
  block: Introduce blk_mq_tagset_iter()
  ata: libata: Set .needs_budget_token
  scsi: core: Generalize scsi_device_busy()
  scsi: core: Improve IOPS in case of host-wide tags

 block/blk-mq-tag.c         | 67 ++++++++++++++++++++++++++------------
 block/blk-mq.h             |  4 +--
 drivers/ata/libata-scsi.c  |  1 +
 drivers/scsi/scsi.c        |  6 ++--
 drivers/scsi/scsi_lib.c    | 38 +++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 20 +++++++++++-
 include/linux/blk-mq.h     |  6 ++--
 include/scsi/scsi_device.h |  5 +--
 include/scsi/scsi_host.h   |  3 ++
 9 files changed, 116 insertions(+), 34 deletions(-)

