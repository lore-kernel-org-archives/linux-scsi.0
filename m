Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1C813BC3F
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 20:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758919123; cv=none; b=YIrQ4yNvZXeeYCtGcKaDyAjNkZkQ3Z3dMLK0w25QySwpIcOpUIeE/9I4ZCUGGHhtuYFeGcq9SBAE5dEjkO/4aEDAYAJBXyYaf3tWwj71yKX5adxHE2/q1UaxAbXlEcNPCPXbjomkSyVl1MMI0OlJ47LwVKiSwClYJNWeed+Jm5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758919123; c=relaxed/simple;
	bh=CFC8ZBhLyEApSbHYUA9l/Leh0NamA2VnBjVYGarTn5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KZnOH00zzRK+8ZS+2t9jOujaAy2DuqLGMshftYfmXHhPZbU6TaMbUBy1SuVVkMkBMVch23zIuBNDFGJ+R9fFc+zegWdeKOeHjlvTt4kwQJqXfO7xyCwFbkrE/lH/yClbgVciWgQrISDJSTUVHe/GsfT+55mZDdPppNYGXydgfwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aX/GiuUs; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aX/GiuUs"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3fb179b398fso318412f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 13:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758919120; x=1759523920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ym4TPzfQjAXnbYs9swIZBpT7+hJCYsXg9Gx2H6vmkGk=;
        b=aX/GiuUsKdcpPboh0qBmnfayxvsOPQ7qDoRurLsBIL8391OIQtOA7w5RWNL1+LopEg
         H0KBzLwB1fIgHBcJWM/su09SIctuC5ghdlNZagMXwC29G7LVJjpEKRsMSzoCx5tGQOxz
         OnsYxcU+tJ0E6vGav9Lww3H1fU3fpA0B5xH6j2yu0rE3daYNjcUIqa3A4TDSU+RotSDf
         M023mbEd5hOm/o3Dxs6NEcxn8yjnujri/E2VuJ3+UmSYI4YWEWRrJP8KpcO6gSALOjN0
         lHdCp44IK5l1rgfMdW2cILTRPkTsULF9hjEz8yJq97q3Wn4ClcAPlEp7ywTBZ6sCCIqv
         7b9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758919120; x=1759523920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ym4TPzfQjAXnbYs9swIZBpT7+hJCYsXg9Gx2H6vmkGk=;
        b=lcT8acz/vZxaBJjwWv2pi/DwoODIZrgmVy/qPRgFjxFr/PoVdpQZDFJwZ9t0mE3MlI
         r8bdY+8mdY1sB0oX7a8YaX6IoWqO+KieL2JchjZrnhRto2TmcuHYQk9j+OLcBC+P/6g7
         nVQZtmXH5nLgyPzAln0MQPQn6jcoRTft2nxG97xLPvnkVcGcYj55R6kIzu/Z/04YXPWS
         K2RAJ3/6HxozyMxCKikA2+rUy77qiM97fZjH+drUi6BfQKDn8e96MAWSDCaExIiiO9G5
         lU9wFFSoM6i7MHPSmEX+t6LG4ateAP/pjssl0isf7RIlpGblX2c9UA1YJMgj3IMtABOA
         5PBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcDF8IhZuiW7pcgju01u1hIzOozwXti6f+ZoQ6zvG3YgVV1J46aqS056sZxlGyzmFBM8df3NxMADyg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6/UE1gkRwTG2IyxiobbHwLiHujjQg0a2qZiAaMdfMLrfvuh/W
	GoYzhTz1qolte/dMdKIat6oiCpdZ0gTXAmNZgl8cyR5c876DRwst5m0=
X-Gm-Gg: ASbGncsXTrOFEn1+eba2mX4WdepXr5WhKK8DLseRMl/pBCPwyB2f3X1iT1l7u2KE8NY
	OJrPY5ZDyNbI8O99sMOK9O62JL/K0z6OHgLKF3zFpgTlYZUn6oJMpQOPV7ST0KeSkJLgc1tKzfI
	ui6hHQurKNIlHjuBwsi+C0lLE3TVaPjdj3n7DbB7S/3v218zvBzsZEMHeannLq7/A9DmlhfXuew
	mPGrnSp/R52D67T0YmE37jv5J0sqeOTgAaYnBluclAbA+dfnoRP8zo0HgI0H+uj4D5AJ4ZLhuRW
	RRuPLW1Ez7UWtzEdVvXZF+55GQs4+NaJXwhDO789811EEm3j3O5deOmb2TLfB4xIACCM+ug2ulg
	5idCz669Aro7IzhyJo2L0pyig80aTJ/rCYc+N0R23/ZuuShh+qOqTav9kmHAOfxCNNE9sl80Cw0
	+55Mzw1g==
X-Google-Smtp-Source: AGHT+IF4NPLOoSuml0YgFypGYUOVcC4TpUrzS7YDckho6hf9UUQyAlY8EuYIfKHrG2bdg1AAQ5cW+w==
X-Received: by 2002:a05:6000:2112:b0:3e2:ac0:8c5c with SMTP id ffacd0b85a97d-40e442af634mr3453173f8f.1.1758919119918;
        Fri, 26 Sep 2025 13:38:39 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb71esm8176068f8f.1.2025.09.26.13.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 13:38:38 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Nilesh Javali <njavali@marvell.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] linux-firmware: ql2500_fw: update ISP25xx Firmware
Date: Fri, 26 Sep 2025 22:38:36 +0200
Message-ID: <20250926203837.278863-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

For Marvell QLogic 2500 Series 8Gb FC HBAs.
From 8.07.00 (2017) to 8.08.207 (2019).

Cc: Nilesh Javali <njavali@marvell.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
---
Taken from:
https://www.h3c.com/cn/BizPortal/DownLoadAccessory/AccessoryDetail.aspx?ID=254b05bb-b70b-4df2-852f-584055fd2258
because http://ldriver.qlogic.com/firmware/ , from WHENCE, redirect to an only drivers site:
https://www.marvell.com/support/ldriver.html

Note:
"GIT binary patch" removed
The full patch has already been sent to FIRMWARE <linux-firmware@kernel.org>
---
 WHENCE        |   2 +-
 ql2500_fw.bin | Bin 275128 -> 275944 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/WHENCE b/WHENCE
index e23c2d28..5b71f36a 100644
--- a/WHENCE
+++ b/WHENCE
@@ -348,7 +348,7 @@ Version: 3.03.28 IPX
 File: ql2400_fw.bin
 Version: 8.07.00 MID
 File: ql2500_fw.bin
-Version: 8.07.00 MIDQ
+Version: 8.08.207 MIDQ
 
 Licence: Redistributable. See LICENCE.qla2xxx for details
 
diff --git a/ql2500_fw.bin b/ql2500_fw.bin
index 999e6f45612b74c9569f426e87136cd19de0df79..fa5cf63057d02245b52a51948b8ac42e953fc180 100644
GIT binary patch
[...]

-- 
2.51.0

