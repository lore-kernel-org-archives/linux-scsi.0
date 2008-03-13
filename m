From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 9/9] mptfc: convert mptfc to use fc queueing helper.
Date: Thu, 13 Mar 2008 13:53:07 -0500
Message-ID: <47D97813.5040505@sgi.com>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-7-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-8-git-send-email-michaelc@cs.wisc.edu> <1204448602-5435-9-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:45214 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754033AbYCMSxN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 14:53:13 -0400
In-Reply-To: <1204448602-5435-9-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com



michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> Convert mptfc to use fc queueing helper.

I've been trying to exercise the fusion FC change.
I can't seem to force the code into returning either
TARGET_BUSY or DID_NO_CONNECT.  Any suggestions on
how I might get a command down to the driver while
the rport is blocked or in DEVLOSS_PENDING?

I've been running 32 outstanding commands to 16 targets,
disabling/enabling the various FC switch ports, AND
I disabled the usage of the scsi_host_lock in
fc_remote_port_delete() and I unlock/relock it in the
mptfc_qmnd() function.

Thanks,
 Mike

> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/message/fusion/mptfc.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index 3cdd4e9..1189bbe 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -656,9 +656,10 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
>  		return 0;
>  	}
>  
> -	err = fc_remote_port_chkready(rport);
> -	if (unlikely(err)) {
> -		SCpnt->result = err;
> +	err = fc_remote_port_queue_ready(rport, SCpnt);
> +	if (err)
> +		return err;
> +	if (SCpnt->result) {
>  		done(SCpnt);
>  		return 0;
>  	}
