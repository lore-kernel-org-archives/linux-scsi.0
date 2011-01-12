From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC/PATCH] Deferred disk spinup during system resume
Date: Wed, 12 Jan 2011 12:21:42 +0100
Message-ID: <20110112112142.GA9610@mtj.dyndns.org>
References: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47199 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1ALLVq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jan 2011 06:21:46 -0500
Received: by fxm20 with SMTP id 20so421001fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2011 03:21:45 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1294795457-9006-1-git-send-email-maksim.rayskiy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: maksim.rayskiy@gmail.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com

Hello, Maksim, Jeff.

On Tue, Jan 11, 2011 at 05:24:17PM -0800, maksim.rayskiy@gmail.com wrote:
> @@ -4978,6 +4978,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
>  	struct ata_link *link = qc->dev->link;
>  	u8 prot = qc->tf.protocol;
>  
> +	if (unlikely(qc->flags & ATA_QCFLAG_VERIFY)) {
> +		ata_port_schedule_eh(ap);
> +		qc->scsidone(qc->scsicmd);
> +		ata_qc_free(qc);
> +		return;

I still prefer the original patch where EH is scheduled from the
translation layer.  This seems unnecessarily intrusive to me.  As I
wrote before, it's not like we have a clean translation anyway and I
think this better fits as impedance matching code in the translation
layer anyway.  But, that said, this is a rather ugly piece of code
which is necessary just to work around the fact that we live under
scsi, so as long as it works, one way or the other probably doesn't
matter all that much (the reason why I prefer the previous one, as it
doens't try to be pretty and just gets it done), so it's Jeff's call.

Thanks.

-- 
tejun
