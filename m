Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F48E14EC73
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641952; cv=none; b=g+HheMuKbSk8VMmgSvvnNeCRfzWLkjjmfnkWGzURa1LsAetLmEU/iAVD9CTUo9gVBHoXMxzJrZz7ZMU33YCjSKbu2LK0WbNTfwwaaTKmHIeX9iC8EP4i3DfU1XCjeTcH3fRWlQd/u6GiZq+kFXDS0KE4IuyoV2kSbfMP/8purwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641952; c=relaxed/simple;
	bh=UhbsLbOYfvT4Xu5ApY+3ggWIW7oTrdc3K/vxv6Sgjgs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h22gT+s8n/KHXNIiLB58R0RsdBzhwLSEO7uoONVq805pI/DBymG/dKSr8XExjdzSJhbdhsRm/pUaahCs7KpvbLCogbt6MgtydQELa+j4MIkEJRs667g604BlqtPWw53fextvoT0GDQwBdE0p3/9XmixROuq4eorkJ9g26qjgu1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mnJuAc6n; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnJuAc6n"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77f343231fcso1144923b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 08:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758641950; x=1759246750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3IKH7wDqw/hTFy7W7zq+0djPj1ZwecQEHG9Vmaw8v48=;
        b=mnJuAc6nTPXhF4M0vxiRNvUn8LwQdw5oKtzDkwm4s3qoi0Tfry5FOLf+wHq32HQpej
         tniHsj60RL2dB7fuk6ouwOCaR5T0F6hfWWsx6R+TLlA+Y5oORgC8iznz6x4jcRJva7EQ
         to49xMEIvc4fTKaZdGg8Eb2AKRl/3b0CXgx/OMpR1M+bQHl8GJWnrhyzIp+/La8s8B6P
         XPwrDD/sLADMklRA/LSKvEFRlY0Fsq7MSna7YWsic6oNaZeXWa5a4EGyIDPdTsY5qGGV
         VkxTjhj+lFda6Xrg4WwYXemhOFWmC40GgrqZzYpbsv1t74z91S43FXWQ1lTIipatUYVa
         RkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758641950; x=1759246750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3IKH7wDqw/hTFy7W7zq+0djPj1ZwecQEHG9Vmaw8v48=;
        b=LVE+wqgroljfo7bGwOdLYxUFcWZ4XkspI9gNJo49zCaUGPEqlHDe0pzqnPhVbYdtAT
         4OaBq3Wc49LsPa0s2N93TWMIJSZqkB1FI1eqfeAFSOpKrGA4MFivA4OFtiJxzIiUbLpA
         zzHwWKt+m1G6LlZaE/PG4E3P4l8Hqotw4+6RQel7YLQJ7RbVSKBSkkXbBS4bXs1whwMT
         GOSVME7ZVkHdilF00flbCMm4wtYpJ3bwwXyKHiNqguLjQS5Mw63zgy+dZUgqIAtlZqV4
         J7WUT6wrln1wS8+ajqQoDUlNPgyV9zgyDvUAuRoWxHhpMVD0Vf9v/f+BwI6/PFUUxMTF
         Mi9g==
X-Gm-Message-State: AOJu0Yylprx3aCoi76sxDfcmMp3spEBF7Pct5nM7UYjtQHXTC/K0oi88
	P6ZT0PgTQhuD+rPiMgTITokOpKNbNgeCchXm5MqEzrLPGhvVAhaxlsF8dnXBcQ==
X-Gm-Gg: ASbGncuo2pZ12nagtITzx2AU6c1nwPTW26tE926s8ZT5UqKTqJBUK0hWSsnp6hllLzJ
	7I6o2IcXE/JyQ+WsbKmOXWGRhSK00hfNKBTwWNpd4gJRFrrJVwbRc53f5gH4zVIBlilIfNG8IaC
	/1PNKNfS0La9B/SZRtXqh5ISTQYybNzDqxd85+p6x817Dq3sEmUf1SQwiXDxRp1DlgHTcQo79N5
	j+UDJepJjWrSVPTc8gZpQvW3UfiT3y47zUBHYmhq99IknDE9eAT7EUgKczH/H6uLi7dbrSXS6rW
	kANfK67pcX3pKy/lbK3WaTQTYTyOLKbtbpBbRd3+LBmCcZDUvlrz+yQ3i7rpBpg4yHln5Fuq5Y1
	MpMUHagpH+Gky+xXZHSFGdHgvSlH4xHmQDyqcVXWTaaoFslrkjo4HXxRxo3NB
X-Google-Smtp-Source: AGHT+IEZo9qSBbfn/Xml4KJtCvUFlULxBDpKYDPazomaYoVMFRKhE6qkj0BzJtkmIiVQastE6+DAtQ==
X-Received: by 2002:a05:6a20:a11a:b0:24d:598d:2171 with SMTP id adf61e73a8af0-2cfefac3edbmr4798271637.51.1758641949959;
        Tue, 23 Sep 2025 08:39:09 -0700 (PDT)
Received: from localhost.localdomain ([23.164.40.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f2f02c0d7sm7536909b3a.93.2025.09.23.08.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 08:39:09 -0700 (PDT)
From: James Smart <jsmart2021@gmail.com>
To: linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] MAINTAINERS: update FC element owners
Date: Tue, 23 Sep 2025 08:38:57 -0700
Message-Id: <20250923153857.100616-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'm relinquishing my maintainer position on the different FC elements.
I am updating them to the Emulex folk that have been watching over them
for a while.

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 MAINTAINERS | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..a20ec47e42ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8977,7 +8977,6 @@ F:	drivers/infiniband/hw/ocrdma/
 F:	include/uapi/rdma/ocrdma-abi.h
 
 EMULEX/BROADCOM EFCT FC/FCOE SCSI TARGET DRIVER
-M:	James Smart <james.smart@broadcom.com>
 M:	Ram Vegesna <ram.vegesna@broadcom.com>
 L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
@@ -8986,8 +8985,8 @@ W:	http://www.broadcom.com
 F:	drivers/scsi/elx/
 
 EMULEX/BROADCOM LPFC FC/FCOE SCSI DRIVER
-M:	James Smart <james.smart@broadcom.com>
-M:	Dick Kennedy <dick.kennedy@broadcom.com>
+M:	Justin Tee <justin.tee@broadcom.com>
+M:	Paul Ely <paul.ely@broadcom.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 W:	http://www.broadcom.com
@@ -18129,7 +18128,9 @@ F:	drivers/nvme/target/fabrics-cmd-auth.c
 F:	include/linux/nvme-auth.h
 
 NVM EXPRESS FC TRANSPORT DRIVERS
-M:	James Smart <james.smart@broadcom.com>
+M:	Justin Tee <justin.tee@broadcom.com>
+M:	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>
+M:	Paul Ely <paul.ely@broadcom.com>
 L:	linux-nvme@lists.infradead.org
 S:	Supported
 F:	drivers/nvme/host/fc.c
-- 
2.35.3

