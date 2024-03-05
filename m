Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41461272A2
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 19:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709668180; cv=none; b=qExNn9P0Z5thEBw/o0to8ixBJdJWhpob4WFAcF5s0krgOENqjb9TW/QYsVSriU8J8x8S0Fu19DJhBjUWCPH2kHN/+cMFfpfchjRozd2jk7eLNtAqFMBZw03qAuhwaTNgQDXIFgw6rclcv2MjPrZc4n9DPJ7hpV59qrczVDOKDcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709668180; c=relaxed/simple;
	bh=eArTxbds+9jJBj0X0IckQcyMO9vFBcya1CFb5iEHHqI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNIkCi9P09Bwdb70wdcYXwWEs+tivZHP/P8hi82jMM0YZC8axQJodb1gl/AmN7PRZsLdwR6UgZvAJf77sum/5xOkxitUEPs5LGv+txE/EInd/tJsE4brfPCzAYbLrl4oTCB7f7QOQpgWMwmOeqUVg2hTmKZm0vveGfHMPN3Upqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IbImqtvp; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbImqtvp"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-69069235a0eso4486016d6.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 11:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709668178; x=1710272978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6QyepeMeNdh4dvf6RFrc0FdzXpa+q1WoVI5foLDSuwc=;
        b=IbImqtvpgAARTHuk0TNr9ckNIEzKo6gVS0yPrBX8XnRhFUZZhh7udAoy5iRy7pVKqH
         XJ88UDUAaKQ4bYctucwNJeJtNpUzZLk6bUCZFWJp3vUTOv1nXYm6yWkxVDPg9THjsmMK
         0yCsNJETEhq7ZB7OudYKktK9Zo/ILCHjTqVohJAhfqP48OvGNhDU9bC1r+Te6j3TUsv/
         lGS5CjJbCNsWpJrEtFWJ7l4VeIm3W/SiPHGC1Pceguj0ge/gweoQBM8k32tMCqcpxxXt
         Ia89052uNoxnQGWBBG2C/xJ+tn1h8uSb3aBprzm/3v3nSOTno+V/TUcEd/PV4rT/8k5d
         nMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709668178; x=1710272978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6QyepeMeNdh4dvf6RFrc0FdzXpa+q1WoVI5foLDSuwc=;
        b=o7YxRyKxOtSpvdIDqavzY5Ibwf9HdTxTJxs2akt8Dzafderwxs6a7dkxyUKWNjPqcz
         AwWERvoe4l7fWjsLX0At6sbSjTOkK4hEe6+DYIVXiGT8w4ltD1M9LB3w13BkTVfy7K89
         6NatfjrojYu+JC2yX6Nnuow9zp2X6XGI0TwDP/08yRSKUGRrIqjVBTqNWQNpij1VldHR
         scCllx084/GgZsf7sjzU8yho2T9Iwj3xp4ndqNf4WFOinDBSR0iZyuqHDQJtDpP8i6MT
         pJ9hGalBkSFI9RyNdZ+Jn1sn3+cMbzbumF7fCr9F9vbYuklw5nCAa6zEIcUmJaZHaaLB
         amTA==
X-Gm-Message-State: AOJu0YyrgNRL6+MBzJxKDQ3AfJzvWvLWZHVpdC2QT5g5R8CIfVAZuY18
	X5hA07wN0NkGj2PREy+2xuKfgl/RvjfqIDSMYG0KltSC8yqyja+0zfsZ655J
X-Google-Smtp-Source: AGHT+IHaJw4vDglwEy7vnHK9DKFGd30KVxm/FxI8cCIWfAeO8cm1Q0nUKnb9CJ4xFG8mBId3wcX/qw==
X-Received: by 2002:a05:620a:4587:b0:788:2f7b:d3 with SMTP id bp7-20020a05620a458700b007882f7b00d3mr786377qkb.7.1709668177859;
        Tue, 05 Mar 2024 11:49:37 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bj13-20020a05620a190d00b007877f52a6b9sm5706050qkb.136.2024.03.05.11.49.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2024 11:49:37 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 12/12] lpfc: Copyright updates for 14.4.0.1 patches
Date: Tue,  5 Mar 2024 12:05:03 -0800
Message-Id: <20240305200503.57317-13-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240305200503.57317-1-justintee8345@gmail.com>
References: <20240305200503.57317-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update copyrights to 2024 for files modified in the 14.4.0.1 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.h  | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 39f78ef291f7..cf7c42ec0306 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 37d9ead7a7c0..c1e9ec0243ba 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

