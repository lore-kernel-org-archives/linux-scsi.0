From: Doug Maxey <dwm@austin.ibm.com>
Subject: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Sat, 23 Oct 2004 19:55:36 -0500
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <200410240055.i9O0taCf006206@falcon10.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
To: Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <greg@kroah.com>
Cc: linuxppc64-dev@ozlabs.org, Linux IDE Mailing List <linux-ide@vger.kernel.org>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Jacob Moilanen <moilanen@austin.ibm.com>, Olof Johansson <olof@austin.ibm.com>, dwm@austin.ibm.com
List-Id: linux-scsi@vger.kernel.org


Name: inline ide_fix_driveid()

Rationale:
	This is a fix for bugme.osdl 3819.
	With any of the 2.6.9 release flavors (vanilla, mm1, ac3), one
	cannot build the usb isd200 module due to the dependency on
	ide_fix_driveid() being exported from ide-iops.

Description:
	When building IDE modular, the current ide_fix_driveid() is
	exported from ide-iops.c.  This patch makes the function an inline.

Status: compile tested on ppc64.  Other issues prevent run test.


Signed-off-by: Doug Maxey <dwm@austin.ibm.com>

ChangeLog:

++doug

 drivers/ide/ide-iops.c |   98 -------------------------------------------------
 include/linux/ide.h    |   48 +++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 99 deletions(-)

diff -Nwupa lk-2.6.9-mm1/drivers/ide/ide-iops.c lk-2.6.9-mm1.edit/drivers/ide/ide-iops.c
--- lk-2.6.9-mm1/drivers/ide/ide-iops.c	2004-10-22 15:10:30.465342832 -0500
+++ lk-2.6.9-mm1.edit/drivers/ide/ide-iops.c	2004-10-23 00:22:16.901355000 -0500
@@ -352,104 +352,6 @@ EXPORT_SYMBOL(atapi_output_bytes);
 /*
  * Beginning of Taskfile OPCODE Library and feature sets.
  */
