From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] scsi_mid_low_api.txt recommend resid usage
Date: Fri, 24 Dec 2010 09:46:12 -0800
Message-ID: <20101224094612.8056bbcd.rdunlap@xenotime.net>
References: <4D140825.6000704@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:32884 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751701Ab0LXRqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 12:46:17 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 24 Dec 2010 09:46:13 -0800
In-Reply-To: <4D140825.6000704@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, 23 Dec 2010 21:40:37 -0500 Douglas Gilbert wrote:

> As discussed in a thread on this list titled:
>     "RFC: short reads on block devices"
> this patch adds recommendations for LLDs to set resid
> when there might be uncertainty about how much data
> has been returned by a device.
> 
> This patch inline and attached] is against scsi-misc-2.6.git
> 
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> 
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt 
> b/Documentation/scsi/scsi_mid_low_api.txt
> index df322c1..7bcdea7 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt

> @@ -1351,6 +1351,18 @@ Members of interest:
>                      report a DID_ERROR. Better for an LLD to implement
>                      'resid'.
> 
> +It is recommended that a LLD set 'resid' on data transfers from a SCSI
> +target device (e.g. READs). It is especially important that 'resid' is set
> +when such data transfers have sense keys of MEDIUM ERROR and HARDWARE ERROR
> +(and possibly RECOVERED ERROR). In these cases if a LLD is in doubt how much
> +data has been received then the safest approach is to indicate no bytes have
> +been received. For example: to indicate that no valid data has been received
> +a LLD might use these helpers:
> +    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
> +where 'SCpnt' is a pointer to a scsi_cmnd object. To indicate only three 512
> +bytes blocks has been received 'resid' could be set like this:
> +    scsi_set_resid(SCpnt, scsi_bufflen(SCpnt) - (3 * 512));
> +
>   The scsi_cmnd structure is defined in include/scsi/scsi_cmnd.h


Hi Doug,

Using "an LLD" instead of "a LLD" would be more consistent with the rest
of this txt file (and read better to me).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
