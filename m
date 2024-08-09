Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAD33D6D
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 19:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723231903; cv=none; b=fQVgSg/c+05P24+BVzwGcZqD3J/P1qJF/Q1rHXPnpY4N1R8MBGpoikEJ8e7hQRtW28QhJqzbqYKd1XhQmjS8Yv9YxJj1XiBqTO1N8dPnUra4yAVMeIg2RXXVfqs25USmfBTrTuVBOhzRkH4XGhBEuhAsQyaytCMlcK0FYn7axtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723231903; c=relaxed/simple;
	bh=vwruTUhYIEaxxeJzr0s0cBuQlRRHPnlEYIkTPAmrWo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O3pxx65bcFGQ7uNiUo8RfNUaCOdMIN3SJ1lAkddFVh2hdV4DRRPFb6dTZAqueUPv/AJ7+1bm+QoejVQhpGVeyCEu7Rrwo4xaqCjUtm1wVD4cyNbfG9kYgOpeQI2rjbWhqf4exH4uGWGQfsnmsuL3Fkv279tQ7ToNFlQ7eZNiuLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W1AUnpoJ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W1AUnpoJ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgYv11DDyz6ClY90;
	Fri,  9 Aug 2024 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1723231899; x=1725823900; bh=ExmNx25lH30xTAoeaTNz849a3Y6PXMsV/Av
	5c6qc6t8=; b=W1AUnpoJPuQfpvtqRo+9nWVANKjGSsSdsx4jv7BNzI4ccZLsu14
	cx4KxknCLposktAKPEfk9BUBfhnlCr116IUDARMRdnhdZUnYfISOxtj0MlyAFUkY
	SL/Xl3gisGDw4tMSkmZxWJgomxFfJi1kBD4oGQM/HpqTQW70qccWlrnlnrYFZMMr
	enxlKbafH41F9ZlbUIulm7XV7bQNcIeVSTzAS64aWVnnsr63fCn+M6A+YHUH/GD4
	Gg+FzA9WURY0xlSesN9z7sDOPzpBUo61aBjbw7v+2rSySeHrOczpmuAfOxZaX79g
	HtBHqgA6iIFX0n7bdA7FW3mwJ3gVApyF1Eg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 49bV3tzDD8aV; Fri,  9 Aug 2024 19:31:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgYtz3vvRz6ClY8s;
	Fri,  9 Aug 2024 19:31:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Fix system resume for SCSI devices
Date: Fri,  9 Aug 2024 12:31:12 -0700
Message-ID: <20240809193115.1222737-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes a particular type of system resume failure for
SCSI devices. Please consider this patch series for the next merge window=
.

Thanks,

Bart.

Changes compared to v1:
 - Renamed SCMD_RETRY_PASST_ON_UA into SCMD_RETRY_PASSTHROUGH.

Bart Van Assche (2):
  scsi: core: Retry passthrough commands if SCMD_RETRY_PASSTHROUGH is
    set
  sd: Retry START STOP UNIT commands

 drivers/scsi/scsi_error.c | 5 ++++-
 drivers/scsi/sd.c         | 1 +
 include/scsi/scsi_cmnd.h  | 5 ++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

