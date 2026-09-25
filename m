Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6F54D17A1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360949; cv=none; b=kSNy55nxwCaO/EyJtF1+gXPAtHbdXQZT50IewtE9SOakMQMZVhWvO+T2p0qcdwt9uzyXu50xB+g/+IYmUe9ROb1ZS5dzfDM4b1w9RLOfuCMUdcv8tFF2j9DlVwxiJm/EOv7ZUtDhNtibCcXGcv8EW0RdON0iCYbeM1K1RiQP9nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360949; c=relaxed/simple;
	bh=MPdz775N3+jcft2V8/7bM8JjQb/WljxhgclN6oyM1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUKFGuELMpvjBPwSrl+1qSing8q9JfUTfj8IvN+qCkJ5T4N/Xr9jSZ6C8LPyu6hHjtbDZ6FST1eybveMAHEBW4oRd9X7GuW7KFkbzHy3I3rWva8qM9fNsK1BRKgmxgRc5Lvw+PLQBUIShI3S/IglSAS7zIcnj9MTaF6DVAtcMq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rh/LVjVs; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rh/LVjVs"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzkC3xD3z1XM5kW;
	Fri, 25 Sep 2026 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360944; x=1792952945; bh=2q3dc
	niELjSkQaIj7lnzfifO5GLZf2MrO5zEZnWaG7A=; b=rh/LVjVs6VjtWrx2meGWS
	FF8P9fH+MzQYSDkA5oQVHhm/hBjo56/KW7WDyDMI2jKD+kce3IjFlOeTTTgcfqzb
	x32OshcvoNMZoEWNmKamvmdy7A+108whYaFMhSG+oSaeIZFJ5MprrZD+GDNX/Qlt
	DYwrIjdBfuYoS6NAam9nvEfXmMp4C9nzbkcHgce07mtJ+PHz9ccNI0tEM7u2Tttp
	62pEBvoai/R/aI7aF6ATfMycPSEuP07d9JHQJ0fWiCJQQ4co4FMZyXMYeenh+IDC
	sqgGqOFlCTKumDd7boYk5dIZQOwf4QYtZuB6omeMSJLuTbmJtBmPqcjH3bqsckwU
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OOxllL61S_X7; Fri, 25 Sep 2026 18:29:04 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzk65zNPz1XM4Sx;
	Fri, 25 Sep 2026 18:29:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 03/54] scsi: st: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:25:41 -0700
Message-ID: <fd9ee36abab86feb7b4a8e8c0cc7e84ba72fd764.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document what mutex is released by st_common_ioctl().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1ca9753cb734..8827b487de9d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3538,6 +3538,7 @@ static int partition_tape(struct scsi_tape *STp, in=
t size)
 static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *ST=
m,
 			    struct file *file, unsigned int cmd_in,
 			    unsigned long arg)
+	__releases(&STp->lock)
 {
 	int i, retval =3D 0;
=20
