From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: [PATCH] scsi_debug: Fix endianess in partition table
Date: Mon, 11 Feb 2013 18:34:54 +0100
Message-ID: <1360604094.24863.1.camel@br8ggx07.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50367 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab3BKRgp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2013 12:36:45 -0500
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Mon, 11 Feb 2013 10:36:44 -0700
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 36C211FF003E
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2013 10:36:38 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r1BHaR4p123962
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2013 10:36:28 -0700
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r1BHaHsI028724
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2013 10:36:18 -0700
Received: from [9.152.224.73] (dyn-9-152-224-73.boeblingen.de.ibm.com [9.152.224.73])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id r1BHZ8Cg025773
	for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2013 10:35:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

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


