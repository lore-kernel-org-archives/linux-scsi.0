From: "conway, heather" <conway_heather@emc.com>
Subject: [SLE] RE: SCSI scanning issue with SuSE distributions?
Date: Tue, 3 Sep 2002 17:01:56 -0400
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5501C1A4E4@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <suse-linux-e-return-113971-suse-linux-e=m.gmane.org@suse.com>
list-help: <mailto:suse-linux-e-help@suse.com>
list-unsubscribe: <mailto:suse-linux-e-unsubscribe-suse-linux-e=m.gmane.org@suse.com>
list-post: <mailto:suse-linux-e@suse.com>
To: 'Patrick Mansfield' <patmans@us.ibm.com>, "conway, heather" <conway_heather@emc.com>
Cc: "'suse-linux-e@suse.com'" <suse-linux-e@suse.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Thanks Patrick.  
-----Original Message-----
From: Patrick Mansfield [mailto:patmans@us.ibm.com]
Sent: Wednesday, August 28, 2002 2:30 PM
To: conway, heather
Cc: 'suse-linux-e@suse.com'; 'linux-scsi@vger.kernel.org'
Subject: Re: SCSI scanning issue with SuSE distributions?


On Mon, Aug 26, 2002 at 09:52:20PM -0400, conway, heather wrote:
> > Hi Folks,
> > I'm hoping you can help.  I'm working with SuSE attached to a CLARiiON
> > array and the SuSE SCSI stack is incorrectly reporting CLARiiON devices.
> > SuSE SLES 7, v7.3, and v8.0 all experience the same problem.  
> > The problem is as follows:
> > When a SuSE host is attached to the CLARiiON, it is inaccurately
reporting
> > that there are 254 devices per HBA.  For clarity's sake, I do not think
> > that problem is that Linux doesn't support more than 128 devices....that
> > isn't the problem here.  
> > For instance, if a system has two HBAs with only 8 CLARiiON devices
> > allocated to each HBA for a total of 16 actual devices, the SuSE
> > distributions will report 254 devices per HBA.  The system should see
only
> > a total of 16 CLARiiON devices, but instead, it reports that it sees
508.
> > This happens with the qla2x00.o and qla2200/qla2300.o drivers that are
> > incorporated into the SuSE distributions as well as the 'EMC-approved'
> > v4.47.16 qLogic driver and v4.20L Emulex driver.  
> > RedHat doesn't have this problem when attached to CLARiiON arrays, but
> > their SCSI scanning is definitely different.  I have put together a
couple
> > of patches, but so far haven't come up with the right combination to
> > correct the problem.
> > Has anyone seen this previously?  If so, do you have a patch to resolve
> > the problem ?
> > Thanks in advance for the assistance.
> > Heather

Heather -

There were changes to RedHat way back for PQ problems that don't appear
in the mainline 2.4 (at least 2.4.19), to fix issues for a Scsi_Device 
when it had a PQ value (of 1 or such) it was configured into the system,
even though it could not be used. Look at the diff between 2.4.19 and redhat
(appended here), the code is "if (lun != 0 && (scsi_result[0] >> 5) == 1)".

It should probably also have sparse lun check as part of the if, so sparce
lun devices don't stop scanning when one of these luns are hit.

If you're hitting this problem there should also be read capacity failures.

Something like this is needed in 2.5.x.

Reference:

http://marc.theaimsgroup.com/?l=linux-scsi&m=98462326621762&w=2

--- scsi_scan.c	Fri Aug  2 17:39:44 2002
+++ /home/patman/scsi_scan.c	Wed Aug 28 11:20:09 2002
@@ -155,16 +155,16 @@
  	{"TOSHIBA","CDROM","*", BLIST_ISROM},
  	{"TOSHIBA","CD-ROM","*", BLIST_ISROM},
 	{"MegaRAID", "LD", "*", BLIST_FORCELUN},
