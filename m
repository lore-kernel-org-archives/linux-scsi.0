From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: [PATCH RESEND] scsi_debug: Fix endianess in partition table
Date: Thu, 06 Jun 2013 12:56:12 +0200
Message-ID: <1370516172.4392.3.camel@br9vgx5g.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:35758 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FFK4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 06:56:17 -0400
Received: from /spool/local
	by e06smtp17.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Thu, 6 Jun 2013 11:52:42 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6DF652190059
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2013 11:59:27 +0100 (BST)
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r56Au3JV11468824
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jun 2013 10:56:03 GMT
Received: from d06av05.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r56AuDVD024557
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jun 2013 04:56:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

James,
could you pick up this fix, please?

Btw., it looks like others where bitten by this one:
https://nazar.karan.org/blob/distro!
parted.git/8780c767126938173f49dfbcd4360813932f7756/SOURCES!
disable-t9020.patch

Thanks,
Martin





Both start_sect and nr_sects in struct partition are __le32 and
require cpu_to_le32() on assignment.

Without this fix tools like fdisk show an invalid partition table
for SCSI devices emulated by scsi_debug on big-endian architectures,
like s390x. Besides a kernel message like this was emitted:

sda: p1 start 536870912 is beyond EOD, enabling native capacity
sda: p1 start 536870912 is beyond EOD, truncated

For verification 'xxd -l 512 /dev/sda' has been used to make sure
that this fix makes scsi_debug generated partition tables on s390x
look like the ones generated on my laptop.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

---
 drivers/scsi/scsi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2662,8 +2662,8 @@ static void __init sdebug_build_parts(un
 			       / sdebug_sectors_per;
 		pp->end_sector = (end_sec % sdebug_sectors_per) + 1;
 
-		pp->start_sect = start_sec;
-		pp->nr_sects = end_sec - start_sec + 1;
+		pp->start_sect = cpu_to_le32(start_sec);
+		pp->nr_sects = cpu_to_le32(end_sec - start_sec + 1);
 		pp->sys_ind = 0x83;	/* plain Linux partition */
 	}
 }


