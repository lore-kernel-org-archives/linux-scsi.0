From: Michael Schmitz <schmitzmic@gmail.com>
Subject: [PATCH v3 4/4] m68k/atari - atari_scsi: use correct virt/phys translation for DMA buffer
Date: Mon, 31 Mar 2014 21:06:08 +1300
Message-ID: <1396253168-25601-5-git-send-email-schmitz@debian.org>
References: <1396253168-25601-1-git-send-email-schmitz@debian.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1396253168-25601-1-git-send-email-schmitz@debian.org>
Sender: linux-m68k-owner@vger.kernel.org
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, debian-68k@lists.debian.org, Michael Schmitz <schmitz@debian.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With the kernel running from FastRAM instead of ST-RAM, none of ST-RAM is
mapped by mem_init, and DMA-addressable buffer must be mapped by ioremap.

Use platform specific virt/phys translation helpers for this case.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 296c936..a8d721f 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -639,7 +639,7 @@ static int __init atari_scsi_detect(struct scsi_host_template *host)
 					"double buffer\n");
 			return 0;
 		}
-		atari_dma_phys_buffer = virt_to_phys(atari_dma_buffer);
+		atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
 		atari_dma_orig_addr = 0;
 	}
 #endif
-- 
1.7.0.4
