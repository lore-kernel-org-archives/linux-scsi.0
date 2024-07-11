Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A07D161B43;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720718902; cv=none; b=dSLGgWUdkHHJMUBjoCgoqovdQiHI09H3FabbpKVk3kPmWyQyzEdZb7q/yh8DRQCrLsVS6PrqTJxrWkiSCGvqBqjeDP831Q+L5d05KQSjW6207JzIOVEDrJaESeuxUDlNIqQnfZ/bdOZrJ/pKJ1WnF3tr/VR2fAy2SxP97c81Jpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720718902; c=relaxed/simple;
	bh=S/t7jEfsjpSOFiX2lqIU3Uboq5XyFS6FeOQZndPIGIE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZlSZ2G4h6BHiUD4PUtKyYGBBEuHF0ghXpF91sUZZjJknzgvLvjQYZv6iy4veOOA1324JvdWgthqYsnlS7k3ZkRV/V213koHIuiRqkQ7S1Zdok1CIT6kT8w6xg034dqAsRBg+4y4PIhnb7SZD5W//nfEtws8C/AQ+COnjnDw48UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocbYwkZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocbYwkZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B95EC116B1;
	Thu, 11 Jul 2024 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720718902;
	bh=S/t7jEfsjpSOFiX2lqIU3Uboq5XyFS6FeOQZndPIGIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocbYwkZIbRZThQpOqDQiRvszH6StHF5tuWI+zDdk3c4P6f/0Ko+nxo84R4HRLhTT7
	 8xmQVMsRpNfMzXqsXPRb3o3oxNYuPw16e8lt5iDd35BBcPSxiaxy18eLB0mEXVm8p2
	 5zucKlHQDvJA5duk3yQ90QNBmTXBLsOuT+PAuBKePLJpR0/+pjVj7T5nviF8IsmgZZ
	 sM4ymqj0cTDMFrIzj34nLa9j5riV6VvTwL5t/R1WR+Mu/ljfSZdsWNEtUuFLEv5hTT
	 0ektS5tRdYxFgrL6QLW4goR2Y+eAhE3aHwvLotzhbFFoi/9pjWJniJDY0SCJCstw/M
	 dUNZEH4ikJ/kQ==
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
Subject: [PATCH 1/6] scsi: message: fusion: struct _RAID_VOL0_SETTINGS: Replace 1-element array with flexible array
Date: Thu, 11 Jul 2024 10:28:15 -0700
Message-Id: <20240711172821.123936-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2598; i=kees@kernel.org; h=from:subject; bh=S/t7jEfsjpSOFiX2lqIU3Uboq5XyFS6FeOQZndPIGIE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBmkBYz9kgTTMGIAtlV30HywJoIqN5yG0+IKrxfM Rxmxp5my4+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZpAWMwAKCRCJcvTf3G3A JrRjEACn7ztVfg6iizze+imGktoQFIv0ZdxFCxj80w/UO9p+bTxQ9zjpMqjcD1XB9FKsuktLWDq Oq3B3APJ7DwCuEtMDNF331HnIyNg0Ud0gcGvQ4bLkHwU9QbfTrO22DQSmdzO4feTjAG09/ALjgm EuHTDFe+vB7V0f1DukEjThNBdRly13mXQIXQUs+KrfaEfXHrGXLRMs7HXDqe8AKe8jaKleUo7N0 3uusN4oBBhXuLcTIKP0HttFChDcsdwBpPCZ15WvFRTBKKo7flcM6roE6WT3O+ZnD/FxDqY6vD+9 eP0BIAodeRKfmsKJI/Yda0kfwM40TnECm69LVhKAlZKAVlJCpzabolINZH0F81LKDS4j/vrxpZR 4afZ85C7DZ9dd/m1tj3VnSTUlbrxuduggCKxnTNSod1uMMqDdz9VMiuMOcMukaqs+A63XG0EeOa znm/Eh9zPm/wY5OsIcZfVIWHXuIiULsXviDrtomWkuskoGm6lIh/Q1+GavPO6DlLnEvXLh1njkr ME0SHw8M5k+IQMJ91tSum5cNM3rZmqxqwbMDWKK7iGIhNlLfDq5uKQXShXFrFPamjsMrx/LzBEi WEQq4nCoYmP2LYqJSBUFz/tU5Vs0p27fJQpK2Cr21Li/rYSUjxKyVp7fSaHTwGb7u75ajdMIgY4 yrjXX3H+H4lHpBQ==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Replace the deprecated[1] use of a 1-element array in
struct _RAID_VOL0_SETTINGS with a modern flexible array.

Additionally add __counted_by annotation since PhysDisk is only ever
accessed via a loops bounded by NumPhysDisks:

lsi/mpi_cnfg.h:    RAID_VOL0_PHYS_DISK     PhysDisk[] __counted_by(NumPhysDisks); /* 28h */
mptbase.c:	for (i = 0; i < buffer->NumPhysDisks; i++) {
mptbase.c:		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
mptsas.c:	for (i = 0; i < buffer->NumPhysDisks; i++) {
mptsas.c:		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
mptsas.c:	for (i = 0; i < buffer->NumPhysDisks; i++) {
mptsas.c:		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)

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
index 3770cb1cff7d..f59a741ef21c 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -2295,14 +2295,6 @@ typedef struct _RAID_VOL0_SETTINGS
 #define MPI_RAID_HOT_SPARE_POOL_6                       (0x40)
 #define MPI_RAID_HOT_SPARE_POOL_7                       (0x80)
 
-/*
- * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
- * one and check Header.PageLength at runtime.
- */
-#ifndef MPI_RAID_VOL_PAGE_0_PHYSDISK_MAX
-#define MPI_RAID_VOL_PAGE_0_PHYSDISK_MAX        (1)
-#endif
-
 typedef struct _CONFIG_PAGE_RAID_VOL_0
 {
     CONFIG_PAGE_HEADER      Header;         /* 00h */
@@ -2321,7 +2313,7 @@ typedef struct _CONFIG_PAGE_RAID_VOL_0
     U8                      DataScrubRate;  /* 25h */
     U8                      ResyncRate;     /* 26h */
     U8                      InactiveStatus; /* 27h */
-    RAID_VOL0_PHYS_DISK     PhysDisk[MPI_RAID_VOL_PAGE_0_PHYSDISK_MAX];/* 28h */
+    RAID_VOL0_PHYS_DISK     PhysDisk[] __counted_by(NumPhysDisks); /* 28h */
 } CONFIG_PAGE_RAID_VOL_0, MPI_POINTER PTR_CONFIG_PAGE_RAID_VOL_0,
   RaidVolumePage0_t, MPI_POINTER pRaidVolumePage0_t;
 
-- 
2.34.1

