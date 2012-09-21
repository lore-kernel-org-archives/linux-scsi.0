From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] aic7xxx_old: silence GCC warnings
Date: Fri, 21 Sep 2012 11:28:43 +0200
Message-ID: <1348219723.1581.5.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Building the aic7xxx_old driver triggers these GCC warnings:
    drivers/scsi/aic7xxx_old.c:7901:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
    drivers/scsi/aic7xxx_old.c:7898:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]
    drivers/scsi/aic7xxx_old.c:8517:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
    drivers/scsi/aic7xxx_old.c:8510:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]

Fix these warnings by adopting the idiom used elsewhere in this driver.
Since AHC_EISA and AHC_VL are only ever set for AHC_AIC7770 this fix
should not lead to any functional change.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed these warnings while building v3.6-rc6 on current Fedora
17, using Fedora's default config.

1) Compile tested only.

2) This patch is not checkpatch clean. But this file actually triggers
thousands of checkpatch errors and warnings:
    total: 4779 errors, 7528 warnings, 11149 lines checked

So I didn't bother to fix the few errors and warnings this patch
triggers by sticking to this file (lack of) coding style.

 drivers/scsi/aic7xxx_old.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 5b212f0..1a381c8 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -7893,12 +7893,12 @@ aic7xxx_register(struct scsi_host_template *template, struct aic7xxx_host *p,
 
   printk(KERN_INFO "(scsi%d) <%s> found at ", p->host_no,
     board_names[p->board_name_index]);
-  switch(p->chip)
+  switch(p->chip & ~AHC_CHIPID_MASK)
   {
-    case (AHC_AIC7770|AHC_EISA):
+    case AHC_EISA:
       printk("EISA slot %d\n", p->pci_device_fn);
       break;
-    case (AHC_AIC7770|AHC_VL):
+    case AHC_VL:
       printk("VLB slot %d\n", p->pci_device_fn);
       break;
     default:
@@ -8505,16 +8505,16 @@ aic7xxx_load_seeprom(struct aic7xxx_host *p, unsigned char *sxfrctl1)
   {
     printk(KERN_INFO "aic7xxx: Loading serial EEPROM...");
   }
-  switch (p->chip)
+  switch (p->chip & ~AHC_CHIPID_MASK)
   {
-    case (AHC_AIC7770|AHC_EISA):  /* None of these adapters have seeproms. */
+    case AHC_EISA:  /* None of these adapters have seeproms. */
       if (aic_inb(p, SCSICONF) & TERM_ENB)
         p->flags |= AHC_TERM_ENB_A;
       if ( (p->features & AHC_TWIN) && (aic_inb(p, SCSICONF + 1) & TERM_ENB) )
         p->flags |= AHC_TERM_ENB_B;
       break;
 
-    case (AHC_AIC7770|AHC_VL):
+    case AHC_VL:
       have_seeprom = read_284x_seeprom(p, (struct seeprom_config *) scarray);
       break;
 
-- 
1.7.11.4
