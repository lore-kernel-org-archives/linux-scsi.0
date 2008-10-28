From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH v2] SCSI: detect missing data for INQUIRY
Date: Tue, 28 Oct 2008 09:02:27 -0400
Message-ID: <49070D63.6050706@emulex.com>
References: <Pine.LNX.4.44L0.0810271452540.2296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41622 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYJ1NJs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 09:09:48 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810271452540.2296-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, =?ISO-8859-1?Q?=D6rjan_Nordlund?= <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

Checking the payload like this is really hokey - but probably works.
Have we lost all notion from the LLDD on what the actual payload length 
was (calculated by expected transfer length and resid) ?  Seems like a 
much better idea than just checking contents.

-- james s

Alan Stern wrote:
> This patch (as1154b) fixes a problem in scsi_probe_lun(): The function
> doesn't check whether the device has actually sent back any INQUIRY
> data!  The patch adds a test to see if the result buffer is still
> empty after the command has been executed.
> 
> This enables the Thecus N2050 storage device to work.  The firmware on
> that device starts up strangely; it sends no data in response to the
> initial INQUIRY, and it sends the INQUIRY information in response to
> the followup REQUEST SENSE!  But after that it works better, so
> retrying the INQUIRY is enough to get it going.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -602,6 +602,14 @@ static int scsi_probe_lun(struct scsi_de
>                                     (sshdr.ascq == 0))
>                                         continue;
>                         }
> +               } else {
> +                       /*
> +                        * If the first four bytes are all 0 then probably
> +                        * nothing was transferred.  Try again.
> +                        */
> +                       if ((inq_result[0] | inq_result[1] |
> +                                       inq_result[2] | inq_result[3]) == 0)
> +                               continue;
>                 }
>                 break;
>         }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
