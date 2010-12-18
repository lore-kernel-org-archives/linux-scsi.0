From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: set resid to indicate no data-in when medium
 error
Date: Fri, 17 Dec 2010 19:16:06 -0500
Message-ID: <4D0BFD46.3030505@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000700070206000001070808"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41871 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab0LRAQN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 19:16:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

This is a multi-part message in MIME format.
--------------000700070206000001070808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As discussed in a thread on this list titled:
    "RFC: short reads on block devices"
this patch provides additional information associated
with a medium error. And that is that the data-in buffer
contains no valid data.

This patch is against lk 2.6.36

Changelog:
    set resid to the requested data-in length when a
    MEDIUM ERROR is simulated. This implies no valid
    data is returned in the data-in buffer

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------000700070206000001070808
Content-Type: text/x-patch;
 name="sdebug2636resid1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug2636resid1.diff"

--- linux/drivers/scsi/scsi_debug.c	2010-12-03 17:17:54.000000000 -0500
+++ linux/drivers/scsi/scsi_debug.c2636resid1	2010-12-16 00:48:25.000000000 -0500
@@ -1790,6 +1790,7 @@ static int resp_read(struct scsi_cmnd *S
 			devip->sense_buff[5] = (ret >> 8) & 0xff;
 			devip->sense_buff[6] = ret & 0xff;
 		}
+	        scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 		return check_condition_result;
 	}
 

--------------000700070206000001070808--
