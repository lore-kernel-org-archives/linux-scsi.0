From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/3] debloat aic7xxx and aic79xx drivers
Date: Sun, 14 Oct 2007 16:02:15 +0100
Message-ID: <200710141602.16283.vda.linux@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com> <200710141600.10468.vda.linux@googlemail.com> <200710141601.08946.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_49iEHWnVC13zALA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:51034 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbXJNPCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 11:02:24 -0400
Received: by ug-out-1314.google.com with SMTP id z38so778759ugc
        for <linux-scsi@vger.kernel.org>; Sun, 14 Oct 2007 08:02:22 -0700 (PDT)
In-Reply-To: <200710141601.08946.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--Boundary-00=_49iEHWnVC13zALA
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Adds more consts

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda


--Boundary-00=_49iEHWnVC13zALA
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="linux-2.6.23-aic-3-addconst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-aic-3-addconst.patch"

diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx.h linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx.h
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx.h	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx.h	2007-10-14 15:21:55.000000000 +0100
@@ -813,9 +813,9 @@ struct ahd_tmode_tstate {
  * to parity errors in each phase table. 
  */
 struct ahd_phase_table_entry {
-        uint8_t phase;
-        uint8_t mesg_out; /* Message response to parity errors */
-	char *phasemsg;
+	uint8_t phase;
+	uint8_t mesg_out; /* Message response to parity errors */
+	const char *phasemsg;
 };
 
 /************************** Serial EEPROM Format ******************************/
@@ -1328,9 +1328,9 @@ extern const int ahd_num_aic7770_devs;
 /******************************************************************************/
 
 /***************************** PCI Front End *********************************/
-struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
+const struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
 int			  ahd_pci_config(struct ahd_softc *,
-					 struct ahd_pci_identity *);
+					 const struct ahd_pci_identity *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
 
 /************************** SCB and SCB queue management **********************/
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_core.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_core.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_core.c	2007-10-14 15:21:38.000000000 +0100
@@ -52,7 +52,7 @@
 
 
 /***************************** Lookup Tables **********************************/
-static char *ahd_chip_names[] =
+static const char *const ahd_chip_names[] =
 {
 	"NONE",
 	"aic7901",
@@ -65,11 +65,11 @@ static const u_int num_chip_names = ARRA
  * Hardware error codes.
  */
 struct ahd_hard_error_entry {
-        uint8_t errno;
-	char *errmesg;
+	uint8_t errno;
+	const char *errmesg;
 };
 
-static struct ahd_hard_error_entry ahd_hard_errors[] = {
+static const struct ahd_hard_error_entry ahd_hard_errors[] = {
 	{ DSCTMOUT,	"Discard Timer has timed out" },
 	{ ILLOPCODE,	"Illegal Opcode in sequencer program" },
 	{ SQPARERR,	"Sequencer Parity Error" },
@@ -79,7 +79,7 @@ static struct ahd_hard_error_entry ahd_h
 };
 static const u_int num_errors = ARRAY_SIZE(ahd_hard_errors);
 
-static struct ahd_phase_table_entry ahd_phase_table[] =
+static const struct ahd_phase_table_entry ahd_phase_table[] =
 {
 	{ P_DATAOUT,	MSG_NOOP,		"in Data-out phase"	},
 	{ P_DATAIN,	MSG_INITIATOR_DET_ERR,	"in Data-in phase"	},
@@ -213,7 +213,7 @@ static void		ahd_dumpseq(struct ahd_soft
 #endif
 static void		ahd_loadseq(struct ahd_softc *ahd);
 static int		ahd_check_patch(struct ahd_softc *ahd,
-					struct patch **start_patch,
+					const struct patch **start_patch,
 					u_int start_instr, u_int *skip_addr);
 static u_int		ahd_resolve_seqaddr(struct ahd_softc *ahd,
 					    u_int address);
@@ -254,7 +254,7 @@ static void		ahd_freeze_devq(struct ahd_
 					struct scb *scb);
 static void		ahd_handle_scb_status(struct ahd_softc *ahd,
 					      struct scb *scb);
-static struct ahd_phase_table_entry* ahd_lookup_phase_entry(int phase);
+static const struct ahd_phase_table_entry* ahd_lookup_phase_entry(int phase);
 static void		ahd_shutdown(void *arg);
 static void		ahd_update_coalescing_values(struct ahd_softc *ahd,
 						     u_int timer,
@@ -4337,11 +4337,11 @@ ahd_print_devinfo(struct ahd_softc *ahd,
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
@@ -9358,7 +9358,7 @@ ahd_loadseq(struct ahd_softc *ahd)
 	struct	cs cs_table[num_critical_sections];
 	u_int	begin_set[num_critical_sections];
 	u_int	end_set[num_critical_sections];
-	struct	patch *cur_patch;
+	const struct patch *cur_patch;
 	u_int	cs_count;
 	u_int	cur_cs;
 	u_int	i;
@@ -9513,11 +9513,11 @@ ahd_loadseq(struct ahd_softc *ahd)
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
@@ -9551,7 +9551,7 @@ ahd_check_patch(struct ahd_softc *ahd, s
 static u_int
 ahd_resolve_seqaddr(struct ahd_softc *ahd, u_int address)
 {
-	struct patch *cur_patch;
+	const struct patch *cur_patch;
 	int address_offset;
 	u_int skip_addr;
 	u_int i;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_osm.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_osm.c	2007-10-14 15:20:05.000000000 +0100
@@ -193,7 +193,7 @@ struct ahd_linux_iocell_opts
 #define AIC79XX_PRECOMP_INDEX	0
 #define AIC79XX_SLEWRATE_INDEX	1
 #define AIC79XX_AMPLITUDE_INDEX	2
-static struct ahd_linux_iocell_opts aic79xx_iocell_info[] =
+static const struct ahd_linux_iocell_opts aic79xx_iocell_info[] =
 {
 	AIC79XX_DEFAULT_IOOPTS,
 	AIC79XX_DEFAULT_IOOPTS,
@@ -557,13 +557,11 @@ ahd_linux_info(struct Scsi_Host *host)
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
 
@@ -1148,7 +1146,7 @@ aic79xx_setup(char *s)
 	char   *p;
 	char   *end;
 
-	static struct {
+	static const struct {
 		const char *name;
 		uint32_t *flag;
 	} options[] = {
@@ -1380,7 +1378,7 @@ ahd_platform_init(struct ahd_softc *ahd)
 	 * Lookup and commit any modified IO Cell options.
 	 */
 	if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
-		struct ahd_linux_iocell_opts *iocell_opts;
+		const struct ahd_linux_iocell_opts *iocell_opts;
 
 		iocell_opts = &aic79xx_iocell_info[ahd->unit];
 		if (iocell_opts->precomp != AIC79XX_DEFAULT_PRECOMP)
@@ -2767,7 +2765,7 @@ static void ahd_linux_set_pcomp_en(struc
 		uint8_t precomp;
 
 		if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
-			struct ahd_linux_iocell_opts *iocell_opts;
+			const struct ahd_linux_iocell_opts *iocell_opts;
 
 			iocell_opts = &aic79xx_iocell_info[ahd->unit];
 			precomp = iocell_opts->precomp;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm_pci.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2007-10-14 15:20:05.000000000 +0100
@@ -58,7 +58,7 @@ static void	ahd_linux_pci_dev_remove(str
 	ID2C(x),         \
 	ID2C(IDIROC(x))
 
-static struct pci_device_id ahd_linux_pci_id_table[] = {
+static const struct pci_device_id ahd_linux_pci_id_table[] = {
 	/* aic7901 based controllers */
 	ID(ID_AHA_29320A),
 	ID(ID_AHA_29320ALP),
@@ -129,7 +129,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	char		 buf[80];
 	struct		 ahd_softc *ahd;
 	ahd_dev_softc_t	 pci;
-	struct		 ahd_pci_identity *entry;
+	const struct ahd_pci_identity *entry;
 	char		*name;
 	int		 error;
 	struct device	*dev = &pdev->dev;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_pci.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_pci.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_pci.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_pci.c	2007-10-14 15:20:05.000000000 +0100
@@ -97,7 +97,7 @@ static ahd_device_setup_t ahd_aic7901A_s
 static ahd_device_setup_t ahd_aic7902_setup;
 static ahd_device_setup_t ahd_aic790X_setup;
 
-static struct ahd_pci_identity ahd_pci_ident_table[] =
+static const struct ahd_pci_identity ahd_pci_ident_table[] =
 {
 	/* aic7901 based controllers */
 	{
@@ -253,7 +253,7 @@ static void	ahd_configure_termination(st
 static void	ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat);
 static void	ahd_pci_intr(struct ahd_softc *ahd);
 
-struct ahd_pci_identity *
+const struct ahd_pci_identity *
 ahd_find_pci_device(ahd_dev_softc_t pci)
 {
 	uint64_t  full_id;
@@ -261,7 +261,7 @@ ahd_find_pci_device(ahd_dev_softc_t pci)
 	uint16_t  vendor;
 	uint16_t  subdevice;
 	uint16_t  subvendor;
-	struct	  ahd_pci_identity *entry;
+	const struct ahd_pci_identity *entry;
 	u_int	  i;
 
 	vendor = ahd_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
@@ -292,7 +292,7 @@ ahd_find_pci_device(ahd_dev_softc_t pci)
 }
 
 int
-ahd_pci_config(struct ahd_softc *ahd, struct ahd_pci_identity *entry)
+ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 {
 	struct scb_data *shared_scb_data;
 	u_int		 command;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_proc.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_proc.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_proc.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_proc.c	2007-10-14 15:20:05.000000000 +0100
@@ -57,7 +57,7 @@ static int	ahd_proc_write_seeprom(struct
  * Table of syncrates that don't follow the "divisible by 4"
  * rule. This table will be expanded in future SCSI specs.
  */
-static struct {
+static const struct {
 	u_int period_factor;
 	u_int period;	/* in 100ths of ns */
 } scsi_syncrates[] = {
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	2007-10-14 15:20:05.000000000 +0100
@@ -1027,7 +1027,7 @@ ahd_patch0_func(struct ahd_softc *ahd)
 	return (0);
 }
 
-static struct patch {
+static const struct patch {
 	ahd_patch_func_t		*patch_func;
 	uint32_t		 begin		:10,
 				 skip_instr	:10,
@@ -1166,7 +1166,7 @@ static struct patch {
 	{ ahd_patch23_func, 815, 11, 1 }
 };
 
-static struct cs {
+static const struct cs {
 	uint16_t	begin;
 	uint16_t	end;
 } critical_sections[] = {
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx.h linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx.h
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx.h	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx.h	2007-10-14 15:22:14.000000000 +0100
@@ -759,8 +759,8 @@ struct ahc_syncrate {
  * to parity errors in each phase table. 
  */
 struct ahc_phase_table_entry {
-        uint8_t phase;
-        uint8_t mesg_out; /* Message response to parity errors */
+	uint8_t phase;
+	uint8_t mesg_out; /* Message response to parity errors */
 	char *phasemsg;
 };
 
@@ -1124,7 +1124,7 @@ typedef int (ahc_device_setup_t)(struct 
 struct ahc_pci_identity {
 	uint64_t		 full_id;
 	uint64_t		 id_mask;
-	char			*name;
+	const char		*name;
 	ahc_device_setup_t	*setup;
 };
 
@@ -1145,9 +1145,9 @@ extern const int ahc_num_aic7770_devs;
 /******************************************************************************/
 
 /***************************** PCI Front End *********************************/
-struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
+const struct ahc_pci_identity	*ahc_find_pci_device(ahc_dev_softc_t);
 int			 ahc_pci_config(struct ahc_softc *,
-					struct ahc_pci_identity *);
+					const struct ahc_pci_identity *);
 int			 ahc_pci_test_register_access(struct ahc_softc *);
 
 /*************************** EISA/VL Front End ********************************/
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_93cx6.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_93cx6.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_93cx6.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_93cx6.c	2007-10-14 15:20:05.000000000 +0100
@@ -84,16 +84,16 @@ struct seeprom_cmd {
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
@@ -108,7 +108,7 @@ static struct seeprom_cmd seeprom_read  
  * Send a START condition and the given command
  */
 static void
-send_seeprom_cmd(struct seeprom_descriptor *sd, struct seeprom_cmd *cmd)
+send_seeprom_cmd(struct seeprom_descriptor *sd, const struct seeprom_cmd *cmd)
 {
 	uint8_t temp;
 	int i = 0;
@@ -227,7 +227,7 @@ int
 ahc_write_seeprom(struct seeprom_descriptor *sd, uint16_t *buf,
 		  u_int start_addr, u_int count)
 {
-	struct seeprom_cmd *ewen, *ewds;
+	const struct seeprom_cmd *ewen, *ewds;
 	uint16_t v;
 	uint8_t temp;
 	int i, k;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_core.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_core.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_core.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_core.c	2007-10-14 15:21:33.000000000 +0100
@@ -73,7 +73,7 @@ static const u_int num_chip_names = ARRA
  * Hardware error codes.
  */
 struct ahc_hard_error_entry {
-        uint8_t errno;
+	uint8_t errno;
 	const char *errmesg;
 };
 
@@ -221,7 +221,7 @@ static void		ahc_dumpseq(struct ahc_soft
 #endif
 static int		ahc_loadseq(struct ahc_softc *ahc);
 static int		ahc_check_patch(struct ahc_softc *ahc,
-					struct patch **start_patch,
+					const struct patch **start_patch,
 					u_int start_instr, u_int *skip_addr);
 static void		ahc_download_instr(struct ahc_softc *ahc,
 					   u_int instrptr, uint8_t *dconsts);
@@ -6849,7 +6849,7 @@ ahc_loadseq(struct ahc_softc *ahc)
 	struct	cs cs_table[num_critical_sections];
 	u_int	begin_set[num_critical_sections];
 	u_int	end_set[num_critical_sections];
-	struct	patch *cur_patch;
+	const struct patch *cur_patch;
 	u_int	cs_count;
 	u_int	cur_cs;
 	u_int	i;
@@ -6954,11 +6954,11 @@ ahc_loadseq(struct ahc_softc *ahc)
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
@@ -7017,7 +7017,7 @@ ahc_download_instr(struct ahc_softc *ahc
 	case AIC_OP_JE:
 	case AIC_OP_JZ:
 	{
-		struct patch *cur_patch;
+		const struct patch *cur_patch;
 		int address_offset;
 		u_int address;
 		u_int skip_addr;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm.c	2007-10-14 15:05:07.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_osm.c	2007-10-14 15:20:05.000000000 +0100
@@ -511,13 +511,11 @@ ahc_linux_info(struct Scsi_Host *host)
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
@@ -1033,7 +1031,7 @@ aic7xxx_setup(char *s)
 	char   *p;
 	char   *end;
 
-	static struct {
+	static const struct {
 		const char *name;
 		uint32_t *flag;
 	} options[] = {
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2007-10-14 15:05:08.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2007-10-14 15:20:05.000000000 +0100
@@ -55,7 +55,7 @@ static void	ahc_linux_pci_dev_remove(str
 */
 #define ID(x)	ID_C(x, PCI_CLASS_STORAGE_SCSI)
 
-static struct pci_device_id ahc_linux_pci_id_table[] = {
+static const struct pci_device_id ahc_linux_pci_id_table[] = {
 	/* aic7850 based controllers */
 	ID(ID_AHA_2902_04_10_15_20C_30C),
 	/* aic7860 based controllers */
@@ -231,7 +231,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *
 	const uint64_t	 mask_39bit = 0x7FFFFFFFFFULL;
 	struct		 ahc_softc *ahc;
 	ahc_dev_softc_t	 pci;
-	struct		 ahc_pci_identity *entry;
+	const struct ahc_pci_identity *entry;
 	char		*name;
 	int		 error;
 	struct device	*dev = &pdev->dev;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_pci.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_pci.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_pci.c	2007-10-14 15:05:08.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_pci.c	2007-10-14 15:20:05.000000000 +0100
@@ -168,8 +168,7 @@ static ahc_device_setup_t ahc_aha394XX_s
 static ahc_device_setup_t ahc_aha494XX_setup;
 static ahc_device_setup_t ahc_aha398XX_setup;
 
-static struct ahc_pci_identity ahc_pci_ident_table [] =
-{
+static const struct ahc_pci_identity ahc_pci_ident_table[] = {
 	/* aic7850 based controllers */
 	{
 		ID_AHA_2902_04_10_15_20C_30C,
@@ -670,7 +669,7 @@ ahc_9005_subdevinfo_valid(uint16_t devic
 	return (result);
 }
 
-struct ahc_pci_identity *
+const struct ahc_pci_identity *
 ahc_find_pci_device(ahc_dev_softc_t pci)
 {
 	uint64_t  full_id;
@@ -678,7 +677,7 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 	uint16_t  vendor;
 	uint16_t  subdevice;
 	uint16_t  subvendor;
-	struct	  ahc_pci_identity *entry;
+	const struct ahc_pci_identity *entry;
 	u_int	  i;
 
 	vendor = ahc_pci_read_config(pci, PCIR_DEVVENDOR, /*bytes*/2);
@@ -712,7 +711,7 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 }
 
 int
-ahc_pci_config(struct ahc_softc *ahc, struct ahc_pci_identity *entry)
+ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 {
 	u_int	 command;
 	u_int	 our_id;
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_proc.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_proc.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_proc.c	2007-10-14 15:05:08.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_proc.c	2007-10-14 15:20:05.000000000 +0100
@@ -58,7 +58,7 @@ static int	ahc_proc_write_seeprom(struct
  * Table of syncrates that don't follow the "divisible by 4"
  * rule. This table will be expanded in future SCSI specs.
  */
-static struct {
+static const struct {
 	u_int period_factor;
 	u_int period;	/* in 100ths of ns */
 } scsi_syncrates[] = {
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	2007-10-14 15:05:08.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	2007-10-14 15:20:05.000000000 +0100
@@ -1081,7 +1081,7 @@ ahc_patch0_func(struct ahc_softc *ahc)
 	return (0);
 }
 
-static struct patch {
+static const struct patch {
 	ahc_patch_func_t		*patch_func;
 	uint32_t		 begin		:10,
 				 skip_instr	:10,
@@ -1291,7 +1291,7 @@ static struct patch {
 	{ ahc_patch4_func, 865, 12, 1 }
 };
 
-static struct cs {
+static const struct cs {
 	uint16_t	begin;
 	uint16_t	end;
 } critical_sections[] = {
diff -urpN linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aicasm/aicasm.c linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aicasm/aicasm.c
--- linux-2.6.23-aic-2-addstatic/drivers/scsi/aic7xxx/aicasm/aicasm.c	2007-10-14 15:05:11.000000000 +0100
+++ linux-2.6.23-aic-3-addconst/drivers/scsi/aic7xxx/aicasm/aicasm.c	2007-10-14 15:20:05.000000000 +0100
@@ -415,7 +415,7 @@ output_code()
 	}
 
 	fprintf(ofile,
-"static struct patch {\n"
+"static const struct patch {\n"
 "	%spatch_func_t		*patch_func;\n"
 "	uint32_t		 begin		:10,\n"
 "				 skip_instr	:10,\n"
@@ -435,7 +435,7 @@ output_code()
 	fprintf(ofile, "\n};\n\n");
 
 	fprintf(ofile,
-"static struct cs {\n"
+"static const struct cs {\n"
 "	uint16_t	begin;\n"
 "	uint16_t	end;\n"
 "} critical_sections[] = {\n");

--Boundary-00=_49iEHWnVC13zALA--
