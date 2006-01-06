From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Fri, 06 Jan 2006 22:39:34 +1000
Message-ID: <43BE6506.7090901@torque.net>
References: <doc5jl$acv$1@sea.gmane.org> <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com> <20060106013640.GA27841@aracnet.com> <43BDDCAE.7000506@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030402000300020802090505"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43BDDCAE.7000506@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: patman@aracnet.com, Chris Paulson-Ellis <chris@edesix.com>, Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030402000300020802090505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> patman@aracnet.com wrote:
> 
>>On Fri, Dec 23, 2005 at 12:12:18AM +0000, Chris Paulson-Ellis wrote:
>>
>>
>>
>>>>Why not just fix the kernel when it's filling in the page 83
>>>>data to pull the serial from page 80 instead of putting *that* there?
>>>>
>>>>Bill
>>>
>>>Indeed. Here's the patch. Now I have 3 ways to fix this. Any more anyone?
>>
>>
>>This is the best approach, I think you could even remove page 0x83 support
>>and still be SCSI compliant.
> 
> 
> Pat,
> Not since 2000/2001 ... The VPD device identification page
> (0x83) and the "Supported VPD pages" page (0x0) are
> mandatory in SPC-2 (ANSI INCITS 351-2001), SPC-3 (soon
> to be a standard) and SPC-4. Recent SCSI to ATA
> Translation drafts (e.g. sat-r07a.pdf) define a mapping
> for the naa-5 identifier defined in ATA/ATAPI-7 and
> ATA/ATAPI-8 (IDENTIFY DEVICE response words 108 to 111)
> to VPD page 0x83. There are also moves afoot to get a
> similar wwn identifier into the IDENTIFY PACKET DEVICE
> response.
> 
> SAT defines two device id descriptors for VPD page 0x83:
>   - based on WWN naa-5 (described above)
>   - based on model number and serial number (IDENTIFY
>     DEVICE response words 27-46 and 10-19)
> 
> So removing VPD page 0x83 would be a retrograde step
> IMO. The libata implementation should be enhanced to
> support one or both of the above descriptors as they
> have a defined format (unlike serial number VPD page (0x80)).
> libata's current approach to yield "Linux ATA-SCSI simulator"
> for the loosely formatted ASCII identification descriptor
> is just a place holder.

The attachment adds the second item above to the patch
suggested by Chris Paulson-Ellis <chris@edesix.com> in:
http://marc.theaimsgroup.com/?l=linux-hotplug-devel&m=113529667019652&w=2

The patch is against lk 2.6.15 and was tested on a sil
controller with a Seagate ST380013AS sata disk.

Changelog:
  - make existing libata VPD device identification page (0x83)
    supply the ATA serial number in the libata "vendor
    specific" designator (from Chris Paulson-Ellis)
  - add a "t10 vendor id based" designator as defined in
    SAT rev 07a (section 10.3.4.2.3) that supplies ATA
    model and serial numbers
  - make the libata VPD page 0x83 more extensible (for
    adding more designators in the future).

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert


--------------030402000300020802090505
Content-Type: text/x-patch;
 name="libata_vpd83_2615.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata_vpd83_2615.diff"

--- linux/drivers/scsi/libata-scsi.c	2006-01-04 08:50:42.000000000 +1000
+++ linux/drivers/scsi/libata-scsi.c2615vpd	2006-01-06 20:16:25.000000000 +1000
@@ -1532,16 +1532,16 @@
 	return 0;
 }
 
-static const char *inq_83_str = "Linux ATA-SCSI simulator";
-
 /**
  *	ata_scsiop_inq_83 - Simulate INQUIRY EVPD page 83, device identity
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
  *	@buflen: Response buffer length.
  *
- *	Returns device identification.  Currently hardcoded to
- *	return "Linux ATA-SCSI simulator".
+ *	Yields two logocal unit device identification designators:
+ *	  - vendor specific ASCII containing the ATA serial number
+ *	  - SAT defined "t10 vendor id based" containing ASCII vendor
+ *	    name ("ATA     "), model and serial numbers.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -1550,16 +1550,39 @@
 unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
 			      unsigned int buflen)
 {
+	int num;
+	const int sat_model_serial_desc_len = 68;
+	const int ata_model_byte_len = 40;
+
 	rbuf[1] = 0x83;			/* this page code */
-	rbuf[3] = 4 + strlen(inq_83_str);	/* page len */
+	num = 4;
 
-	/* our one and only identification descriptor (vendor-specific) */
-	if (buflen > (strlen(inq_83_str) + 4 + 4 - 1)) {
-		rbuf[4 + 0] = 2;	/* code set: ASCII */
-		rbuf[4 + 3] = strlen(inq_83_str);
-		memcpy(rbuf + 4 + 4, inq_83_str, strlen(inq_83_str));
+	if (buflen > (ATA_SERNO_LEN + num + 3)) {
+		/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
+		rbuf[num + 0] = 2;	
+		rbuf[num + 3] = ATA_SERNO_LEN;
+		num += 4;
+		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
+				  ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
+		num += ATA_SERNO_LEN;
 	}
-
+	if (buflen > (sat_model_serial_desc_len + num + 3)) {
+		/* SAT defined lu model and serial numbers descriptor */
+		/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
+		rbuf[num + 0] = 2;	
+		rbuf[num + 1] = 1;	
+		rbuf[num + 3] = sat_model_serial_desc_len;
+		num += 4;
+		strncpy(rbuf + num, "ATA     ", 8);
+		num += 8;
+		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
+				  ATA_ID_PROD_OFS, ata_model_byte_len);
+		num += ata_model_byte_len;
+		ata_dev_id_string(args->id, (unsigned char *) rbuf + num,
+				  ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
+		num += ATA_SERNO_LEN;
+	}
+	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */
 	return 0;
 }
 


--------------030402000300020802090505--
