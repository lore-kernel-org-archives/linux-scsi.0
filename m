From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH 3/4] scsi: ultrastor: Use correct format identifier for kernel pointer
Date: Mon, 11 Apr 2016 09:25:53 -0400
Message-ID: <e3ec50672b8e8fd8279178bdba00edfe9af85cbe.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36095 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637AbcDKN0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 09:26:41 -0400
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
In-Reply-To: <cover.1460379702.git.vilhelm.gray@gmail.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org, William Breathitt Gray <vilhelm.gray@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>

The 'bios_segment' member of a struct ultrastor_config is passed to the
sprintf function with a respective %05X format identifier. The
'bio_segment' member is a kernel pointer, but the %X format identifier
expects an int data type. A cast to int is correctly used to satisfy the
format identifier, but this assumes that the int data type is the same
size as the kernel pointer, which is not the case on several
architectures such as X86_64. This patch removes the int cast and
replaces the %05X format identifier with %pK in order to print the
'bio_segment' member regardless of architecture.

Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
---
 drivers/scsi/ultrastor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 14e0c40..2e99f98 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -670,12 +670,12 @@ static const char *ultrastor_info(struct Scsi_Host * shpnt)
       sprintf(buf, "UltraStor 24F SCSI @ Slot %u IRQ%u",
 	      config.slot, config.interrupt);
     else if (config.subversion)
-      sprintf(buf, "UltraStor 34F SCSI @ Port %03X BIOS %05X IRQ%u",
-	      config.port_address, (int)config.bios_segment,
+      sprintf(buf, "UltraStor 34F SCSI @ Port %03X BIOS %pK IRQ%u",
+	      config.port_address, config.bios_segment,
 	      config.interrupt);
     else
-      sprintf(buf, "UltraStor 14F SCSI @ Port %03X BIOS %05X IRQ%u DMA%u",
-	      config.port_address, (int)config.bios_segment,
+      sprintf(buf, "UltraStor 14F SCSI @ Port %03X BIOS %pK IRQ%u DMA%u",
+	      config.port_address, config.bios_segment,
 	      config.interrupt, config.dma_channel);
     return buf;
 }
-- 
2.7.3

