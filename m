From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 10/11] scsi/atari: Revive "atascsi=" setup option
Date: Wed, 21 Mar 2012 10:51:54 +0100
Message-ID: <1332323515-7314-10-git-send-email-geert@linux-m68k.org>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-m68k@lists.linux-m68k.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Michael Schmitz <schmitzmic@googlemail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It was documented in Documentation/m68k/kernel-options.txt and
Documentation/scsi/scsi-parameters.txt, but the implementation was
missing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@googlemail.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_scsi.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 04a154f..3102ce5 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -734,17 +734,21 @@ int atari_scsi_release(struct Scsi_Host *sh)
 	return 1;
 }
 
-void __init atari_scsi_setup(char *str, int *ints)
+#ifndef MODULE
+static int __init atari_scsi_setup(char *str)
 {
 	/* Format of atascsi parameter is:
 	 *   atascsi=<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
 	 * Defaults depend on TT or Falcon, hostid determined at run time.
 	 * Negative values mean don't change.
 	 */
+	int ints[6];
+
+	get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (ints[0] < 1) {
 		printk("atari_scsi_setup: no arguments!\n");
-		return;
+		return 0;
 	}
 
 	if (ints[0] >= 1) {
@@ -777,8 +781,13 @@ void __init atari_scsi_setup(char *str, int *ints)
 			setup_use_tagged_queuing = !!ints[5];
 	}
 #endif
+
+	return 1;
 }
 
+__setup("atascsi=", atari_scsi_setup);
+#endif /* !MODULE */
+
 int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
 {
 	int rv;
-- 
1.7.0.4
