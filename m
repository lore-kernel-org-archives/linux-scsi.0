From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] reorder call in scsi_remove_host
Date: Mon, 16 Aug 2004 13:18:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816201835.GA2179@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:48382 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S267935AbUHPUSy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 16:18:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@suse.de>

This patch against scsi-misc-2.6 reorders a call to scsi_forget_host in
the scsi_remove_host function. This removes the error message
"Synchronizing SCSI cache..." on rmmod of a scsi host driver module as
shown in example output 1 and 2 below.

I had previous created a much more complicated patch to work around this
problem. In response Christoph mention a simpler solution (pointer to
thread below) which is this patch.

http://marc.theaimsgroup.com/?l=linux-scsi&m=108720042210331&w=2

Example output.

1.) Before patch.

elm:~# scsi1 : scsi_debug, version 1.73 [20040518], dev_size_mb=8,
opts=0x0
  Vendor: Linux     Model: scsi_debug        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc: unknown partition table
Attached scsi disk sdc at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg4 at scsi1, channel 0, id 0, lun 0,  type 0
Synchronizing SCSI cache for disk sdc: <4>FAILED
  status = 0, message = 00, host = 1, driver = 00

2.) After patch.

elm:~# scsi1 : scsi_debug, version 1.73 [20040518], dev_size_mb=8, opts=0x0
  Vendor: Linux     Model: scsi_debug        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc: unknown partition table
Attached scsi disk sdc at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg4 at scsi1, channel 0, id 0, lun 0,  type 0
Synchronizing SCSI cache for disk sdc:

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Reorder call to scsi_forget_host in scsi_remove_host function.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
EDESC


 patched-scsi-misc-2.6-andmike/drivers/scsi/hosts.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/hosts.c~scsi_forget_host drivers/scsi/hosts.c
--- patched-scsi-misc-2.6/drivers/scsi/hosts.c~scsi_forget_host	Wed Aug 11 17:33:46 2004
+++ patched-scsi-misc-2.6-andmike/drivers/scsi/hosts.c	Wed Aug 11 17:35:07 2004
@@ -75,9 +75,9 @@ void scsi_host_cancel(struct Scsi_Host *
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	scsi_forget_host(shost);
 	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
-	scsi_forget_host(shost);
 
 	set_bit(SHOST_DEL, &shost->shost_state);
 
