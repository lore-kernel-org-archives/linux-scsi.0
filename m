From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 01/12] scsi_debug: cleanup naming and bit crunching
Date: Tue, 26 Apr 2016 11:13:38 -0700
Message-ID: <571FAFD2.3030902@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-2-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0087.outbound.protection.outlook.com ([207.46.100.87]:60000
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752216AbcDZSNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 14:13:43 -0400
In-Reply-To: <1461600999-28893-2-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> @@ -580,8 +580,8 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
>
>   static unsigned int scsi_debug_lbp(void)
>   {
> -	return ((0 == scsi_debug_fake_rw) &&
> -		(scsi_debug_lbpu | scsi_debug_lbpws | scsi_debug_lbpws10));
> +	return ((0 == sdebug_fake_rw) &&
> +		(sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
>   }

Since you are changing this code, please remove the superfluous 
parentheses, place the constant at the right side of the comparison and 
change "|" into "||" since the intention of the above code is to perform 
a logical or and this code is not in a performance-critical path.

> +	sdebug_verbose = !!(SDEBUG_OPT_NOISE & sdebug_opts);
> +	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts);

Same comment here: please put constants at the right side. I think the 
latest version of checkpatch requests to do so.

Bart.
