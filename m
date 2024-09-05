Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951C21863F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 22:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573745; cv=none; b=rlPU8jXX07k92pZCYb4b29T/zqikdyYc9l+iiMAfozCiZbbmqLfczF6pmNOC9YxF/AiK6j0eSZ7WWueBwWIV7BKWvU/pG/BojDjzfF6MipxpA825oCWP2gk4bGan2GOZMolb62/X9kUmwWPyerttZnjuT3Uww7bkHj+TBVrJuaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573745; c=relaxed/simple;
	bh=v7ETuhD9oXWPIXPAD/y8M0F9av6RiJoXwmXukWScqJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pWXfz3NprwqC+vChyi0SV/SaqY/KCy1sQgZEedOz+KwvlUrePV/Gy+xKXxdxXRNbkjS9kGZ6Y4dBF9sG6u2TcneC3B6TnbLmM/+WjUQN5y5pnZp2Ijo8i/D2oIQgLmkbIzVgVmuUgbs1ZIpXDTh7bFHrEp+f1N8vR9lAPMSiJqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=leQ9pp9P; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="leQ9pp9P"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X0CyQ6bBxz6ClY8x;
	Thu,  5 Sep 2024 22:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1725573741; x=1728165742; bh=d3ogksf1PvuRZ7I7pWecLQcDPiYEPEJ4FFV
	a9H8385c=; b=leQ9pp9Pdpa5HHSnLsd++xLLwuJwisXICTq8SR9N7c63Vyh4uJz
	vfESgW2P/AUzPHVP/J7A7HBSpBXitmziy4U8RkwXAfVHcvm0/oaRSDtv6NlpIwJT
	8Y7uTVXzz0QXX88cEOEOg32gCRQQyZ/rr6D32OIyS0971Tl1GYYoPqGrPMy3gU+U
	ReokJQbnkiGsKPQbs+R62u9386vrEarzjFtBJg+gPyeIFEnxhlL39iZTNg1DRcu0
	EkkPYZkRgtwIX0eACN47wsa5JkVmC+azdQi6b1qsgUSSlbDE272nwhUECmkIzGM6
	y1nvC77fiOLwBT5v7WnphJbdhqKWHjJpKhg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6PixMLoe_LQK; Thu,  5 Sep 2024 22:02:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X0CyN72tKz6ClY8w;
	Thu,  5 Sep 2024 22:02:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/10] Simplify the UFS driver initialization code
Date: Thu,  5 Sep 2024 15:01:26 -0700
Message-ID: <20240905220214.738506-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
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
e
  and hence makes the UFS driver easier to maintain.
* Two functions have a boolean 'init_dev_params' argument. This patch ser=
ies
  removes that argument from both functions by splitting functions and by
  pushing some function calls from caller into callee.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
 - Split patch "Move the MCQ scsi_add_host() call" into two patches to ma=
ke
   it easier for reviewers.

Changes compared to v2:
 - Improved several patch descriptions.
 - Moved one source code comment.

Changes compared to v1:
 - Fixed a compiler warning reported by the kernel build robot.
 - Improved patch descriptions.

Bart Van Assche (10):
  scsi: ufs: core: Introduce ufshcd_add_scsi_host()
  scsi: ufs: core: Introduce ufshcd_activate_link()
  scsi: ufs: core: Introduce ufshcd_post_device_init()
  scsi: ufs: core: Call ufshcd_add_scsi_host() later
  scsi: ufs: core: Move the ufshcd_device_init() call
  scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
  scsi: ufs: core: Expand the ufshcd_device_init(hba, true) call
  scsi: ufs: core: Move the MCQ scsi_add_host() call
  scsi: ufs: core: Move code out of an if-statement
  scsi: ufs: core: Remove the second argument of ufshcd_device_init()

 drivers/ufs/core/ufshcd.c | 268 ++++++++++++++++++++++----------------
 1 file changed, 153 insertions(+), 115 deletions(-)

