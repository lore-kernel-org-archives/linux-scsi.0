From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] scsi: fix qla1280 printk format warnings
Date: Wed, 16 Jul 2008 11:50:54 -0700
Message-ID: <20080716115054.f13e9ae6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39709 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbYGPS6B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 14:58:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, dwmw2 <dwmw2@infradead.org>
Cc: scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings (firmware-related):

linux-next-20080716/drivers/scsi/qla1280.c:1654: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
linux-next-20080716/drivers/scsi/qla1280.c:1713: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/qla1280.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20080716.orig/drivers/scsi/qla1280.c
+++ linux-next-20080716/drivers/scsi/qla1280.c
@@ -1650,7 +1650,7 @@ qla1280_load_firmware_pio(struct scsi_ql
 		return err;
 	}
 	if ((fw->size % 2) || (fw->size < 6)) {
-		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, ql1280_board_tbl[ha->devnum].fwname);
 		err = -EINVAL;
 		goto out;
@@ -1709,7 +1709,7 @@ qla1280_load_firmware_dma(struct scsi_ql
 		return err;
 	}
 	if ((fw->size % 2) || (fw->size < 6)) {
-		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, ql1280_board_tbl[ha->devnum].fwname);
 		err = -EINVAL;
 		goto out;


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
