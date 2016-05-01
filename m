From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: [PATCH RESEND] scsi: ultrastor: Use correct format identifier for
 kernel pointer
Date: Sun, 1 May 2016 17:54:08 -0400
Message-ID: <20160501215356.GA16432@sophia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The 'bios_segment' member of a struct ultrastor_config is passed to the
sprintf function with a respective %05X format identifier. The
'bio_segment' member is a kernel pointer, but the %X format identifier
expects an int data type. A cast to int is correctly used to satisfy the
format identifier, but this assumes that the int data type is the same
size as the kernel pointer, which is not the case on several
architectures such as X86_64. This patch removes the int cast and
replaces the %05X format identifier with %pK in order to print the
'bio_segment' member regardless of architecture.

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
