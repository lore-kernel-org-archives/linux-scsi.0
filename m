From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/8] scsi/sun3: sun3scsi_detect() and NCR5380_init() should be __init
Date: Mon, 13 Jun 2011 20:39:18 +0200
Message-ID: <1307990362-22768-5-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:39364 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab1FMSjk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 14:39:40 -0400
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>

WARNING: vmlinux.o(.text+0x18545c): Section mismatch in reference from the function sun3scsi_detect() to the function .init.text:NCR5380_print_options()
WARNING: vmlinux.o(.text+0x18556c): Section mismatch in reference from the function sun3scsi_detect() to the function .init.text:NCR5380_print_options()
WARNING: vmlinux.o(.text+0x187692): Section mismatch in reference from the function sun3scsi_detect() to the function .init.text:NCR5380_print_options()
WARNING: vmlinux.o(.text+0x187770): Section mismatch in reference from the function sun3scsi_detect() to the function .init.text:NCR5380_print_options()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_NCR5380.c  |    2 +-
 drivers/scsi/sun3_scsi.c     |    2 +-
 drivers/scsi/sun3_scsi_vme.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 29c8246..0d04c3a 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -842,7 +842,7 @@ static char *lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, char *pos, char *buffer,
  * 
  */
 
-static int NCR5380_init (struct Scsi_Host *instance, int flags)
+static int __init NCR5380_init(struct Scsi_Host *instance, int flags)
 {
     int i;
     SETUP_HOSTDATA(instance);
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 613f588..2ad6b91 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -195,7 +195,7 @@ static struct Scsi_Host *default_instance;
  *
  */
  
-int sun3scsi_detect(struct scsi_host_template * tpnt)
+int __init sun3scsi_detect(struct scsi_host_template * tpnt)
 {
 	unsigned long ioaddr;
 	static int called = 0;
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 7c526b8..cd6d779 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -137,7 +137,7 @@ static struct Scsi_Host *default_instance;
  *
  */
  
-static int sun3scsi_detect(struct scsi_host_template * tpnt)
+static int __init sun3scsi_detect(struct scsi_host_template * tpnt)
 {
 	unsigned long ioaddr, irq = 0;
 	static int called = 0;
-- 
1.7.0.4

