From: "Martin K. Petersen" <martin.petersen@ORACLE.COM>
Subject: Re: [PATCH] scsi: Fix printing of variable length commands
Date: Wed, 20 Jan 2010 02:17:40 -0500
Message-ID: <yq1wrzdkzxn.fsf@sermon.lab.mkp.net>
References: <yq1aawbt3rr.fsf@sermon.lab.mkp.net> <4B558030.90006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:54222 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0ATHSQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 02:18:16 -0500
In-Reply-To: <4B558030.90006@panasas.com> (Boaz Harrosh's message of "Tue, 19
	Jan 2010 11:49:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> If you are already at it could you also add the things that
Boaz> bothered me? I did stare at this function before, but did not see
Boaz> the bug you are fixing, thanks.  (Did see other less important
Boaz> stuff)

I'm ok with cleaning up the redundant statements even though it's a bit
of churn in what's otherwise a pure bug fix patch.  Simply on the
grounds that it's silly code.


> - sa = (cdbp[8] << 8) + cdbp[9];
> + sa = be16_to_cpu(((struct scsi_varlen_cdb_hdr *)cdbp)->service_action);

Here, however, I find the original code far superior.  I know what
you're doing and why but I find the old code a bazillion times easier to
read.  Short and to the point.  No complex typecasts and I don't have to
go hunting for varlen_cdb_hdr struct definitions.  I dive straight into
SBC and see that bytes 8 and 9 in the CDB constitute the service action.
Done!

I know that the header looks the same for all variable length commands.
But we don't have a struct scsi_cdb_header with an "operation code"
entry pointing to cmnd[0] either.  Nor do we have headers for the
MAINTENANCE and SERVICE ACTION commands.  To me a CDB is a byte stream
and not a bunch of structs.

Anyway.  I know where you stand on this :)


scsi: Fix printing of variable length commands

We dereferenced the MAINTENANCE IN array when decoding variable length
commands.  Use the right array.  Also consolidate identical if
statements below.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 9129bcf..7092ff6 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -219,18 +219,15 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 			break;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
-		if (name) {
+		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ, sa);
+		if (name)
 			printk("%s", name);
-			if ((cdb_len > 0) && (len != cdb_len))
-				printk(", in_cdb_len=%d, ext_len=%d",
-				       len, cdb_len);
-		} else {
+		else
 			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-			if ((cdb_len > 0) && (len != cdb_len))
-				printk(", in_cdb_len=%d, ext_len=%d",
-				       len, cdb_len);
-		}
+
+		if ((cdb_len > 0) && (len != cdb_len))
+			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
+
 		break;
 	case MAINTENANCE_IN:
 		sa = cdbp[1] & 0x1f;

