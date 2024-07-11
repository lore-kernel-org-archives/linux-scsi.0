Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04D16DEC2;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=DMzR/zEoe+liTgOh9tQQ2Zso5GWfqoLtQk4kTHImg8Lds9cZtcqXLLS3szBCzMX4j/aXDJSF2GEt2UoTVfRyQESmSoIGSdP9KdF4k00SE44GcLczp/IZ4i8uo/c/6V69vSzbn+BZ7UdHfKMNsfVLOijtkOk8XK/Yg60DX/dl0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=MnZHveL4bhw7QKqCedPp+xc07Hey0fundjFehsgmf5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GpFvMvqF7Eb85K1XCwI6FO4p7sG8H3pEGIe5DU19l24tc63ghpXleOHdJtnmRmS2927F4LQp1lv0XXfI2G5pYI31Yve0xQypBGLx6S10rXv+Y4KI2xTWwSiCH2Ya/e50rBwKXP2cXKyhA960Pb/pUZ1Z2fDzD/a3l5BDuu23cwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LY9g7/TR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LY9g7/TR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D08C4AF18;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=MnZHveL4bhw7QKqCedPp+xc07Hey0fundjFehsgmf5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LY9g7/TRYb/UetyNO/Ca4jI5BkPaGisNF3rTpxrp/rYmc43/OSVVGBUGtV4RUVKea
	 DvEnEYhRFasDp+9l0/6exkd6gIqsDT7O7+zSeRN8M+HUI8AThYGX4Ol9crN/HCe7lB
	 y/uarBwBr5PJYavJZLJblTJ+qMt/lxUFDF/EeDm5A+8hN+iFOd6kIW8/Zj3xtGcHgE
	 k5p8LLf4PPsv2I411WZXuvS2qs1D71AbyOVud2zmheZBeO0zRtDaclOedw7eigXbjE
	 9icMa9snQibwOVkPlhcoGXDpvFo4rC9GBrOjr5095UbaKEbek4JQmxk/eERLVPL0vO
	 BGNd8cc3zNVsg==
From: Kees Cook <kees@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Kees Cook <kees@kernel.org>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] scsi: message: fusion: struct _CONFIG_PAGE_IOC_3: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:28:19 -0700
Message-Id: <20240711172821.123936-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3164; i=kees@kernel.org; h=from:subject; bh=MnZHveL4bhw7QKqCedPp+xc07Hey0fundjFehsgmf5w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBY0+IfDHmTrR7F+4Nw6sg6RTWu4dYQ8PC94w LD5eUgElKaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWNAAKCRCJcvTf3G3A JgzlD/9CQ9zmCPlZEsJz+MYcZ3brkTlXQxnE/MRIbQRddbmNlIGZqoltkazt7zYCuJtzE2mUfo9 EgjWZxbXflOmH/r0TZUFYfrhDiYIqrA1n2MOGpdjdFfFTtz3bR/9dL2qkPISojtexAEEkXQnjMF /QlwARa6sNlpqVovfsjPFEJHOGpaHI2JBzf3NpTogg85e8hDSvuQx5dSkVUXmR/1YhljWmMSp3w RmYS3o3/mkDBDLQafWFKs7l/9WxZNIwfjq8KeD6diisq9viZEpUN+BFbn0kqS7+xd6zkWa9xlPX XBUTxMoYQm00LRnRo/US3XsItNIZJELxGuBTD/iBM8uSPoV8gYsAUy9BjTEjwB7ezrBJHy/mFzw CHOjg8UrVPIU/GLcZMhrxjPHl82o4hyixCOvQzvguiRvmcmS5raWAqYQUVF3LLwKVIJqg4f23uI ZiQe/jTPpElylJUBckRZidI4aOW6CNiPbnPd+v0ZlcHLBrnwS1bFwZAVu4K9Y3WddgqcCaCR81J c+h4y7gxX98zlGB0yYec/o/w3ZF0m/nRzRl3zYIfgNtU4uTbX4FZY2cdldLydj8UmX0YwPMAcpo gl/csUMfpUi8LkbwUH4dtYpY8tDrY/Xm9BAjz1zBL51NRT2iP5uFvLMBJ7oCQdfMzvbiEXM9MME idSgdPVwgpNgjbQ==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct _CONFIG_PAGE_IOC_3 with a modern flexible array.

Additionally add __counted_by annotation since PhysDisk is only ever
accessed via a loops bounded by NumPhysDisks:

lsi/mpi_cnfg.h:    IOC_3_PHYS_DISK             PhysDisk[] __counted_by(NumPhysDisks); /* 08h */
mptscsih.c:	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
mptscsih.c:		if ((id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID) &&
mptscsih.c:		    (channel == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskBus)) {
mptscsih.c:	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
mptscsih.c:		    ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum);
mptscsih.c:		    ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum,
mptscsih.c:	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
mptscsih.c:		if ((id == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskID) &&
mptscsih.c:		    (channel == ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskBus)) {
mptscsih.c:			rc = ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum;
mptscsih.c:	for (i = 0; i < ioc->raid_data.pIocPg3->NumPhysDisks; i++) {
mptscsih.c:		    ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum);
mptscsih.c:		    ioc->raid_data.pIocPg3->PhysDisk[i].PhysDiskNum,

No binary differences are present after this conversion.

Link: https://github.com/KSPP/linux/issues/79 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
---
 drivers/message/fusion/lsi/mpi_cnfg.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 7713c74e515b..bac49c162165 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1056,21 +1056,13 @@ typedef struct _IOC_3_PHYS_DISK
 } IOC_3_PHYS_DISK, MPI_POINTER PTR_IOC_3_PHYS_DISK,
   Ioc3PhysDisk_t, MPI_POINTER pIoc3PhysDisk_t;
 
-/*
- * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- * one and check Header.PageLength at runtime.
- */
-#ifndef MPI_IOC_PAGE_3_PHYSDISK_MAX
-#define MPI_IOC_PAGE_3_PHYSDISK_MAX         (1)
-#endif
-
 typedef struct _CONFIG_PAGE_IOC_3
 {
     CONFIG_PAGE_HEADER          Header;                                /* 00h */
     U8                          NumPhysDisks;                          /* 04h */
     U8                          Reserved1;                             /* 05h */
     U16                         Reserved2;                             /* 06h */
-    IOC_3_PHYS_DISK             PhysDisk[MPI_IOC_PAGE_3_PHYSDISK_MAX]; /* 08h */
+    IOC_3_PHYS_DISK             PhysDisk[] __counted_by(NumPhysDisks); /* 08h */
 } CONFIG_PAGE_IOC_3, MPI_POINTER PTR_CONFIG_PAGE_IOC_3,
   IOCPage3_t, MPI_POINTER pIOCPage3_t;
 
-- 
2.34.1

