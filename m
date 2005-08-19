From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove aiclib.c
Date: Fri, 19 Aug 2005 18:57:13 +0200
Message-ID: <20050819165713.GA15912@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:7901 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932556AbVHSQ5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 12:57:17 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

#include of C files and macro tricks to rename symbols are evil and just
cause trouble.  Let's doublicate the two functions as they're going to
go away soon enough anyway.


Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-08-17 21:27:26.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-08-19 19:04:01.000000000 +0200
@@ -48,12 +48,6 @@
 
 static struct scsi_transport_template *ahd_linux_transport_template = NULL;
 
-/*
- * Include aiclib.c as part of our
- * "module dependencies are hard" work around.
- */
-#include "aiclib.c"
-
 #include <linux/init.h>		/* __setup */
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
@@ -372,8 +366,6 @@
 				 struct ahd_linux_device *,
 				 struct scsi_cmnd *);
 static void ahd_linux_setup_tag_info_global(char *p);
-static aic_option_callback_t ahd_linux_setup_tag_info;
-static aic_option_callback_t ahd_linux_setup_iocell_info;
 static int  aic79xx_setup(char *c);
 
 static int ahd_linux_unit;
@@ -907,6 +899,86 @@
 	}
 }
 
+static char *
+ahd_parse_brace_option(char *opt_name, char *opt_arg, char *end, int depth,
+		       void (*callback)(u_long, int, int, int32_t),
+		       u_long callback_arg)
+{
+	char	*tok_end;
+	char	*tok_end2;
+	int      i;
+	int      instance;
+	int	 targ;
+	int	 done;
+	char	 tok_list[] = {'.', ',', '{', '}', '\0'};
+
+	/* All options use a ':' name/arg separator */
+	if (*opt_arg != ':')
+		return (opt_arg);
+	opt_arg++;
+	instance = -1;
+	targ = -1;
+	done = FALSE;
+	/*
+	 * Restore separator that may be in
+	 * the middle of our option argument.
+	 */
+	tok_end = strchr(opt_arg, '\0');
+	if (tok_end < end)
+		*tok_end = ',';
+	while (!done) {
+		switch (*opt_arg) {
+		case '{':
+			if (instance == -1) {
+				instance = 0;
+			} else {
+				if (depth > 1) {
+					if (targ == -1)
+						targ = 0;
+				} else {
+					printf("Malformed Option %s\n",
+					       opt_name);
+					done = TRUE;
+				}
+			}
+			opt_arg++;
+			break;
+		case '}':
+			if (targ != -1)
+				targ = -1;
+			else if (instance != -1)
+				instance = -1;
+			opt_arg++;
+			break;
+		case ',':
+		case '.':
+			if (instance == -1)
+				done = TRUE;
+			else if (targ >= 0)
+				targ++;
+			else if (instance >= 0)
+				instance++;
+			opt_arg++;
+			break;
+		case '\0':
+			done = TRUE;
+			break;
+		default:
+			tok_end = end;
+			for (i = 0; tok_list[i]; i++) {
+				tok_end2 = strchr(opt_arg, tok_list[i]);
+				if ((tok_end2) && (tok_end2 < tok_end))
+					tok_end = tok_end2;
+			}
+			callback(callback_arg, instance, targ,
+				 simple_strtol(opt_arg, NULL, 0));
+			opt_arg = tok_end;
+			break;
+		}
+	}
+	return (opt_arg);
+}
+
 /*
  * Handle Linux boot parameters. This routine allows for assigning a value
  * to a parameter with a ':' between the parameter and the value.
@@ -964,18 +1036,18 @@
 		if (strncmp(p, "global_tag_depth", n) == 0) {
 			ahd_linux_setup_tag_info_global(p + n);
 		} else if (strncmp(p, "tag_info", n) == 0) {
-			s = aic_parse_brace_option("tag_info", p + n, end,
+			s = ahd_parse_brace_option("tag_info", p + n, end,
 			    2, ahd_linux_setup_tag_info, 0);
 		} else if (strncmp(p, "slewrate", n) == 0) {
-			s = aic_parse_brace_option("slewrate",
+			s = ahd_parse_brace_option("slewrate",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
 			    AIC79XX_SLEWRATE_INDEX);
 		} else if (strncmp(p, "precomp", n) == 0) {
-			s = aic_parse_brace_option("precomp",
+			s = ahd_parse_brace_option("precomp",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
 			    AIC79XX_PRECOMP_INDEX);
 		} else if (strncmp(p, "amplitude", n) == 0) {
-			s = aic_parse_brace_option("amplitude",
+			s = ahd_parse_brace_option("amplitude",
 			    p + n, end, 1, ahd_linux_setup_iocell_info,
 			    AIC79XX_AMPLITUDE_INDEX);
 		} else if (p[n] == ':') {
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_proc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_proc.c	2005-08-17 21:27:26.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_proc.c	2005-08-19 18:58:06.000000000 +0200
@@ -53,6 +53,49 @@
 static int	ahd_proc_write_seeprom(struct ahd_softc *ahd,
 				       char *buffer, int length);
 
+/*
+ * Table of syncrates that don't follow the "divisible by 4"
+ * rule. This table will be expanded in future SCSI specs.
+ */
+static struct {
+	u_int period_factor;
+	u_int period;	/* in 100ths of ns */
+} scsi_syncrates[] = {
+	{ 0x08, 625 },	/* FAST-160 */
+	{ 0x09, 1250 },	/* FAST-80 */
+	{ 0x0a, 2500 },	/* FAST-40 40MHz */
+	{ 0x0b, 3030 },	/* FAST-40 33MHz */
+	{ 0x0c, 5000 }	/* FAST-20 */
+};
+
+/*
+ * Return the frequency in kHz corresponding to the given
+ * sync period factor.
+ */
+static u_int
+ahd_calc_syncsrate(u_int period_factor)
+{
+	int i;
+	int num_syncrates;
+
+	num_syncrates = sizeof(scsi_syncrates) / sizeof(scsi_syncrates[0]);
+	/* See if the period is in the "exception" table */
+	for (i = 0; i < num_syncrates; i++) {
+
+		if (period_factor == scsi_syncrates[i].period_factor) {
+			/* Period in kHz */
+			return (100000000 / scsi_syncrates[i].period);
+		}
+	}
+
+	/*
+	 * Wasn't in the table, so use the standard
+	 * 4 times conversion.
+	 */
+	return (10000000 / (period_factor * 4 * 10));
+}
+
+
 static void
 copy_mem_info(struct info_str *info, char *data, int len)
 {
@@ -109,7 +152,7 @@
         speed = 3300;
         freq = 0;
 	if (tinfo->offset != 0) {
-		freq = aic_calc_syncsrate(tinfo->period);
+		freq = ahd_calc_syncsrate(tinfo->period);
 		speed = freq;
 	}
 	speed *= (0x01 << tinfo->width);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-08-17 21:27:26.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-08-19 19:03:53.000000000 +0200
@@ -125,12 +125,6 @@
 
 static struct scsi_transport_template *ahc_linux_transport_template = NULL;
 
-/*
- * Include aiclib.c as part of our
- * "module dependencies are hard" work around.
- */
-#include "aiclib.c"
-
 #include <linux/init.h>		/* __setup */
 #include <linux/mm.h>		/* For fetching system memory size */
 #include <linux/blkdev.h>		/* For block_size() */
@@ -391,7 +385,6 @@
 				 struct ahc_linux_device *,
 				 struct scsi_cmnd *);
 static void ahc_linux_setup_tag_info_global(char *p);
