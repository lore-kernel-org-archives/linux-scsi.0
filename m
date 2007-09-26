From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: [PATCH 3/3] NCR53C8XX: Remove deprecated IRQ flags (SA_*)
Date: Thu, 27 Sep 2007 01:36:23 +0300
Message-ID: <20070926223623.GC25905@Ahmed>
References: <20070926223343.GA25905@Ahmed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:15111 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763416AbXIZWgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 18:36:41 -0400
Received: by mu-out-0910.google.com with SMTP id i10so3981623mue
        for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2007 15:36:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20070926223343.GA25905@Ahmed>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, matthew@wil.cx, linux-scsi@vger.kernel.org

Hi Matthew,

A patch to stop using deprecated IRQ flags in ncr53c8xx documentaion. The new
IRQF_* macros are used instead.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/Documentation/scsi/ChangeLog.ncr53c8xx b/Documentation/scsi/ChangeLog.ncr53c8xx
index 7d03e9d..a9f721a 100644
--- a/Documentation/scsi/ChangeLog.ncr53c8xx
+++ b/Documentation/scsi/ChangeLog.ncr53c8xx
@@ -195,9 +195,9 @@ Sun Feb  14:00 1999 Gerard Roudier (groudier@club-internet.fr)
 	  Pointed out by Leonard Zubkoff.
 	- Allow to tune request_irq() flags from the boot command line using 
 	  ncr53c8xx=irqm:??, as follows:
-	  a) If bit 0x10 is set in irqm, SA_SHIRQ flag is not used.
-	  b) If bit 0x20 is set in irqm, SA_INTERRUPT flag is not used.
-	  By default the driver uses both SA_SHIRQ and SA_INTERRUPT.
+	  a) If bit 0x10 is set in irqm, IRQF_SHARED flag is not used.
+	  b) If bit 0x20 is set in irqm, IRQF_DISABLED flag is not used.
+	  By default the driver uses both IRQF_SHARED and IRQF_DISABLED.
 	  Option 'ncr53c8xx=irqm:0x20' may be used when an IRQ is shared by 
 	  a 53C8XX adapter and a network board.
 	- Tiny mispelling fixed (ABORT instead of ABRT). Was fortunately 
diff --git a/Documentation/scsi/ncr53c8xx.txt b/Documentation/scsi/ncr53c8xx.txt
index 39d409a..a65cea9 100644
--- a/Documentation/scsi/ncr53c8xx.txt
+++ b/Documentation/scsi/ncr53c8xx.txt
@@ -785,8 +785,8 @@ port address 0x1400.
         irqm:0     always open drain
         irqm:1     same as initial settings (assumed BIOS settings)
         irqm:2     always totem pole
-        irqm:0x10  driver will not use SA_SHIRQ flag when requesting irq
-        irqm:0x20  driver will not use SA_INTERRUPT flag when requesting irq
+        irqm:0x10  driver will not use IRQF_SHARED flag when requesting irq
+        irqm:0x20  driver will not use IRQF_DISABLED flag when requesting irq
 
     (Bits 0x10 and 0x20 can be combined with hardware irq mode option)
 
@@ -1236,15 +1236,15 @@ when the SCSI DATA IN phase is reentered after a phase mismatch.
 When an IRQ is shared by devices that are handled by different drivers, it 
 may happen that one driver complains about the request of the IRQ having 
 failed. Inder Linux-2.0, this may be due to one driver having requested the 
-IRQ using the SA_INTERRUPT flag but some other having requested the same IRQ 
+IRQ using the IRQF_DISABLED flag but some other having requested the same IRQ 
 without this flag. Under both Linux-2.0 and linux-2.2, this may be caused by 
-one driver not having requested the IRQ with the SA_SHIRQ flag.
+one driver not having requested the IRQ with the IRQF_SHARED flag.
 
 By default, the ncr53c8xx and sym53c8xx drivers request IRQs with both the 
-SA_INTERRUPT and the SA_SHIRQ flag under Linux-2.0 and with only the SA_SHIRQ 
+IRQF_DISABLED and the IRQF_SHARED flag under Linux-2.0 and with only the IRQF_SHARED 
 flag under Linux-2.2.
 
-Under Linux-2.0, you can disable use of SA_INTERRUPT flag from the boot 
+Under Linux-2.0, you can disable use of IRQF_DISABLED flag from the boot 
 command line by using the following option:
 
      ncr53c8xx=irqm:0x20   (for the generic ncr53c8xx driver)
@@ -1252,7 +1252,7 @@ command line by using the following option:
 
 If this does not fix the problem, then you may want to check how all other 
 drivers are requesting the IRQ and report the problem. Note that if at least 
-a single driver does not request the IRQ with the SA_SHIRQ flag (share IRQ), 
+a single driver does not request the IRQ with the IRQF_SHARED flag (share IRQ), 
 then the request of the IRQ obviously will not succeed for all the drivers.
 
 15. SCSI problem troubleshooting

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