-void ide_fix_driveid (struct hd_driveid *id)
-{
-#ifndef __LITTLE_ENDIAN
-# ifdef __BIG_ENDIAN
-	int i;
-	u16 *stringcast;
-
-	id->config         = __le16_to_cpu(id->config);
-	id->cyls           = __le16_to_cpu(id->cyls);
-	id->reserved2      = __le16_to_cpu(id->reserved2);
-	id->heads          = __le16_to_cpu(id->heads);
-	id->track_bytes    = __le16_to_cpu(id->track_bytes);
-	id->sector_bytes   = __le16_to_cpu(id->sector_bytes);
-	id->sectors        = __le16_to_cpu(id->sectors);
-	id->vendor0        = __le16_to_cpu(id->vendor0);
-	id->vendor1        = __le16_to_cpu(id->vendor1);
-	id->vendor2        = __le16_to_cpu(id->vendor2);
-	stringcast = (u16 *)&id->serial_no[0];
-	for (i = 0; i < (20/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->buf_type       = __le16_to_cpu(id->buf_type);
-	id->buf_size       = __le16_to_cpu(id->buf_size);
-	id->ecc_bytes      = __le16_to_cpu(id->ecc_bytes);
-	stringcast = (u16 *)&id->fw_rev[0];
-	for (i = 0; i < (8/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	stringcast = (u16 *)&id->model[0];
-	for (i = 0; i < (40/2); i++)
-		stringcast[i] = __le16_to_cpu(stringcast[i]);
-	id->dword_io       = __le16_to_cpu(id->dword_io);
-	id->reserved50     = __le16_to_cpu(id->reserved50);
-	id->field_valid    = __le16_to_cpu(id->field_valid);
-	id->cur_cyls       = __le16_to_cpu(id->cur_cyls);
-	id->cur_heads      = __le16_to_cpu(id->cur_heads);
-	id->cur_sectors    = __le16_to_cpu(id->cur_sectors);
-	id->cur_capacity0  = __le16_to_cpu(id->cur_capacity0);
-	id->cur_capacity1  = __le16_to_cpu(id->cur_capacity1);
-	id->lba_capacity   = __le32_to_cpu(id->lba_capacity);
-	id->dma_1word      = __le16_to_cpu(id->dma_1word);
-	id->dma_mword      = __le16_to_cpu(id->dma_mword);
-	id->eide_pio_modes = __le16_to_cpu(id->eide_pio_modes);
-	id->eide_dma_min   = __le16_to_cpu(id->eide_dma_min);
-	id->eide_dma_time  = __le16_to_cpu(id->eide_dma_time);
-	id->eide_pio       = __le16_to_cpu(id->eide_pio);
-	id->eide_pio_iordy = __le16_to_cpu(id->eide_pio_iordy);
-	for (i = 0; i < 2; ++i)
-		id->words69_70[i] = __le16_to_cpu(id->words69_70[i]);
-	for (i = 0; i < 4; ++i)
-		id->words71_74[i] = __le16_to_cpu(id->words71_74[i]);
-	id->queue_depth    = __le16_to_cpu(id->queue_depth);
-	for (i = 0; i < 4; ++i)
-		id->words76_79[i] = __le16_to_cpu(id->words76_79[i]);
-	id->major_rev_num  = __le16_to_cpu(id->major_rev_num);
-	id->minor_rev_num  = __le16_to_cpu(id->minor_rev_num);
-	id->command_set_1  = __le16_to_cpu(id->command_set_1);
-	id->command_set_2  = __le16_to_cpu(id->command_set_2);
-	id->cfsse          = __le16_to_cpu(id->cfsse);
-	id->cfs_enable_1   = __le16_to_cpu(id->cfs_enable_1);
-	id->cfs_enable_2   = __le16_to_cpu(id->cfs_enable_2);
-	id->csf_default    = __le16_to_cpu(id->csf_default);
-	id->dma_ultra      = __le16_to_cpu(id->dma_ultra);
-	id->trseuc         = __le16_to_cpu(id->trseuc);
-	id->trsEuc         = __le16_to_cpu(id->trsEuc);
-	id->CurAPMvalues   = __le16_to_cpu(id->CurAPMvalues);
-	id->mprc           = __le16_to_cpu(id->mprc);
-	id->hw_config      = __le16_to_cpu(id->hw_config);
-	id->acoustic       = __le16_to_cpu(id->acoustic);
-	id->msrqs          = __le16_to_cpu(id->msrqs);
-	id->sxfert         = __le16_to_cpu(id->sxfert);
-	id->sal            = __le16_to_cpu(id->sal);
-	id->spg            = __le32_to_cpu(id->spg);
-	id->lba_capacity_2 = __le64_to_cpu(id->lba_capacity_2);
-	for (i = 0; i < 22; i++)
-		id->words104_125[i]   = __le16_to_cpu(id->words104_125[i]);
-	id->last_lun       = __le16_to_cpu(id->last_lun);
-	id->word127        = __le16_to_cpu(id->word127);
-	id->dlf            = __le16_to_cpu(id->dlf);
-	id->csfo           = __le16_to_cpu(id->csfo);
-	for (i = 0; i < 26; i++)
-		id->words130_155[i] = __le16_to_cpu(id->words130_155[i]);
-	id->word156        = __le16_to_cpu(id->word156);
-	for (i = 0; i < 3; i++)
-		id->words157_159[i] = __le16_to_cpu(id->words157_159[i]);
-	id->cfa_power      = __le16_to_cpu(id->cfa_power);
-	for (i = 0; i < 14; i++)
-		id->words161_175[i] = __le16_to_cpu(id->words161_175[i]);
-	for (i = 0; i < 31; i++)
-		id->words176_205[i] = __le16_to_cpu(id->words176_205[i]);
-	for (i = 0; i < 48; i++)
-		id->words206_254[i] = __le16_to_cpu(id->words206_254[i]);
-	id->integrity_word  = __le16_to_cpu(id->integrity_word);
-# else
-#  error "Please fix <asm/byteorder.h>"
-# endif
-#endif
-}
-
-EXPORT_SYMBOL(ide_fix_driveid);
 
 void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
 {
diff -Nwupa lk-2.6.9-mm1/include/linux/ide.h lk-2.6.9-mm1.edit/include/linux/ide.h
--- lk-2.6.9-mm1/include/linux/ide.h	2004-10-22 15:10:36.748318728 -0500
+++ lk-2.6.9-mm1.edit/include/linux/ide.h	2004-10-23 15:28:52.635380680 -0500
@@ -1204,7 +1204,53 @@ extern ide_startstop_t ide_abort(ide_dri
  */
 extern void ide_cmd(ide_drive_t *, u8, u8, ide_handler_t *);
 
-extern void ide_fix_driveid(struct hd_driveid *);
+/*
+ * ide_fix_driveid - fix IDENTIFY DEVICE data for big endian machines.
+ * @id - pointer to data from drive.
+ *
+ * Could be a one liner except for the 3 x 32 bit and 2 x 64 bit
+ * fields.  Offsets are from d1532v1r4.
+ */
+static inline void ide_fix_driveid (struct hd_driveid *id)
+{
+#ifndef __LITTLE_ENDIAN
+# ifdef __BIG_ENDIAN
+	u16 *sp = (u16*)id;
+
+	for (; sp < ((u16*)id) + 61; sp++) *sp = __le16_to_cpu(*sp);
+
+	/* lba_capacity */
+	*((u32*)sp)  = __le32_to_cpu(*((u32*)sp));
+	sp += 2;
+
+	for (; sp < ((u16*)id) + 98; sp++)
+		*sp = __le16_to_cpu(*sp);
+
+	/* Streaming Perfomance Granularity. words 98-99 */
+	*((u32*)sp)  = __le32_to_cpu(*((u32*)sp));
+	sp += 2;			/* word 100 */
+
+	/* lba_capacity2. words 100-103 */
+	*((u64*)sp) = __le64_to_cpu(*((u64*)sp));
+	sp += 4;			/* word 104 */
+
+	for (; sp < ((u16*)id) + 117; sp++)
+		*sp = __le16_to_cpu(*sp);
+
+
+	/* Words per Logical Sector. words 117-118 */
+	*((u32*)sp)  = __le32_to_cpu(*((u32*)sp));
+	sp += 2;			/* word 119 */
+
+	for (; sp < ((u16*)id) + 256; sp++)
+		*sp = __le16_to_cpu(*sp);
+
+# else
+#  error "Please fix <asm/byteorder.h>"
+# endif
+#endif
+}
+
 /*
  * ide_fixstring() cleans up and (optionally) byte-swaps a text string,
  * removing leading/trailing blanks and compressing internal blanks.