-static aic_option_callback_t ahc_linux_setup_tag_info;
 static int  aic7xxx_setup(char *s);
 
 static int ahc_linux_unit;
@@ -920,6 +913,86 @@
 	}
 }
 
+static char *
+ahc_parse_brace_option(char *opt_name, char *opt_arg, char *end, int depth,
+		       void (*callback)(u_long, int, int, int32_t),
+		       u_long callback_arg)
+{
+	char	*tok_end;
+	char	*tok_end2;
+	int      i;
+	int      instance;
+	int	 targ;
+	int	 done;
+	char	 tok_list[] = {'.', ',', '{', '}', '\0'};
+
+	/* All options use a ':' name/arg separator */
+	if (*opt_arg != ':')
+		return (opt_arg);
+	opt_arg++;
+	instance = -1;
+	targ = -1;
+	done = FALSE;
+	/*
+	 * Restore separator that may be in
+	 * the middle of our option argument.
+	 */
+	tok_end = strchr(opt_arg, '\0');
+	if (tok_end < end)
+		*tok_end = ',';
+	while (!done) {
+		switch (*opt_arg) {
+		case '{':
+			if (instance == -1) {
+				instance = 0;
+			} else {
+				if (depth > 1) {
+					if (targ == -1)
+						targ = 0;
+				} else {
+					printf("Malformed Option %s\n",
+					       opt_name);
+					done = TRUE;
+				}
+			}
+			opt_arg++;
+			break;
+		case '}':
+			if (targ != -1)
+				targ = -1;
+			else if (instance != -1)
+				instance = -1;
+			opt_arg++;
+			break;
+		case ',':
+		case '.':
+			if (instance == -1)
+				done = TRUE;
+			else if (targ >= 0)
+				targ++;
+			else if (instance >= 0)
+				instance++;
+			opt_arg++;
+			break;
+		case '\0':
+			done = TRUE;
+			break;
+		default:
+			tok_end = end;
+			for (i = 0; tok_list[i]; i++) {
+				tok_end2 = strchr(opt_arg, tok_list[i]);
+				if ((tok_end2) && (tok_end2 < tok_end))
+					tok_end = tok_end2;
+			}
+			callback(callback_arg, instance, targ,
+				 simple_strtol(opt_arg, NULL, 0));
+			opt_arg = tok_end;
+			break;
+		}
+	}
+	return (opt_arg);
+}
+
 /*
  * Handle Linux boot parameters. This routine allows for assigning a value
  * to a parameter with a ':' between the parameter and the value.
@@ -974,7 +1047,7 @@
 		if (strncmp(p, "global_tag_depth", n) == 0) {
 			ahc_linux_setup_tag_info_global(p + n);
 		} else if (strncmp(p, "tag_info", n) == 0) {
-			s = aic_parse_brace_option("tag_info", p + n, end,
+			s = ahc_parse_brace_option("tag_info", p + n, end,
 			    2, ahc_linux_setup_tag_info, 0);
 		} else if (p[n] == ':') {
 			*(options[i].flag) = simple_strtoul(p + n + 1, NULL, 0);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_proc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_proc.c	2005-08-17 21:27:26.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_proc.c	2005-08-19 18:58:00.000000000 +0200
@@ -54,6 +54,49 @@
 static int	ahc_proc_write_seeprom(struct ahc_softc *ahc,
 				       char *buffer, int length);
 
+/*
+ * Table of syncrates that don't follow the "divisible by 4"
+ * rule. This table will be expanded in future SCSI specs.
+ */
+static struct {
+	u_int period_factor;
+	u_int period;	/* in 100ths of ns */
+} scsi_syncrates[] = {
+	{ 0x08, 625 },	/* FAST-160 */
+	{ 0x09, 1250 },	/* FAST-80 */
+	{ 0x0a, 2500 },	/* FAST-40 40MHz */
+	{ 0x0b, 3030 },	/* FAST-40 33MHz */
+	{ 0x0c, 5000 }	/* FAST-20 */
+};
+
+/*
+ * Return the frequency in kHz corresponding to the given
+ * sync period factor.
+ */
+static u_int
+ahc_calc_syncsrate(u_int period_factor)
+{
+	int i;
+	int num_syncrates;
+
+	num_syncrates = sizeof(scsi_syncrates) / sizeof(scsi_syncrates[0]);
+	/* See if the period is in the "exception" table */
+	for (i = 0; i < num_syncrates; i++) {
+
+		if (period_factor == scsi_syncrates[i].period_factor) {
+			/* Period in kHz */
+			return (100000000 / scsi_syncrates[i].period);
+		}
+	}
+
+	/*
+	 * Wasn't in the table, so use the standard
+	 * 4 times conversion.
+	 */
+	return (10000000 / (period_factor * 4 * 10));
+}
+
+
 static void
 copy_mem_info(struct info_str *info, char *data, int len)
 {
@@ -106,7 +149,7 @@
         speed = 3300;
         freq = 0;
 	if (tinfo->offset != 0) {
-		freq = aic_calc_syncsrate(tinfo->period);
+		freq = ahc_calc_syncsrate(tinfo->period);
 		speed = freq;
 	}
 	speed *= (0x01 << tinfo->width);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aiclib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aiclib.c	2005-08-17 21:27:26.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aiclib.c	2005-08-19 18:59:08.000000000 +0200
@@ -32,124 +32,3 @@
 
 #include "aiclib.h"
 
-
-/*
- * Table of syncrates that don't follow the "divisible by 4"
- * rule. This table will be expanded in future SCSI specs.
- */
-static struct {
-	u_int period_factor;
-	u_int period;	/* in 100ths of ns */
-} scsi_syncrates[] = {
-	{ 0x08, 625 },	/* FAST-160 */
-	{ 0x09, 1250 },	/* FAST-80 */
-	{ 0x0a, 2500 },	/* FAST-40 40MHz */
-	{ 0x0b, 3030 },	/* FAST-40 33MHz */
-	{ 0x0c, 5000 }	/* FAST-20 */
-};
-
-/*
- * Return the frequency in kHz corresponding to the given
- * sync period factor.
- */
-u_int
-aic_calc_syncsrate(u_int period_factor)
-{
-	int i;
-	int num_syncrates;
-
-	num_syncrates = sizeof(scsi_syncrates) / sizeof(scsi_syncrates[0]);
-	/* See if the period is in the "exception" table */
-	for (i = 0; i < num_syncrates; i++) {
-
-		if (period_factor == scsi_syncrates[i].period_factor) {
-			/* Period in kHz */
-			return (100000000 / scsi_syncrates[i].period);
-		}
-	}
-
-	/*
-	 * Wasn't in the table, so use the standard
-	 * 4 times conversion.
-	 */
-	return (10000000 / (period_factor * 4 * 10));
-}
-
-char *
-aic_parse_brace_option(char *opt_name, char *opt_arg, char *end, int depth,
-		       aic_option_callback_t *callback, u_long callback_arg)
-{
-	char	*tok_end;
-	char	*tok_end2;
-	int      i;
-	int      instance;
-	int	 targ;
-	int	 done;
-	char	 tok_list[] = {'.', ',', '{', '}', '\0'};
-
-	/* All options use a ':' name/arg separator */
-	if (*opt_arg != ':')
-		return (opt_arg);
-	opt_arg++;
-	instance = -1;
-	targ = -1;
-	done = FALSE;
-	/*
-	 * Restore separator that may be in
-	 * the middle of our option argument.
-	 */
-	tok_end = strchr(opt_arg, '\0');
-	if (tok_end < end)
-		*tok_end = ',';
-	while (!done) {
-		switch (*opt_arg) {
-		case '{':
-			if (instance == -1) {
-				instance = 0;
-			} else {
-				if (depth > 1) {
-					if (targ == -1)
-						targ = 0;
-				} else {
-					printf("Malformed Option %s\n",
-					       opt_name);
-					done = TRUE;
-				}
-			}
-			opt_arg++;
-			break;
-		case '}':
-			if (targ != -1)
-				targ = -1;
-			else if (instance != -1)
-				instance = -1;
-			opt_arg++;
-			break;
-		case ',':
-		case '.':
-			if (instance == -1)
-				done = TRUE;
-			else if (targ >= 0)
-				targ++;
-			else if (instance >= 0)
-				instance++;
-			opt_arg++;
-			break;
-		case '\0':
-			done = TRUE;
-			break;
-		default:
-			tok_end = end;
-			for (i = 0; tok_list[i]; i++) {
-				tok_end2 = strchr(opt_arg, tok_list[i]);
-				if ((tok_end2) && (tok_end2 < tok_end))
-					tok_end = tok_end2;
-			}
-			callback(callback_arg, instance, targ,
-				 simple_strtol(opt_arg, NULL, 0));
-			opt_arg = tok_end;
-			break;
-		}
-	}
-	return (opt_arg);
-}
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aiclib.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aiclib.h	2005-08-17 21:27:26.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aiclib.h	2005-08-19 19:03:27.000000000 +0200
@@ -141,28 +141,6 @@
 	return (int)capacity;
 }
 
