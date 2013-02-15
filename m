From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: [PATCH] scsi_debug: Fix endianess in partition table
Date: Fri, 15 Feb 2013 13:30:06 +0100
Message-ID: <1360931406.4146.4.camel@br8ggx07.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52722 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985Ab3BOMaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 07:30:11 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Fri, 15 Feb 2013 07:30:11 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id C6E9138C801B
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2013 07:30:08 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1FCU8xr300404
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2013 07:30:08 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1FCU8h8013015
	for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2013 10:30:08 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
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


