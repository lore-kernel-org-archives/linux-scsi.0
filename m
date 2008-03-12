From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [RFC] aacraid: Un-remove aacraid devices
Date: Wed, 12 Mar 2008 13:46:11 -0400
Message-ID: <82A96232-B2A8-46D2-ADD9-7E9E6FCF06CC@adaptec.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:54405 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbYCLRqO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Mar 2008 13:46:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, dann frazier <dannf@debian.org>, Stefanos Harhalakis <v13@priest.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

As reported in:

http://marc.info/?l=linux-kernel&m=116784142115175&w=2
http://www.ussg.iu.edu/hypermail/linux/kernel/0602.2/1180.html
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=404927
http://marc.info/?l=linux-scsi&m=117992467131188&w=2

There is a general issue with RAID devices which support on-line array  
management, or firmware/driver RLM and OCE that set the removable bit  
in order to support this functionality. Basically the need to refresh  
the device capacity and/or update partition information when re- 
opened. RAID only needs a subset of this 'removable' functionality, so  
we added a sd bit check_disk_change_on_open.

This being an internals fix, of course, does not solve the problem for  
external RAID devices, which must continue to report 'removable' in  
order to permit this functionality.

We have not unit or compile-tested this patch, as it is an RFC as I  
have too many questions still. Hannes, Dann et.al. is this going to  
give you what you need? It would have been nice to set the bit in  
aac_slave_configure but scsi_disk is not allocated yet ... or should  
we move the bit up one structure into scsi_device?

This attached patch is against current scsi-misc-2.6

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  drivers/scsi/aacraid/aachba.c |   14 ++++++++++++--
  drivers/scsi/sd.c             |    3 ++-
  include/scsi/sd.h             |    1 +
  3 files changed, 15 insertions(+), 3 deletions(-)

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	2008-03-04 16:00:55.000000000 -0500
+++ b/drivers/scsi/aacraid/aachba.c	2008-03-12 11:19:40.749259342 -0400
@@ -39,6 +39,7 @@
  #include <scsi/scsi_cmnd.h>
  #include <scsi/scsi_device.h>
  #include <scsi/scsi_host.h>
+#include <scsi/sd.h>

  #include "aacraid.h"

@@ -2048,6 +2049,7 @@
  		u64 capacity;
  		char cp[13];
  		unsigned int alloc_len;
+		struct scsi_disk *sdkp;

  		dprintk((KERN_DEBUG "READ CAPACITY_16 command.\n"));
  		capacity = fsa_dev_ptr[cid].size - 1;
@@ -2077,7 +2079,11 @@
  				       scsi_bufflen(scsicmd) - alloc_len);

  		/* Do not cache partition table for arrays */
-		scsicmd->device->removable = 1;
+		sdkp = scsi_disk_get(scsicmd->request->rq_disk);
+		if (sdkp) {
+			sdkp->check_disk_change_on_open = 1;
+			scsi_disk_put(sdkp);
+		}

  		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |  
SAM_STAT_GOOD;
  		scsicmd->scsi_done(scsicmd);
@@ -2106,7 +2112,11 @@
  		cp[7] = 0;
  		aac_internal_transfer(scsicmd, cp, 0, sizeof(cp));
  		/* Do not cache partition table for arrays */
-		scsicmd->device->removable = 1;
+		sdkp = scsi_disk_get(scsicmd->request->rq_disk;
+		if (sdkp) {
+			sdkp->check_disk_change_on_open = 1;
+			scsi_disk_put(sdkp);
+		}

  		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |  
SAM_STAT_GOOD;
  		scsicmd->scsi_done(scsicmd);
diff -ru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	2008-02-28 13:30:37.000000000 -0500
+++ b/drivers/scsi/sd.c	2008-03-12 11:05:15.896781864 -0400
@@ -576,7 +576,8 @@
  	if (!scsi_block_when_processing_errors(sdev))
  		goto error_out;

-	if (sdev->removable || sdkp->write_prot)
+	if (sdev->removable || sdkp->write_prot ||
+	    sdkp->check_disk_change_on_open)
  		check_disk_change(inode->i_bdev);

  	/*
diff -ru a/include/scsi/sd.h b/include/scsi/sd.h
--- a/include/scsi/sd.h	2008-02-06 09:17:44.000000000 -0500
+++ b/include/scsi/sd.h	2008-03-12 11:04:31.858415229 -0400
@@ -45,6 +45,7 @@
  	unsigned	WCE : 1;	/* state of disk WCE bit */
  	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
  	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+	unsigned	check_disk_change_on_open : 1;
  };
  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)


Sincerely -- Mark Salyzyn
