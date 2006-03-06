From: Douglas Gilbert <dougg@torque.net>
Subject: Re: libata SCSI page 0x83 query
Date: Mon, 06 Mar 2006 18:29:31 -0500
Message-ID: <440CC5DB.3030802@torque.net>
References: <43AB446F.6000900@edesix.com> <440C97BE.1030105@pobox.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070408070208090400020507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:46280 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S932451AbWCFXal (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Mar 2006 18:30:41 -0500
In-Reply-To: <440C97BE.1030105@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Chris Paulson-Ellis <chris@edesix.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070408070208090400020507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> Chris Paulson-Ellis wrote:
> 
>> Hi,
>>
>> I have a problem with udev persistent device naming for SATA drives
>> that is caused by the libata implementation of the page 0x83 SCSI
>> device identifier query. See this thead from hotplug-devel:
>>
>> http://marc.theaimsgroup.com/?t=113518947900002&r=1&w=2
>>
>> I can work around the problem using /etc/scsi_id.config or udev rules
>> (see the thread), but here is a patch to fix the problem at source.
>> What do you think?
>>
>> Regards,
>> Chris.
>>
>> --- drivers/scsi/libata-scsi.c.orig     2005-12-22 23:23:55.000000000
>> +0000
>> +++ drivers/scsi/libata-scsi.c  2005-12-22 23:56:14.000000000 +0000
>> @@ -1532,16 +1532,13 @@
>>        return 0;
>> }
>>
>> -static const char *inq_83_str = "Linux ATA-SCSI simulator";
>> -
>> /**
>>  *     ata_scsiop_inq_83 - Simulate INQUIRY EVPD page 83, device identity
>>  *     @args: device IDENTIFY data / SCSI command of interest.
>>  *     @rbuf: Response buffer, to which simulated SCSI cmd output is
>> sent.
>>  *     @buflen: Response buffer length.
>>  *
>> - *     Returns device identification.  Currently hardcoded to
>> - *     return "Linux ATA-SCSI simulator".
>> + *     Returns ATA device serial number (as for page 80).
>>  *
>>  *     LOCKING:
>>  *     spin_lock_irqsave(host_set lock)
>> @@ -1551,13 +1548,14 @@
>>                              unsigned int buflen)
>> {
>>        rbuf[1] = 0x83;                 /* this page code */
>> -       rbuf[3] = 4 + strlen(inq_83_str);       /* page len */
>> +       rbuf[3] = 4 + ATA_SERNO_LEN;    /* page len */
>>
>>        /* our one and only identification descriptor (vendor-specific) */
>> -       if (buflen > (strlen(inq_83_str) + 4 + 4 - 1)) {
>> +       if (buflen > (ATA_SERNO_LEN + 4 + 4 - 1)) {
>>                rbuf[4 + 0] = 2;        /* code set: ASCII */
>> -               rbuf[4 + 3] = strlen(inq_83_str);
>> -               memcpy(rbuf + 4 + 4, inq_83_str, strlen(inq_83_str));
>> +               rbuf[4 + 3] = ATA_SERNO_LEN;
>> +               ata_dev_id_string(args->id, (unsigned char *) rbuf + 4
>> + 4,
>> +                                 ATA_ID_SERNO_OFS, ATA_SERNO_LEN);
> 
> 
> Douglas Gilbert has an improved patch along these lines...

I assume that is a prompt to roll another version
of that VPD patch, this time against lk 2.6.16-rc5
as my git tree is unavailable.

Changelog:
  - make existing libata VPD device identification page (0x83)
    supply the ATA serial number in the libata "vendor
    specific" designator (from Chris Paulson-Ellis)
  - add a "t10 vendor id based" designator as defined in
    SAT rev 08 (section 10.3.4.2.3) that supplies ATA
    model and serial numbers
  - make the libata VPD page 0x83 more extensible (for
    adding more designators in the future).
  - rename EVPD to VPD in various places. Enable Vital
    Product Data (EVPD) is a bit in the INQUIRY cdb.

Signed-off-by: Douglas Gilbert <dougg@torque.net>


--------------070408070208090400020507
Content-Type: text/x-patch;
 name="libata_vpd83_2616rc5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libata_vpd83_2616rc5.diff"

--- linux/drivers/scsi/libata-scsi.c	2006-02-27 09:46:11.000000000 -0500
+++ linux/drivers/scsi/libata-scsi.c2616rc5vpd	2006-03-06 17:52:40.000000000 -0500
@@ -1445,7 +1445,7 @@
  *	@buflen: Response buffer length.
  *
  *	Returns standard device identification data associated
- *	with non-EVPD INQUIRY command output.
+ *	with non-VPD INQUIRY command output.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -1496,12 +1496,12 @@
 }
 
 /**
- *	ata_scsiop_inq_00 - Simulate INQUIRY EVPD page 0, list of pages
+ *	ata_scsiop_inq_00 - Simulate INQUIRY VPD page 0, list of pages
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
  *	@buflen: Response buffer length.
  *
- *	Returns list of inquiry EVPD pages available.
+ *	Returns list of inquiry VPD pages available.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -1515,7 +1515,7 @@
 		0x80,	/* page 0x80, unit serial no page */
 		0x83	/* page 0x83, device ident page */
 	};
-	rbuf[3] = sizeof(pages);	/* number of supported EVPD pages */
+	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
 
 	if (buflen > 6)
 		memcpy(rbuf + 4, pages, sizeof(pages));
@@ -1524,7 +1524,7 @@
 }
 
 /**
- *	ata_scsiop_inq_80 - Simulate INQUIRY EVPD page 80, device serial number
+ *	ata_scsiop_inq_80 - Simulate INQUIRY VPD page 80, device serial number
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
  *	@buflen: Response buffer length.
@@ -1553,16 +1553,18 @@
 	return 0;
 }
 
-static const char * const inq_83_str = "Linux ATA-SCSI simulator";
-
 /**
- *	ata_scsiop_inq_83 - Simulate INQUIRY EVPD page 83, device identity
+ *	ata_scsiop_inq_83 - Simulate INQUIRY VPD page 83, device identity
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
  *	@buflen: Response buffer length.
  *
  *	Returns device identification.  Currently hardcoded to
  *	return "Linux ATA-SCSI simulator".
+ *	Yields two logical unit device identification designators:
+ *	 - vendor specific ASCII containing the ATA serial number
+ *	 - SAT defined "t10 vendor id based" containing ASCII vendor
+ *	   name ("ATA     "), model and serial numbers.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host_set lock)
@@ -1571,16 +1573,39 @@
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
 

--------------070408070208090400020507--
