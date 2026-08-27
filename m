Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DA1445ACE
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 11:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787829674; cv=none; b=G4BhQd1RitVnsjb030OahFErB5w1h4T6EuiPOy395biR05ZitazhVSHrhaVASeoZjagbEHe/DCny0+lXAiLTBJlMrInM6cO07DGhzNf5QHe4QR7ohO8I7Dn1BkOlG8l5BzLQRBCGfz/M/3o6St6rPzBdwVWyB5y2b9gte2RQ3So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787829674; c=relaxed/simple;
	bh=SWZzYG82ddIf4CWzyYSqf8meUDhHnZNy8MmQcSNHLqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d/R6J8OW8bn3S3EvSUHkrUQKWy23QfmKwp9Jv5G6YdntR6++a4RrlJB/rmfoJv/H18CjOr1j2F0XXxELTmi3WwYWTQy6TTL68VYaOiOHpExIDe1x+V/UDdeOAOa/UB3d9VvKk6XtxiC23yueZgcd5b7cXu5z4lXmD9zCO0y/8hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E1SmviCV; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E1SmviCV"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d049069377so24934145ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 04:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787829666; x=1788434466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G+EJF4VycVNW4dQeq5vgulgjlvSit3NOpyYWBllNXVY=;
        b=E1SmviCVobiyI45rJLMIAVTULqw5gfQH6MkFtmBqzXg8+5MoexNlIpNZ7W57gRfIpu
         0x8QgbvagqYHAVIPWuw3y7rln/eyi2oWhkyhGHyQQxIouAKZScw6d5izYA6FmVMdBE0+
         Q0blZgSfhdkXF02tJvrI3S/EUwSRP9N6+OgUw1NirXBvtROdk1P3PzkeKvei7e5WBH1R
         vt+v2hxjxr6iPHFh92+CqwdgXnVtYiONm/23vHC/V/xWb9m9F4bVZxsiVBbH7lf3CbFL
         DzTbGprmm8UIUjmlT7Q7G8eXSqoepTyhUSJhGfElTcK3NJkw9nXvaxdxUhcSv3nWK62H
         l1lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787829666; x=1788434466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G+EJF4VycVNW4dQeq5vgulgjlvSit3NOpyYWBllNXVY=;
        b=MYyToiLi+o1EgETZpG3Gco1MFO8NEcmx2geDJPIMqAZcwZzY60ipfuzLvUn6dx9S52
         AqFKFyQnffXTPup8oEjDiYH/8sYTEkAkTUbmO9P+yviQlt8vooyahzuhr2Vc1AgSGg6l
         hoPjIxmm277+zJxGoSbJBcI0Gt1qbsGMYumJ0/zv5/6q7APLSSswxteqfLUrhgqXKw/j
         +r6dAz+r0yFi9HT1F/+9hQJwCfXhw2n7qYn22xwy/j0aRPhJ6kBGAVgCsyTfBbu+N9Fn
         zVsDlpuHujvO9p1KMn2kKO1BXCzCcBuGx2SXIqiQBIKbiflOFzDmDBWmmjmwuSqWcai+
         UVRQ==
X-Gm-Message-State: AFuF++kHR2QYdvRgsQ3yukhKf4uvLdwasgGzb2FgWpDL9nWIdL4dp7jg
	pPohiWQjvDR4DgfZUKub85fVdQ8ZFe/0ZVj2Q581Zoemxh50ySvcZok/
X-Gm-Gg: AR+sD10qmtqmii1txLBEA5xGX4XeY0Ktq3Zq2mmqrFSjQa3yq814Doocekk3aYNvvan
	ZIfjb3k5VHMav7fm49MSYbknqS5EUvtMPwwqn/AFMnhzl3nLpb1OjgIALbNmMLTm1uWnlcRlzbJ
	LQ4nVovUHn0pVirkYbW3wnpApBEDjMUSm5r/4/d93K2eA3k8//N75+AiP8t3HkqUVWU1cIPk8i5
	fMfDoW7Y7krmgsaNQ98hfoWBApbiO4pvfI6QdDSzQhblNH+WtaaEMkqMcX9j7jyQljS4rfcn4Bg
	otmF40S8wh9qVXeU2exZ9ND7cGo1oLKZg9cwEmuU0eOXM1WnFPvzO1Fu1hYB31YCtGO3WBqWxDR
	2+6UNmMwrY7gknTQAGcXJq7MvxKl4EOyNyaWUFF37MYydkBGcJ3WsISFvTyW5wQdm3c+k12EmQF
	isP6quFX7aTMTXnNxpJ0SGMW+efneFTVualJnyvnmaYkQv2wzu+zsiKAieaJlh5/HDKHhzN7S4y
	i6cxo/USOMGhi4tFkKLu9besG3A8/qsCfuxX2su
X-Received: by 2002:a17:90b:4f49:b0:395:4de9:b30 with SMTP id 98e67ed59e1d1-3966d1baf30mr26872063a91.5.1787829666315;
        Thu, 27 Aug 2026 04:21:06 -0700 (PDT)
Received: from baaz.tail58d41.ts.net ([2401:4900:8853:c223:d8cf:ffee:2034:18a5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a8f20095sm16423327c88.6.2026.08.27.04.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 04:21:05 -0700 (PDT)
From: Muhammad Falak R Wani <falakreyaz@gmail.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/2] scsi: ibmvfc: fix kernel-doc name for ibmvfc_scsi_relogin()
Date: Thu, 27 Aug 2026 16:50:37 +0530
Message-ID: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as
SCSI") renamed ibmvfc_relogin() to ibmvfc_scsi_relogin() but left the
kernel-doc comment referring to the old name, so a W=1 build warns:

  drivers/scsi/ibmvscsi/ibmvfc-core.c:1901: warning: expecting prototype
  for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead

Update the kernel-doc comment to use the current function name.

Fixes: e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as SCSI")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608271026.iMLmrwz4-lkp@intel.com/
Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93b9f699c2e53..d1956552698e0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1894,7 +1894,7 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt)
 }
 
 /**
- * ibmvfc_relogin - Log back into the specified device
+ * ibmvfc_scsi_relogin - Log back into the specified device
  * @sdev:	scsi device struct
  *
  **/
-- 
2.55.0

