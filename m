Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE13181BAE;
	Wed, 12 Jun 2024 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718211201; cv=none; b=DGj7WsY36RRuJNioLvvGCWoKui6pmTD5FjYJB1xVCFrqAWqBYX+lnb4ULlCRtZtl/BmupAoXK1ylV5BVHJYkPquD2Onr55KoVNgfIydOTTAoLqaYuD+dx5cnkG8zc5AVxhSvM/ppstMF7s21eL02Q0WUSKLel1ClKSunPTtLIQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718211201; c=relaxed/simple;
	bh=BgI2Qfg+ZHlXmF1l434ZjiNv91MSMDdP8E4X0CC/qyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fx7jyLaTqC17OyVtpB7yUd/cmLavQgz4Z+yJ/ek3Rd5aF7+wQ2RIqS7k8TXhDjGw8LUziBDKltX9vhXfIRp7lE/laPquo0IjG9toOuG8sUT+lHBauzwlWhGs4NQkrLA3isBKw6JtsGut4nsANiRzpinpZhZHz0sWBUufIr0nkGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gGyW0CEW; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gGyW0CEW"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzs6x5xqJz6Cp2tZ;
	Wed, 12 Jun 2024 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1718211191; x=1720803192; bh=ja65RPmAsYQ4wtG5tAMncT4tzoRsc4drTGU
	2fNccyQE=; b=gGyW0CEWy/7RW0dzTcENI0pO+oBugDjGo2BAQJu8LGPBoGKK/Qd
	qknLYVPIImfM1k+6GWcg1PjXdytj03ggqQUNdtefbeebjImVv0lUQK3nfEhLXi1R
	2J9VcSZoW5PL/ankcL++R0PKTTQt3eTG5YJkhs3foL9myeBDSonn35llGnXyRquW
	YdWBVr/Kyz+InC8G2XM7MqeQV8gkzVWfPtY5I4aGIOOBziy4m4l3hmdeTq3bNpjH
	Sg2fmHWyekhrtiCHx1bI1LThGtw0W8TNBWaV0gJGldtSbmpQhdAuYpbZ0GV68ZkM
	Zyd6p/RT/Sq2GhYNe5VEGAeplP5E04KRikg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DsBOtPlFHF6O; Wed, 12 Jun 2024 16:53:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vzs6v2g5Dz6Cnk8t;
	Wed, 12 Jun 2024 16:53:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/2] Do not read the IO hints VPD page from USB storage devices
Date: Wed, 12 Jun 2024 09:52:47 -0700
Message-ID: <20240612165249.2671204-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Recently it was reported that reading the IO hints VPD page makes at leas=
t two
USB storage devices crash. Hence this patch series that disables reading =
the IO
hints VPD page from USB storage devices. Please consider this patch serie=
s for
your scsi-fixes branch.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
  scsi: core: Do not query IO hints for USB devices

 drivers/scsi/sd.c              | 4 ++++
 drivers/usb/storage/scsiglue.c | 2 ++
 include/scsi/scsi_devinfo.h    | 4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

