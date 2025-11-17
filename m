Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E51527FD68;
	Mon, 17 Nov 2025 22:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419945; cv=none; b=ul8jbO8/tLmi6ZzehlcY++JnP7cRns4Dan7cMUnhE6d0XJ3cF0P+j+NWkoYGL1ESIo4ptAxxMLdDzJ+9Z1HpLn5lrhaMkXbUmVV9Pn0ySrO9tHLHhWoYqAwRf7wAMFsjnhFESzJRJ1MuuHaR96pWMnEVvpRCgjyG5k5NnfKJpSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419945; c=relaxed/simple;
	bh=TF38RrYx4GJ/AHaMtGhTB8Eo+GNSWQqfu1k6Y9U1OLs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GzWcsP9ElusHsJSzoJ/vl0wCO9nhoSkvrzf0rT+krnn0Ps0g0vPtL+e+swnzLOwtywhpx6aVUoBTR7hWZHRRAEZDa1AxuGZXc4kcQIwFPVCAkZ0IZMLRnB1hgl85XLM7qZoGbTelTzSfAGunyJ28EBLFFx2Y5X2mwIpYbKPO3Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wwj8fLpk; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wwj8fLpk"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9NKy37HLzltP0N;
	Mon, 17 Nov 2025 22:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1763419941; x=1766011942; bh=OVWpBbPDygsM8YOXySmdwiTT6uv0b6Vw3lr
	jIOeul9M=; b=wwj8fLpkscrreyYRrBOSWYOFReuaCz+OdNmi2ch4RXr0IO0q59d
	iPahlK8lZAvrbDXdqCF40aHl9YKmOdD14P2bpp9V7nzcH/IjwtaP+Jxl1tvte1ds
	RetaAPAtib+r9v/YxgHqCC9Qm3KF5SXobcCNvLWvuEAe8TZXUjGu0Z0qnSnlpRuV
	Vwu0poFh/RG4rnVBuryCt3Ixl1bBp01GcL1dFuccHm1SCFKS4fzxLUYeG0C1gYD6
	4PCvgPo/LeukjRUU15ijZUtXo/8pfdcrFdVSYuHHRyc+N4EVCm62V7ILMnHARVRY
	TRlQsu+vzOED9kmHEmMWkyUMh6bg0D4NeDQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VErRDMu4Yjij; Mon, 17 Nov 2025 22:52:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9NKs4WKzzltNPF;
	Mon, 17 Nov 2025 22:52:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/5] Increase SCSI IOPS
Date: Mon, 17 Nov 2025 14:51:59 -0800
Message-ID: <20251117225205.2024479-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
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
SCSI budget management if it is not needed.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1 (https://lore.kernel.org/linux-scsi/20250910213254=
.1215318-1-bvanassche@acm.org/):
 - Added three block layer patches to introduce the function
   blk_mq_tagset_iter().
 - Applied the optimization not only for host-wide tags but also if there=
 is
   only a single hardware queue.
 - Renamed scsi_device_check_in_flight() into scsi_device_check_allocated=
().
 - Added support for set->shared_tags =3D=3D NULL in scsi_device_busy().

Bart Van Assche (5):
  block: Rename busy_tag_iter_fn into blk_mq_rq_iter_fn
  block: Introduce __blk_mq_tagset_iter()
  block: Introduce blk_mq_tagset_iter()
  scsi: core: Generalize scsi_device_busy()
  scsi: core: Improve IOPS in case of host-wide tags

 block/blk-mq-tag.c         | 67 ++++++++++++++++++++++++++------------
 block/blk-mq.h             |  4 +--
 drivers/scsi/scsi.c        |  3 +-
 drivers/scsi/scsi_lib.c    | 38 +++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 18 +++++++++-
 include/linux/blk-mq.h     |  6 ++--
 include/scsi/scsi_device.h |  5 +--
 7 files changed, 110 insertions(+), 31 deletions(-)

