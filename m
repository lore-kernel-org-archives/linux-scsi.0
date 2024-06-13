Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C3E13D243;
	Thu, 13 Jun 2024 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313537; cv=none; b=Kq1muucsxrCkgHsfCpQRw9VTTxLDr4JCik9XZRUjVIdYZRHZ21qe0flvnWBktBqM2E164W2V181oOg4f5WJ1oj9ONm7x/ekB5uZhmtrR2ydqgDh2caz8MI9KiPk0Va9ZiokcnsRv0PMx37xaU7BnlMy0xi2RbxFYOrg9Qw6rbSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313537; c=relaxed/simple;
	bh=K+amnAHMXL7ZbOYHmjXNkiAUGZB4Ot4Mc5KO6tpik2o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mlj7SoKM7OpLUxTCBNDtNa3GrnoPe8paX4SgqFtzb5ENgSPdS6MqAg1CjkHKN0+t6jNCIhJ1Yem7De2LtolHynIyL9HIBPamDvSOu9tHAAK3ot49kH8u4wlOKOnRatrgUoIaAvHW3jeDgKea8Fv6jRJqknn+Fw40Ukpx9hvEjHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RjcuLnM7; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RjcuLnM7"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W0Zz30tHTzlgMVg;
	Thu, 13 Jun 2024 21:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1718313533; x=1720905534; bh=lf9Wv4l+dRLmfjFPmsEPJ8T05zmFhS1wPjB
	F1wCJhFg=; b=RjcuLnM7OmdniK+9Ah/ECaCDMg0PAmP6djiyeecjxV5q7/d8ql+
	A+G3K82N+0ns0skx5HWCpsLmrBGllWWIBqCLxb0pYnyrE9oDU0LgxGmoGyGh6u+R
	hIYHbmpcdOmGHt78oa0ZpiiFzaKAMsys+IPxex2iZccg5Cv5uCIRY/InmL3WJWjJ
	fYD9jdO/C+wKBVN2bid0nrkxViY7xgCG6Ms6P32QS3Ykf6Pvhnd8DLvuiyYQCV4g
	A0Wm47KuSqlZIy/wZiZ39UlUdRhIkWibq62ZmPO0RPtiumVxxkZazU2+WbielfaR
	VC6BJGeGaMKNuWI3T0tToNw63cjcPWCYB2g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id e0MnTJuWazZ3; Thu, 13 Jun 2024 21:18:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W0Zz05ZCQzlgMVV;
	Thu, 13 Jun 2024 21:18:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/2] Do not read the IO hints VPD page from USB storage devices
Date: Thu, 13 Jun 2024 14:18:25 -0700
Message-ID: <20240613211828.2077477-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
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

Changes compared to v2:
 - Changed "IO hints VPD page" into "IO Advice Hints Grouping mode page".
 - Changed "scsi: core: " prefix for patch 2/2 into "usb: ".
 - Removed redundant Cc-tags.

Changes compared to v1:
 - Also set the BLIST_SKIP_IO_HINTS for USB Attached SCSI devices.

Bart Van Assche (2):
  scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
  usb: Do not query the IO advice hints grouping mode page for USB
    devices

 drivers/scsi/sd.c              | 4 ++++
 drivers/usb/storage/scsiglue.c | 6 ++++++
 drivers/usb/storage/uas.c      | 7 +++++++
 include/scsi/scsi_devinfo.h    | 4 +++-
 4 files changed, 20 insertions(+), 1 deletion(-)

