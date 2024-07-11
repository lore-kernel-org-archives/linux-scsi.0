Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6849416DC16;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=u1x/C+CorNn9dWOOlCAr+M2MfG25d9OUWp5mFqGPZQGAS+ZFlmd9TP0ZcdPF8GphNQV8eGP8l+hm6aE4chGxyZam8pshnL93dNCjXH3BdKUBs27KLNAIilMGMmrla6kbiMWx7kmz3S1b7Qh+22Z85rcUJmuW4mxdYp+5ZLXI9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=KJRtzRSoC+YD4ifccvdvij8WY1nz8g+drmk27AlHQwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=teL8j0zca30pKvDkaUPaeY+lpPU+MGzGuYtSHpXZNlHLL9XlqRQ3N6DjpEtU+hyvaQeCm+Zf+Pv0ai4pYgenYpsHAz46gi8MgPge2X8lqA5fmedBrKG6URkmdk+DVBQXAKq58sr2Z8KxJP374mOKMQY2JgGDE3MtLlnR088Lfxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RY+OuZ2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RY+OuZ2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226AAC4AF09;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=KJRtzRSoC+YD4ifccvdvij8WY1nz8g+drmk27AlHQwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RY+OuZ2TKBefmdXQSIg/eGd1L+8tbd7PPhOzuDJkWRKe7BrSbAnbSM9zhwtFMdEIg
	 LzbSh+rwuV49EMQ5fp/aN/EE/T57RMV/cPsJuGLCmU1CfWYfEYw72KjH5eP37wqgfN
	 DWJATSiLDw470Gt7zhnLgARARNd/hAds2fN8aMwTUu6mKrlI/h1So9IHTGVavhLeOE
	 Z0zMIRSo3ShcBOjoG1hEAIPL8nKKsGjVcvQYV7KptkymwjHCbbmPMsRdpMusQWTgPt
	 /rDK3c5EmznMrCxskPAAecpZbbLDXSe8jan0kVBTXimQYfOMXs31vX6HKhHpOegumt
	 I/4wO1YE4MovA==
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
Subject: [PATCH 3/6] scsi: message: fusion: struct _CONFIG_PAGE_RAID_PHYS_DISK_1: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:28:17 -0700
Message-Id: <20240711172821.123936-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2583; i=kees@kernel.org; h=from:subject; bh=KJRtzRSoC+YD4ifccvdvij8WY1nz8g+drmk27AlHQwc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBYzSnVQ68wF5ei0rKWx29joncaaILeM/2BQk 8+FkSUomRaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWMwAKCRCJcvTf3G3A Jom1D/9g/Ps1VLnG6OKWs8PoOZsmCXRCMBwLmXRoKXoa0Ov5J0/ObTivalAgKfehlP7WTtvsHLS rF/aX+elOIOAaeqHZTX232IdcXI3RsOfBArJ3DpbvyeQ+t59gTM/qksgfP0reTEhB3wbJIEmNWI TXvSlzWVgGyDJiXd2Ry60gESEXdmvJDxDfze7eqs8TpJO5U/d1NNoi0Y7osx96SinJgN2s/ZCO2 QuP3w/9skAG6kz1AIUW71aSWPkBiZ713sPHpXfF8hGPZvIv4w24NdQwfnjyuNYFK3FJ4/3iGRoD yhOEXSUFfRPMcI+bF4VWDYLArkv2jhsxvPh3/sB+OoKY426fTXCjhhAR4J1gzxhioj83OJIiI77 sldYu0ybXollOPNEwiRCsciuAZLTGNG3x84qdRAi6yf5V9JjQYQh8dxbaEJtpJSVaxq3d/gFBsM 3S4hkNIYg/wHBChLR56BJJ5jl2Fciaa9znLw1bNExRUBGOiHmnW+LBl/PBKFvg0EEQlsKjlKWF5 3Tkh4ADbUGf2B+5H0cvZoDCVWc2W1brUi5G9PRW0EOHLRkrh/ROCItOqKcNA7owOr69NebsRk5v pnqKf0uehDP/TY9QzhJWbdmwhpH9cu9mOHsD6ESTLnxuf+I95An3mxmjzVFBJ8yDPObbDxKAoYK FpCOLWn451la7Rg==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct _CONFIG_PAGE_RAID_PHYS_DISK_1 with a modern flexible array.

Additionally add __counted_by annotation since Path is only ever
accessed via a loops bounded by NumPhysDiskPaths:

lsi/mpi_cnfg.h:    RAID_PHYS_DISK1_PATH            Path[] __counted_by(NumPhysDiskPaths);/* 0Ch */
mptbase.c:      phys_disk->NumPhysDiskPaths = buffer->NumPhysDiskPaths;
mptbase.c:      for (i = 0; i < phys_disk->NumPhysDiskPaths; i++) {
mptbase.c:              phys_disk->Path[i].PhysDiskID = buffer->Path[i].PhysDiskID;
mptbase.c:              phys_disk->Path[i].PhysDiskBus = buffer->Path[i].PhysDiskBus;

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
index c7997e32e82e..e30132b57ae7 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -2447,14 +2447,6 @@ typedef struct _RAID_PHYS_DISK1_PATH
 #define MPI_RAID_PHYSDISK1_FLAG_INVALID         (0x0001)
 
 
-/*
- * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- * one and check Header.PageLength or NumPhysDiskPaths at runtime.
- */
-#ifndef MPI_RAID_PHYS_DISK1_PATH_MAX
-#define MPI_RAID_PHYS_DISK1_PATH_MAX    (1)
-#endif
-
 typedef struct _CONFIG_PAGE_RAID_PHYS_DISK_1
 {
     CONFIG_PAGE_HEADER              Header;             /* 00h */
@@ -2462,7 +2454,7 @@ typedef struct _CONFIG_PAGE_RAID_PHYS_DISK_1
     U8                              PhysDiskNum;        /* 05h */
     U16                             Reserved2;          /* 06h */
     U32                             Reserved1;          /* 08h */
-    RAID_PHYS_DISK1_PATH            Path[MPI_RAID_PHYS_DISK1_PATH_MAX];/* 0Ch */
+    RAID_PHYS_DISK1_PATH            Path[] __counted_by(NumPhysDiskPaths);/* 0Ch */
 } CONFIG_PAGE_RAID_PHYS_DISK_1, MPI_POINTER PTR_CONFIG_PAGE_RAID_PHYS_DISK_1,
   RaidPhysDiskPage1_t, MPI_POINTER pRaidPhysDiskPage1_t;
 
-- 
2.34.1

