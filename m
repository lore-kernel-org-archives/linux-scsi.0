From: akpm@osdl.org
Subject: [patch 16/25] drivers/scsi: Use ARRAY_SIZE macro
Date: Thu, 01 Jun 2006 20:42:41 -0700
Message-ID: <200606020338.k523cN1O029252@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43703 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751230AbWFBDij (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2006 23:38:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, tklauser@nuerscht.ch


From: Tobias Klauser <tklauser@nuerscht.ch>

Use ARRAY_SIZE macro instead of sizeof(x)/sizeof(x[0]) and remove
duplicates of the macro.

Signed-off-by: Tobias Klauser <tklauser@nuerscht.ch>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/3w-xxxx.c              |    6 ++--
 drivers/scsi/53c700.c               |   19 ++++++--------
 drivers/scsi/53c7xx.c               |   14 +++++------
 drivers/scsi/NCR53c406a.c           |    8 +++---
 drivers/scsi/aacraid/aachba.c       |   18 ++++++--------
 drivers/scsi/aacraid/commctrl.c     |    2 -
 drivers/scsi/aha1542.c              |   31 +++++++++++-------------
 drivers/scsi/aic7xxx/aic7770.c      |    2 -
 drivers/scsi/aic7xxx/aic79xx.h      |    2 -
 drivers/scsi/aic7xxx/aic79xx_core.c |   10 +++----
 drivers/scsi/aic7xxx/aic79xx_osm.c  |   20 +++++++--------
 drivers/scsi/aic7xxx/aic79xx_pci.c  |    2 -
 drivers/scsi/aic7xxx/aic79xx_proc.c |    4 ---
 drivers/scsi/aic7xxx/aic7xxx.h      |    2 -
 drivers/scsi/aic7xxx/aic7xxx_core.c |    8 +++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c  |   12 ++++-----
 drivers/scsi/aic7xxx/aic7xxx_pci.c  |    2 -
 drivers/scsi/aic7xxx/aic7xxx_proc.c |    4 ---
 drivers/scsi/aic7xxx_old.c          |    2 -
 drivers/scsi/constants.c            |   33 ++++++++++----------------
 drivers/scsi/dtc.c                  |   18 +++++++-------
 drivers/scsi/fd_mcs.c               |    2 -
 drivers/scsi/fdomain.c              |   10 +++----
 drivers/scsi/g_NCR5380.c            |   19 +++++++-------
 drivers/scsi/gdth.c                 |    4 +--
 drivers/scsi/ibmmca.c               |   16 +++++-------
 drivers/scsi/in2000.c               |    2 -
 drivers/scsi/initio.c               |    3 --
 drivers/scsi/ips.c                  |    2 -
 drivers/scsi/osst.c                 |    4 +--
 drivers/scsi/pas16.c                |    8 +++---
 drivers/scsi/qla1280.c              |    7 +----
 drivers/scsi/qlogicpti.c            |    2 -
 drivers/scsi/raid_class.c           |    4 +--
 drivers/scsi/scsi_lib.c             |    2 -
 drivers/scsi/scsi_sysfs.c           |    8 +++---
 drivers/scsi/scsi_transport_fc.c    |    6 ++--
 drivers/scsi/scsi_transport_sas.c   |    4 +--
 drivers/scsi/scsi_transport_spi.c   |    4 +--
 drivers/scsi/sd.c                   |    2 -
 drivers/scsi/seagate.c              |    4 +--
 drivers/scsi/sg.c                   |    6 +---
 drivers/scsi/st.c                   |    2 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    3 --
 drivers/scsi/t128.c                 |   10 +++----
 drivers/scsi/wd33c93.c              |    2 -
 drivers/scsi/wd7000.c               |   12 ++++-----
 47 files changed, 167 insertions(+), 200 deletions(-)

diff -puN drivers/scsi/3w-xxxx.c~drivers-scsi-use-array_size-macro drivers/scsi/3w-xxxx.c
--- devel/drivers/scsi/3w-xxxx.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/3w-xxxx.c	2006-06-01 20:41:51.000000000 -0700
@@ -405,7 +405,7 @@ static int tw_decode_sense(TW_Device_Ext
 	/* Attempt to return intelligent sense information */
 	if (fill_sense) {
 		if ((command->status == 0xc7) || (command->status == 0xcb)) {
-			for (i=0;i<(sizeof(tw_sense_table)/sizeof(tw_sense_table[0]));i++) {
+			for (i = 0; i < ARRAY_SIZE(tw_sense_table); i++) {
 				if (command->flags == tw_sense_table[i][0]) {
 
 					/* Valid bit and 'current errors' */
@@ -625,7 +625,7 @@ static int tw_aen_complete(TW_Device_Ext
 	if (aen == 0x0ff) {
 		printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: INFO: AEN queue overflow.\n", tw_dev->host->host_no);
 	} else {
-		table_max = sizeof(tw_aen_string)/sizeof(char *);
+		table_max = ARRAY_SIZE(tw_aen_string);
 		if ((aen & 0x0ff) < table_max) {
 			if ((tw_aen_string[aen & 0xff][strlen(tw_aen_string[aen & 0xff])-1]) == '#') {
 				printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: %s%d.\n", tw_dev->host->host_no, tw_aen_string[aen & 0xff], aen >> 8);
@@ -786,7 +786,7 @@ static int tw_aen_drain_queue(TW_Device_
 					if (aen == 0x0ff) {
 						printk(KERN_WARNING "3w-xxxx: AEN: INFO: AEN queue overflow.\n");
 					} else {
-						table_max = sizeof(tw_aen_string)/sizeof(char *);
+						table_max = ARRAY_SIZE(tw_aen_string);
 						if ((aen & 0x0ff) < table_max) {
 							if ((tw_aen_string[aen & 0xff][strlen(tw_aen_string[aen & 0xff])-1]) == '#') {
 								printk(KERN_WARNING "3w-xxxx: AEN: %s%d.\n", tw_aen_string[aen & 0xff], aen >> 8);
diff -puN drivers/scsi/53c700.c~drivers-scsi-use-array_size-macro drivers/scsi/53c700.c
--- devel/drivers/scsi/53c700.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/53c700.c	2006-06-01 20:41:51.000000000 -0700
@@ -316,7 +316,7 @@ NCR_700_detect(struct scsi_host_template
 	BUG_ON(!dma_is_consistent(pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
 	hostdata->slots = (struct NCR_700_command_slot *)(memory + SLOTS_OFFSET);
 	hostdata->dev = dev;
-		
+
 	pSlots = pScript + SLOTS_OFFSET;
 
 	/* Fill in the missing routines from the host template */
@@ -332,19 +332,18 @@ NCR_700_detect(struct scsi_host_template
 	tpnt->slave_destroy = NCR_700_slave_destroy;
 	tpnt->change_queue_depth = NCR_700_change_queue_depth;
 	tpnt->change_queue_type = NCR_700_change_queue_type;
-	
+
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
 	if(tpnt->proc_name == NULL)
 		tpnt->proc_name = "53c700";
-	
 
 	host = scsi_host_alloc(tpnt, 4);
 	if (!host)
 		return NULL;
 	memset(hostdata->slots, 0, sizeof(struct NCR_700_command_slot)
 	       * NCR_700_COMMAND_SLOTS_PER_HOST);
-	for(j = 0; j < NCR_700_COMMAND_SLOTS_PER_HOST; j++) {
+	for (j = 0; j < NCR_700_COMMAND_SLOTS_PER_HOST; j++) {
 		dma_addr_t offset = (dma_addr_t)((unsigned long)&hostdata->slots[j].SG[0]
 					  - (unsigned long)&hostdata->slots[0].SG[0]);
 		hostdata->slots[j].pSG = (struct NCR_700_SG_List *)((unsigned long)(pSlots + offset));
@@ -355,14 +354,12 @@ NCR_700_detect(struct scsi_host_template
 		hostdata->slots[j].state = NCR_700_SLOT_FREE;
 	}
 
-	for(j = 0; j < sizeof(SCRIPT)/sizeof(SCRIPT[0]); j++) {
+	for (j = 0; j < ARRAY_SIZE(SCRIPT); j++)
 		script[j] = bS_to_host(SCRIPT[j]);
-	}
 
 	/* adjust all labels to be bus physical */
-	for(j = 0; j < PATCHES; j++) {
+	for (j = 0; j < PATCHES; j++)
 		script[LABELPATCHES[j]] = bS_to_host(pScript + SCRIPT[LABELPATCHES[j]]);
-	}
 	/* now patch up fixed addresses. */
 	script_patch_32(script, MessageLocation,
 			pScript + MSGOUT_OFFSET);
@@ -385,17 +382,17 @@ NCR_700_detect(struct scsi_host_template
 	host->hostdata[0] = (unsigned long)hostdata;
 	/* kick the chip */
 	NCR_700_writeb(0xff, host, CTEST9_REG);
-	if(hostdata->chip710) 
+	if (hostdata->chip710)
 		hostdata->rev = (NCR_700_readb(host, CTEST8_REG)>>4) & 0x0f;
 	else
 		hostdata->rev = (NCR_700_readb(host, CTEST7_REG)>>4) & 0x0f;
 	hostdata->fast = (NCR_700_readb(host, CTEST9_REG) == 0);
-	if(banner == 0) {
+	if (banner == 0) {
 		printk(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
 		banner = 1;
 	}
 	printk(KERN_NOTICE "scsi%d: %s rev %d %s\n", host->host_no,
-	       hostdata->chip710 ? "53c710" : 
+	       hostdata->chip710 ? "53c710" :
 	       (hostdata->fast ? "53c700-66" : "53c700"),
 	       hostdata->rev, hostdata->differential ?
 	       "(Differential)" : "");
diff -puN drivers/scsi/53c7xx.c~drivers-scsi-use-array_size-macro drivers/scsi/53c7xx.c
--- devel/drivers/scsi/53c7xx.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/53c7xx.c	2006-06-01 20:41:51.000000000 -0700
@@ -361,7 +361,7 @@ int CmdPageStart = (0 - Ent_dsa_zero - s
 static char *setup_strings[] =
 	{"","","","","","","",""};
 
-#define MAX_SETUP_STRINGS (sizeof(setup_strings) / sizeof(char *))
+#define MAX_SETUP_STRINGS ARRAY_SIZE(setup_strings)
 #define SETUP_BUFFER_SIZE 200
 static char setup_buffer[SETUP_BUFFER_SIZE];
 static char setup_used[MAX_SETUP_STRINGS];
@@ -2190,15 +2190,15 @@ static const struct {
  */
 
 
-static void 
+static void
 synchronous (struct Scsi_Host *host, int target, char *msg) {
     struct NCR53c7x0_hostdata *hostdata = (struct NCR53c7x0_hostdata *)
 	host->hostdata[0];
     int desire, divisor, i, limit;
     unsigned char scntl3, sxfer;
 /* The diagnostic message fits on one line, even with max. width integers */
-    char buf[80];	
-   
+    char buf[80];
+
 /* Desired transfer clock in Hz */
     desire = 1000000000L / (msg[3] * 4);
 /* Scale the available SCSI clock by 10 so we get tenths */
@@ -2209,14 +2209,14 @@ synchronous (struct Scsi_Host *host, int
 	msg[4] = 8;
 
     if (hostdata->options & OPTION_DEBUG_SDTR)
-    	printk("scsi%d : optimal synchronous divisor of %d.%01d\n", 
+    	printk("scsi%d : optimal synchronous divisor of %d.%01d\n",
 	    host->host_no, divisor / 10, divisor % 10);
 
-    limit = (sizeof(syncs) / sizeof(syncs[0]) -1);
+    limit = ARRAY_SIZE(syncs) - 1;
     for (i = 0; (i < limit) && (divisor > syncs[i].div); ++i);
 
     if (hostdata->options & OPTION_DEBUG_SDTR)
-    	printk("scsi%d : selected synchronous divisor of %d.%01d\n", 
+    	printk("scsi%d : selected synchronous divisor of %d.%01d\n",
 	    host->host_no, syncs[i].div / 10, syncs[i].div % 10);
 
     msg[3] = ((1000000000L / hostdata->scsi_clock) * syncs[i].div / 10 / 4);
diff -puN drivers/scsi/aacraid/aachba.c~drivers-scsi-use-array_size-macro drivers/scsi/aacraid/aachba.c
--- devel/drivers/scsi/aacraid/aachba.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aacraid/aachba.c	2006-06-01 20:41:51.000000000 -0700
@@ -641,13 +641,13 @@ static void setinqstr(struct aac_dev *de
 			cp[sizeof(str->pid)] = c;
 	} else {
 		struct aac_driver_ident *mp = aac_get_driver_ident(dev->cardtype);
-   
-		inqstrcpy (mp->vname, str->vid); 
+
+		inqstrcpy (mp->vname, str->vid);
 		/* last six chars reserved for vol type */
 		inqstrcpy (mp->model, str->pid);
 	}
 
-	if (tindex < (sizeof(container_types)/sizeof(char *))){
+	if (tindex < ARRAY_SIZE(container_types)){
 		char *findit = str->pid;
 
 		for ( ; *findit != ' '; findit++); /* walk till we find a space */
@@ -1576,7 +1576,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		 *	see: <vendor>.c i.e. aac.c
 		 */
 		if (scmd_id(scsicmd) == host->this_id) {
-			setinqstr(dev, (void *) (inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
+			setinqstr(dev, (void *) (inq_data.inqd_vid), ARRAY_SIZE(container_types));
 			inq_data.inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 			aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
@@ -2381,7 +2381,7 @@ static struct aac_srb_status_info srb_st
 	{ SRB_STATUS_SUCCESS,		"Success"},
 	{ SRB_STATUS_ABORTED,		"Aborted Command"},
 	{ SRB_STATUS_ABORT_FAILED,	"Abort Failed"},
-	{ SRB_STATUS_ERROR,		"Error Event"}, 
+	{ SRB_STATUS_ERROR,		"Error Event"},
 	{ SRB_STATUS_BUSY,		"Device Busy"},
 	{ SRB_STATUS_INVALID_REQUEST,	"Invalid Request"},
 	{ SRB_STATUS_INVALID_PATH_ID,	"Invalid Path ID"},
@@ -2400,7 +2400,7 @@ static struct aac_srb_status_info srb_st
 	{ SRB_STATUS_BAD_SRB_BLOCK_LENGTH,"Bad Srb Block Length"},
 	{ SRB_STATUS_REQUEST_FLUSHED,	"Request Flushed"},
 	{ SRB_STATUS_DELAYED_RETRY,	"Delayed Retry"},
-	{ SRB_STATUS_INVALID_LUN,	"Invalid LUN"}, 
+	{ SRB_STATUS_INVALID_LUN,	"Invalid LUN"},
 	{ SRB_STATUS_INVALID_TARGET_ID,	"Invalid TARGET ID"},
 	{ SRB_STATUS_BAD_FUNCTION,	"Bad Function"},
 	{ SRB_STATUS_ERROR_RECOVERY,	"Error Recovery"},
@@ -2415,11 +2415,9 @@ char *aac_get_status_string(u32 status)
 {
 	int i;
 
-	for(i=0; i < (sizeof(srb_status_info)/sizeof(struct aac_srb_status_info)); i++ ){
-		if(srb_status_info[i].status == status){
+	for (i = 0; i < ARRAY_SIZE(srb_status_info); i++)
+		if (srb_status_info[i].status == status)
 			return srb_status_info[i].str;
-		}
-	}
 
 	return "Bad Status Code";
 }
diff -puN drivers/scsi/aacraid/commctrl.c~drivers-scsi-use-array_size-macro drivers/scsi/aacraid/commctrl.c
--- devel/drivers/scsi/aacraid/commctrl.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aacraid/commctrl.c	2006-06-01 20:41:51.000000000 -0700
@@ -535,7 +535,7 @@ static int aac_send_raw_srb(struct aac_d
 	default:
 		data_dir = DMA_NONE;
 	}
-	if (user_srbcmd->sg.count > (sizeof(sg_list)/sizeof(sg_list[0]))) {
+	if (user_srbcmd->sg.count > ARRAY_SIZE(sg_list)) {
 		dprintk((KERN_DEBUG"aacraid: too many sg entries %d\n",
 		  le32_to_cpu(srbcmd->sg.count)));
 		rcode = -EINVAL;
diff -puN drivers/scsi/aha1542.c~drivers-scsi-use-array_size-macro drivers/scsi/aha1542.c
--- devel/drivers/scsi/aha1542.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aha1542.c	2006-06-01 20:41:51.000000000 -0700
@@ -1011,7 +1011,7 @@ static int __init do_setup(char *str)
 
 	int count=setup_idx;
 
-	get_options(str, sizeof(ints)/sizeof(int), ints);
+	get_options(str, ARRAY_SIZE(ints), ints);
 	aha1542_setup(str,ints);
 
 	return count<setup_idx;
@@ -1072,8 +1072,7 @@ static int __init aha1542_detect(struct 
 		int slot = 0;
 		int pos = 0;
 
-		for (indx = 0; (slot !=  MCA_NOTFOUND) && 
-			     (indx < sizeof(bases)/sizeof(bases[0])); indx++) {
+		for (indx = 0; (slot != MCA_NOTFOUND) && (indx < ARRAY_SIZE(bases)); indx++) {
 
 			if (bases[indx])
 				continue;
@@ -1083,10 +1082,9 @@ static int __init aha1542_detect(struct 
 			if (slot == MCA_NOTFOUND)
 				break;
 
-			
 			/* Found one */
 			pos = mca_read_stored_pos(slot, 3);
-			
+
 			/* Decode address */
 			if (pos & 0x80) {
 				if (pos & 0x02) {
@@ -1118,23 +1116,22 @@ static int __init aha1542_detect(struct 
 			mca_set_adapter_name(slot, "Adapter AHA-1640");
 			mca_set_adapter_procfn(slot, NULL, NULL);
 			mca_mark_as_used(slot);
-			
+
 			/* Go on */
 			slot++;
 		}
-		
+
 	}
 #endif
 
 	/*
 	 *	Hunt for ISA Plug'n'Pray Adaptecs (AHA1535)
 	 */
-	 
+
 	if(isapnp)
 	{
 		struct pnp_dev *pdev = NULL;
-		for(indx = 0; indx <sizeof(bases)/sizeof(bases[0]);indx++)
-		{
+		for(indx = 0; indx < ARRAY_SIZE(bases); indx++) {
 			if(bases[indx])
 				continue;
 			pdev = pnp_find_dev(NULL, ISAPNP_VENDOR('A', 'D', 'P'), 
@@ -1144,29 +1141,29 @@ static int __init aha1542_detect(struct 
 			/*
 			 *	Activate the PnP card
 			 */
-			 
+
 			if(pnp_device_attach(pdev)<0)
 				continue;
-			
+
 			if(pnp_activate_dev(pdev)<0) {
 				pnp_device_detach(pdev);
 				continue;
 			}
-			
+
 			if(!pnp_port_valid(pdev, 0)) {
 				pnp_device_detach(pdev);
 				continue;
 			}
-				
+
 			bases[indx] = pnp_port_start(pdev, 0);
-			
+
 			/* The card can be queried for its DMA, we have 
 			   the DMA set up that is enough */
-			   
+
 			printk(KERN_INFO "ISAPnP found an AHA1535 at I/O 0x%03X\n", bases[indx]);
 		}
 	}
-	for (indx = 0; indx < sizeof(bases) / sizeof(bases[0]); indx++)
+	for (indx = 0; indx < ARRAY_SIZE(bases); indx++)
 		if (bases[indx] != 0 && request_region(bases[indx], 4, "aha1542")) {
 			shpnt = scsi_register(tpnt,
 					sizeof(struct aha1542_hostdata));
diff -puN drivers/scsi/aic7xxx/aic7770.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic7770.c
--- devel/drivers/scsi/aic7xxx/aic7770.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7770.c	2006-06-01 20:41:51.000000000 -0700
@@ -107,7 +107,7 @@ struct aic7770_identity aic7770_ident_ta
 		ahc_aic7770_EISA_setup
 	}
 };
-const int ahc_num_aic7770_devs = NUM_ELEMENTS(aic7770_ident_table);
+const int ahc_num_aic7770_devs = ARRAY_SIZE(aic7770_ident_table);
 
 struct aic7770_identity *
 aic7770_find_device(uint32_t id)
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic79xx_core.c
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-06-01 20:41:51.000000000 -0700
@@ -662,7 +662,7 @@ static char *ahd_chip_names[] =
 	"aic7902",
 	"aic7901A"
 };
-static const u_int num_chip_names = NUM_ELEMENTS(ahd_chip_names);
+static const u_int num_chip_names = ARRAY_SIZE(ahd_chip_names);
 
 /*
  * Hardware error codes.
@@ -680,7 +680,7 @@ static struct ahd_hard_error_entry ahd_h
 	{ MPARERR,	"Scratch or SCB Memory Parity Error" },
 	{ CIOPARERR,	"CIOBUS Parity Error" },
 };
-static const u_int num_errors = NUM_ELEMENTS(ahd_hard_errors);
+static const u_int num_errors = ARRAY_SIZE(ahd_hard_errors);
 
 static struct ahd_phase_table_entry ahd_phase_table[] =
 {
@@ -700,7 +700,7 @@ static struct ahd_phase_table_entry ahd_
  * In most cases we only wish to itterate over real phases, so
  * exclude the last element from the count.
  */
-static const u_int num_phases = NUM_ELEMENTS(ahd_phase_table) - 1;
+static const u_int num_phases = ARRAY_SIZE(ahd_phase_table) - 1;
 
 /* Our Sequencer Program */
 #include "aic79xx_seq.h"
@@ -7930,7 +7930,7 @@ ahd_qinfifo_count(struct ahd_softc *ahd)
 		return (wrap_qinfifonext - wrap_qinpos);
 	else
 		return (wrap_qinfifonext
-		      + NUM_ELEMENTS(ahd->qinfifo) - wrap_qinpos);
+		      + ARRAY_SIZE(ahd->qinfifo) - wrap_qinpos);
 }
 
 static void
@@ -9291,7 +9291,7 @@ ahd_check_patch(struct ahd_softc *ahd, s
 	struct	patch *last_patch;
 	u_int	num_patches;
 
-	num_patches = sizeof(patches)/sizeof(struct patch);
+	num_patches = ARRAY_SIZE(patches);
 	last_patch = &patches[num_patches];
 	cur_patch = *start_patch;
 
diff -puN drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic79xx.h
--- devel/drivers/scsi/aic7xxx/aic79xx.h~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx.h	2006-06-01 20:41:51.000000000 -0700
@@ -68,8 +68,6 @@ struct scb_platform_data;
 #define FALSE 0
 #endif
 
-#define NUM_ELEMENTS(array) (sizeof(array) / sizeof(*array))
-
 #define ALL_CHANNELS '\0'
 #define ALL_TARGETS_MASK 0xFFFF
 #define INITIATOR_WILDCARD	(~0)
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic79xx_osm.c
--- devel/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_osm.c	2006-06-01 20:41:51.000000000 -0700
@@ -918,7 +918,7 @@ ahd_linux_setup_iocell_info(u_long index
 {
 
 	if ((instance >= 0)
-	 && (instance < NUM_ELEMENTS(aic79xx_iocell_info))) {
+	 && (instance < ARRAY_SIZE(aic79xx_iocell_info))) {
 		uint8_t *iocell_info;
 
 		iocell_info = (uint8_t*)&aic79xx_iocell_info[instance];
@@ -936,7 +936,7 @@ ahd_linux_setup_tag_info_global(char *p)
 	tags = simple_strtoul(p + 1, NULL, 0) & 0xff;
 	printf("Setting Global Tags= %d\n", tags);
 
-	for (i = 0; i < NUM_ELEMENTS(aic79xx_tag_info); i++) {
+	for (i = 0; i < ARRAY_SIZE(aic79xx_tag_info); i++) {
 		for (j = 0; j < AHD_NUM_TARGETS; j++) {
 			aic79xx_tag_info[i].tag_commands[j] = tags;
 		}
@@ -948,7 +948,7 @@ ahd_linux_setup_tag_info(u_long arg, int
 {
 
 	if ((instance >= 0) && (targ >= 0)
-	 && (instance < NUM_ELEMENTS(aic79xx_tag_info))
+	 && (instance < ARRAY_SIZE(aic79xx_tag_info))
 	 && (targ < AHD_NUM_TARGETS)) {
 		aic79xx_tag_info[instance].tag_commands[targ] = value & 0x1FF;
 		if (bootverbose)
@@ -1074,21 +1074,21 @@ aic79xx_setup(char *s)
 	end = strchr(s, '\0');
 
 	/*
-	 * XXX ia64 gcc isn't smart enough to know that NUM_ELEMENTS
+	 * XXX ia64 gcc isn't smart enough to know that ARRAY_SIZE
 	 * will never be 0 in this case.
-	 */      
-	n = 0;  
+	 */
+	n = 0;
 
 	while ((p = strsep(&s, ",.")) != NULL) {
 		if (*p == '\0')
 			continue;
-		for (i = 0; i < NUM_ELEMENTS(options); i++) {
+		for (i = 0; i < ARRAY_SIZE(options); i++) {
 
 			n = strlen(options[i].name);
 			if (strncmp(options[i].name, p, n) == 0)
 				break;
 		}
-		if (i == NUM_ELEMENTS(options))
+		if (i == ARRAY_SIZE(options))
 			continue;
 
 		if (strncmp(p, "global_tag_depth", n) == 0) {
@@ -1296,7 +1296,7 @@ ahd_platform_init(struct ahd_softc *ahd)
 	/*
 	 * Lookup and commit any modified IO Cell options.
 	 */
-	if (ahd->unit < NUM_ELEMENTS(aic79xx_iocell_info)) {
+	if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
 		struct ahd_linux_iocell_opts *iocell_opts;
 
 		iocell_opts = &aic79xx_iocell_info[ahd->unit];
@@ -1428,7 +1428,7 @@ ahd_linux_user_tagdepth(struct ahd_softc
 
 	tags = 0;
 	if ((ahd->user_discenable & devinfo->target_mask) != 0) {
-		if (ahd->unit >= NUM_ELEMENTS(aic79xx_tag_info)) {
+		if (ahd->unit >= ARRAY_SIZE(aic79xx_tag_info)) {
 
 			if (warned_user == 0) {
 				printf(KERN_WARNING
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic79xx_pci.c
--- devel/drivers/scsi/aic7xxx/aic79xx_pci.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_pci.c	2006-06-01 20:41:51.000000000 -0700
@@ -201,7 +201,7 @@ static struct ahd_pci_identity ahd_pci_i
 	}
 };
 
-static const u_int ahd_num_pci_devs = NUM_ELEMENTS(ahd_pci_ident_table);
+static const u_int ahd_num_pci_devs = ARRAY_SIZE(ahd_pci_ident_table);
 		
 #define	DEVCONFIG		0x40
 #define		PCIXINITPAT	0x0000E000ul
diff -puN drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic79xx_proc.c
--- devel/drivers/scsi/aic7xxx/aic79xx_proc.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_proc.c	2006-06-01 20:41:51.000000000 -0700
@@ -76,11 +76,9 @@ static u_int
 ahd_calc_syncsrate(u_int period_factor)
 {
 	int i;
-	int num_syncrates;
 
-	num_syncrates = sizeof(scsi_syncrates) / sizeof(scsi_syncrates[0]);
 	/* See if the period is in the "exception" table */
-	for (i = 0; i < num_syncrates; i++) {
+	for (i = 0; i < ARRAY_SIZE(scsi_syncrates); i++) {
 
 		if (period_factor == scsi_syncrates[i].period_factor) {
 			/* Period in kHz */
diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic7xxx_core.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_core.c	2006-06-01 20:41:51.000000000 -0700
@@ -439,7 +439,7 @@ char *ahc_chip_names[] =
 	"aic7892",
 	"aic7899"
 };
-static const u_int num_chip_names = NUM_ELEMENTS(ahc_chip_names);
+static const u_int num_chip_names = ARRAY_SIZE(ahc_chip_names);
 
 /*
  * Hardware error codes.
@@ -459,7 +459,7 @@ static struct ahc_hard_error_entry ahc_h
 	{ PCIERRSTAT,	"PCI Error detected" },
 	{ CIOPARERR,	"CIOBUS Parity Error" },
 };
-static const u_int num_errors = NUM_ELEMENTS(ahc_hard_errors);
+static const u_int num_errors = ARRAY_SIZE(ahc_hard_errors);
 
 static struct ahc_phase_table_entry ahc_phase_table[] =
 {
@@ -479,7 +479,7 @@ static struct ahc_phase_table_entry ahc_
  * In most cases we only wish to itterate over real phases, so
  * exclude the last element from the count.
  */
-static const u_int num_phases = NUM_ELEMENTS(ahc_phase_table) - 1;
+static const u_int num_phases = ARRAY_SIZE(ahc_phase_table) - 1;
 
 /*
  * Valid SCSIRATE values.  (p. 3-17)
@@ -6738,7 +6738,7 @@ ahc_check_patch(struct ahc_softc *ahc, s
 	struct	patch *last_patch;
 	u_int	num_patches;
 
-	num_patches = sizeof(patches)/sizeof(struct patch);
+	num_patches = ARRAY_SIZE(patches);
 	last_patch = &patches[num_patches];
 	cur_patch = *start_patch;
 
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic7xxx.h
--- devel/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx.h	2006-06-01 20:41:51.000000000 -0700
@@ -69,8 +69,6 @@ struct seeprom_descriptor;
 #define FALSE 0
 #endif
 
-#define NUM_ELEMENTS(array) (sizeof(array) / sizeof(*array))
-
 #define ALL_CHANNELS '\0'
 #define ALL_TARGETS_MASK 0xFFFF
 #define INITIATOR_WILDCARD	(~0)
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic7xxx_osm.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_osm.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_osm.c	2006-06-01 20:41:51.000000000 -0700
@@ -886,7 +886,7 @@ ahc_linux_setup_tag_info_global(char *p)
 	tags = simple_strtoul(p + 1, NULL, 0) & 0xff;
 	printf("Setting Global Tags= %d\n", tags);
 
-	for (i = 0; i < NUM_ELEMENTS(aic7xxx_tag_info); i++) {
+	for (i = 0; i < ARRAY_SIZE(aic7xxx_tag_info); i++) {
 		for (j = 0; j < AHC_NUM_TARGETS; j++) {
 			aic7xxx_tag_info[i].tag_commands[j] = tags;
 		}
@@ -898,7 +898,7 @@ ahc_linux_setup_tag_info(u_long arg, int
 {
 
 	if ((instance >= 0) && (targ >= 0)
-	 && (instance < NUM_ELEMENTS(aic7xxx_tag_info))
+	 && (instance < ARRAY_SIZE(aic7xxx_tag_info))
 	 && (targ < AHC_NUM_TARGETS)) {
 		aic7xxx_tag_info[instance].tag_commands[targ] = value & 0xff;
 		if (bootverbose)
@@ -1020,7 +1020,7 @@ aic7xxx_setup(char *s)
 	end = strchr(s, '\0');
 
 	/*
-	 * XXX ia64 gcc isn't smart enough to know that NUM_ELEMENTS
+	 * XXX ia64 gcc isn't smart enough to know that ARRAY_SIZE
 	 * will never be 0 in this case.
 	 */
 	n = 0;
@@ -1028,13 +1028,13 @@ aic7xxx_setup(char *s)
 	while ((p = strsep(&s, ",.")) != NULL) {
 		if (*p == '\0')
 			continue;
-		for (i = 0; i < NUM_ELEMENTS(options); i++) {
+		for (i = 0; i < ARRAY_SIZE(options); i++) {
 
 			n = strlen(options[i].name);
 			if (strncmp(options[i].name, p, n) == 0)
 				break;
 		}
-		if (i == NUM_ELEMENTS(options))
+		if (i == ARRAY_SIZE(options))
 			continue;
 
 		if (strncmp(p, "global_tag_depth", n) == 0) {
@@ -1360,7 +1360,7 @@ ahc_linux_user_tagdepth(struct ahc_softc
 
 	tags = 0;
 	if ((ahc->user_discenable & devinfo->target_mask) != 0) {
-		if (ahc->unit >= NUM_ELEMENTS(aic7xxx_tag_info)) {
+		if (ahc->unit >= ARRAY_SIZE(aic7xxx_tag_info)) {
 			if (warned_user == 0) {
 
 				printf(KERN_WARNING
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic7xxx_pci.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_pci.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_pci.c	2006-06-01 20:41:51.000000000 -0700
@@ -553,7 +553,7 @@ static struct ahc_pci_identity ahc_pci_i
 	}
 };
 
-static const u_int ahc_num_pci_devs = NUM_ELEMENTS(ahc_pci_ident_table);
+static const u_int ahc_num_pci_devs = ARRAY_SIZE(ahc_pci_ident_table);
 		
 #define AHC_394X_SLOT_CHANNEL_A	4
 #define AHC_394X_SLOT_CHANNEL_B	5
diff -puN drivers/scsi/aic7xxx/aic7xxx_proc.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx/aic7xxx_proc.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_proc.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_proc.c	2006-06-01 20:41:51.000000000 -0700
@@ -77,11 +77,9 @@ static u_int
 ahc_calc_syncsrate(u_int period_factor)
 {
 	int i;
-	int num_syncrates;
 
-	num_syncrates = sizeof(scsi_syncrates) / sizeof(scsi_syncrates[0]);
 	/* See if the period is in the "exception" table */
-	for (i = 0; i < num_syncrates; i++) {
+	for (i = 0; i < ARRAY_SIZE(scsi_syncrates); i++) {
 
 		if (period_factor == scsi_syncrates[i].period_factor) {
 			/* Period in kHz */
diff -puN drivers/scsi/aic7xxx_old.c~drivers-scsi-use-array_size-macro drivers/scsi/aic7xxx_old.c
--- devel/drivers/scsi/aic7xxx_old.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx_old.c	2006-06-01 20:41:51.000000000 -0700
@@ -1565,7 +1565,7 @@ aic7xxx_check_patch(struct aic7xxx_host 
   struct sequencer_patch *last_patch;
   int num_patches;
 
-  num_patches = sizeof(sequencer_patches)/sizeof(struct sequencer_patch);
+  num_patches = ARRAY_SIZE(sequencer_patches);
   last_patch = &sequencer_patches[num_patches];
   cur_patch = *start_patch;
 
diff -puN drivers/scsi/constants.c~drivers-scsi-use-array_size-macro drivers/scsi/constants.c
--- devel/drivers/scsi/constants.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/constants.c	2006-06-01 20:41:51.000000000 -0700
@@ -114,8 +114,7 @@ static const struct value_name_pair main
 	{0xd, "Report supported task management functions"},
 	{0xe, "Report priority"},
 };
-#define MAINT_IN_SZ \
-        (int)(sizeof(maint_in_arr) / sizeof(maint_in_arr[0]))
+#define MAINT_IN_SZ ARRAY_SIZE(maint_in_arr)
 
 static const struct value_name_pair maint_out_arr[] = {
 	{0x6, "Set device identifier"},
@@ -123,34 +122,29 @@ static const struct value_name_pair main
 	{0xb, "Change aliases"},
 	{0xe, "Set priority"},
 };
-#define MAINT_OUT_SZ \
-        (int)(sizeof(maint_out_arr) / sizeof(maint_out_arr[0]))
+#define MAINT_OUT_SZ ARRAY_SIZE(maint_out_arr)
 
 static const struct value_name_pair serv_in12_arr[] = {
 	{0x1, "Read media serial number"},
 };
-#define SERV_IN12_SZ  \
-        (int)(sizeof(serv_in12_arr) / sizeof(serv_in12_arr[0]))
+#define SERV_IN12_SZ ARRAY_SIZE(serv_in12_arr)
 
 static const struct value_name_pair serv_out12_arr[] = {
 	{-1, "dummy entry"},
 };
-#define SERV_OUT12_SZ \
-        (int)(sizeof(serv_out12_arr) / sizeof(serv_in12_arr[0]))
+#define SERV_OUT12_SZ ARRAY_SIZE(serv_out12_arr)
 
 static const struct value_name_pair serv_in16_arr[] = {
 	{0x10, "Read capacity(16)"},
 	{0x11, "Read long(16)"},
 };
-#define SERV_IN16_SZ  \
-        (int)(sizeof(serv_in16_arr) / sizeof(serv_in16_arr[0]))
+#define SERV_IN16_SZ ARRAY_SIZE(serv_in16_arr)
 
 static const struct value_name_pair serv_out16_arr[] = {
 	{0x11, "Write long(16)"},
 	{0x1f, "Notify data transfer device(16)"},
 };
-#define SERV_OUT16_SZ \
-        (int)(sizeof(serv_out16_arr) / sizeof(serv_in16_arr[0]))
+#define SERV_OUT16_SZ ARRAY_SIZE(serv_out16_arr)
 
 static const struct value_name_pair variable_length_arr[] = {
 	{0x1, "Rebuild(32)"},
@@ -190,8 +184,7 @@ static const struct value_name_pair vari
 	{0x8f7e, "Perform SCSI command (osd)"},
 	{0x8f7f, "Perform task management function (osd)"},
 };
-#define VARIABLE_LENGTH_SZ \
-        (int)(sizeof(variable_length_arr) / sizeof(variable_length_arr[0]))
+#define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
 
 static const char * get_sa_name(const struct value_name_pair * arr,
 			        int arr_sz, int service_action)
@@ -1280,10 +1273,10 @@ EXPORT_SYMBOL(scsi_print_command);
 #ifdef CONFIG_SCSI_CONSTANTS
 
 static const char * const hostbyte_table[]={
-"DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET", 
+"DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
-#define NUM_HOSTBYTE_STRS (sizeof(hostbyte_table) / sizeof(const char *))
+#define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 void scsi_print_hostbyte(int scsiresult)
 {
@@ -1293,7 +1286,7 @@ void scsi_print_hostbyte(int scsiresult)
 	if (hb < NUM_HOSTBYTE_STRS)
 		printk("(%s) ", hostbyte_table[hb]);
 	else
-		printk("is invalid "); 
+		printk("is invalid ");
 }
 #else
 void scsi_print_hostbyte(int scsiresult)
@@ -1305,14 +1298,14 @@ void scsi_print_hostbyte(int scsiresult)
 #ifdef CONFIG_SCSI_CONSTANTS
 
 static const char * const driverbyte_table[]={
-"DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR", 
+"DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
-#define NUM_DRIVERBYTE_STRS (sizeof(driverbyte_table) / sizeof(const char *))
+#define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
 static const char * const driversuggest_table[]={"SUGGEST_OK",
 "SUGGEST_RETRY", "SUGGEST_ABORT", "SUGGEST_REMAP", "SUGGEST_DIE",
 "SUGGEST_5", "SUGGEST_6", "SUGGEST_7", "SUGGEST_SENSE"};
-#define NUM_SUGGEST_STRS (sizeof(driversuggest_table) / sizeof(const char *))
+#define NUM_SUGGEST_STRS ARRAY_SIZE(driversuggest_table)
 
 void scsi_print_driverbyte(int scsiresult)
 {
diff -puN drivers/scsi/dtc.c~drivers-scsi-use-array_size-macro drivers/scsi/dtc.c
--- devel/drivers/scsi/dtc.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/dtc.c	2006-06-01 20:41:51.000000000 -0700
@@ -145,35 +145,35 @@ static struct override {
 0, IRQ_AUTO}};
 #endif
 
-#define NO_OVERRIDES (sizeof(overrides) / sizeof(struct override))
+#define NO_OVERRIDES ARRAY_SIZE(overrides)
 
 static struct base {
 	unsigned long address;
 	int noauto;
-} bases[] __initdata = { 
-	{ 0xcc000, 0 }, 
-	{ 0xc8000, 0 }, 
-	{ 0xdc000, 0 }, 
+} bases[] __initdata = {
+	{ 0xcc000, 0 },
+	{ 0xc8000, 0 },
+	{ 0xdc000, 0 },
 	{ 0xd8000, 0 }
 };
 
-#define NO_BASES (sizeof (bases) / sizeof (struct base))
+#define NO_BASES ARRAY_SIZE(bases)
 
 static const struct signature {
 	const char *string;
 	int offset;
-} signatures[] = { 
+} signatures[] = {
 	{"DATA TECHNOLOGY CORPORATION BIOS", 0x25},
 };
 
-#define NO_SIGNATURES (sizeof (signatures) /  sizeof (struct signature))
+#define NO_SIGNATURES ARRAY_SIZE(signatures)
 
 #ifndef MODULE
 /*
  * Function : dtc_setup(char *str, int *ints)
  *
  * Purpose : LILO command line initialization of the overrides array,
- * 
+ *
  * Inputs : str - unused, ints - array of integer parameters with ints[0]
  *	equal to the number of ints.
  *
diff -puN drivers/scsi/fd_mcs.c~drivers-scsi-use-array_size-macro drivers/scsi/fd_mcs.c
--- devel/drivers/scsi/fd_mcs.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/fd_mcs.c	2006-06-01 20:41:51.000000000 -0700
@@ -279,7 +279,7 @@ static struct fd_mcs_adapters_struct fd_
 	 2},
 };
 
-#define FD_BRDS sizeof(fd_mcs_adapters)/sizeof(struct fd_mcs_adapters_struct)
+#define FD_BRDS ARRAY_SIZE(fd_mcs_adapters)
 
 static irqreturn_t fd_mcs_intr(int irq, void *dev_id, struct pt_regs *regs);
 
diff -puN drivers/scsi/fdomain.c~drivers-scsi-use-array_size-macro drivers/scsi/fdomain.c
--- devel/drivers/scsi/fdomain.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/fdomain.c	2006-06-01 20:41:51.000000000 -0700
@@ -420,10 +420,10 @@ static unsigned long addresses[] = {
    0xd0000,
    0xe0000,
 };
-#define ADDRESS_COUNT (sizeof( addresses ) / sizeof( unsigned ))
-		       
+#define ADDRESS_COUNT ARRAY_SIZE(addresses)
+
 static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
-#define PORT_COUNT (sizeof( ports ) / sizeof( unsigned short ))
+#define PORT_COUNT ARRAY_SIZE(ports)
 
 static unsigned short ints[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
 
@@ -502,7 +502,7 @@ static struct signature {
     geometry location are verified). */
 };
 
-#define SIGNATURE_COUNT (sizeof( signatures ) / sizeof( struct signature ))
+#define SIGNATURE_COUNT ARRAY_SIZE(signatures)
 
 static void print_banner( struct Scsi_Host *shpnt )
 {
@@ -519,7 +519,7 @@ static void print_banner( struct Scsi_Ho
 
       if (bios_minor >= 0) printk("%d", bios_minor);
       else                 printk("?.");
-   
+
       printk( " at 0x%lx using scsi id %d\n",
 	      bios_base, shpnt->this_id );
    }
diff -puN drivers/scsi/gdth.c~drivers-scsi-use-array_size-macro drivers/scsi/gdth.c
--- devel/drivers/scsi/gdth.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/gdth.c	2006-06-01 20:41:51.000000000 -0700
@@ -556,8 +556,8 @@ static struct timer_list gdth_timer;
 #endif
 
 #define PTR2USHORT(a)   (ushort)(ulong)(a)
-#define GDTOFFSOF(a,b)  (size_t)&(((a*)0)->b)   
-#define INDEX_OK(i,t)   ((i)<sizeof(t)/sizeof((t)[0]))
+#define GDTOFFSOF(a,b)  (size_t)&(((a*)0)->b)
+#define INDEX_OK(i,t)   ((i)<ARRAY_SIZE(t))
 
 #define NUMDATA(a)      ( (gdth_num_str  *)((a)->hostdata))
 #define HADATA(a)       (&((gdth_ext_str *)((a)->hostdata))->haext)
diff -puN drivers/scsi/g_NCR5380.c~drivers-scsi-use-array_size-macro drivers/scsi/g_NCR5380.c
--- devel/drivers/scsi/g_NCR5380.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/g_NCR5380.c	2006-06-01 20:41:51.000000000 -0700
@@ -138,10 +138,9 @@ static struct override {
 [1] __initdata = { { 0,},};
 #endif
 
+#define NO_OVERRIDES ARRAY_SIZE(overrides)
 
-#define NO_OVERRIDES (sizeof(overrides) / sizeof(struct override))
-
-#ifndef MODULE 
+#ifndef MODULE
 
 /**
  *	internal_setup		-	handle lilo command string override
@@ -210,7 +209,7 @@ static int __init do_NCR5380_setup(char 
 {
 	int ints[10];
 
-	get_options(str, sizeof(ints) / sizeof(int), ints);
+	get_options(str, ARRAY_SIZE(ints), ints);
 	internal_setup(BOARD_NCR5380, str, ints);
 	return 1;
 }
@@ -218,7 +217,7 @@ static int __init do_NCR5380_setup(char 
 /**
  * 	do_NCR53C400_setup		-	set up entry point
  *	@str: unused
- *	@ints: integer parameters from kernel setup code 
+ *	@ints: integer parameters from kernel setup code
  *
  *	Setup function invoked at boot to parse the ncr53c400= command
  *	line.
@@ -228,7 +227,7 @@ static int __init do_NCR53C400_setup(cha
 {
 	int ints[10];
 
-	get_options(str, sizeof(ints) / sizeof(int), ints);
+	get_options(str, ARRAY_SIZE(ints), ints);
 	internal_setup(BOARD_NCR53C400, str, ints);
 	return 1;
 }
@@ -236,7 +235,7 @@ static int __init do_NCR53C400_setup(cha
 /**
  * 	do_NCR53C400A_setup	-	set up entry point
  *	@str: unused
- *	@ints: integer parameters from kernel setup code 
+ *	@ints: integer parameters from kernel setup code
  *
  *	Setup function invoked at boot to parse the ncr53c400a= command
  *	line.
@@ -246,7 +245,7 @@ static int __init do_NCR53C400A_setup(ch
 {
 	int ints[10];
 
-	get_options(str, sizeof(ints) / sizeof(int), ints);
+	get_options(str, ARRAY_SIZE(ints), ints);
 	internal_setup(BOARD_NCR53C400A, str, ints);
 	return 1;
 }
@@ -254,7 +253,7 @@ static int __init do_NCR53C400A_setup(ch
 /**
  * 	do_DTC3181E_setup	-	set up entry point
  *	@str: unused
- *	@ints: integer parameters from kernel setup code 
+ *	@ints: integer parameters from kernel setup code
  *
  *	Setup function invoked at boot to parse the dtc3181e= command
  *	line.
@@ -264,7 +263,7 @@ static int __init do_DTC3181E_setup(char
 {
 	int ints[10];
 
-	get_options(str, sizeof(ints) / sizeof(int), ints);
+	get_options(str, ARRAY_SIZE(ints), ints);
 	internal_setup(BOARD_DTC3181E, str, ints);
 	return 1;
 }
diff -puN drivers/scsi/ibmmca.c~drivers-scsi-use-array_size-macro drivers/scsi/ibmmca.c
--- devel/drivers/scsi/ibmmca.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/ibmmca.c	2006-06-01 20:41:51.000000000 -0700
@@ -1441,7 +1441,7 @@ static int ibmmca_getinfo(char *buf, int
 	struct Scsi_Host *dev = dev_id;
 
 	spin_lock_irqsave(dev->host_lock, flags);
-	
+
 	shpnt = dev;		/* assign host-structure to local pointer */
 	len = 0;		/* set filled text-buffer index to 0 */
 	/* get the _special contents of the hostdata structure */
@@ -1456,7 +1456,7 @@ static int ibmmca_getinfo(char *buf, int
 		/* if the integrated subsystem has been found automatically: */
 		len += sprintf(buf + len,
 			       "Adapter category: integrated\n" "Chip revision level: %d\n" "Chip status: %s\n" "8 kByte NVRAM status: %s\n", ((pos[2] & 0xf0) >> 4), (pos[2] & 1) ? "enabled" : "disabled", (pos[2] & 2) ? "locked" : "accessible");
-	} else if ((speciale >= 0) && (speciale < (sizeof(subsys_list) / sizeof(struct subsys_list_struct)))) {
+	} else if ((speciale >= 0) && (speciale < ARRAY_SIZE(subsys_list))) {
 		/* if the subsystem is a slot adapter */
 		len += sprintf(buf + len, "Adapter category: slot-card\n" "ROM Segment Address: ");
 		if ((pos[2] & 0xf0) == 0xf0)
@@ -1477,16 +1477,16 @@ static int ibmmca_getinfo(char *buf, int
 	while (len % sizeof(int) != (sizeof(int) - 1))
 		len += sprintf(buf + len, " ");
 	len += sprintf(buf + len, "\n");
-	
+
 	spin_unlock_irqrestore(shpnt->host_lock, flags);
-	
+
 	return len;
 }
 
 int ibmmca_detect(struct scsi_host_template * scsi_template)
 {
 	struct Scsi_Host *shpnt;
-	int port, id, i, j, k, list_size, slot;
+	int port, id, i, j, k, slot;
 	int devices_on_irq_11 = 0;
 	int devices_on_irq_14 = 0;
 	int IRQ14_registered = 0;
@@ -1603,8 +1603,7 @@ int ibmmca_detect(struct scsi_host_templ
 	/* now look for other adapters in MCA slots, */
 	/* determine the number of known IBM-SCSI-subsystem types */
 	/* see the pos[2] dependence to get the adapter port-offset. */
-	list_size = sizeof(subsys_list) / sizeof(struct subsys_list_struct);
-	for (i = 0; i < list_size; i++) {
+	for (i = 0; i < ARRAY_SIZE(subsys_list); i++) {
 		/* scan each slot for a fitting adapter id */
 		slot = 0;	/* start at slot 0 */
 		while ((slot = mca_find_adapter(subsys_list[i].mca_id, slot))
@@ -1669,8 +1668,7 @@ int ibmmca_detect(struct scsi_host_templ
 	/* now check for SCSI-adapters, mapped to the integrated SCSI
 	 * area. E.g. a W/Cache in MCA-slot 9(!). Do the check correct here,
 	 * as this is a known effect on some models 95xx. */
-	list_size = sizeof(subsys_list) / sizeof(struct subsys_list_struct);
-	for (i = 0; i < list_size; i++) {
+	for (i = 0; i < ARRAY_SIZE(subsys_list); i++) {
 		/* scan each slot for a fitting adapter id */
 		slot = mca_find_adapter(subsys_list[i].mca_id, MCA_INTEGSCSI);
 		if (slot != MCA_NOTFOUND) {	/* scan through all slots */
diff -puN drivers/scsi/in2000.c~drivers-scsi-use-array_size-macro drivers/scsi/in2000.c
--- devel/drivers/scsi/in2000.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/in2000.c	2006-06-01 20:41:51.000000000 -0700
@@ -1809,7 +1809,7 @@ static int in2000_abort(Scsi_Cmnd * cmd)
 
 
 #define MAX_IN2000_HOSTS 3
-#define MAX_SETUP_ARGS (sizeof(setup_args) / sizeof(char *))
+#define MAX_SETUP_ARGS ARRAY_SIZE(setup_args)
 #define SETUP_BUFFER_SIZE 200
 static char setup_buffer[SETUP_BUFFER_SIZE];
 static char setup_used[MAX_SETUP_ARGS];
diff -puN drivers/scsi/initio.c~drivers-scsi-use-array_size-macro drivers/scsi/initio.c
--- devel/drivers/scsi/initio.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/initio.c	2006-06-01 20:41:51.000000000 -0700
@@ -154,7 +154,6 @@
 static unsigned int i91u_debug = DEBUG_DEFAULT;
 #endif
 
-#define TULSZ(sz)     (sizeof(sz) / sizeof(sz[0]))
 #define TUL_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
 
 typedef struct PCI_ID_Struc {
@@ -2771,7 +2770,7 @@ static int tul_NewReturnNumberOfAdapters
 
 	init_i91uAdapter_table();
 
-	for (i = 0; i < TULSZ(i91u_pci_devices); i++)
+	for (i = 0; i < ARRAY_SIZE(i91u_pci_devices); i++)
 	{
 		while ((pDev = pci_find_device(i91u_pci_devices[i].vendor_id, i91u_pci_devices[i].device_id, pDev)) != NULL) {
 			if (pci_enable_device(pDev))
diff -puN drivers/scsi/ips.c~drivers-scsi-use-array_size-macro drivers/scsi/ips.c
--- devel/drivers/scsi/ips.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/ips.c	2006-06-01 20:41:51.000000000 -0700
@@ -556,7 +556,7 @@ ips_setup(char *ips_str)
 		 * We now have key/value pairs.
 		 * Update the variables
 		 */
-		for (i = 0; i < (sizeof (options) / sizeof (options[0])); i++) {
+		for (i = 0; i < ARRAY_SIZE(options); i++) {
 			if (strnicmp
 			    (key, options[i].option_name,
 			     strlen(options[i].option_name)) == 0) {
diff -puN drivers/scsi/NCR53c406a.c~drivers-scsi-use-array_size-macro drivers/scsi/NCR53c406a.c
--- devel/drivers/scsi/NCR53c406a.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/NCR53c406a.c	2006-06-01 20:41:51.000000000 -0700
@@ -213,16 +213,16 @@ static void *addresses[] = {
 	(void *) 0xd8000,
 	(void *) 0xc8000
 };
-#define ADDRESS_COUNT (sizeof( addresses ) / sizeof( unsigned ))
+#define ADDRESS_COUNT ARRAY_SIZE(addresses)
 #endif				/* USE_BIOS */
 
 /* possible i/o port addresses */
 static unsigned short ports[] = { 0x230, 0x330, 0x280, 0x290, 0x330, 0x340, 0x300, 0x310, 0x348, 0x350 };
-#define PORT_COUNT (sizeof( ports ) / sizeof( unsigned short ))
+#define PORT_COUNT ARRAY_SIZE(ports)
 
 /* possible interrupt channels */
 static unsigned short intrs[] = { 10, 11, 12, 15 };
-#define INTR_COUNT (sizeof( intrs ) / sizeof( unsigned short ))
+#define INTR_COUNT ARRAY_SIZE(intrs)
 
 /* signatures for NCR 53c406a based controllers */
 #if USE_BIOS
@@ -236,7 +236,7 @@ struct signature {
 	{
 "Copyright (C) Acculogic, Inc.\r\n2.8M Diskette Extension Bios ver 4.04.03 03/01/1993", 61, 82},};
 
-#define SIGNATURE_COUNT (sizeof( signatures ) / sizeof( struct signature ))
+#define SIGNATURE_COUNT ARRAY_SIZE(signatures)
 #endif				/* USE_BIOS */
 
 /* ============================================================ */
diff -puN drivers/scsi/osst.c~drivers-scsi-use-array_size-macro drivers/scsi/osst.c
--- devel/drivers/scsi/osst.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/osst.c	2006-06-01 20:41:51.000000000 -0700
@@ -5492,7 +5492,7 @@ static int __init osst_setup (char *str)
   char *stp;
 
   stp = get_options(str, ARRAY_SIZE(ints), ints);
-	
+
   if (ints[0] > 0) {
 	for (i = 0; i < ints[0] && i < ARRAY_SIZE(parms); i++)
 		  *parms[i].val = ints[i + 1];
@@ -5507,7 +5507,7 @@ static int __init osst_setup (char *str)
 				break;
 			}
 		}
-		if (i >= sizeof(parms) / sizeof(struct osst_dev_parm))
+		if (i >= ARRAY_SIZE(parms))
 			printk(KERN_INFO "osst :I: Illegal parameter in '%s'\n",
 			       stp);
 		stp = strchr(stp, ',');
diff -puN drivers/scsi/pas16.c~drivers-scsi-use-array_size-macro drivers/scsi/pas16.c
--- devel/drivers/scsi/pas16.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/pas16.c	2006-06-01 20:41:51.000000000 -0700
@@ -156,7 +156,7 @@ static int default_irqs[] __initdata =
 static struct override {
     unsigned short io_port;
     int  irq;
-} overrides 
+} overrides
 #ifdef PAS16_OVERRIDE
     [] __initdata = PAS16_OVERRIDE;
 #else
@@ -164,19 +164,19 @@ static struct override {
 	{0,IRQ_AUTO}};
 #endif
 
-#define NO_OVERRIDES (sizeof(overrides) / sizeof(struct override))
+#define NO_OVERRIDES ARRAY_SIZE(overrides)
 
 static struct base {
     unsigned short io_port;
     int noauto;
-} bases[] __initdata = 
+} bases[] __initdata =
 	{ {PAS16_DEFAULT_BASE_1, 0},
 	  {PAS16_DEFAULT_BASE_2, 0},
 	  {PAS16_DEFAULT_BASE_3, 0},
 	  {PAS16_DEFAULT_BASE_4, 0}
 	};
 
-#define NO_BASES (sizeof (bases) / sizeof (struct base))
+#define NO_BASES ARRAY_SIZE(bases)
 
 static const unsigned short  pas16_offset[ 8 ] =
     {
diff -puN drivers/scsi/qla1280.c~drivers-scsi-use-array_size-macro drivers/scsi/qla1280.c
--- devel/drivers/scsi/qla1280.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/qla1280.c	2006-06-01 20:41:51.000000000 -0700
@@ -4215,15 +4215,12 @@ qla1280_get_token(char *str)
 {
 	char *sep;
 	long ret = -1;
-	int i, len;
-
-	len = sizeof(setup_token)/sizeof(struct setup_tokens);
+	int i;
 
 	sep = strchr(str, ':');
 
 	if (sep) {
-		for (i = 0; i < len; i++){
-
+		for (i = 0; i < ARRAY_SIZE(setup_token); i++) {
 			if (!strncmp(setup_token[i].token, str, (sep - str))) {
 				ret =  setup_token[i].val;
 				break;
diff -puN drivers/scsi/qlogicpti.c~drivers-scsi-use-array_size-macro drivers/scsi/qlogicpti.c
--- devel/drivers/scsi/qlogicpti.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/qlogicpti.c	2006-06-01 20:41:51.000000000 -0700
@@ -132,7 +132,7 @@ static const u_char mbox_param[] = {
 	PACKB(0, 0)	/* 0x0042 */
 };
 
-#define MAX_MBOX_COMMAND	(sizeof(mbox_param)/sizeof(u_short))
+#define MAX_MBOX_COMMAND	ARRAY_SIZE(mbox_param)
 
 /* queue length's _must_ be power of two: */
 #define QUEUE_DEPTH(in, out, ql)	((in - out) & (ql))
diff -puN drivers/scsi/raid_class.c~drivers-scsi-use-array_size-macro drivers/scsi/raid_class.c
--- devel/drivers/scsi/raid_class.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/raid_class.c	2006-06-01 20:41:51.000000000 -0700
@@ -131,7 +131,7 @@ static const char *raid_state_name(enum 
 	int i;
 	char *name = NULL;
 
-	for (i = 0; i < sizeof(raid_states)/sizeof(raid_states[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(raid_states); i++) {
 		if (raid_states[i].value == state) {
 			name = raid_states[i].name;
 			break;
@@ -161,7 +161,7 @@ static const char *raid_level_name(enum 
 	int i;
 	char *name = NULL;
 
-	for (i = 0; i < sizeof(raid_levels)/sizeof(raid_levels[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(raid_levels); i++) {
 		if (raid_levels[i].value == level) {
 			name = raid_levels[i].name;
 			break;
diff -puN drivers/scsi/scsi_lib.c~drivers-scsi-use-array_size-macro drivers/scsi/scsi_lib.c
--- devel/drivers/scsi/scsi_lib.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_lib.c	2006-06-01 20:41:51.000000000 -0700
@@ -30,7 +30,7 @@
 #include "scsi_logging.h"
 
 
-#define SG_MEMPOOL_NR		(sizeof(scsi_sg_pools)/sizeof(struct scsi_host_sg_pool))
+#define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
 #define SG_MEMPOOL_SIZE		32
 
 struct scsi_host_sg_pool {
diff -puN drivers/scsi/scsi_sysfs.c~drivers-scsi-use-array_size-macro drivers/scsi/scsi_sysfs.c
--- devel/drivers/scsi/scsi_sysfs.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_sysfs.c	2006-06-01 20:41:51.000000000 -0700
@@ -40,7 +40,7 @@ const char *scsi_device_state_name(enum 
 	int i;
 	char *name = NULL;
 
-	for (i = 0; i < sizeof(sdev_states)/sizeof(sdev_states[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		if (sdev_states[i].value == state) {
 			name = sdev_states[i].name;
 			break;
@@ -66,7 +66,7 @@ const char *scsi_host_state_name(enum sc
 	int i;
 	char *name = NULL;
 
-	for (i = 0; i < sizeof(shost_states)/sizeof(shost_states[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(shost_states); i++) {
 		if (shost_states[i].value == state) {
 			name = shost_states[i].name;
 			break;
@@ -161,7 +161,7 @@ store_shost_state(struct class_device *c
 	struct Scsi_Host *shost = class_to_shost(class_dev);
 	enum scsi_host_state state = 0;
 
-	for (i = 0; i < sizeof(shost_states)/sizeof(shost_states[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(shost_states); i++) {
 		const int len = strlen(shost_states[i].name);
 		if (strncmp(shost_states[i].name, buf, len) == 0 &&
 		   buf[len] == '\n') {
@@ -467,7 +467,7 @@ store_state_field(struct device *dev, st
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
 
-	for (i = 0; i < sizeof(sdev_states)/sizeof(sdev_states[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
 		if (strncmp(sdev_states[i].name, buf, len) == 0 &&
 		   buf[len] == '\n') {
diff -puN drivers/scsi/scsi_transport_fc.c~drivers-scsi-use-array_size-macro drivers/scsi/scsi_transport_fc.c
--- devel/drivers/scsi/scsi_transport_fc.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_transport_fc.c	2006-06-01 20:41:51.000000000 -0700
@@ -50,7 +50,7 @@ static const char *get_fc_##title##_name
 	int i;								\
 	char *name = NULL;						\
 									\
-	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {		\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
 		if (table[i].value == table_key) {			\
 			name = table[i].name;				\
 			break;						\
@@ -65,7 +65,7 @@ static int get_fc_##title##_match(const 
 {									\
 	int i;								\
 									\
-	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {		\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {			\
 		if (strncmp(table_key, table[i].name,			\
 				table[i].matchlen) == 0) {		\
 			*value = table[i].value;			\
@@ -140,7 +140,7 @@ get_fc_##title##_names(u32 table_key, ch
 	ssize_t len = 0;					\
 	int i;							\
 								\
-	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
 		if (table[i].value & table_key) {		\
 			len += sprintf(buf + len, "%s%s",	\
 				prefix, table[i].name);		\
diff -puN drivers/scsi/scsi_transport_sas.c~drivers-scsi-use-array_size-macro drivers/scsi/scsi_transport_sas.c
--- devel/drivers/scsi/scsi_transport_sas.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_transport_sas.c	2006-06-01 20:41:51.000000000 -0700
@@ -65,7 +65,7 @@ get_sas_##title##_names(u32 table_key, c
 	ssize_t len = 0;					\
 	int i;							\
 								\
-	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
 		if (table[i].value & table_key) {		\
 			len += sprintf(buf + len, "%s%s",	\
 				prefix, table[i].name);		\
@@ -83,7 +83,7 @@ get_sas_##title##_names(u32 table_key, c
 	ssize_t len = 0;					\
 	int i;							\
 								\
-	for (i = 0; i < sizeof(table)/sizeof(table[0]); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
 		if (table[i].value == table_key) {		\
 			len += sprintf(buf + len, "%s",		\
 				table[i].name);			\
diff -puN drivers/scsi/scsi_transport_spi.c~drivers-scsi-use-array_size-macro drivers/scsi/scsi_transport_spi.c
--- devel/drivers/scsi/scsi_transport_spi.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/scsi_transport_spi.c	2006-06-01 20:41:51.000000000 -0700
@@ -146,7 +146,7 @@ static inline const char *spi_signal_to_
 {
 	int i;
 
-	for (i = 0; i < sizeof(signal_types)/sizeof(signal_types[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(signal_types); i++) {
 		if (type == signal_types[i].value)
 			return signal_types[i].name;
 	}
@@ -156,7 +156,7 @@ static inline enum spi_signal_type spi_s
 {
 	int i, len;
 
-	for (i = 0; i < sizeof(signal_types)/sizeof(signal_types[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(signal_types); i++) {
 		len =  strlen(signal_types[i].name);
 		if (strncmp(name, signal_types[i].name, len) == 0 &&
 		    (name[len] == '\n' || name[len] == '\0'))
diff -puN drivers/scsi/sd.c~drivers-scsi-use-array_size-macro drivers/scsi/sd.c
--- devel/drivers/scsi/sd.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/sd.c	2006-06-01 20:41:51.000000000 -0700
@@ -175,7 +175,7 @@ static ssize_t sd_store_cache_type(struc
 		 * it's not worth the risk */
 		return -EINVAL;
 
-	for (i = 0; i < sizeof(sd_cache_types)/sizeof(sd_cache_types[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
 		const int len = strlen(sd_cache_types[i]);
 		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
 		    buf[len] == '\n') {
diff -puN drivers/scsi/seagate.c~drivers-scsi-use-array_size-macro drivers/scsi/seagate.c
--- devel/drivers/scsi/seagate.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/seagate.c	2006-06-01 20:41:51.000000000 -0700
@@ -312,7 +312,7 @@ static Signature __initdata signatures[]
 	{"IBM F1 V1.2009/22/93", 5, 25, FD},
 };
 
-#define NUM_SIGNATURES (sizeof(signatures) / sizeof(Signature))
+#define NUM_SIGNATURES ARRAY_SIZE(signatures)
 #endif				/* n OVERRIDE */
 
 /*
@@ -457,7 +457,7 @@ int __init seagate_st0x_detect (struct s
  * space for the on-board RAM instead.
  */
 
-		for (i = 0; i < (sizeof (seagate_bases) / sizeof (unsigned int)); ++i) {
+		for (i = 0; i < ARRAY_SIZE(seagate_bases); ++i) {
 			void __iomem *p = ioremap(seagate_bases[i], 0x2000);
 			if (!p)
 				continue;
diff -puN drivers/scsi/sg.c~drivers-scsi-use-array_size-macro drivers/scsi/sg.c
--- devel/drivers/scsi/sg.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/sg.c	2006-06-01 20:41:51.000000000 -0700
@@ -2635,8 +2635,7 @@ static int
 sg_proc_init(void)
 {
 	int k, mask;
-	int num_leaves =
-	    sizeof (sg_proc_leaf_arr) / sizeof (sg_proc_leaf_arr[0]);
+	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
 	struct proc_dir_entry *pdep;
 	struct sg_proc_leaf * leaf;
 
@@ -2661,8 +2660,7 @@ static void
 sg_proc_cleanup(void)
 {
 	int k;
-	int num_leaves =
-	    sizeof (sg_proc_leaf_arr) / sizeof (sg_proc_leaf_arr[0]);
+	int num_leaves = ARRAY_SIZE(sg_proc_leaf_arr);
 
 	if (!sg_proc_sgp)
 		return;
diff -puN drivers/scsi/st.c~drivers-scsi-use-array_size-macro drivers/scsi/st.c
--- devel/drivers/scsi/st.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/st.c	2006-06-01 20:41:51.000000000 -0700
@@ -3839,7 +3839,7 @@ static int __init st_setup(char *str)
 					break;
 				}
 			}
-			if (i >= sizeof(parms) / sizeof(struct st_dev_parm))
+			if (i >= ARRAY_SIZE(parms))
 				 printk(KERN_WARNING "st: invalid parameter in '%s'\n",
 					stp);
 			stp = strchr(stp, ',');
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~drivers-scsi-use-array_size-macro drivers/scsi/sym53c8xx_2/sym_hipd.c
--- devel/drivers/scsi/sym53c8xx_2/sym_hipd.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/sym53c8xx_2/sym_hipd.c	2006-06-01 20:41:51.000000000 -0700
@@ -1276,8 +1276,7 @@ static struct sym_chip sym_dev_table[] =
  FE_RAM|FE_IO256|FE_LEDC}
 };
 
-#define sym_num_devs \
-	(sizeof(sym_dev_table) / sizeof(sym_dev_table[0]))
+#define sym_num_devs (ARRAY_SIZE(sym_dev_table))
 
 /*
  *  Look up the chip table.
diff -puN drivers/scsi/t128.c~drivers-scsi-use-array_size-macro drivers/scsi/t128.c
--- devel/drivers/scsi/t128.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/t128.c	2006-06-01 20:41:51.000000000 -0700
@@ -126,15 +126,15 @@
 static struct override {
     unsigned long address;
     int irq;
-} overrides 
+} overrides
 #ifdef T128_OVERRIDE
     [] __initdata = T128_OVERRIDE;
 #else
-    [4] __initdata = {{0, IRQ_AUTO}, {0, IRQ_AUTO}, 
+    [4] __initdata = {{0, IRQ_AUTO}, {0, IRQ_AUTO},
         {0 ,IRQ_AUTO}, {0, IRQ_AUTO}};
 #endif
 
-#define NO_OVERRIDES (sizeof(overrides) / sizeof(struct override))
+#define NO_OVERRIDES ARRAY_SIZE(overrides)
 
 static struct base {
     unsigned int address;
@@ -143,7 +143,7 @@ static struct base {
     { 0xcc000, 0}, { 0xc8000, 0}, { 0xdc000, 0}, { 0xd8000, 0}
 };
 
-#define NO_BASES (sizeof (bases) / sizeof (struct base))
+#define NO_BASES ARRAY_SIZE(bases)
 
 static struct signature {
     const char *string;
@@ -152,7 +152,7 @@ static struct signature {
 {"TSROM: SCSI BIOS, Version 1.12", 0x36},
 };
 
-#define NO_SIGNATURES (sizeof (signatures) /  sizeof (struct signature))
+#define NO_SIGNATURES ARRAY_SIZE(signatures)
 
 /*
  * Function : t128_setup(char *str, int *ints)
diff -puN drivers/scsi/wd33c93.c~drivers-scsi-use-array_size-macro drivers/scsi/wd33c93.c
--- devel/drivers/scsi/wd33c93.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/wd33c93.c	2006-06-01 20:41:51.000000000 -0700
@@ -1701,7 +1701,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 }
 
 #define MAX_WD33C93_HOSTS 4
-#define MAX_SETUP_ARGS ((int)(sizeof(setup_args) / sizeof(char *)))
+#define MAX_SETUP_ARGS ARRAY_SIZE(setup_args)
 #define SETUP_BUFFER_SIZE 200
 static char setup_buffer[SETUP_BUFFER_SIZE];
 static char setup_used[MAX_SETUP_ARGS];
diff -puN drivers/scsi/wd7000.c~drivers-scsi-use-array_size-macro drivers/scsi/wd7000.c
--- devel/drivers/scsi/wd7000.c~drivers-scsi-use-array_size-macro	2006-06-01 20:41:51.000000000 -0700
+++ devel-akpm/drivers/scsi/wd7000.c	2006-06-01 20:41:51.000000000 -0700
@@ -267,7 +267,7 @@ static const long wd7000_biosaddr[] = {
 	0xc0000, 0xc2000, 0xc4000, 0xc6000, 0xc8000, 0xca000, 0xcc000, 0xce000,
 	0xd0000, 0xd2000, 0xd4000, 0xd6000, 0xd8000, 0xda000, 0xdc000, 0xde000
 };
-#define NUM_ADDRS (sizeof(wd7000_biosaddr)/sizeof(long))
+#define NUM_ADDRS ARRAY_SIZE(wd7000_biosaddr)
 
 static const unsigned short wd7000_iobase[] = {
 	0x0300, 0x0308, 0x0310, 0x0318, 0x0320, 0x0328, 0x0330, 0x0338,
@@ -275,13 +275,13 @@ static const unsigned short wd7000_iobas
 	0x0380, 0x0388, 0x0390, 0x0398, 0x03a0, 0x03a8, 0x03b0, 0x03b8,
 	0x03c0, 0x03c8, 0x03d0, 0x03d8, 0x03e0, 0x03e8, 0x03f0, 0x03f8
 };
-#define NUM_IOPORTS (sizeof(wd7000_iobase)/sizeof(unsigned short))
+#define NUM_IOPORTS ARRAY_SIZE(wd7000_iobase)
 
 static const short wd7000_irq[] = { 3, 4, 5, 7, 9, 10, 11, 12, 14, 15 };
-#define NUM_IRQS (sizeof(wd7000_irq)/sizeof(short))
+#define NUM_IRQS ARRAY_SIZE(wd7000_irq)
 
 static const short wd7000_dma[] = { 5, 6, 7 };
-#define NUM_DMAS (sizeof(wd7000_dma)/sizeof(short))
+#define NUM_DMAS ARRAY_SIZE(wd7000_dma)
 
 /*
  * The following is set up by wd7000_detect, and used thereafter for
@@ -317,7 +317,7 @@ static Config configs[] = {
 	{7, 6, 0x350, BUS_ON, BUS_OFF},	/* My configuration (Zaga)     */
 	{-1, -1, 0x0, BUS_ON, BUS_OFF}	/* Empty slot                  */
 };
-#define NUM_CONFIGS (sizeof(configs)/sizeof(Config))
+#define NUM_CONFIGS ARRAY_SIZE(configs)
 
 /*
  *  The following list defines strings to look for in the BIOS that identify
@@ -333,7 +333,7 @@ typedef struct signature {
 static const Signature signatures[] = {
 	{"SSTBIOS", 0x0000d, 7}	/* "SSTBIOS" @ offset 0x0000d */
 };
-#define NUM_SIGNATURES (sizeof(signatures)/sizeof(Signature))
+#define NUM_SIGNATURES ARRAY_SIZE(signatures)
 
 
 /*
_
