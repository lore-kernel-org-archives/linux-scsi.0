From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] 2.5.72: set data direction to SCSI_DATA_NONE for START_STOP command
Date: Tue, 17 Jun 2003 09:45:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200306170945.02663.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-3.de.ibm.com ([194.196.100.236]:53383 "EHLO
	d12lmsgate-3.de.ibm.com") by vger.kernel.org with ESMTP
	id S264619AbTFQHhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2003 03:37:47 -0400
Received: from d12relay01.megacenter.de.ibm.com (d12relay01.megacenter.de.ibm.com [9.149.165.180])
	by d12lmsgate-3.de.ibm.com (8.12.9/8.12.8) with ESMTP id h5H7pYsn080600
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2003 09:51:38 +0200
Received: from osiris (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay01.megacenter.de.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h5H7pVos059682
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2003 09:51:31 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

while trying to access a disk drive via an FCP bridge we got an FCP_RSP IU
with the RSP_CODE field set to "FCP_CMND Fields Invalid". This happened
after sending a START_STOP command to the device. Reason for this was that
the FCP_CMND IU incorrectly had the RDDATA field set to one, because of a
bug in sd_spinup_disk(). There the data direction for START_STOP is set
to SCSI_DATA_READ instead of SCSI_DATA_NONE.
Please apply the patch below.

Thanks,
Heiko

diff -urN linux-2.5.72/drivers/scsi/sd.c linux-2.5.72-start/drivers/scsi/sd.c
--- linux-2.5.72/drivers/scsi/sd.c	Tue Jun 17 06:20:19 2003
+++ linux-2.5.72-start/drivers/scsi/sd.c	Tue Jun 17 09:17:15 2003
@@ -856,7 +856,7 @@
 				SRpnt->sr_sense_buffer[0] = 0;
 				SRpnt->sr_sense_buffer[2] = 0;
 
-				SRpnt->sr_data_direction = SCSI_DATA_READ;
+				SRpnt->sr_data_direction = SCSI_DATA_NONE;
 				scsi_wait_req(SRpnt, (void *)cmd, 
 					      (void *) buffer, 0/*512*/, 
 					      SD_TIMEOUT, SD_MAX_RETRIES);

