From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] ncr53c8xx: move driver local quirks into the scsi blacklist
Date: 04 Oct 2004 12:46:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096911968.2290.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5785 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268367AbUJDRqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Oct 2004 13:46:09 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i94Hk7m13239
	for <linux-scsi@vger.kernel.org>; Mon, 4 Oct 2004 13:46:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

No driver should have a separate blacklist from the mid-layer.

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/03 18:20:20-05:00 jejb@pashleys.(none) 
#   ncr53c8xx: move driver local quirks up to scsi blacklist
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# include/scsi/scsi_devinfo.h
#   2004/10/03 18:16:35-05:00 jejb@pashleys.(none) +1 -0
#   ncr53c8xx: move driver local quirks up to scsi blacklist
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# include/scsi/scsi_device.h
#   2004/10/03 18:16:35-05:00 jejb@pashleys.(none) +1 -0
#   ncr53c8xx: move driver local quirks up to scsi blacklist
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/scsi_scan.c
#   2004/10/03 18:16:35-05:00 jejb@pashleys.(none) +7 -0
#   ncr53c8xx: move driver local quirks up to scsi blacklist
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/scsi_devinfo.c
#   2004/10/03 18:16:34-05:00 jejb@pashleys.(none) +4 -0
#   ncr53c8xx: move driver local quirks up to scsi blacklist
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/ncr53c8xx.c
#   2004/10/03 18:16:33-05:00 jejb@pashleys.(none) +3 -98
#   ncr53c8xx: move driver local quirks up to scsi blacklist
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
diff -Nru a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	2004-10-04 12:44:24 -05:00
+++ b/drivers/scsi/ncr53c8xx.c	2004-10-04 12:44:24 -05:00
@@ -398,20 +398,6 @@
 
 /*==========================================================
 **
-**	"Special features" of targets.
-**	quirks field		of struct tcb.
-**	actualquirks field	of struct ccb.
-**
-**==========================================================
-*/
-
-#define	QUIRK_AUTOSAVE	(0x01)
-#define	QUIRK_NOMSG	(0x02)
-#define QUIRK_NOSYNC	(0x10)
-#define QUIRK_NOWIDE16	(0x20)
-
-/*==========================================================
-**
 **	Capability bits in Inquire response byte 7.
 **
 **==========================================================
@@ -1151,7 +1137,7 @@
 #endif
 	ncrcmd  save_dp		[  7];
 	ncrcmd  restore_dp	[  5];
-	ncrcmd  disconnect	[ 17];
+	ncrcmd  disconnect	[ 10];
 	ncrcmd	msg_out		[  9];
 	ncrcmd	msg_out_done	[  7];
 	ncrcmd  idle		[  2];
@@ -1251,7 +1237,6 @@
 static	void	ncr_int_ma	(struct ncb *np);
 static	void	ncr_int_sir	(struct ncb *np);
 static  void    ncr_int_sto     (struct ncb *np);
-static	u_long	ncr_lookup	(char* id);
 static	void	ncr_negotiate	(struct ncb* np, struct tcb* tp);
 static	int	ncr_prepare_nego(struct ncb *np, struct ccb *cp, u_char *msgptr);
 
@@ -1844,21 +1829,6 @@
 	*/
 	SCR_LOAD_REG (HS_REG, HS_DISCONNECT),
 		0,
-	/*
-	**	If QUIRK_AUTOSAVE is set,
-	**	do an "save pointer" operation.
-	*/
-	SCR_FROM_REG (QU_REG),
-		0,
-	SCR_JUMP ^ IFFALSE (MASK (QUIRK_AUTOSAVE, QUIRK_AUTOSAVE)),
-		PADDR (cleanup_ok),
-	/*
-	**	like SAVE_DP message:
-	**	Copy TEMP register to SAVEP in header.
-	*/
-	SCR_COPY (4),
-		RADDR (temp),
-		NADDR (header.savep),
 	SCR_JUMP,
 		PADDR (cleanup_ok),
 
@@ -3740,7 +3710,7 @@
 	/*
 	**	status
 	*/
-	cp->actualquirks		= tp->quirks;
+	cp->actualquirks		= 0;
 	cp->host_status			= cp->nego_status ? HS_NEGOTIATE : HS_BUSY;
 	cp->scsi_status			= S_ILLEGAL;
 	cp->parity_status		= 0;
@@ -6071,7 +6041,7 @@
 		/*
 		**	Select without ATN for quirky devices.
 		*/
