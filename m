Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A22D16DC1C;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=b9bUgs/SNWLcPMCWi4CZS3GrIwSSsqBWGfgEa/zTtO+f0QV8rnCpkuj0+8M/kOW+yuNi3MzCR+hnEJbT2meg3nYY6XrfRScJo3OMTUBIFe0ys2SrzVN/o/f4w+O9chzqx4UnE4F/Si0cV2GAs5e7bWV6+uuiRNrewyFQ7hKNUbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=TFdd55gm7tedjfyA0tSLEzREVFMSxyPLwq5f8b56lIU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C2Mz8hyPXMEqrFOQJpiN2w74qaI8dS2MIx7R5xRUm5sOvDndSpvoSTOWEzwv+KLaeTo+vxF9ocCtd9SMkL4DggMzrLuz4ar9dN3MnbhV0gXyUTpVKaaSYnETxGy8IeEsCHn3640JF9SaB36GTMWZ09cCAssa/cXPIX1wGQcAPZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNTz3k1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNTz3k1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F79BC4AF0E;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=TFdd55gm7tedjfyA0tSLEzREVFMSxyPLwq5f8b56lIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNTz3k1RXtoJrTD9geq4YJ0PrHvAeG2XxRtC9sf46503DGwhjZmQaqDW9kJOcNTSq
	 Qsj/hvU6mzG8ZtMeIUEV197iGw+y8AfJZ7/WH0mQjU6yYuB9ndL4hB3iFWbf6R8+BU
	 Z8UQopMovKLTBt6MiPpYj1ZLqy4IItYhoKX3ViSlK8jquNLVkS9bvxazVQu3z9fDpt
	 Gc2quSK38zGhYI56+s5PeLy2VJgh+ff6wmD26qan2pyaxULvlkkIRywLixZrFIliMC
	 x6LsA4wn2lk8KEDvYdof5tlssYkhD7v4iurSHMb7Xm0TZkuvQCA5B4QPKWWStzV0tb
	 Y18sudmcjoNZQ==
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
Subject: [PATCH 4/6] scsi: message: fusion: struct _CONFIG_PAGE_IOC_2: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:28:18 -0700
Message-Id: <20240711172821.123936-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3512; i=kees@kernel.org; h=from:subject; bh=TFdd55gm7tedjfyA0tSLEzREVFMSxyPLwq5f8b56lIU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBYznU8jZsF6x0BPmD/cpzsBuAcKzr5zPGH8d 6njqRjZCS+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWMwAKCRCJcvTf3G3A Jh3gEACcdiLzOrjIsH9nE0Jmj2soc1aVdJlCGWpvkTRhtXFB4qYoXSUz0FamS8xcMmgSZpPhJHX g7xPhTslDwQJCbQwu25emCMpaHKERUR7WSXYtLagPOH3ux2+3B8qfaE+nXq5JvysvIgYS2a3dx9 BCdSkg5/CiLpRAXWBr99yKCvkaaAI4lJ8vEuKHxtAOVkr+lUkfH8nLyqXv5vagDTyGkfYWUPMcJ WkqCBQmStYBBJ8NvrQJjKZ+civiqKv2PR2UQwUoRX3cKo5KGubB9cyPcaWQmSvR7wWqApi19izC mUl+AWCiZkFouXX95ai+6UInmWHjtJ/rl86CL+eeKwQlN+UnjsAMeex26IlUKE41IdEptGxU956 jE2MSPA4641M9o9ozAxRfYjmWuHksUVuNl9jUeRZHRWCWvwRLWC34mzoJtxDm1RdDvMVDUExmQ0 BGbul+ZtVDXMt60e/7mTMB1CYzjJbb4g0m89MFrznJJWAGVItnuD32aVoFd2oM5i3IhrpS63oqx b04bNWR1k4uyVEYKbLMNsscCi58iNlUeGK46VC9F0qXPHlsGWoFx6ACDJCnaDBMDSRNy30MxG+u X8/0gxgZrVNQK1qUFLocaZk8aSrD/Uidh2+cpVGg7OjN1xBQRTbFR4w+VhbbvkjR9oTRpb1e4kt Cuvm5c0PHMDbINQ==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct _CONFIG_PAGE_IOC_2 with a modern flexible array.

Additionally add __counted_by annotation since RaidVolume is only ever
accessed from loops controlled by NumActiveVolumes:

lsi/mpi_cnfg.h:    CONFIG_PAGE_IOC_2_RAID_VOL  RaidVolume[] __counted_by(NumActiveVolumes); /* 0Ch */
mptbase.c:      for (i = 0; i < pIoc2->NumActiveVolumes ; i++)
mptbase.c:                  pIoc2->RaidVolume[i].VolumeBus,
mptbase.c:                  pIoc2->RaidVolume[i].VolumeID);
mptsas.c:               for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
mptsas.c:                                       RaidVolume[i].VolumeID) {
mptsas.c:                                       RaidVolume[i].VolumeBus;
mptsas.c:       for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
mptsas.c:                   ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
mptsas.c:                   ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID);
mptsas.c:                   ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID, 0);
mptsas.c:               for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
mptsas.c:                       if (ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID ==
mptsas.c:       for (i = 0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++)
mptsas.c:               if (ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID == id)
mptspi.c:       for (i=0; i < ioc->raid_data.pIocPg2->NumActiveVolumes; i++) {
mptspi.c:               if (ioc->raid_data.pIocPg2->RaidVolume[i].VolumeID == id) {

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
index e30132b57ae7..7713c74e515b 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1018,14 +1018,6 @@ typedef struct _CONFIG_PAGE_IOC_2_RAID_VOL
 
 #define MPI_IOCPAGE2_FLAG_VOLUME_INACTIVE           (0x08)
 
-/*
- * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- * one and check Header.PageLength at runtime.
- */
-#ifndef MPI_IOC_PAGE_2_RAID_VOLUME_MAX
-#define MPI_IOC_PAGE_2_RAID_VOLUME_MAX      (1)
-#endif
-
 typedef struct _CONFIG_PAGE_IOC_2
 {
     CONFIG_PAGE_HEADER          Header;                              /* 00h */
@@ -1034,7 +1026,7 @@ typedef struct _CONFIG_PAGE_IOC_2
     U8                          MaxVolumes;                          /* 09h */
     U8                          NumActivePhysDisks;                  /* 0Ah */
     U8                          MaxPhysDisks;                        /* 0Bh */
-    CONFIG_PAGE_IOC_2_RAID_VOL  RaidVolume[MPI_IOC_PAGE_2_RAID_VOLUME_MAX];/* 0Ch */
+    CONFIG_PAGE_IOC_2_RAID_VOL  RaidVolume[] __counted_by(NumActiveVolumes); /* 0Ch */
 } CONFIG_PAGE_IOC_2, MPI_POINTER PTR_CONFIG_PAGE_IOC_2,
   IOCPage2_t, MPI_POINTER pIOCPage2_t;
 
-- 
2.34.1

