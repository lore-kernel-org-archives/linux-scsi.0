From: Brett Russ <bruss@netezza.com>
Subject: Re: [PATCH] scsi: improve description for deferred error
Date: Tue, 28 Dec 2010 16:45:52 -0500
Message-ID: <ifdlqg$dnm$1@dough.gmane.org>
References: <4C739DE9.5070803@ct.jp.nec.com> <4C73FA8F.5080800@kernel.org> <4C74CD95.1000208@ct.jp.nec.com> <20100825152831.GA8509@redhat.com> <4C7789BE.1060609@ct.jp.nec.com> <20100827134940.GA22504@redhat.com> <4C7B4C23.8020100@ct.jp.nec.com> <20100901005537.GA21466@redhat.com> <4C7E0184.9030502@suse.de> <4C7E02F0.2020701@suse.de> <20101208211425.GA21249@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55211 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0L1VuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2010 16:50:05 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1PXhQh-0003JP-RF
	for linux-scsi@vger.kernel.org; Tue, 28 Dec 2010 22:50:03 +0100
Received: from 68-187-222-30.dhcp.oxfr.ma.charter.com ([68.187.222.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2010 22:50:03 +0100
Received: from bruss by 68-187-222-30.dhcp.oxfr.ma.charter.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 28 Dec 2010 22:50:03 +0100
In-Reply-To: <20101208211425.GA21249@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 12/8/2010 16:14, Mike Snitzer wrote:
> From: Hannes Reinecke<hare@suse.de>
>
> Properly describe a "deferred error" as such in scsi_io_completion.
> The deferred error (and the associated sense) will have nothing to do
> with the victim scsi command that is also printed.  The victim command
> shall not have been processed and shall be retried.

I'm curious if the command will ever reach this level of code 
(scsi_io_completion()) unless you happened to take the deferred error 
(DE) on the very last retry of the command?  Not to say this patch isn't 
a good one, just that we need more.

It seems like scsi_check_sense() will see the DE first, drop it on the 
floor, and order a retry of the victim command.  Unless there are more 
DEs, won't that be the last we see of the first DE?

But, I'm pretty new to this area, so I could be wrong.  Simulating it 
with scsi_debug seems to show the behavior I noted above.

-BR

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index eafeeda..0aa0d68 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -889,7 +889,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>   			break;
>   		}
>   	} else {
> -		description = "Unhandled error code";
> +		if (sense_deferred)
> +			description = "Deferred error";
> +		else
> +			description = "Unhandled error code";
>   		action = ACTION_FAIL;
>   	}