-		if (tp->quirks & QUIRK_NOMSG)
+		if (cmd->device->select_no_atn)
 			cp->start.schedule.l_paddr =
 			cpu_to_scr(NCB_SCRIPTH_PHYS (np, select_no_atn));
 
@@ -7062,15 +7032,6 @@
 		goto fail;
 
 	/*
-	**	Get device quirks from a speciality table.
-	*/
-	tp->quirks = ncr_lookup (inq_data);
-	if (tp->quirks && bootverbose) {
-		PRINT_LUN(np, tn, ln);
-		printk ("quirks=%x.\n", tp->quirks);
-	}
-
-	/*
 	**	Evaluate trustable target/unit capabilities.
 	**	We only believe device version >= SCSI-2 that 
 	**	use appropriate response data format (2).
@@ -7338,62 +7299,6 @@
 		err |= 4;
 	};
 	return (err);
-}
-
-/*==========================================================
-**
-**
-**	Device lookup.
-**
-**	@GENSCSI@ should be integrated to scsiconf.c
-**
-**
-**==========================================================
-*/
-
-struct table_entry {
-	char *	manufacturer;
-	char *	model;
-	char *	version;
-	u_long	info;
-};
-
-static struct table_entry device_tab[] =
-{
-#if 0
-	{"", "", "", QUIRK_NOMSG},
-#endif
-	{"SONY", "SDT-5000", "3.17", QUIRK_NOMSG},
-	{"WangDAT", "Model 2600", "01.7", QUIRK_NOMSG},
-	{"WangDAT", "Model 3200", "02.2", QUIRK_NOMSG},
-	{"WangDAT", "Model 1300", "02.4", QUIRK_NOMSG},
-	{"", "", "", 0} /* catch all: must be last entry. */
-};
-
-static u_long ncr_lookup(char * id)
-{
-	struct table_entry * p = device_tab;
-	char *d, *r, c;
-
-	for (;;p++) {
-
-		d = id+8;
-		r = p->manufacturer;
-		while ((c=*r++)) if (c!=*d++) break;
-		if (c) continue;
-
-		d = id+16;
-		r = p->model;
-		while ((c=*r++)) if (c!=*d++) break;
-		if (c) continue;
-
-		d = id+32;
-		r = p->version;
-		while ((c=*r++)) if (c!=*d++) break;
-		if (c) continue;
-
-		return (p->info);
-	}
 }
 
 /*==========================================================
diff -Nru a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	2004-10-04 12:44:24 -05:00
+++ b/drivers/scsi/scsi_devinfo.c	2004-10-04 12:44:24 -05:00
@@ -83,6 +83,7 @@
 	{"SONY", "CD-ROM CDU-55S", "1.0i", BLIST_NOLUN},
 	{"SONY", "CD-ROM CDU-561", "1.7x", BLIST_NOLUN},
 	{"SONY", "CD-ROM CDU-8012", NULL, BLIST_NOLUN},
+	{"SONY", "SDT-5000", "3.17", BLIST_SELECT_NO_ATN},
 	{"TANDBERG", "TDC 3600", "U07", BLIST_NOLUN},	/* locks up */
 	{"TEAC", "CD-R55S", "1.0H", BLIST_NOLUN},	/* locks up */
 	/*
@@ -196,6 +197,9 @@
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
+	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
+	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2004-10-04 12:44:24 -05:00
+++ b/drivers/scsi/scsi_scan.c	2004-10-04 12:44:24 -05:00
@@ -575,6 +575,13 @@
 		sdev->borken = 0;
 
 	/*
+	 * Apparently some really broken devices (contrary to the SCSI
+	 * standards) need to be selected without asserting ATN
+	 */
+	if (*bflags & BLIST_SELECT_NO_ATN)
+		sdev->select_no_atn = 1;
+
+	/*
 	 * Some devices may not want to have a start command automatically
 	 * issued when a device is added.
 	 */
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	2004-10-04 12:44:24 -05:00
+++ b/include/scsi/scsi_device.h	2004-10-04 12:44:24 -05:00
@@ -110,6 +110,7 @@
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
+	unsigned select_no_atn:1;
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
diff -Nru a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
--- a/include/scsi/scsi_devinfo.h	2004-10-04 12:44:24 -05:00
+++ b/include/scsi/scsi_devinfo.h	2004-10-04 12:44:24 -05:00
@@ -26,4 +26,5 @@
 #define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
 #define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
 #define BLIST_NO_ULD_ATTACH	0x100000 /* device is actually for RAID config */
+#define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
 #endif

