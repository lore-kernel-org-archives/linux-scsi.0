From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] Set correct completion code in scsi_send_eh_cmnd()
Date: Thu, 15 May 2014 06:29:27 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F14942@G4W3202.americas.hpqcorp.net>
References: <1399529396-52685-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:39960 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOGbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2014 02:31:17 -0400
In-Reply-To: <1399529396-52685-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Stephen Cameron <scameron@beardog.cce.hp.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Thursday, May 08, 2014 1:10 AM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Hannes Reinecke; Stephen Cameron
> Subject: [PATCH] Set correct completion code in scsi_send_eh_cmnd()
> 
> ->queuecommand returns '0' for successful command submission,
> so we need to set the correct SCSI midlayer return value
> when calling scsi_log_completion().
> 
> Reported-by: Robert Elliott <elliott@hp.com>
> Cc: Stephen Cameron <scameron@beardog.cce.hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f17aa7a..f4e0cad 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1029,6 +1029,7 @@ retry:
>  		rtn = NEEDS_RETRY;
>  	} else {
>  		timeleft = wait_for_completion_timeout(&done, timeout);
> +		rtn = SUCCESS;
>  	}
> 
>  	shost->eh_action = NULL;
> --
> 1.7.12.4

I've confirmed that patch successfully gets rid of bogus reporting 
of "UNKNOWN" for successfully submitted commands from that 
function, correcting the use of "internal return values" vs.
"midlayer return values."

 [ 5454.381659] sd 2:0:0:1: [sds] scsi_eh_2: requesting sense
[ 5454.383597] scsi_eh_done scmd: ffff880428963a70 result: 0
[ 5454.385457] sd 2:0:0:1: [sds] Done: UNKNOWN
[ 5454.387430] sd 2:0:0:1: [sds] Result: hostbyte=DID_OK driverbyte=DRIVER_OK

Tested-by: Robert Elliott <elliott@hp.com>


