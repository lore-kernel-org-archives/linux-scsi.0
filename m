Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA0273FD
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901397; cv=none; b=ENksc+PXxtPRsvXhFQRcwQ8ocCs9qTbgZFW3I6M2pSHEZzsN8VSFntAv3ReEc3KWGnlowrtYtsf62NhVq21HnUAC+aCugnnnde2sWT4zSgD0GgSZKM/kgcTGw8vnSHcHyFASeoXfbG1rnZfE9LAOOiscsRQnkLpoAKVjlNTgohI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901397; c=relaxed/simple;
	bh=6Z/WBLeFk9jhL0ApAcevfyYSxzZqcePXtacPCy6cn5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FhAJBiT8M5raGQic6gdVSqvcvL6icMYO4FsQsPCJeZBJAod8yEmT9KcOiOrC7p/fhN6KKd1yLwdIFQpkq0zslG9iv7gzhTgU0tDbcmjAaoi6gJrnJKJkAB+V8hDqzI1qW9/52vcZsT/fKPGE7Uu5fgv7naSB4i87DeG24bcXoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uelpdb7u; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uelpdb7u"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WdCg73L9Hz6ClY9F;
	Mon,  5 Aug 2024 23:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1722901394; x=1725493395; bh=wamSblpFo5LsTNXD8v5mF5B8oB+HB3osent
	8mfp/wus=; b=uelpdb7uLwJ/8CSu1emAAd+74vZhqnEAe+srwQ+eVcb9fw006C2
	IFXRsqNjWGSdrigSbwlibLe3qsDwSyfv31AVm/FwBLOdv7GDEKkssp7I4Jh7gayK
	6jf+/ELGymlT81i1FVbGAbjh7rxAuu/UJ7df7f/I7fj7MzCK9e0jAjvM1FkoH4Mx
	WF5A2Uro+TcoR+/peh3wlWSJnapvj3GRIeWAbtjODFWIT5QvODVdyDLy6V0CM6O/
	INZk1c8BR2GMGv4j2WqP8WIZaxAOSz48m9p4KnLKKBlRhwRPyPxNHVyy2ct0f+/8
	lbPvxiwTLFPvGyyIQMrKVqLgUTOwvJ+sOZQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XLz2Lm5O_ZHN; Mon,  5 Aug 2024 23:43:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCg52hmtz6CmLxj;
	Mon,  5 Aug 2024 23:43:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/6] SCSI disk source code cleanup
Date: Mon,  5 Aug 2024 16:42:43 -0700
Message-ID: <20240805234250.271828-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series removes multiple forward declarations from the SCSI dis=
k (sd)
driver and also makes error messages easier to find with grep. Please con=
sider
this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
 - reduced function argument indentation (whitespace only change).

Bart Van Assche (6):
  scsi: sd: Move the sd_remove() function definition
  scsi: sd: Move the sd_config_discard() function definition
  scsi: sd: Move the sd_config_write_same() function definition
  scsi: sd: Move the scsi_disk_release() function definition
  scsi: sd: Move the sd_fops definition
  scsi: sd: Do not split error messages

 drivers/scsi/sd.c | 413 ++++++++++++++++++++++------------------------
 1 file changed, 199 insertions(+), 214 deletions(-)

