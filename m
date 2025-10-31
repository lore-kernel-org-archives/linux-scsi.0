Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1577B26C3BE
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 22:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761948552; cv=none; b=UWehkNPhx1eRJKcQ2X/V9FUZi4wlb3d0pzNcerVviWYNO+qUv71AfAht0HB4KjOCJHW6kDwcukijDOkVSfEOvmU3hrKH3cPAPV9UKyAkXbOioxlTObYGTV1QnD90wd+Q6I8BX8+1+zxU4OSqRaR6Jh5GXP/9JQbvtqDsGkPD4sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761948552; c=relaxed/simple;
	bh=HP/Dmdl/FKwtNUmtvGqBZoClJrjkEwojscmfiK867pY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qcCnT0oGZ4xeVXdu0wUBWyBtqU6J5MU+ilxNo60HlI5EV0+WK1qHfhNY0Y7h4GmM+HruW2WaVVqv4bIDxvh7x2gqTOA5pcnsJ/0csHDZHUK2XTLifPEtHkNiWV0ifAFvxeXgrX5F+vBBBZEMUk9A8PmCmBKChbazAs+4b4MD+Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UiX/7S9l; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UiX/7S9l"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyw9y01Fkzlw7Lx;
	Fri, 31 Oct 2025 22:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1761948548; x=1764540549; bh=s9WclqpaG30oaGUhRKothJD+JUe8UI/zu1s
	vj5WgRv4=; b=UiX/7S9lBrztSztOJxzFnQNPBj6tQxP61S1H7ErpoUVoSIMIaVZ
	5CrZx0BKLGK3i4SzgvGq3ltGhKqCJF48DdvmCyJJ4e8X0BHSRQeyWQVWG5GS8yuj
	thOUJe8KBXtb7XUU3jBYM67gIuvfTl4KgXGfF2cK4XJLv4XgHIQjm6Xp5n0M4RzS
	mm1cG3AukH9oyISxqcgkyEKrYOKMdc3f6lOH8jxzr88u9thYgrk8MFw00e6F5WY8
	PyRtPKi7IoRvTaAmZLNxubybo1fiUEV/IlhdU/kzLXpSXSxqP9X4+3R0qAWKaDy8
	yznOghMh18pN25SjQlanVkgktn1zt30XQZA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aE8dBVkt6wzS; Fri, 31 Oct 2025 22:09:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyw9s4pJXzlw65H;
	Fri, 31 Oct 2025 22:09:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Remove unused code from scsi_sysfs.c
Date: Fri, 31 Oct 2025 15:08:56 -0700
Message-ID: <20251031220857.2917954-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Remove unused code since we do not keep unused code in the Linux kernel.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_sysfs.c | 62 ---------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ebd3e435d071..6b347596ef19 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -605,68 +605,6 @@ sdev_show_##field (struct device *dev, struct device=
_attribute *attr,	\
 	sdev_show_function(field, format_string)			\
 static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
=20
-
-/*
- * sdev_rw_attr: create a function and attribute variable for a
- * read/write field.
- */
-#define sdev_rw_attr(field, format_string)				\
-	sdev_show_function(field, format_string)				\
-									\
-static ssize_t								\
-sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
-		    const char *buf, size_t count)			\
-{									\
-	struct scsi_device *sdev;					\
-	sdev =3D to_scsi_device(dev);					\
-	sscanf (buf, format_string, &sdev->field);			\
-	return count;							\
-}									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_sto=
re_##field);
-
-/* Currently we don't export bit fields, but we might in future,
- * so leave this code in */
-#if 0
-/*
- * sdev_rd_attr: create a function and attribute variable for a
- * read/write bit field.
- */
-#define sdev_rw_attr_bit(field)						\
-	sdev_show_function(field, "%d\n")					\
-									\
-static ssize_t								\
-sdev_store_##field (struct device *dev, struct device_attribute *attr,	\
-		    const char *buf, size_t count)			\
-{									\
-	int ret;							\
-	struct scsi_device *sdev;					\
-	ret =3D scsi_sdev_check_buf_bit(buf);				\
-	if (ret >=3D 0)	{						\
-		sdev =3D to_scsi_device(dev);				\
-		sdev->field =3D ret;					\
-		ret =3D count;						\
-	}								\
-	return ret;							\
-}									\
-static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_sto=
re_##field);
-
-/*
- * scsi_sdev_check_buf_bit: return 0 if buf is "0", return 1 if buf is "=
1",
- * else return -EINVAL.
- */
-static int scsi_sdev_check_buf_bit(const char *buf)
-{
-	if ((buf[1] =3D=3D '\0') || ((buf[1] =3D=3D '\n') && (buf[2] =3D=3D '\0=
'))) {
-		if (buf[0] =3D=3D '1')
-			return 1;
-		else if (buf[0] =3D=3D '0')
-			return 0;
-		else
-			return -EINVAL;
-	} else
-		return -EINVAL;
-}
-#endif
 /*
  * Create the actual show/store functions and data structures.
  */
