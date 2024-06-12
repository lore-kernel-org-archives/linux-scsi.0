Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971512F50;
	Wed, 12 Jun 2024 20:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718224666; cv=none; b=fajykIvJH1UWNIhN+m5BGzGgoIPJ6+vUeJSghaLNDhOusOwdRY2qFCQdcxlY9GHxENxpDwhf47iHZia7QLza6963XyDxddDo4Tx7Y8ZSCR1w+egU3ay+dt53sqdVoDWTTJFcgXFtxtvuX9n0jdhFsVxzksF7jlv+cZ0DrZYUl/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718224666; c=relaxed/simple;
	bh=GnJk4UZAX5oFSBXdoOueGQfU+JgettK7xNaztM/tXFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SWE76jsVlP8D3xodjA9GiB6z6qMCys9UyQhYk0xhp81P/CnIt+HQ4nMD5l8Tb7gpv150RTk+r9dpSvUWfluC78kuByyAjuUmWnVovtC8fUZywbao8/6yHotrQDzMBUnrtbr7FFxoUULlBCOoX+H0X7phPaJw+3Bh7QD8zrR94do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YTDkMFNn; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YTDkMFNn"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzy5z5f00z6CmR5y;
	Wed, 12 Jun 2024 20:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1718224661; x=1720816662; bh=ReW8YQsh0vnkHqXgrSb8mIR6jO6V+3eTiTT
	WZYW1Mfs=; b=YTDkMFNnS+JKICaFARpDtY3gha/5Twb23hEpCPSbcT/Nt/extng
	iZwDaWpfdCBPsBgm+sb64M8lmHleqI70YBWE1a8FYMna8gf2QNE8Nm2CHi9cQVRc
	wbRwOgK9nG52u7AUkyc+Vk38/FkgaKATKuUd9SSz18NmzWpDKVwG37QgEpYO28Ve
	QniSBfOl8MAyk14WvkNxLuKBPoXSThSDJBL8K3GUHI9jcGMBdIhj3ocQXCX5lO04
	1IN8cwxpRXyvJoqBk0i9oS9zsOQgxmlbPqWsgkZFJos2mpmzGw/UdG4LWQAMyDiP
	T18K2aYnJ/28G4YgVZA1bGY7nbY4sS3lq6Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N1EqzgRdyTVa; Wed, 12 Jun 2024 20:37:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vzy5x1r5Zz6Cnk9Y;
	Wed, 12 Jun 2024 20:37:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Do not read the IO hints VPD page from USB storage devices
Date: Wed, 12 Jun 2024 13:37:31 -0700
Message-ID: <20240612203735.4108690-1-bvanassche@acm.org>
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

Changes compared to v1:
 - Also set the BLIST_SKIP_IO_HINTS for USB Attached SCSI devices.

Bart Van Assche (2):
  scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
  scsi: core: Do not query IO hints for USB devices

 drivers/scsi/sd.c              | 4 ++++
 drivers/usb/storage/scsiglue.c | 6 ++++++
 drivers/usb/storage/uas.c      | 7 +++++++
 include/scsi/scsi_devinfo.h    | 4 +++-
 4 files changed, 20 insertions(+), 1 deletion(-)

