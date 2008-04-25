From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/5] aic7xxx: add const
Date: Fri, 25 Apr 2008 04:36:01 +0200
Message-ID: <200804250436.01295.vda.linux@googlemail.com>
References: <200804250432.16943.vda.linux@googlemail.com> <200804250434.49377.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ROUEIr1tmV6N3CG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:15892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbYDYChO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 22:37:14 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3380872fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 19:37:12 -0700 (PDT)
In-Reply-To: <200804250434.49377.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

--Boundary-00=_ROUEIr1tmV6N3CG
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch adds more const keywords where appropriate.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_ROUEIr1tmV6N3CG
Content-Type: text/x-diff;
  charset="koi8-r";
  name="aic_debloat_3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aic_debloat_3.diff"

--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx.h	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx.h	Thu Apr 24 07:54:17 2008
@@ -814,9 +814,9 @@
  */
 struct ahd_phase_table_entry {
         uint8_t phase;
         uint8_t mesg_out; /* Message response to parity errors */
-	char *phasemsg;
+	const char *phasemsg;
 };
 
 /************************** Serial EEPROM Format ******************************/
 
@@ -1334,11 +1334,11 @@
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
 
 /***************************** PCI Front End *********************************/
-struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
+const struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
 int			  ahd_pci_config(struct ahd_softc *,
-					 struct ahd_pci_identity *);
+					 const struct ahd_pci_identity *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
 #ifdef CONFIG_PM
 void	ahd_pci_suspend(struct ahd_softc *);
 void	ahd_pci_resume(struct ahd_softc *);
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_core.c	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx_core.c	Thu Apr 24 07:54:17 2008
@@ -51,9 +51,9 @@
 #endif
 
 
 /***************************** Lookup Tables **********************************/
