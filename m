Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1DE10A22
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2024 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287644; cv=none; b=u5JAi0Lx/ZyyMfTU6MEEuX38duMCyQlSTwkG6DoHrE1lFMX0qQSCyI2LcDXZqEXFXecdbNYvmxq8yrX4lKFbKICe9uxOgSqekVW3nip3pjihTImw9H0wltZbjAARjG7xg7jKKOk01UrHZmpGiA1QvOzb7WPELRdCppdkjY7ubIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287644; c=relaxed/simple;
	bh=TcRvrIWTYcUIzgCA/YaTxBjf4H5PQT5txEWv1hb7vmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JischDF3Go1xKCQQkOr+Wz0bA0NxEjeBGx9tNf5DCn1G7tWgc3RFLK91Qd7TZTBqzR084kIyyulvGH/It0SpaooahL8C2IDD7IRa7/OcEdSc0bbzARcxKE0Kg/NNgolu8jGDLdoqy3Qfy0/zLI94Ss8cTcf6oSSyKqFfAobASlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gnIXKxPK; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gnIXKxPK"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VJrHG2Yhtz6Cnk8s;
	Tue, 16 Apr 2024 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1713287640; x=1715879641; bh=RtSxV
	3yc6ZQrbnFIzvzWHP5wFPwMgoFQ3+Yet1veUxc=; b=gnIXKxPKrNp2siziX8zTJ
	MQ8WA3+Qz9xGUgFc3owMyYhX+Lu/eaFMmuAVt6b3L+uLZ80v692+WBgiTSYiuZO/
	652KC+W3FxxScLF9YNADhn3kH92N1M3qrfZ0DjqVUdyNbT0oNAeshDpWv0mPEpmV
	Zne68wdOvtr0Kn7sXPTDyjt8hg7bdQUNg6QYZ3pU/wIpqZaKzOJZCd2btShPCIi1
	1TlKi80+Akjwn3BEJjd2K+4/7irBnEYC29uxPoJjSvz/Kt4VAq4aaQR0R7bAOWCz
	0lScekc7/dsSOVGFpt3y6HzKv/LFpnFEsdIaU0ulJ2961MEmYppvUVC8mIlBQ84X
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fzz6s3y1rXyD; Tue, 16 Apr 2024 17:14:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VJrHD5F6yz6Cnk8m;
	Tue, 16 Apr 2024 17:14:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] Fix a rare crash in the UFS driver
Date: Tue, 16 Apr 2024 10:13:27 -0700
Message-ID: <20240416171357.1062583-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Sporadic crashes have been observed with the UFS kernel driver if a timeo=
ut
occurs. This patch series fixes these crashes. Please consider this patch
series for the next merge window.

Thanks,

Bart.

Changes compared to v1: fixed a build error in the MediaTek driver.

Bart Van Assche (4):
  scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
  scsi: ufs: Make ufshcd_poll() complain about unsupported arguments
  scsi: ufs: Make the polling code report which command has been
    completed
  scsi: ufs: Check for completion from the timeout handler

 drivers/ufs/core/ufs-mcq.c      | 25 +++++++++-----
 drivers/ufs/core/ufshcd-priv.h  |  6 ++--
 drivers/ufs/core/ufshcd.c       | 61 ++++++++++++++++++++++++++-------
 drivers/ufs/host/ufs-mediatek.c |  2 +-
 drivers/ufs/host/ufs-qcom.c     |  2 +-
 include/ufs/ufshcd.h            |  3 +-
 6 files changed, 72 insertions(+), 27 deletions(-)

