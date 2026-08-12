Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AC748CD4B
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 21:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786569974; cv=none; b=e6Fkvor+sddm2VijfuqrpJ0d6Ne7dw5MdDncqbhiHTxMESLaIiYjJHPEMSbkAXIRKGKqIZgEN5m+W8Sx6d8GE7KWHGUcrP0n4y+B5HmRCq1KSctpXtmXK0PyKAjTJO9VCDu+jh6XFQo4CBsvcepFDFRkEMM27f27nyWOTgWiyhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786569974; c=relaxed/simple;
	bh=OYH2eC5Dvdkbtb22N3EJvheQ5JKxoHgfv8COm9i6bqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PltQGPhRVg2T8REwkS0Uk4SGX3fByeb+hdB8kP8W2kC6mC4CpIJ09VJQnYo15KIioCS7IHTjhyZEqM8P5OCB6tkWpM2se348WC6qr16sviKZlduHwkykhPM5x68Dt/3nsXK0Kk1a/qbK2eRDYH9JIcrC8l8+Ky9hxvILcKJKjZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MOs/U+Vx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MOs/U+Vx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hL1kJ4Gpbz1XM31H;
	Wed, 12 Aug 2026 21:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786569942; x=1789161943; bh=PPQDRTGZSE/maVaexxQKEWTVWvohhrScgU/
	7ZQljX7U=; b=MOs/U+VxmBQXndfNhI8E0R5Irkv5o4GO/reVvg5y53pixsjiwzs
	LHrF2dDp7lr8/skyt2DsTKmSio/5S2v9V5+CnPHn5YXXEnZvEzPu0u21uWqY+IZ2
	vmkVDVGUKCO8Q0UP2RQk5TMU/a07LPIxsLS0V1bb1KMPtxHAevAZgxFtgXGALWN2
	vxWIm+kSgeSVt26YcNfGAzojOGLSrN/kaJSMZ1bSKzWN8x+Bfxap9x8Ja4S6RusE
	xbF8v8CpJRmnVyUYs8FDRH5Ksumaf1ok8FaA93IxbTapJXLkHcvNaarxFkbMe/Kx
	0Ne9uSd4roTuOtfeoOGmsUXQXAG4lZ2Sd2g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x3m9vgwIXK8b; Wed, 12 Aug 2026 21:25:42 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hL1kF6DWNz1XM4TB;
	Wed, 12 Aug 2026 21:25:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] ufs: core: Improve error handling
Date: Wed, 12 Aug 2026 21:25:22 +0000
Message-ID: <cover.1786569828.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series fixes two subtle race conditions related to UFS error h=
andling.
Please consider these changes for the next merge window.

Thanks,

Bart.

Changes compared to v1: fixed three Sashiko complaints.

Bart Van Assche (2):
  ufs: core: Fix a race condition triggered by ufshcd_eh_timed_out()
  ufs: core: Do not forcibly complete SCSI commands

 drivers/ufs/core/ufshcd.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

