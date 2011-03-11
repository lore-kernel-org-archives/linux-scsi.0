From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: consecutive medium errors
Date: Fri, 11 Mar 2011 10:43:35 -0500
Message-ID: <4D7A4327.3050404@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010400090002090701070902"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46282 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550Ab1CKPnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 10:43:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@ORACLE.COM>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

This is a multi-part message in MIME format.
--------------010400090002090701070902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A useful test case for error recovery is multiple,
consecutive medium errors. When scsi_debug is started
with "opts=2" a MEDIUM ERROR is generated when block
0x1234 (4660) is read. The patch extends that to
10 consecutive blocks from 0x1234 (i.e. blocks 4660 to
4669 inclusive).

# lsscsi -gs
[0:0:0:0]  disk  ATA    INTEL SSD  2CV1 /dev/sda /dev/sg0 80.0GB
[10:0:0:0] disk  Linux  scsi_debug 0004 /dev/sdb /dev/sg1 1.09TB

# ddpt if=/dev/sg1 iflag=coe bs=512 count=4680
Output file not specified so no copy, just reading input
 >> unrecovered read error at blk=4660, substitute zeros
...
 >> unrecovered read error at blk=4669, substitute zeros
4670+10 records in
0+0 records out
10 unrecovered read errors
lowest unrecovered read lba=4660, highest unrecovered lba=4669
time to read data: 0.047943 secs at 49.87 MB/sec

BTW Change /dev/sg1 (bsg device works just as well) to
/dev/sdb to see why, with faulty media, you do not want
to use the block layer interface. Reason: time block
layer takes to do useless retries and collateral damage
to data in its 4 KB blocks (O_DIRECT mitigates the
latter).

This patch applies to lk 2.6.37 and also applies
to lk 2.6.38-rc8 including with Martin Petersen's
recent patch.

ChangeLog:
    - extend opts=2 medium error generation at block
      0x1234 to 10 consecutive blocks (i.e. blocks
      0x1234 to 0x123d).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------010400090002090701070902
Content-Type: text/x-patch;
 name="sdebug2637mederr1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug2637mederr1.patch"

--- linux/drivers/scsi/scsi_debug.c	2011-01-05 09:36:01.496918857 -0500
+++ linux/drivers/scsi/scsi_debug.c2637mederr	2011-01-15 21:46:20.717085001 -0500
@@ -144,6 +144,7 @@ static const char * scsi_debug_version_d
 /* when 1==SCSI_DEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
 #define OPT_MEDIUM_ERR_ADDR   0x1234 /* that's sector 4660 in decimal */
+#define OPT_MEDIUM_ERR_NUM    10     /* number of consecutive medium errs */
 
 /* If REPORT LUNS has luns >= 256 it can choose "flat space" (value 1)
  * or "peripheral device" addressing (value 0) */
@@ -1791,15 +1792,15 @@ static int resp_read(struct scsi_cmnd *S
 		return ret;
 
 	if ((SCSI_DEBUG_OPT_MEDIUM_ERR & scsi_debug_opts) &&
-	    (lba <= OPT_MEDIUM_ERR_ADDR) &&
+	    (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
 	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
 		/* claim unrecoverable read error */
-		mk_sense_buffer(devip, MEDIUM_ERROR, UNRECOVERED_READ_ERR,
-				0);
+		mk_sense_buffer(devip, MEDIUM_ERROR, UNRECOVERED_READ_ERR, 0);
 		/* set info field and valid bit for fixed descriptor */
 		if (0x70 == (devip->sense_buff[0] & 0x7f)) {
 			devip->sense_buff[0] |= 0x80;	/* Valid bit */
-			ret = OPT_MEDIUM_ERR_ADDR;
+			ret = (lba < OPT_MEDIUM_ERR_ADDR) 
+			      ? OPT_MEDIUM_ERR_ADDR : (int)lba;
 			devip->sense_buff[3] = (ret >> 24) & 0xff;
 			devip->sense_buff[4] = (ret >> 16) & 0xff;
 			devip->sense_buff[5] = (ret >> 8) & 0xff;

--------------010400090002090701070902--
