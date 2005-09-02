From: Neil Brown <neilb@suse.de>
Subject: Possible deadlock in scsi_lib.c
Date: Fri, 2 Sep 2005 13:13:54 +1000
Message-ID: <17175.50034.697065.553704@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:29389 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030661AbVIBDOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 23:14:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


Hi,
  If a filesystem, while writing out data, decides that it is good
to issue a cache flush on a SCSI drive (or other 'sd' device), it will
call blkdev_issue_flush which calls ->issue_flush_fn which is
scsi_issue_flush_fn. 
This calls sd_issue_flush which calls sd_sync_cache, which calls
scsi_execute_request.
This will (as sshdr != NULL) call
    kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL)

If memory is tight, the presence of GFP_KERNEL may cause write
requests to be sent to some filesystem to free up memory, however if
that filesystem is waiting for the issue_flush_fn to complete, you
could get a deadlock.

I wonder if it might be more appropriate to use GFP_NOIO as in the
following patch.

I wonder if it might be even more appropriate to cope better with a
kmalloc failure, especially as in this use, sd_sync_cache only will
use the sense information to print out a more informative error
message.

Note that I'm not certain that this deadlock is actually happening,
and it is in a filesystem that is not in mainline kernel (few mainline
filesystems use issue_flush_fn).  However I think it may still be a
real bug.

Thanks for your time,

NeilBrown

--

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/scsi/scsi_lib.c~current~ ./drivers/scsi/scsi_lib.c
--- ./drivers/scsi/scsi_lib.c~current~	2005-09-02 13:01:53.000000000 +1000
+++ ./drivers/scsi/scsi_lib.c	2005-09-02 13:02:00.000000000 +1000
@@ -339,7 +339,7 @@ int scsi_execute_req(struct scsi_device 
 	int result;
 	
 	if (sshdr) {
-		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+		sense = kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
 		if (!sense)
 			return DRIVER_ERROR << 24;
 		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
