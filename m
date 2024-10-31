Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774B21CF7B7
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412947; cv=none; b=ekvv94Rguc5J0WQQoyd9zNdZRx6htTdqepSqNiNWCK7kD7ecbKIBakxy98exCVRvt0sbxbas+d0W4APHIR5e7sHK162ayZMi36ikUnlAWey2gE3WwT9od0OGG2AsV1NFYomoKvgU4jlP0FoXXwqPz7hDgsYUrfqGBQF6vThi7UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412947; c=relaxed/simple;
	bh=ca5+cukJVALptxsrWZhtVxBs2hk+hnjN4uFULkXP8Ww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJ5zKy6zXX4QE0bvmpuXMljah8wCAiIUf/KkOE8LGVygw6MflTIAYTZ1Pl5wF8u7qmzKhN05M2k+8GwR8KZ0ssoicVLlZr7vMk8WQo9JBxXch2kp2hWqUOg21dr9i51pc+5Tqn1UFGdW7IIdA+5rDZ/IuRn/4jMunKE0oo9YL7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1+KwIdz; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1+KwIdz"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7eb0bc007edso871972a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412941; x=1731017741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pg9S00d9LfKH+DkfiQ4/I94qt5P3s56zZXgEdy9d9ek=;
        b=F1+KwIdzb5fVX2lFXhEq9FU3Pfm+mhQ2V386ZZf3PFDBhFp0EnIZzo6W02h9fKdxjE
         A15Np+6+F8OV+1y/VTK+iYAomUe2yhmhhvjgzasxwjd+wZ+Ia2WfHFTPcJpRQV4zYJTr
         34ahz+RiANJrpUkescDPu+ECJNzFX4P1ltWduLZyJT+MqaKpUrT5dnd7Uy9rYOvV3Pnw
         OWa3M6i1+xrE7JPHCrF6hi1MuFOg90S5w62XDNjWITXhNnSZnmT65XuG+eQkW3f8p7oD
         v9TpIxBTvbrz+cXGAafrFbIuTbPKfAXRz1R3LLCkmX5NAHBPAUzSYxMk+33qy6T8Omrf
         9mVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412941; x=1731017741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pg9S00d9LfKH+DkfiQ4/I94qt5P3s56zZXgEdy9d9ek=;
        b=wbhB/5G2GhDN432v05TzmV9TAZlgv5T+6HAIExhrR7sW5hk2T1Vmka5CPTj+QawAEq
         v2uSQgJD+P7OCW8atSUrkcdM5/MWVzu27y4ZmVdyZ/IsIHGc7RxXBBdhjoly+zB47NHd
         j/lBvrVCb1yhpj8uC1xOsmqF+aLiHOx393hwjY317cxDBGZo3diwoPzckmudcS0W3FmC
         Ntesozfh/UUZ1R1/NI7mad1Mxh3iYBtpXPVM16jjC0mz0gY9kEpYmPrNkJ0UXT5kdXuW
         218Y5+3g1wqls5qLKwgXRw5pDmh9NB9UzOyGn+NaKD7/DzM60gRKZSZYjxAwnFS1Q6KU
         GODQ==
X-Gm-Message-State: AOJu0Yy36cxq7RuSxjIql2sDRG7m5Cqw3vnoOUFJd9cIx/1JNkdf04Kn
	Roy3g4B5LEMfLExDmEF+RmIVQboHpXIu7LwD4c8fhOLOnfHxje+9Cpq2ZA==
X-Google-Smtp-Source: AGHT+IHu+Q7Skjj/PLvgNNGCILgSWtpE7Cy+vat4jv/ho769sIHE3Y9UTpVAXHfyyo9EQw5iDOl1JA==
X-Received: by 2002:a17:90b:1fc3:b0:2e2:a661:596a with SMTP id 98e67ed59e1d1-2e93c1860femr6380073a91.13.1730412940599;
        Thu, 31 Oct 2024 15:15:40 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:40 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/11] lpfc: Copyright updates for 14.4.0.6 patches
Date: Thu, 31 Oct 2024 15:32:19 -0700
Message-Id: <20241031223219.152342-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Update copyrights to 2024 for files modified in the 14.4.0.6 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h | 2 +-
 drivers/scsi/lpfc/lpfc_disc.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index f8a77ffdb0a8..efeb61b15a5b 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index af5d5bd75642..3e173b5d00e0 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

