From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Fix printing of variable length commands
Date: Mon, 18 Jan 2010 18:03:04 -0500
Message-ID: <yq1aawbt3rr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:32900 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab0ARXEI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2010 18:04:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de


The MAINTENANCE IN array is incorrectly used when decoding variable
length commands.  Use the right array.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 9129bcf..db68e3b 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -219,7 +219,7 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
+		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ, sa);
 		if (name) {
 			printk("%s", name);
 			if ((cdb_len > 0) && (len != cdb_len))
