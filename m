From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Sanitize PQ3 device handling (Take #2)
Date: Tue, 24 May 2005 10:24:26 +0200
Message-ID: <4292E4BA.5040001@suse.de>
References: <428CA4E3.9030601@suse.de> <20050520214030.GA8925@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070801040108030907090100"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:4265 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261466AbVEXIYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 04:24:40 -0400
In-Reply-To: <20050520214030.GA8925@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070801040108030907090100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Patrick Mansfield wrote:
> On Thu, May 19, 2005 at 04:38:27PM +0200, Hannes Reinecke wrote:
>>Hi James,
>>
>>this is an updated version of the patch. As I suspected, the issue isn't
>>quite as easy. Problem is that older SCSI-2 device have the habit for
>>responding to LUN1 in addition to LUN0, even though only one device is
>>attached. LUN1 has set PQ to 3 accordingly.
>>And of course we _don't_ want those fake devices to stick around.
>>So I've improved the logic to not register devices with LUN != 0 and a
>>PQ of 1 or 3. All other devices are registered accordingly.
>>
>>I can't really see why we should register devices with PQ 1 and LUN !=
>>0; if one wants to have them he still can do a REPORT LUN on LUN 0 and
>>an explicit scan for the missing device.
>>
>>And I do think the locking is slightly wrong for the failure case;
>>without this adaptecs have a habit of crashing when doing a rmmod.
> 
> Is that what the extra put's are fixing? That should be a separate patch.
> 
Hm. Yes, probably.

[ .. ]
> I don't have a strong opinion for either direction, but having LUN 0 with
> and sometimes without an sd there bothers me. Pick your poison ...
> 
I don't really have a problem with having sd attached to LUN 0
sometimes. We're doing only what the SCSI device tells us ...

> Long term, a way to access any LUN on a target from user space would be
> very useful, not just LUN 0.
> 
That's what I thought also; only some dastardly SCSI-2 drives respond to
LUN 0 and LUN 1 (actually all SCSI-2 device which I have connected here;
wonder whether this is again some 'interesting' specification
interpretation). So it's doubtful whether this a possible way to go.
Or maybe return all LUNs for SCSI-3 and higher?

[ .. ]
> I prefer naming with all LUN in all the defines since we are returning LUN
> status, or leave as is. For SCSI_SCAN_TARGET_IGNORED, we are not
> configuring the LUN.
> 
> i.e. keep the original:
> 
> #define SCSI_SCAN_NO_RESPONSE		0
> #define SCSI_SCAN_TARGET_PRESENT	1
> #define SCSI_SCAN_LUN_PRESENT		2
> 
> Or:
> 
> #define SCSI_SCAN_NO_RESPONSE		0
> #define SCSI_SCAN_LUN_IGNORED		1
> #define SCSI_SCAN_LUN_PRESENT		2
> 
> 
Yes, this makes more sense. Still think having SCSI_SCAN_LUN_IGNORED
instead of SCSI_SCAN_TARGET_PRESENT is more sensible as the meaning of
those flags changed slightly (flags indicate now the device state in
scsi-ml, not the state according to the SCSI-bus).

> You should add code to not print the "unknown device type" if PQ 3 or 1,
> or special case type 31 (0x1f).
> 
> SCSI spec says for PQ of 011 (3):
> 
> 	The device server is not capable of supporting a peripheral device
> 	on this logical unit.  For this peripheral qualifier the
> 	peripheral device type shall be set to 1Fh to provide
> 	compatibility with previous versions of SCSI.
> 
Agreed.

Fixed patch attached.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------070801040108030907090100
Content-Type: text/plain;
 name="linux-2.6.12-rc4-scsi-scan-sparse-luns"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.12-rc4-scsi-scan-sparse-luns"

From: Hannes Reinecke <hare@suse.de>
Subject: Sanitize PQ3 device handling

The current handling of devices with a PQ of 3 is plain broken.
Whenever we detect such a device, no device check with REPORT LUNs is
made but rather a SCSI-2 sequential scan is done. This is plain wrong
for modern storage servers who use LUN 0 as a virtual device to be
used for configuration, eg REPORT LUN queries.

Improved scanning logic:
First LUN 0 is scanned then a report_lun scan is attempted if a device
is detected. This will bail out for any device which does not support
it; for those a sequential scan is performed.
All devices are registered with the midlayer except those which report
a PQ of 1 or 3 and have a LUN != 0. LUN 0 will always be registered as
we might need it for configuration / queries.

--- linux-2.6.12-rc4.orig/drivers/scsi/scsi_scan.c	2005-05-07 07:20:31.000000000 +0200
+++ linux-2.6.12-rc4/drivers/scsi/scsi_scan.c	2005-05-23 15:51:24.000000000 +0200
@@ -64,15 +64,15 @@
  * SCSI_SCAN_NO_RESPONSE: no valid response received from the target, this
  * includes allocation or general failures preventing IO from being sent.
  *
- * SCSI_SCAN_TARGET_PRESENT: target responded, but no device is available
- * on the given LUN.
+ * SCSI_SCAN_LUN_IGNORED: target responded, but is ignored from the
+ * midlayer
  *
- * SCSI_SCAN_LUN_PRESENT: target responded, and a device is available on a
- * given LUN.
+ * SCSI_SCAN_LUN_PRESENT: target responded, and is registered with the
+ * midlayer
  */
 #define SCSI_SCAN_NO_RESPONSE		0
-#define SCSI_SCAN_TARGET_PRESENT	1
-#define SCSI_SCAN_LUN_PRESENT		2
+#define SCSI_SCAN_LUN_IGNORED		1
+#define SCSI_SCAN_LUN_PRESENT		2
 
 static char *scsi_null_device_strs = "nullnullnullnull";
 
@@ -553,8 +556,7 @@
 
 	/*
 	 * The scanning code needs to know the scsi_level, even if no
-	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
-	 * non-zero LUNs can be scanned.
+	 * device is attached at LUN 0 so that non-zero LUNs can be scanned.
 	 */
 	sdev->scsi_level = inq_result[2] & 0x07;
 	if (sdev->scsi_level >= 2 ||
@@ -615,6 +617,7 @@
 	} else if (*bflags & BLIST_NO_ULD_ATTACH)
 		sdev->no_uld_attach = 1;
 
+	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
 	switch (sdev->type = (inq_result[0] & 0x1f)) {
 	case TYPE_TAPE:
 	case TYPE_DISK:
@@ -632,7 +635,8 @@
 		sdev->writeable = 0;
 		break;
 	default:
-		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
+		if (sdev->inq_periph_qual != 1 && sdev->inq_periph_qual != 3)
+			printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
 	}
 
 	print_inquiry(inq_result);
@@ -651,9 +655,13 @@
 	 * Don't set the device offline here; rather let the upper
 	 * level drivers eval the PQ to decide whether they should
 	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
+	 *
+	 * Since we don't set the device offline anymore there is
+	 * no sense at all in treating PQ 1 and PQ 3 differently
+	 * as both do not have a device attached. If PQ 1 targets
+	 * ever get it's device back we need to rescan anyway.
 	 */ 
 
-	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
 	sdev->removable = (0x80 & inq_result[1]) >> 7;
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
@@ -756,8 +764,7 @@
  *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
- *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
- *         attached at the LUN
+ *     SCSI_SCAN_LUN_IGNORED: target responded but was ignored.
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
@@ -812,21 +819,18 @@
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if ((result[0] >> 5) == 3) {
+	if ( lun != 0 && ((result[0] >> 5) == 3) || ((result[0] >> 5) == 1)) {
 		/*
-		 * For a Peripheral qualifier 3 (011b), the SCSI
-		 * spec says: The device server is not capable of
-		 * supporting a physical device on this logical
-		 * unit.
+		 * The Peripheral qualifier indicates that there
+		 * is no physical device connected.
 		 *
-		 * For disks, this implies that there is no
-		 * logical disk configured at sdev->lun, but there
-		 * is a target id responding.
+		 * So ignore this device if it's not LUN 0;
+		 * keep LUN 0 around so as to send inquiries to it.
 		 */
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-					"scsi scan: peripheral qualifier of 3,"
-					" no device added\n"));
-		res = SCSI_SCAN_TARGET_PRESENT;
+					"scsi scan: no physical device present,"
+					" device not added\n"));
+		res = SCSI_SCAN_LUN_IGNORED;
 		goto out_free_result;
 	}
 
@@ -1280,22 +1285,29 @@
 	 */
 	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, NULL);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
-		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
+		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0) {
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
+			if (res == SCSI_SCAN_LUN_IGNORED)
+				/*
+				 * There's a target here, but lun 0 is not 
+				 * connected to a device and does not support
+				 * the report_lun scan.  Fall back to a 
+				 * sequential lun scan with a bflags of 
+				 * SPARSELUN.
+				 *
+				 * The old code also used a default scsi level
+				 * of SCSI_2 which seems a bit spurious. Any
+				 * misbehaving device should rather be added
+				 * to the blacklist.
+				 */
+				bflags |= BLIST_SPARSELUN;
+
 			scsi_sequential_lun_scan(starget, bflags,
 				       	res, sdev->scsi_level, rescan);
-	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
-		/*
-		 * There's a target here, but lun 0 is offline so we
-		 * can't use the report_lun scan.  Fall back to a
-		 * sequential lun scan with a bflags of SPARSELUN and
-		 * a default scsi level of SCSI_2
-		 */
-		scsi_sequential_lun_scan(starget, BLIST_SPARSELUN,
-				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
+		}
 	}
 	if (sdev)
 		scsi_device_put(sdev);

--------------070801040108030907090100--
