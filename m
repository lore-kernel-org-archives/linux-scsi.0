From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: noisy reservation conflicts
Date: Mon, 14 Jun 2004 12:18:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614191832.GA1298@us.ibm.com>
References: <40CD3F44.4080004@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:6624 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263799AbUFNTTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 15:19:24 -0400
Content-Disposition: inline
In-Reply-To: <40CD3F44.4080004@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> While testing persistent reservations it is quite common
> to get a status of "reservation conflict". When using
> the SG_IO ioctl this status is returned via the
> sg_io_hdr::status field and is simple to process.
> 
> However this lk 2.6.7-rc3 code fragment in
> scsi_decide_disposition() [scsi_error.c] makes it very
> noisy (on the console and in the log):
> 
>         case RESERVATION_CONFLICT:
>                 printk("scsi%d (%d,%d,%d) : reservation conflict\n",
>                        scmd->device->host->host_no,
>                        scmd->device->channel,
>                        scmd->device->id, scmd->device->lun);
>                 return SUCCESS; /* causes immediate i/o error */
> 

If we think it is important enough to leave we should wrap it with
either a SCSI_LOG_MLCOMPLETE or SCSI_LOG_ERROR_RECOVERY to stay
consistent with the scsi_decide_disposition function. Though I think the
use of SCSI_LOG_ERROR_RECOVERY maybe should be replaced with
SCSI_LOG_MLCOMPLETE in scsi_decide_disposition.

The upper level drivers could also report similar info if this was
removed as sd has SCSI_LOG_HLCOMPLETE that should cover sg_io ios
through sd and sg_cmd_done has SCSI_LOG_TIMEOUT (correct?).

-andmike
--
Michael Anderson
andmike@us.ibm.com

