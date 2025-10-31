Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A6B3112DC
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761949143; cv=none; b=CMFXPyNBWBPpw7AEUri+o4le9dNBU6CSuBQqa2Th4EyXk1eKK0FqZs2z7gwbV6gkbr/1idlt4PaAZUukbVVsConsnUcALWmD4xPoR9WzNjoaU0BKdIz0wvJ2CNbWKkECBs3Qi+sgoYojIduy/J6e0DXNgUggoe/2pUzcO4VzpeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761949143; c=relaxed/simple;
	bh=5TdjHc8t8dEh1vetaEuGKBZhXQSB6Nvrlc9Tdb2vIZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AFJvXUn70wOb/8xzVjdszlDxiXuasLzh/Oq4+++SXeGBfqNRFVpKX7tFhMDG3Csx0QHzGqvwljw3lRbRYUIFMvac2MlN+mAwX4ME1lvynwlZlzoLELLVX4hQ2ODXW6YgOBClNR/hW3MCmHo04HwTRl8f9NfpfZ6tmFbGBQquFLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qWtBRglW; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qWtBRglW"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cywPJ3JzKzm0pL4;
	Fri, 31 Oct 2025 22:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1761949139; x=1764541140; bh=010OywsVoadOwoyMPnpg0WEt5oIvEdCWHN8
	dpSquuKY=; b=qWtBRglW+PUBdcJ1cAe7uRLyeGe3jbPNaUjBOlEIIX+BYJPArUA
	RrnLqjVamx1RgKmWMNhRAg6AlrGw6k7zf7pXWlRBbgRRJqIyZwyw9zpibED5mcU7
	PVTiyqC43phosEwiA+iq783/ElScfP2P45Dh4VMYcI5eYZXZCkDYEiy6LvnqzFN8
	/5JGSQVW0gQeuOA0OB91T3giUCtQjnBmlX6DtIbKdKRls6/WOiyaE0d6pjgCoVtP
	2xFYJLh/KyzK6W1AEqjq7dU3pu6INwuuPw01thn7lJTDTkdvba7tWQJGKAwuyDan
	LBo/e9KyA7gWZZdf7XlivBtnfgE05coU2Rg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YoEbAY6a2Rz3; Fri, 31 Oct 2025 22:18:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cywPD6HRmzm0jvV;
	Fri, 31 Oct 2025 22:18:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Improve sdev_store_timeout()
Date: Fri, 31 Oct 2025 15:18:44 -0700
Message-ID: <20251031221844.2921694-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Check whether or not the conversion of the argument to an integer
succeeded. Reject invalid timeout values.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_sysfs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2cbbba192b24..6b347596ef19 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -648,10 +648,14 @@ static ssize_t
 sdev_store_timeout (struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
-	struct scsi_device *sdev;
-	int timeout;
-	sdev =3D to_scsi_device(dev);
-	sscanf (buf, "%d\n", &timeout);
+	struct scsi_device *sdev =3D to_scsi_device(dev);
+	int ret, timeout;
+
+	ret =3D kstrtoint(buf, 0, &timeout);
+	if (ret)
+		return ret;
+	if (timeout <=3D 0)
+		return -EINVAL;
 	blk_queue_rq_timeout(sdev->request_queue, timeout * HZ);
 	return count;
 }