-	{"DGC",  "RAID",      "*", BLIST_SPARSELUN | BLIST_LARGELUN}, //
Dell PV 650F (tgt @ LUN 0)
-	{"DGC",  "DISK",      "*", BLIST_SPARSELUN | BLIST_LARGELUN}, //
Dell PV 650F (no tgt @ LUN 0) 
-	{"DELL", "PV660F",   "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN |
BLIST_LARGELUN},
-	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN |
BLIST_LARGELUN}, // Dell PV 530F
-	{"DELL", "PV530F",    "*", BLIST_SPARSELUN | BLIST_LARGELUN}, //
Dell PV 530F
+	{"DGC",  "RAID",      "*", BLIST_SPARSELUN}, // Dell PV 650F (tgt @
LUN 0)
+	{"DGC",  "DISK",      "*", BLIST_SPARSELUN}, // Dell PV 650F (no tgt
@ LUN 0) 
+	{"DELL", "PV660F",   "*", BLIST_SPARSELUN},
+	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN},
+	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN}, // Dell PV 530F
+	{"DELL", "PV530F",    "*", BLIST_SPARSELUN}, // Dell PV 530F
 	{"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},
 	{"HP", "A6189A", "*", BLIST_SPARSELUN |  BLIST_LARGELUN}, // HP
VA7400, by Alar Aun
-	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN | BLIST_LARGELUN},   // CMD
RAID Controller
-	{"CNSI", "G7324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     //
Chaparral G7324 RAID
+	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN},   // CMD RAID Controller
+	{"CNSI", "G7324", "*", BLIST_SPARSELUN},     // Chaparral G7324 RAID
 	{"CNSi", "G8324", "*", BLIST_SPARSELUN},     // Chaparral G8324 RAID
 	{"Zzyzx", "RocketStor 500S", "*", BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", "*", BLIST_SPARSELUN},
@@ -196,10 +196,14 @@
 static unsigned int max_scsi_luns = 1;
 #endif
 
+static unsigned int scsi_allow_ghost_devices = 0;
+
 #ifdef MODULE
 
 MODULE_PARM(max_scsi_luns, "i");
 MODULE_PARM_DESC(max_scsi_luns, "last scsi LUN (should be between 1 and
2^32-1)");
+MODULE_PARM(scsi_allow_ghost_devices, "i");
+MODULE_PARM_DESC(scsi_allow_ghost_devices, "allow devices marked as being
offline to be accessed anyway (0 = off, else allow ghosts on lun 0 through
allow_ghost_devices - 1");
 
 #else
 
@@ -219,6 +223,21 @@
 
 __setup("max_scsi_luns=", scsi_luns_setup);
 
+static int __init scsi_allow_ghost_devices_setup(char *str)
+{
+	unsigned int tmp;
+
+	if (get_option(&str, &tmp) == 1) {
+		scsi_allow_ghost_devices = tmp;
+		return 1;
+	} else {
+		printk("scsi_allow_ghost_devices_setup: usage
scsi_allow_ghost_devices=n (0: off else\nallow ghost devices (ghost devices
are devices that report themselves as\nbeing offline but which we allow
access to anyway) on lun 0 through n - 1.\n");
+		return 0;
+	}
+}
+
+__setup("scsi_allow_ghost_devices=", scsi_allow_ghost_devices_setup);
+
 #endif
 
 static void print_inquiry(unsigned char *data)
@@ -318,13 +337,9 @@
 		memset(SDpnt, 0, sizeof(Scsi_Device));
 		/*
 		 * Register the queue for the device.  All I/O requests will
-		 * come in through here.  We also need to register a pointer
to
-		 * ourselves, since the queue handler won't know what device
-		 * the queue actually represents.   We could look it up, but
it
-		 * is pointless work.
+		 * come in through here.
 		 */
 		scsi_initialize_queue(SDpnt, shpnt);
-		SDpnt->request_queue.queuedata = (void *) SDpnt;
 		/* Make sure we have something that is valid for DMA
purposes */
 		scsi_result = ((!shpnt->unchecked_isa_dma)
 			       ? &scsi_result0[0] : kmalloc(512, GFP_DMA));
@@ -605,6 +620,23 @@
 	 */
 
 	/*
+	 * If we are offline and we are on a LUN != 0, then skip this entry.
+	 * If we are on a BLIST_FORCELUN device this will stop the scan at
+	 * the first offline LUN (typically the correct thing to do).  If
+	 * we are on a BLIST_SPARSELUN device then this won't stop the scan,
+	 * but it will keep us from having false entries in our device
+	 * array. DL
+	 *
+	 * NOTE: Need to test this to make sure it doesn't cause problems
+	 * with tape autoloaders, multidisc CD changers, and external
+	 * RAID chassis that might use sparse luns or multiluns... DL
+	 */
+	if (lun != 0 && (scsi_result[0] >> 5) == 1) {
+		scsi_release_request(SRpnt);
+		return 0;
+	}
+
+	/*
 	 * Get any flags for this device.  
 	 */
 	bflags = get_device_flags (scsi_result);
@@ -642,8 +674,11 @@
 
 	SDpnt->removable = (0x80 & scsi_result[1]) >> 7;
 	/* Use the peripheral qualifier field to determine online/offline */
-	if (((scsi_result[0] >> 5) & 7) == 1) 	SDpnt->online = FALSE;
-	else SDpnt->online = TRUE;
+	if ((((scsi_result[0] >> 5) & 7) == 1) &&
+	    (lun >= scsi_allow_ghost_devices))
+		SDpnt->online = FALSE;
+	else 
+		SDpnt->online = TRUE;
 	SDpnt->lockable = SDpnt->removable;
 	SDpnt->changed = 0;
 	SDpnt->access_count = 0;
@@ -675,7 +710,7 @@
 	}
 
 	SDpnt->device_blocked = FALSE;
-	SDpnt->device_busy = 0;
+	atomic_set(&SDpnt->device_busy,0);
 	SDpnt->single_lun = 0;
 	SDpnt->soft_reset =
 	    (scsi_result[7] & 1) && ((scsi_result[3] & 7) == 2);
@@ -844,11 +879,26 @@
 		 * I think we need REPORT LUNS in future to avoid scanning
 		 * of unused LUNs. But, that is another item.
 		 */
+		/*
 		if (*max_dev_lun < shpnt->max_lun)
 			*max_dev_lun = shpnt->max_lun;
 		else 	if ((max_scsi_luns >> 1) >= *max_dev_lun)
 				*max_dev_lun += shpnt->max_lun;
 			else	*max_dev_lun = max_scsi_luns;
+		*/
+		/*
+		 * Blech...the above code is broken.  When you have a device
+		 * that is present, and it is a FORCELUN device, then we
+		 * need to scan *all* the luns on that device.  Besides,
+		 * skipping the scanning of LUNs is a false optimization.
+		 * Scanning for a LUN on a present device is a very fast
+		 * operation, it's scanning for devices that don't exist
that
+		 * is expensive and slow (although if you are truly scanning
+		 * through MAX_SCSI_LUNS devices that would be bad, I hope
+		 * all of the controllers out there set a reasonable value
+		 * in shpnt->max_lun).  DL
+		 */
+		*max_dev_lun = shpnt->max_lun;
 		return 1;
 	}
 	/*

-- Patrick Mansfield

-- 
Check the headers for your unsubscription address
For additional commands send e-mail to suse-linux-e-help@suse.com
Also check the archives at http://lists.suse.com
Please read the FAQs: suse-linux-e-faq@suse.com
