From: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 0/3] [SCSI] mvsas: fix multiple shift issues
Date: Mon,  5 Nov 2012 14:53:00 -0500
Message-ID: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Xi Wang <xi.wang@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The main issue is that bit(n) is defined as:

	(u32)1 << n

Thus bit(n) with n >= 32 will produce 0 or 1, depending on the
architecture.  This is also undefined behavior in C.

The OR with sata_reg_set (u64) then doesn't work because bit()
does a 32-bit shift, which should have been a 64-bit shift:

	if (i >= 32) {
		mvi->sata_reg_set |= bit(i);
		...
	}

The other two patches fix similar oversized shift issues.

Xi Wang (3):
  [SCSI] mvsas: fix shift in mvs_94xx_assign_reg_set()
  [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
  [SCSI] mvsas: fix shift in mv_ffc64()

 drivers/scsi/mvsas/mv_94xx.c |    8 +++++---
 drivers/scsi/mvsas/mv_94xx.h |   14 ++------------
 drivers/scsi/mvsas/mv_sas.h  |    2 +-
 3 files changed, 8 insertions(+), 16 deletions(-)

-- 
1.7.10.4