-static char *ahd_chip_names[] =
+static const char *const ahd_chip_names[] =
 {
 	"NONE",
 	"aic7901",
 	"aic7902",
@@ -65,12 +65,12 @@
  * Hardware error codes.
  */
 struct ahd_hard_error_entry {
         uint8_t errno;
-	char *errmesg;
+	const char *errmesg;
 };
 
-static struct ahd_hard_error_entry ahd_hard_errors[] = {
+static const struct ahd_hard_error_entry ahd_hard_errors[] = {
 	{ DSCTMOUT,	"Discard Timer has timed out" },
 	{ ILLOPCODE,	"Illegal Opcode in sequencer program" },
 	{ SQPARERR,	"Sequencer Parity Error" },
 	{ DPARERR,	"Data-path Parity Error" },
@@ -78,9 +78,9 @@
 	{ CIOPARERR,	"CIOBUS Parity Error" },
 };
 static const u_int num_errors = ARRAY_SIZE(ahd_hard_errors);
 
-static struct ahd_phase_table_entry ahd_phase_table[] =
+static const struct ahd_phase_table_entry ahd_phase_table[] =
 {
 	{ P_DATAOUT,	MSG_NOOP,		"in Data-out phase"	},
 	{ P_DATAIN,	MSG_INITIATOR_DET_ERR,	"in Data-in phase"	},
 	{ P_DATAOUT_DT,	MSG_NOOP,		"in DT Data-out phase"	},
@@ -212,9 +212,9 @@
 static void		ahd_dumpseq(struct ahd_softc *ahd);
 #endif
 static void		ahd_loadseq(struct ahd_softc *ahd);
 static int		ahd_check_patch(struct ahd_softc *ahd,
-					struct patch **start_patch,
+					const struct patch **start_patch,
 					u_int start_instr, u_int *skip_addr);
 static u_int		ahd_resolve_seqaddr(struct ahd_softc *ahd,
 					    u_int address);
 static void		ahd_download_instr(struct ahd_softc *ahd,
@@ -253,9 +253,9 @@
 static void		ahd_freeze_devq(struct ahd_softc *ahd,
 					struct scb *scb);
 static void		ahd_handle_scb_status(struct ahd_softc *ahd,
 					      struct scb *scb);
-static struct ahd_phase_table_entry* ahd_lookup_phase_entry(int phase);
+static const struct ahd_phase_table_entry* ahd_lookup_phase_entry(int phase);
 static void		ahd_shutdown(void *arg);
 static void		ahd_update_coalescing_values(struct ahd_softc *ahd,
 						     u_int timer,
 						     u_int maxcmds,
@@ -4336,13 +4336,13 @@
 	printf("%s:%c:%d:%d: ", ahd_name(ahd), 'A',
 	       devinfo->target, devinfo->lun);
 }
 
-static struct ahd_phase_table_entry*
+static const struct ahd_phase_table_entry*
 ahd_lookup_phase_entry(int phase)
 {
-	struct ahd_phase_table_entry *entry;
-	struct ahd_phase_table_entry *last_entry;
+	const struct ahd_phase_table_entry *entry;
+	const struct ahd_phase_table_entry *last_entry;
 
 	/*
 	 * num_phases doesn't include the default entry which
 	 * will be returned if the phase doesn't match.
@@ -9353,9 +9353,9 @@
 {
 	struct	cs cs_table[num_critical_sections];
 	u_int	begin_set[num_critical_sections];
 	u_int	end_set[num_critical_sections];
-	struct	patch *cur_patch;
+	const struct patch *cur_patch;
 	u_int	cs_count;
 	u_int	cur_cs;
 	u_int	i;
 	int	downloaded;
@@ -9508,13 +9508,13 @@
 	}
 }
 
 static int
-ahd_check_patch(struct ahd_softc *ahd, struct patch **start_patch,
+ahd_check_patch(struct ahd_softc *ahd, const struct patch **start_patch,
 		u_int start_instr, u_int *skip_addr)
 {
-	struct	patch *cur_patch;
-	struct	patch *last_patch;
+	const struct patch *cur_patch;
+	const struct patch *last_patch;
 	u_int	num_patches;
 
 	num_patches = ARRAY_SIZE(patches);
 	last_patch = &patches[num_patches];
@@ -9546,9 +9546,9 @@
 
 static u_int
 ahd_resolve_seqaddr(struct ahd_softc *ahd, u_int address)
 {
-	struct patch *cur_patch;
+	const struct patch *cur_patch;
 	int address_offset;
 	u_int skip_addr;
 	u_int i;
 
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_osm.c	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx_osm.c	Thu Apr 24 07:54:17 2008
@@ -192,9 +192,9 @@
 }
 #define AIC79XX_PRECOMP_INDEX	0
 #define AIC79XX_SLEWRATE_INDEX	1
 #define AIC79XX_AMPLITUDE_INDEX	2
-static struct ahd_linux_iocell_opts aic79xx_iocell_info[] =
+static const struct ahd_linux_iocell_opts aic79xx_iocell_info[] =
 {
 	AIC79XX_DEFAULT_IOOPTS,
 	AIC79XX_DEFAULT_IOOPTS,
 	AIC79XX_DEFAULT_IOOPTS,
@@ -556,15 +556,13 @@
 
 	bp = &buffer[0];
 	ahd = *(struct ahd_softc **)host->hostdata;
 	memset(bp, 0, sizeof(buffer));
-	strcpy(bp, "Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev ");
-	strcat(bp, AIC79XX_DRIVER_VERSION);
-	strcat(bp, "\n");
-	strcat(bp, "        <");
+	strcpy(bp, "Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev " AIC79XX_DRIVER_VERSION "\n"
+			"        <");
 	strcat(bp, ahd->description);
-	strcat(bp, ">\n");
-	strcat(bp, "        ");
+	strcat(bp, ">\n"
+			"        ");
 	ahd_controller_info(ahd, ahd_info);
 	strcat(bp, ahd_info);
 
 	return (bp);
@@ -1147,9 +1145,9 @@
 	int	i, n;
 	char   *p;
 	char   *end;
 
-	static struct {
+	static const struct {
 		const char *name;
 		uint32_t *flag;
 	} options[] = {
 		{ "extended", &aic79xx_extended },
@@ -1379,9 +1377,9 @@
 	/*
 	 * Lookup and commit any modified IO Cell options.
 	 */
 	if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
-		struct ahd_linux_iocell_opts *iocell_opts;
+		const struct ahd_linux_iocell_opts *iocell_opts;
 
 		iocell_opts = &aic79xx_iocell_info[ahd->unit];
 		if (iocell_opts->precomp != AIC79XX_DEFAULT_PRECOMP)
 			AHD_SET_PRECOMP(ahd, iocell_opts->precomp);
@@ -2769,9 +2767,9 @@
 	if (pcomp && spi_max_width(starget)) {
 		uint8_t precomp;
 
 		if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
-			struct ahd_linux_iocell_opts *iocell_opts;
+			const struct ahd_linux_iocell_opts *iocell_opts;
 
 			iocell_opts = &aic79xx_iocell_info[ahd->unit];
 			precomp = iocell_opts->precomp;
 		} else {
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	Thu Apr 24 07:54:17 2008
@@ -48,9 +48,9 @@
 #define ID(x)            \
 	ID2C(x),         \
 	ID2C(IDIROC(x))
 
-static struct pci_device_id ahd_linux_pci_id_table[] = {
+static const struct pci_device_id ahd_linux_pci_id_table[] = {
 	/* aic7901 based controllers */
 	ID(ID_AHA_29320A),
 	ID(ID_AHA_29320ALP),
 	ID(ID_AHA_29320LPE),
@@ -158,9 +158,9 @@
 {
 	char		 buf[80];
 	struct		 ahd_softc *ahd;
 	ahd_dev_softc_t	 pci;
-	struct		 ahd_pci_identity *entry;
+	const struct ahd_pci_identity *entry;
 	char		*name;
 	int		 error;
 	struct device	*dev = &pdev->dev;
 
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_pci.c	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx_pci.c	Thu Apr 24 07:54:17 2008
@@ -96,9 +96,9 @@
 static ahd_device_setup_t ahd_aic7901A_setup;
 static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-static struct ahd_pci_identity ahd_pci_ident_table[] =
+static const struct ahd_pci_identity ahd_pci_ident_table[] =
 {
 	/* aic7901 based controllers */
 	{
 		ID_AHA_29320A,
@@ -252,17 +252,17 @@
 					  u_int adapter_control);
 static void	ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat);
 static void	ahd_pci_intr(struct ahd_softc *ahd);
 
-struct ahd_pci_identity *
+const struct ahd_pci_identity *
 ahd_find_pci_device(ahd_dev_softc_t pci)
 {
 	uint64_t  full_id;
 	uint16_t  device;
 	uint16_t  vendor;
 	uint16_t  subdevice;
 	uint16_t  subvendor;
-	struct	  ahd_pci_identity *entry;
+	const struct ahd_pci_identity *entry;
 	u_int	  i;
 
 	vendor = ahd_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
 	device = ahd_pci_read_config(pci, PCIR_DEVICE, /*bytes*/2);
@@ -291,9 +291,9 @@
 	return (NULL);
 }
 
 int
-ahd_pci_config(struct ahd_softc *ahd, struct ahd_pci_identity *entry)
+ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 {
 	struct scb_data *shared_scb_data;
 	u_int		 command;
 	uint32_t	 devconfig;
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic79xx_proc.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic79xx_proc.c	Thu Apr 24 07:54:17 2008
@@ -56,9 +56,9 @@
 /*
  * Table of syncrates that don't follow the "divisible by 4"
  * rule. This table will be expanded in future SCSI specs.
  */
-static struct {
+static const struct {
 	u_int period_factor;
 	u_int period;	/* in 100ths of ns */
 } scsi_syncrates[] = {
 	{ 0x08, 625 },	/* FAST-160 */
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx.h	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx.h	Thu Apr 24 07:54:17 2008
@@ -1113,9 +1113,9 @@
 
 struct ahc_pci_identity {
 	uint64_t		 full_id;
 	uint64_t		 id_mask;
-	char			*name;
+	const char		*name;
 	ahc_device_setup_t	*setup;
 };
 
 /***************************** VL/EISA Declarations ***************************/
@@ -1134,11 +1134,11 @@
 /*************************** Function Declarations ****************************/
 /******************************************************************************/
 
 /***************************** PCI Front End *********************************/
-struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
+const struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
 int			 ahc_pci_config(struct ahc_softc *,
-					struct ahc_pci_identity *);
+					const struct ahc_pci_identity *);
 int			 ahc_pci_test_register_access(struct ahc_softc *);
 #ifdef CONFIG_PM
 void			 ahc_pci_resume(struct ahc_softc *ahc);
 #endif
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_93cx6.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx_93cx6.c	Thu Apr 24 07:54:17 2008
@@ -83,18 +83,18 @@
  	uint8_t bits[11];
 };
 
 /* Short opcodes for the c46 */
-static struct seeprom_cmd seeprom_ewen = {9, {1, 0, 0, 1, 1, 0, 0, 0, 0}};
-static struct seeprom_cmd seeprom_ewds = {9, {1, 0, 0, 0, 0, 0, 0, 0, 0}};
+static const struct seeprom_cmd seeprom_ewen = {9, {1, 0, 0, 1, 1, 0, 0, 0, 0}};
+static const struct seeprom_cmd seeprom_ewds = {9, {1, 0, 0, 0, 0, 0, 0, 0, 0}};
 
 /* Long opcodes for the C56/C66 */
-static struct seeprom_cmd seeprom_long_ewen = {11, {1, 0, 0, 1, 1, 0, 0, 0, 0}};
-static struct seeprom_cmd seeprom_long_ewds = {11, {1, 0, 0, 0, 0, 0, 0, 0, 0}};
+static const struct seeprom_cmd seeprom_long_ewen = {11, {1, 0, 0, 1, 1, 0, 0, 0, 0}};
+static const struct seeprom_cmd seeprom_long_ewds = {11, {1, 0, 0, 0, 0, 0, 0, 0, 0}};
 
 /* Common opcodes */
-static struct seeprom_cmd seeprom_write = {3, {1, 0, 1}};
-static struct seeprom_cmd seeprom_read  = {3, {1, 1, 0}};
+static const struct seeprom_cmd seeprom_write = {3, {1, 0, 1}};
+static const struct seeprom_cmd seeprom_read  = {3, {1, 1, 0}};
 
 /*
  * Wait for the SEERDY to go high; about 800 ns.
  */
@@ -107,9 +107,9 @@
 /*
  * Send a START condition and the given command
  */
 static void
-send_seeprom_cmd(struct seeprom_descriptor *sd, struct seeprom_cmd *cmd)
+send_seeprom_cmd(struct seeprom_descriptor *sd, const struct seeprom_cmd *cmd)
 {
 	uint8_t temp;
 	int i = 0;
 
@@ -226,9 +226,9 @@
 int
 ahc_write_seeprom(struct seeprom_descriptor *sd, uint16_t *buf,
 		  u_int start_addr, u_int count)
 {
-	struct seeprom_cmd *ewen, *ewds;
+	const struct seeprom_cmd *ewen, *ewds;
 	uint16_t v;
 	uint8_t temp;
 	int i, k;
 
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_core.c	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx_core.c	Thu Apr 24 07:54:17 2008
@@ -220,9 +220,9 @@
 static void		ahc_dumpseq(struct ahc_softc *ahc);
 #endif
 static int		ahc_loadseq(struct ahc_softc *ahc);
 static int		ahc_check_patch(struct ahc_softc *ahc,
-					struct patch **start_patch,
+					const struct patch **start_patch,
 					u_int start_instr, u_int *skip_addr);
 static void		ahc_download_instr(struct ahc_softc *ahc,
 					   u_int instrptr, uint8_t *dconsts);
 #ifdef AHC_TARGET_MODE
@@ -6850,9 +6850,9 @@
 {
 	struct	cs cs_table[num_critical_sections];
 	u_int	begin_set[num_critical_sections];
 	u_int	end_set[num_critical_sections];
-	struct	patch *cur_patch;
+	const struct patch *cur_patch;
 	u_int	cs_count;
 	u_int	cur_cs;
 	u_int	i;
 	u_int	skip_addr;
@@ -6955,13 +6955,13 @@
 	return (0);
 }
 
 static int
-ahc_check_patch(struct ahc_softc *ahc, struct patch **start_patch,
+ahc_check_patch(struct ahc_softc *ahc, const struct patch **start_patch,
 		u_int start_instr, u_int *skip_addr)
 {
-	struct	patch *cur_patch;
-	struct	patch *last_patch;
+	const struct patch *cur_patch;
+	const struct patch *last_patch;
 	u_int	num_patches;
 
 	num_patches = ARRAY_SIZE(patches);
 	last_patch = &patches[num_patches];
@@ -7018,9 +7018,9 @@
 	case AIC_OP_JNZ:
 	case AIC_OP_JE:
 	case AIC_OP_JZ:
 	{
-		struct patch *cur_patch;
+		const struct patch *cur_patch;
 		int address_offset;
 		u_int address;
 		u_int skip_addr;
 		u_int i;
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_osm.c	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx_osm.c	Thu Apr 24 07:54:17 2008
@@ -510,15 +510,13 @@
 
 	bp = &buffer[0];
 	ahc = *(struct ahc_softc **)host->hostdata;
 	memset(bp, 0, sizeof(buffer));
-	strcpy(bp, "Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev ");
-	strcat(bp, AIC7XXX_DRIVER_VERSION);
-	strcat(bp, "\n");
-	strcat(bp, "        <");
+	strcpy(bp, "Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev " AIC7XXX_DRIVER_VERSION "\n"
+			"        <");
 	strcat(bp, ahc->description);
-	strcat(bp, ">\n");
-	strcat(bp, "        ");
+	strcat(bp, ">\n"
+			"        ");
 	ahc_controller_info(ahc, ahc_info);
 	strcat(bp, ahc_info);
 	strcat(bp, "\n");
 
@@ -1032,9 +1030,9 @@
 	int	i, n;
 	char   *p;
 	char   *end;
 
-	static struct {
+	static const struct {
 		const char *name;
 		uint32_t *flag;
 	} options[] = {
 		{ "extended", &aic7xxx_extended },
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Thu Apr 24 07:48:38 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Thu Apr 24 07:54:17 2008
@@ -45,9 +45,9 @@
 /* Define the macro locally since it's different for different class of chips.
 */
 #define ID(x)	ID_C(x, PCI_CLASS_STORAGE_SCSI)
 
-static struct pci_device_id ahc_linux_pci_id_table[] = {
+static const struct pci_device_id ahc_linux_pci_id_table[] = {
 	/* aic7850 based controllers */
 	ID(ID_AHA_2902_04_10_15_20C_30C),
 	/* aic7860 based controllers */
 	ID(ID_AHA_2930CU),
@@ -205,9 +205,9 @@
 	char		 buf[80];
 	const uint64_t	 mask_39bit = 0x7FFFFFFFFFULL;
 	struct		 ahc_softc *ahc;
 	ahc_dev_softc_t	 pci;
-	struct		 ahc_pci_identity *entry;
+	const struct ahc_pci_identity *entry;
 	char		*name;
 	int		 error;
 	struct device	*dev = &pdev->dev;
 
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_pci.c	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx_pci.c	Thu Apr 24 07:54:17 2008
@@ -167,10 +167,9 @@
 static ahc_device_setup_t ahc_aha394XX_setup;
 static ahc_device_setup_t ahc_aha494XX_setup;
 static ahc_device_setup_t ahc_aha398XX_setup;
 
-static struct ahc_pci_identity ahc_pci_ident_table [] =
-{
+static const struct ahc_pci_identity ahc_pci_ident_table[] = {
 	/* aic7850 based controllers */
 	{
 		ID_AHA_2902_04_10_15_20C_30C,
 		ID_ALL_MASK,
@@ -667,17 +666,17 @@
 	}
 	return (result);
 }
 
-struct ahc_pci_identity *
+const struct ahc_pci_identity *
 ahc_find_pci_device(ahc_dev_softc_t pci)
 {
 	uint64_t  full_id;
 	uint16_t  device;
 	uint16_t  vendor;
 	uint16_t  subdevice;
 	uint16_t  subvendor;
-	struct	  ahc_pci_identity *entry;
+	const struct ahc_pci_identity *entry;
 	u_int	  i;
 
 	vendor = ahc_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
 	device = ahc_pci_read_config(pci, PCIR_DEVICE, /*bytes*/2);
@@ -709,9 +708,9 @@
 	return (NULL);
 }
 
 int
-ahc_pci_config(struct ahc_softc *ahc, struct ahc_pci_identity *entry)
+ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 {
 	u_int	 command;
 	u_int	 our_id;
 	u_int	 sxfrctl1;
--- scsi-misc-2.6-2008_04_15.p2/drivers/scsi/aic7xxx/aic7xxx_proc.c	Thu Apr 24 07:51:53 2008
+++ scsi-misc-2.6-2008_04_15.p3/drivers/scsi/aic7xxx/aic7xxx_proc.c	Thu Apr 24 07:54:17 2008
@@ -57,9 +57,9 @@
 /*
  * Table of syncrates that don't follow the "divisible by 4"
  * rule. This table will be expanded in future SCSI specs.
  */
-static struct {
+static const struct {
 	u_int period_factor;
 	u_int period;	/* in 100ths of ns */
 } scsi_syncrates[] = {
 	{ 0x08, 625 },	/* FAST-160 */

--Boundary-00=_ROUEIr1tmV6N3CG--
