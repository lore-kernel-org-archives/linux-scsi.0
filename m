From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Deferred disk spinup during system resume
Date: Fri, 7 Jan 2011 14:06:44 -0500
Message-ID: <20110107190644.GB7355@mtj.dyndns.org>
References: <1294363626-28901-1-git-send-email-maksim.rayskiy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45223 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab1AGTGs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 14:06:48 -0500
Received: by vws16 with SMTP id 16so7244428vws.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jan 2011 11:06:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1294363626-28901-1-git-send-email-maksim.rayskiy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: maksim.rayskiy@gmail.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com

Hello,

On Thu, Jan 06, 2011 at 05:27:06PM -0800, maksim.rayskiy@gmail.com wrote:
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 7f77c67..0a9d400 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -4978,6 +4978,14 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>  	struct ata_link *link = qc->dev->link;
>  	u8 prot = qc->tf.protocol;
>  
> +	if (unlikely(link->eh_info.dev_action[qc->dev->devno] &
> +			ATA_EH_VERIFY)) {
> +		ata_port_schedule_eh(ap);
> +		qc->scsidone(qc->scsicmd);
> +		ata_qc_free(qc);
> +		return;

Hmm... this is weird.  You'll probably want to define a qc flag to
indicate that the command is for verify and then schedule EH from
ata_qc_issue().  That said, I'm not quite sure whether that's any
better than scheduling EH from libata-scsi.  It's not like the
boundary is clearly defined.  We already play with EH for other stuff
from libata-scsi.  Jeff, do you think going through QCFLAG is
important?

Thanks.

-- 
tejun
