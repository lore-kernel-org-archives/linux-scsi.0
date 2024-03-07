Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96143241E9
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 20:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843430; cv=none; b=LBmQTmf8w7/Y4kRPaVvTTM5V1imIshSJ2rb9HFB3QJCSQUkW562bBV48kfcfjdZ6iCStBpKcvWsnh6RmX9IPM6VOxZorAHbtZ8Z2IWS3K0myD52i8LE9Hr+ZKPuHdlVKTK9NT5eFjkyFH9e4FkbjWP0bcscYb5EkI6t9pnTi6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843430; c=relaxed/simple;
	bh=1wMn6n03xItkS3U7hbZkqr93+wFGzctkNiSgGb/PDIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SY24Qbgqu5UnMnPPRrAsSc9VyL+yNFxdEy5EzZJu8b66BhKh0+tGIRDPh8qXnNoBaws3BfNXRmohiHJ0ocgucMCTuphMhpMVtxIlpdH6FSujNrWFp77ti/uwRRSoafdaJj5xYaCXrzrQGtlJ01c30syvCADeUrISAjqCK1SIexs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YDIxYvXZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YDIxYvXZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TrLXG488Sz6Cl451;
	Thu,  7 Mar 2024 20:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1709843421; x=1712435422; bh=lqdeRNa/qnKaKeul56m859uYEZ71b9N6s8u
	VzNV7ce4=; b=YDIxYvXZAjMKjaEvWY6jTfbif4B6vS77bKj9ZOJdAxUnrYRebDQ
	nRdu2kTiePp3JYTuXcWGl+pEye3V1IAH/E932UKvRRe/f2TDYEsI/alz8PYfj7X6
	x+xlvnb3eLZUbQ8HV+4j/geqjqO5xZjU5ZUlgCC4l6Hdr2JUncib3haydn8zY4a5
	Jg5/yDD3+AQIYuNbCxI7fMznj/YENdcrovIsAzHoI1tmqdrQNydafpymwMdrZ2Kv
	cLmCYNHHb7ZinwmkQt7mtVozjJLjvExvVtMmgqphYPgY2+k8XsyJxDjtsUxBZivr
	zy1wCtDeCK2mpSDZMbuP7jHt8W8JZL7akXw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LsDxHbRNIDVF; Thu,  7 Mar 2024 20:30:21 +0000 (UTC)
Received: from bvanassche-linux.mtv.corp.google.com (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TrLXD2qwrz6Cl450;
	Thu,  7 Mar 2024 20:30:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] scsi_debug improvements
Date: Thu,  7 Mar 2024 12:30:03 -0800
Message-ID: <20240307203015.870254-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes a bug in the scsi_debug driver, simplifies the
driver and also splits it into two source files. Please consider this pat=
ch
series for the next merge window.

Thanks,

Bart.

Changes compared to v2:
 - Converted a single patch into a patch series.
 - Addressed John's comments on the patch that splits the source code int=
o two
   files.

Changes compared to v1:
 - Made the patch description more detailed.

Bart Van Assche (4):
  scsi: scsi_debug: Remove a reference to in_use_bm
  scsi: scsi_debug: Do not sleep in atomic sections
  scsi: scsi_debug: Simplify command handling
  scsi: scsi_debug: Make CRC_T10DIF support optional

 drivers/scsi/Kconfig                          |   3 +-
 drivers/scsi/Makefile                         |   2 +
 drivers/scsi/scsi_debug_dif.c                 | 240 +++++++++++
 drivers/scsi/scsi_debug_dif.h                 |  57 +++
 .../scsi/{scsi_debug.c =3D> scsi_debug_main.c}  | 399 ++----------------
 5 files changed, 333 insertions(+), 368 deletions(-)
 create mode 100644 drivers/scsi/scsi_debug_dif.c
 create mode 100644 drivers/scsi/scsi_debug_dif.h
 rename drivers/scsi/{scsi_debug.c =3D> scsi_debug_main.c} (96%)