-/**************************** Module Library Hack *****************************/
-/*
- * What we'd like to do is have a single "scsi library" module that both the
- * aic7xxx and aic79xx drivers could load and depend on.  A cursory examination
- * of implementing module dependencies in Linux (handling the install and
- * initrd cases) does not look promissing.  For now, we just duplicate this
- * code in both drivers using a simple symbol renaming scheme that hides this
- * hack from the drivers.
- */
-#define AIC_LIB_ENTRY_CONCAT(x, prefix)	prefix ## x
-#define	AIC_LIB_ENTRY_EXPAND(x, prefix) AIC_LIB_ENTRY_CONCAT(x, prefix)
-#define AIC_LIB_ENTRY(x)		AIC_LIB_ENTRY_EXPAND(x, AIC_LIB_PREFIX)
-
-#define aic_calc_syncsrate		AIC_LIB_ENTRY(_calc_syncrate)
-
-u_int		aic_calc_syncsrate(u_int /*period_factor*/);
-
-typedef void aic_option_callback_t(u_long, int, int, int32_t);
-char *		aic_parse_brace_option(char *opt_name, char *opt_arg,
-				       char *end, int depth,
-				       aic_option_callback_t *, u_long);
-
 static __inline uint32_t
 scsi_4btoul(uint8_t *bytes)
 {
