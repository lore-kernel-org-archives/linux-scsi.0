From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Sun, 01 Apr 2007 11:36:18 -0500
Message-ID: <1175445379.27675.3.camel@mulgrave.il.steeleye.com>
References: <11751999513070-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50323 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933635AbXDAQgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Apr 2007 12:36:22 -0400
In-Reply-To: <11751999513070-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com

On Thu, 2007-03-29 at 15:25 -0500, Brian King wrote:
> -		int rtn;
> +		int retry_cnt = 1, rtn;
>  
> +retry_stu:
>  		rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
>  					START_UNIT_TIMEOUT, 0);
> -		if (rtn == SUCCESS)
> +
> +		switch (rtn) {
> +		case SUCCESS:
>  			return 0;
> +		case NEEDS_RETRY:
> +			if (retry_cnt--)
> +				goto retry_stu;
> +			/*FALLTHRU*/
> +		default:
> +			return 1;
> +		}

This is pretty much an open coded for loop ... how about just doing a
for loop as attached below?

The two advantages to this are:

     1. it's cleaner and more readable
     2. the compiler knows how to optimize it better

James

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7a1a1bb..28a266c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -932,10 +932,12 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
 
 	if (scmd->device->allow_restart) {
-		int rtn;
+		int i, rtn = NEEDS_RETRY;
+
+		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
+			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
+						START_UNIT_TIMEOUT, 0);
 
-		rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
-					START_UNIT_TIMEOUT, 0);
 		if (rtn == SUCCESS)
 			return 0;
 	}


