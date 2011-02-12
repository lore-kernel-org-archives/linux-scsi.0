From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH
 commands
Date: Sat, 12 Feb 2011 10:30:06 -0600
Message-ID: <1297528206.3026.7.camel@mulgrave.site>
References: <1295597274-5844-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab1BLQaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Feb 2011 11:30:12 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 66DD789FC6
	for <linux-scsi@vger.kernel.org>; Sat, 12 Feb 2011 17:30:11 +0100 (CET)
In-Reply-To: <1295597274-5844-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2011-01-21 at 09:07 +0100, Hannes Reinecke wrote:
> Consider a scenario where a SCSI EH command like TUR fails with a NOT READY
> status - MANUAL INTERVENTION REQUIRED (02/04/03). As evident in the ASC/ASCQ
> description, manual intervention is required in this case i.e. the target wants
> TUR to fail here so that the host administrator can take corrective action.
> 
> But this particular ASC/ASCQ is not handled in the scsi_check_sense, which
> ultimately causes scsi_eh_tur to erroneously report a SUCCESS (device ready)
> instead of the actual FAILURE state (device not ready).
> 
> This patch converts scsi_check_sense() to return SOFT_ERROR in
> cases where an error has been signalled via the sense code, but
> we should not wake the error handler. This error code will be
> reverted back to SUCCESS for normal command handling, but
> scsi_eh_completed_normally() will convert it to FAILED.

I can't reconcile this patch with the detailed error handling ones: you
change a lot of call sites to TARGET_ERROR in that patch and SOFT_ERROR
in this one.  Since the detailed error handling seems the more
important, I'll drop this one ... can you work out a reconciliation,
please?

Thanks,

James


