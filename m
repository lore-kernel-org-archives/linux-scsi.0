From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] lk 2.6.7-bk6 [Re: noisy reservation conflicts]
Date: Fri, 25 Jun 2004 16:17:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40DBC35C.8000208@torque.net>
References: <40CD3F44.4080004@torque.net> <20040614191832.GA1298@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000300060206080105010202"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:33042 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S266240AbUFYGRj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 02:17:39 -0400
In-Reply-To: <20040614191832.GA1298@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000300060206080105010202
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Mike Anderson wrote:
> Douglas Gilbert [dougg@torque.net] wrote:
> 
>>While testing persistent reservations it is quite common
>>to get a status of "reservation conflict". When using
>>the SG_IO ioctl this status is returned via the
>>sg_io_hdr::status field and is simple to process.
>>
>>However this lk 2.6.7-rc3 code fragment in
>>scsi_decide_disposition() [scsi_error.c] makes it very
>>noisy (on the console and in the log):
>>
>>        case RESERVATION_CONFLICT:
>>                printk("scsi%d (%d,%d,%d) : reservation conflict\n",
>>                       scmd->device->host->host_no,
>>                       scmd->device->channel,
>>                       scmd->device->id, scmd->device->lun);
>>                return SUCCESS; /* causes immediate i/o error */
>>
> 
> 
> If we think it is important enough to leave we should wrap it with
> either a SCSI_LOG_MLCOMPLETE or SCSI_LOG_ERROR_RECOVERY to stay
> consistent with the scsi_decide_disposition function. Though I think the
> use of SCSI_LOG_ERROR_RECOVERY maybe should be replaced with
> SCSI_LOG_MLCOMPLETE in scsi_decide_disposition.
> 
> The upper level drivers could also report similar info if this was
> removed as sd has SCSI_LOG_HLCOMPLETE that should cover sg_io ios
> through sd and sg_cmd_done has SCSI_LOG_TIMEOUT (correct?).

Mike,
Yes the sg driver uses SCSI_LOG_TIMEOUT to avoid other usages
and a logging loop.

Just so this thread isn't forgotten, attached is a patch to
wrap the printk in question in a SCSI_LOG_ERROR_RECOVERY
macro.

Doug Gilbert



--------------000300060206080105010202
Content-Type: text/x-patch;
 name="scsi_error_rconflict.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error_rconflict.diff"

--- linux/drivers/scsi/scsi_error.c	2004-06-25 15:10:49.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c267bk6rc	2004-06-25 16:04:20.161354808 +1000
@@ -1375,9 +1375,10 @@
 		return SUCCESS;
 
 	case RESERVATION_CONFLICT:
-		printk("scsi%d (%d,%d,%d) : reservation conflict\n",
-		       scmd->device->host->host_no, scmd->device->channel,
-		       scmd->device->id, scmd->device->lun);
+		SCSI_LOG_ERROR_RECOVERY(5, printk("scsi%d (%d,%d,%d) : "
+			"reservation conflict\n",
+			scmd->device->host->host_no, scmd->device->channel,
+			scmd->device->id, scmd->device->lun));
 		return SUCCESS; /* causes immediate i/o error */
 	default:
 		return FAILED;

--------------000300060206080105010202--
