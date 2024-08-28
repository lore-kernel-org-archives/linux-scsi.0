Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C8E2868B
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724867101; cv=none; b=e3tTFaqakD/JaaynKuEyEyc1tRxMX8e2U3zBihmE8DGbUcEmmjfen2jhOTF6Kj0s8gxQwfxEQ8S2Z502TI9xnt9WYePbXKF5iXURV5i8UXi8beT7zDzjfdboOtkXLs9ycX7jzKriBOCzu2FY0XHO+Xbz/CnjNP+zdNOOoTQxN3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724867101; c=relaxed/simple;
	bh=tE31/GIvl0nZIoUEg0+PRZqOLw1A2SOUb2160qwOqc4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TjyggqNKEwxiv+tNQAkRaJoKM6w95V/tOrFyUHF/HyQQge3s3Uv86vMM4Ale+MzkETCKOm2YJH2a+12jwW2YyTe+ld4kVEWpVS/+oSkRSxD3KHr4V/bRJtTBik/bbggPbPPpLfvewlUBRO37PYVgxK4lxwDyPz3QBCrz3R5s0hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3iaW1fgP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3iaW1fgP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WvBd72DY0zlgTGW;
	Wed, 28 Aug 2024 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1724867098; x=1727459099; bh=kVfP3ICC22O3ZJBCdXG8PYroavZ0jY2BkGw
	i+2XLQiw=; b=3iaW1fgPG/7kZ1YE0ZGBOLIN7ydB4MWsdX7Icr3xf/LtzGM9deX
	JGOOxA1QxJQjCp8Nvu7FYdkpOonuYafIjY31XcaerZRuwB2TVheGUNT27Zw1Qf0p
	XXM8lGW6wGOGbiL29H7OrYpk2b2E+o9RxhsZZdW1ovo3XfQfYvhwZ73yFp3jV+Tx
	k7aJPFB0aWeLvH74GkuhciPqxr8kziT0V89jdfbLlBR6S2wj9KwSWkY8huXjOs0i
	4VTOn2gPRRpWPUypmOubA1rwb9DSCm0scpfxlipFoEi3pYuZFiw7cGkCofCSDtCC
	iP7mRHmgSJnXzdptBS/vVP8IebBbk8KdR4A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NNIdwzcRm-03; Wed, 28 Aug 2024 17:44:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WvBd55XqrzlgVXv;
	Wed, 28 Aug 2024 17:44:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/9] Simplify the UFS driver initialization code
Date: Wed, 28 Aug 2024 10:43:52 -0700
Message-ID: <20240828174435.2469498-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Martin,

This patch series addresses the following issues in the UFS driver
initialization code:
* The legacy and MCQ scsi_add_host() calls occur in different functions. =
This
  patch series reduces the number of scsi_add_host() calls from two to on=
e.
* Two functions have a boolean 'init_dev_params' argument. This patch ser=
ies
  removes that argument from both functions by splitting functions and by
  pushing some function calls from caller into callee.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v2:
 - Improved several patch descriptions.
 - Moved one source code comment.

Changes compared to v1:
 - Fixed a compiler warning reported by the kernel build robot.
 - Improved patch descriptions.

Bart Van Assche (9):
  ufs: core: Introduce ufshcd_add_scsi_host()
  ufs: core: Introduce ufshcd_activate_link()
  ufs: core: Introduce ufshcd_post_device_init()
  ufs: core: Call ufshcd_add_scsi_host() later
  ufs: core: Move the ufshcd_device_init() call
  ufs: core: Move the ufshcd_device_init(hba, true) call
  ufs: core: Expand the ufshcd_device_init(hba, true) call
  ufs: core: Move the MCQ scsi_add_host() call
  ufs: core: Remove the second argument of ufshcd_device_init()

 drivers/ufs/core/ufshcd.c | 268 ++++++++++++++++++++++----------------
 1 file changed, 153 insertions(+), 115 deletions(-)

