From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 06/12] scsi_debug: re-order file scope declarations
Date: Tue, 26 Apr 2016 13:55:42 -0700
Message-ID: <571FD5CE.2010706@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-7-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0054.outbound.protection.outlook.com ([157.56.111.54]:1579
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752149AbcDZUzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 16:55:46 -0400
In-Reply-To: <1461600999-28893-7-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> +static unsigned int scsi_debug_lbp(void)
> +{
> +	return ((0 == sdebug_fake_rw) &&
> +		(sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
> +}

Same comment here as for a previous patch: please do not introduce 
superfluous parentheses and please use logical or instead of binary or 
for combining boolean variables.

> @@ -1970,7 +1965,7 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   			(devip->target * 1000) - 3;
>   	/* set DPOFUA bit for disks */
>   	if (0 == sdebug_ptype)
> -		dev_spec = (DEV_READONLY(target) ? 0x80 : 0x0) | 0x10;
> +		dev_spec = 0x10;	/* would be 0x81 if read-only */
>   	else
>   		dev_spec = 0x0;
>   	if (msense_6) {

This change has not been explained in the patch description. Should it 
perhaps be merged into another patch of this series?

Bart.
