Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4C33101A2
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 05:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780896009; cv=none; b=OinLleiXUFSsmDp+M8AX0bo4e64LMRaOhSXluZAGDRbZbFNE5Z6C3viPl9B04X5yqksYrrkyTVB0kWThfGH1EXDVhIjLP+syl+T/uqXMDyG+saK4YbxwgySlQXfQf0zuz3lysWQZlst2U9VBVCYNxAZcwcvbYIbEqT/fKNZVh5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780896009; c=relaxed/simple;
	bh=w0eMqpE2DKuYdMxtHQzEHmuoUuiuFQ3ww571CwZ8qE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a5TLBovEbq8rb0sCYG1a2MPe3G0ehst+VfZxpVi9fV2uq28nExHqRKA9nMUtMlNfJ2wlsQoucglIegINM5leim1n5lgmYk7rlPjvH789aI4dz4ceqVrNNohY0BBOldV6vi35zOF8g8MzKroOHoC2VLMz7mx6/jpBd/3KMo664oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EuJHyy/L; arc=none smtp.client-ip=74.125.82.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EuJHyy/L"
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-137ec563a95so4575198c88.0
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jun 2026 22:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780896007; x=1781500807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=00X0z1cboQ6oKHbGCA7RyCrLv3pho/TkOSoPRKU0WEA=;
        b=EuJHyy/LynH7nhID5v6P5lx2/OaP3fHQ+PBZK1wSv1GXBFyVVCA94/LhqPdZwMGJLY
         dV+3s6byuxsKk4eUVcDKSGn7lUFaNsYl3ooF5UtXarP44/aI03atCZUb/B3HMPlq4aOn
         Iq7PIi+SAXA97t97kgRsVoGRQLICUaU+0m9f4AfBMbgdcZVohYHAN+EBHzeHaitn1e34
         f4XAcaF5gAYmpo0YP4rpdogTv+TutsCRrmovfelEkMmnHsaaLHdDS7ypUB++CBi6ApgQ
         t1T48x6jb+N2y9aflVQXspCZx2o8JdW/wNYQfJKoxFuHZs+g3ecDdcW3QjH7QryLVq4y
         R5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780896007; x=1781500807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00X0z1cboQ6oKHbGCA7RyCrLv3pho/TkOSoPRKU0WEA=;
        b=PoQyQUsOBmVt3EXZbXOQXTgOqyWLz3uYA2mE9KXM1LvgCIMsQYqNhGqbawO55Q75Y1
         /uOkU2kad03nvEiWT6JtLa+wEdSVSGCjb1PCvOWHycYG3+J7Y04MJkWHkdsdUHaYv8Ih
         jBjLlmU7Oo4gPNfD5iuw5xHn5vz+2fwJpZCvCvQry7GIsOWDh0BZEUWc7PeNZ2fK4EVT
         SS4mCkYkhiqJixhnKS5EzOCi2zjOgJURN+FVbWIXChdMF1w6PiUJazE+sEx8bLbrZe1k
         NMDZL5tlcK8gxDUq5psXKk+p4l4Nb/mRWqAbQMHD8BhZlU9SRq5AZPIyLw15+VVnHo9a
         mgyA==
X-Forwarded-Encrypted: i=1; AFNElJ/U/nV4d2fQLaEWPWSRHagVnyNNTklN9RqRa9zXWhd7olbzi2UbIW30OzVS/DfS1UD3dVJzmejLXqNT@vger.kernel.org
X-Gm-Message-State: AOJu0YwO7CThQZGDUfjsPDJ4yPmhwJe9zAT+cqxpSKxBO7dj/qDIq4AB
	WAPZ+dj3l8SAXitmgkujpMpMYZ7REjOD9c5N9tu4go1uEbsA43naIwE8
X-Gm-Gg: Acq92OEfdNQCmjJQkkAPfis2Tvl29k5Itzcx15rkvNNISP996Jk1ejbUBDGRJ6XGQSH
	qYQ/pgdtbCHd6QGHZnDlk2eOih+KeHjjpXRZzJyobkn4QnNL1o09Z7kMunPk+atby/O0yTptND+
	/hKcpC/MUovB7IubiF6zDsPLSyLBvN16vP3n1BIPBO3gxO25W/9SFWqFrx50+NYH6ALpSJWC0D5
	RQFFSWn/ur25JHWycl4RqvpDIqLcDqYP6KaIPOnHGfSWu/D9nyMjVveXMlA/7JSY5nULvYRPsAv
	DODB8L06xzihyJN1XQvCdnprSIi38xjEA6yKEBtAopaPqBu/0KKzx+VR5gzCrnWAC1ySd5jI6cP
	78M2VTCsmDR4+90KmGxu8JaI0WF7zXxfZWJO3vamD7jTcZedh/aArI0e8Kq6xur8GWEl13MFWIp
	kQu4c18SX9spIeGYeTZpYZ5EhJR+TY29TJ/ugd5cNQpQHtW7hEzvDvYqVkpBD4/zps0HPm5eJgD
	rpJJ2BZrTqxN2xzbjpdcwxygpl8YIGmUbXMOVCLPHGv1PYEnEH0JfORzyOAsfp5gmh/lNlZkJni
	I4JNuc9/U++Q0L6TGcp0tm9VPSSK
X-Received: by 2002:a05:7022:6b99:b0:136:b370:64de with SMTP id a92af1059eb24-1380671273bmr7692171c88.32.1780896007014;
        Sun, 07 Jun 2026 22:20:07 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137f549bbefsm11725310c88.4.2026.06.07.22.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 22:20:06 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: acornscsi: resolve set-but-not-used variable warning
Date: Sun,  7 Jun 2026 22:19:53 -0700
Message-ID: <20260608051954.109435-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The variable "p" in the acornscsi_info() function is set but not used,
which causes a warning with W=1 builds. Remove it to resolve this issue.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/scsi/arm/acornscsi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 79d7d7336b6a..ebf09b787dfd 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2681,11 +2681,9 @@ static int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
  */
 static const char *acornscsi_info(struct Scsi_Host *host)
 {
-    static char string[100], *p;
+    static char string[100];
 
-    p = string;
-    
-    p += sprintf(string, "%s at port %08lX irq %d v%d.%d.%d"
+    sprintf(string, "%s at port %08lX irq %d v%d.%d.%d"
 #ifdef CONFIG_SCSI_ACORNSCSI_SYNC
     " SYNC"
 #endif
-- 
2.43.0

