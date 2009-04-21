From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
Date: Tue, 21 Apr 2009 13:52:54 -0700
Message-ID: <1240347174.10627.20.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:39923 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZDUUxE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 16:53:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

This is with current git as of this morning, which is at v2.6.30-rc2.

I have a 1.5TB USB device which gets a bit angry when I plug it in.  It
ends up with a scsi_disk->capacity of ffffffffaea87b30.  I tracked it
down to the lba calculation in read_capacity_10():

	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
 		(buffer[2] << 8) | buffer[3];

lba is getting all 0xf's in its high 32 bits.  It seems odd that this
would happen since 'buffer' is an 'unsigned char', but that is
apparently what is going on.  Note that this isn't an issue 32-bit
kernels compiled with CONFIG_LBD=n since there's no more bits into which
the sign could be extended.

The attached one-liner seems to make my system happier.  

Before patch (with a bit of my added debugging):

sd 5:0:0:0: [sdb] read_capacity_10() sector size: 0x200/512 
sd 5:0:0:0: [sdb] capacity (in 512-byte blocks: ffffffffaea87b30
sd 5:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
sd 5:0:0:0: [sdb] Using 0xffffffff as device size sector_size was: 0xffffffea/-22
sd 5:0:0:0: [sdb] 4294967296 512-byte hardware sectors: (2.19 TB/2.00 TiB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 1c 00 00 00
sd 5:0:0:0: [sdb] Assuming drive cache: write through
sd 5:0:0:0: [sdb] read_capacity_10() sector size: 0x200/512 
sd 5:0:0:0: [sdb] capacity (in 512-byte blocks: ffffffffaea87b30
sd 5:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
sd 5:0:0:0: [sdb] Using 0xffffffff as device size sector_size was: 0xffffffea/-22
sd 5:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1 
sd 5:0:0:0: [sdb] Attached SCSI disk 
sd 5:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 5:0:0:0: [sdb] Sense Key : Aborted Command [current] 
sd 5:0:0:0: [sdb] Add. Sense: No additional sense information

after patch:

[ 5257.068646] usb 5-2: new high speed USB device using ehci_hcd and address 9
[ 5257.215421] usb 5-2: configuration #1 chosen from 1 choice
[ 5257.221640] scsi14 : SCSI emulation for USB Mass Storage devices
[ 5257.221937] usb-storage: device found at 9
[ 5257.221939] usb-storage: waiting for device to settle before scanning
[ 5262.225981] usb-storage: device scan complete
[ 5262.227477] scsi 14:0:0:0: Direct-Access     Seagate  FreeAgent        102D PQ: 0 ANSI: 4
[ 5262.227936] sd 14:0:0:0: Attached scsi generic sg3 type 0
[ 5273.458856] sd 14:0:0:0: [sdc] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
[ 5273.460121] sd 14:0:0:0: [sdc] Write Protect is off
[ 5273.460126] sd 14:0:0:0: [sdc] Mode Sense: 1c 00 00 00
[ 5273.460130] sd 14:0:0:0: [sdc] Assuming drive cache: write through
[ 5273.475750] sd 14:0:0:0: [sdc] Assuming drive cache: write through
[ 5273.488125]  sdc: sdc1
[ 5273.541147] sd 14:0:0:0: [sdc] Attached SCSI disk


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..db60e96 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1402,7 +1402,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
 			(buffer[6] << 8) | buffer[7];
-	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
+	lba =	((sector_t)buffer[0] << 24) | (buffer[1] << 16) |
 		(buffer[2] << 8) | buffer[3];
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {


-- Dave

