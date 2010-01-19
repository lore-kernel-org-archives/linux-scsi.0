From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: Fix printing of variable length commands
Date: Tue, 19 Jan 2010 11:49:36 +0200
Message-ID: <4B558030.90006@panasas.com>
References: <yq1aawbt3rr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:48959 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755448Ab0ASJtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2010 04:49:39 -0500
In-Reply-To: <yq1aawbt3rr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 01/19/2010 01:03 AM, Martin K. Petersen wrote:
> 
> The MAINTENANCE IN array is incorrectly used when decoding variable
> length commands.  Use the right array.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 9129bcf..db68e3b 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -219,7 +219,7 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
>  			break;
>  		}
>  		sa = (cdbp[8] << 8) + cdbp[9];
> -		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
> +		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ, sa);
>  		if (name) {
>  			printk("%s", name);
>  			if ((cdb_len > 0) && (len != cdb_len))
> --

If you are already at it could you also add the things that bothered me? I did stare
at this function before, but did not see the bug you are fixing, thanks.
(Did see other less important stuff)

(Below also includes your change)
---
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 9129bcf..6c3c31e 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -218,19 +218,16 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 			       "len=%d ext_len=%d", len, cdb_len);
 			break;
 		}
-		sa = (cdbp[8] << 8) + cdbp[9];
-		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
+		sa = be16_to_cpu(
+			((struct scsi_varlen_cdb_hdr *)cdbp)->service_action);
+		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ, sa);
 		if (name) {
 			printk("%s", name);
-			if ((cdb_len > 0) && (len != cdb_len))
-				printk(", in_cdb_len=%d, ext_len=%d",
-				       len, cdb_len);
 		} else {
 			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-			if ((cdb_len > 0) && (len != cdb_len))
-				printk(", in_cdb_len=%d, ext_len=%d",
-				       len, cdb_len);
 		}
+		if ((cdb_len > 0) && (len != cdb_len))
+			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
 		break;
 	case MAINTENANCE_IN:
 		sa = cdbp[1] & 0x1f;
